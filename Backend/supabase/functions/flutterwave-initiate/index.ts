// supabase/functions/flutterwave-initiate/index.ts
//
// DEPRECATED — This is a legacy payment initiation function with no authentication.
//
// The canonical payment initiation function is /functions/v1/create-flutterwave-payment.
// That function:
//   - Authenticates the caller via JWT
//   - Validates the invoice exists and the caller owns it
//   - Uses a structured tx_ref tied to the invoice ID (INV-{id}-{ts})
//   - Supports split payments via Flutterwave subaccounts
//
// This file is intentionally disabled. Calls to it will return 410 Gone.
// Update any client code to call /functions/v1/create-flutterwave-payment instead.
//
// DO NOT deploy this function without a full security review.
//
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  console.warn(
    "[flutterwave-initiate] DEPRECATED endpoint called. " +
    "Please migrate to /functions/v1/create-flutterwave-payment."
  );

  return new Response(
    JSON.stringify({
      error: "This endpoint has been deprecated. Use /functions/v1/create-flutterwave-payment instead.",
      migration_guide: "https://docs.nobleinvoice.ai/api/payments#migration",
    }),
    {
      status: 410,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    }
  );
});
