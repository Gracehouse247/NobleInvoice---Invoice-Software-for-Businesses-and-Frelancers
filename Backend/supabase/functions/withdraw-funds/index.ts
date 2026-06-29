// supabase/functions/withdraw-funds/index.ts
//
// Handles wallet withdrawal requests.
// Validates balance, debits wallet atomically, then calls Flutterwave Transfers API.
// Includes idempotency key on the FLW transfer to prevent double-payouts.
//
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL             = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FLUTTERWAVE_SECRET_KEY   = Deno.env.get("FLUTTERWAVE_SECRET_KEY")!;

// ── Flutterwave Transfer Fees (Nigeria) ───────────────────────────────────────
// These are deducted from the withdrawal amount before the user receives it.
function getTransferFee(amount: number, currency: string): number {
  if (currency !== "NGN") return 0; // Handle other currencies as needed
  if (amount <= 5000)  return 10.75;
  if (amount <= 50000) return 26.88;
  return 53.80; // > ₦50,000
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "https://invoice.noblesworld.com.ng",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonError("Method not allowed", 405);
  }

  try {
    // ── 1. Authenticate the calling user ─────────────────────────────────────
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonError("Missing Authorization header", 401);
    }

    const supabaseUser = createClient(SUPABASE_URL, Deno.env.get("SUPABASE_ANON_KEY")!, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: { user }, error: authErr } = await supabaseUser.auth.getUser();
    if (authErr || !user) {
      return jsonError("Unauthorized", 401);
    }

    // ── 2. Parse request body ─────────────────────────────────────────────────
    const body = await req.json();
    const {
      amount,          // Amount to withdraw (number)
      currency,        // Currency code e.g. "NGN"
      account_number,  // Recipient bank account number
      account_bank,    // FLW bank code e.g. "044" for Access Bank
      account_name,    // Name of the account holder
      narration,       // Optional: description
    } = body as {
      amount:         number;
      currency:       string;
      account_number: string;
      account_bank:   string;
      account_name:   string;
      narration?:     string;
    };

    // ── 3. Validate inputs ────────────────────────────────────────────────────
    if (!amount || amount <= 0)     return jsonError("Invalid amount", 400);
    if (!currency)                  return jsonError("Currency is required", 400);
    if (!account_number)            return jsonError("Account number is required", 400);
    if (!account_bank)              return jsonError("Bank code is required", 400);
    if (!account_name)              return jsonError("Account name is required", 400);

    const verifiedCurrency = currency.toUpperCase();
    const transferFee = getTransferFee(amount, verifiedCurrency);

    if (amount <= transferFee) {
      return jsonError(`Withdrawal amount must be greater than the transfer fee of ${transferFee} ${verifiedCurrency}`, 400);
    }

    // ── 4. Debit wallet atomically via RPC ───────────────────────────────────
    const supabaseAdmin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const transferRef   = `WD-${user.id}-${Date.now()}`;

    const { data: debitResult, error: debitErr } = await supabaseAdmin.rpc("debit_wallet", {
      p_user_id:       user.id,
      p_currency_code: verifiedCurrency,
      p_amount:        amount,
      p_transfer_fee:  transferFee,
      p_reference:     transferRef,
      p_description:   narration || `Wallet withdrawal to ${account_name}`,
    });

    if (debitErr) {
      console.error("debit_wallet RPC error:", debitErr);
      return jsonError("Failed to process withdrawal: " + debitErr.message, 500);
    }

    if (!debitResult?.success) {
      console.error("debit_wallet returned failure:", debitResult);
      return jsonError(debitResult?.error || "Insufficient balance or wallet not found", 402);
    }

    const netAmount = debitResult.net_received as number;
    console.log(`Wallet debited for user ${user.id}. Sending ₦${netAmount} to ${account_number}`);

    // ── 5. Initiate FLW Transfer (Payout) ────────────────────────────────────
    const fwTransferPayload = {
      account_bank,
      account_number,
      amount:       netAmount,   // User actually receives this (after FLW fee deduction)
      narration:    narration || `NobleInvoice Payout`,
      currency:     verifiedCurrency,
      reference:    transferRef,  // Idempotency key — FLW will reject duplicates with same ref
      callback_url: `${SUPABASE_URL}/functions/v1/flw-webhook`,
      debit_currency: verifiedCurrency,
      beneficiary_name: account_name,
      meta: [
        {
          mobile_number: "",
          email:         user.email ?? "",
          mobile_carrier: "AIRTEL",
          firstname:     account_name.split(" ")[0] || account_name,
          lastname:      account_name.split(" ").slice(1).join(" ") || "",
        }
      ],
    };

    const fwRes = await fetch("https://api.flutterwave.com/v3/transfers", {
      method:  "POST",
      headers: {
        Authorization:  `Bearer ${FLUTTERWAVE_SECRET_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(fwTransferPayload),
    });

    const fwData = await fwRes.json();

    if (fwData.status !== "success") {
      // Transfer failed after wallet was debited — call RPC to refund and mark failed
      console.error("FLW transfer initiation failed. Refunding wallet. FLW response:", fwData);

      await supabaseAdmin.rpc("confirm_withdrawal", {
        p_reference: transferRef,
        p_status:    "failed",
      });

      return jsonError(`Transfer failed: ${fwData.message || "Unknown FLW error"}`, 502);
    }

    const transferId = fwData.data?.id;
    console.log(`✅ FLW Transfer initiated. ID: ${transferId}, Reference: ${transferRef}`);

    return new Response(
      JSON.stringify({
        success:       true,
        transfer_id:   transferId,
        reference:     transferRef,
        amount_sent:   netAmount,
        transfer_fee:  transferFee,
        currency:      verifiedCurrency,
        message:       `Your withdrawal of ${verifiedCurrency} ${netAmount} is being processed. Transfers typically arrive within minutes.`,
      }),
      {
        status:  200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );

  } catch (e) {
    console.error("withdraw-funds error:", e);
    return jsonError(String(e), 500);
  }
});

function jsonError(message: string, status: number) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
