// supabase/functions/send-invoice-reminders/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { GoogleAuth } from "https://esm.sh/google-auth-library@8.7.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// FCM V1 Credentials from Secrets
const FIREBASE_PROJECT_ID = Deno.env.get("FIREBASE_PROJECT_ID")!;
const FIREBASE_CLIENT_EMAIL = Deno.env.get("FIREBASE_CLIENT_EMAIL")!;
const FIREBASE_PRIVATE_KEY = Deno.env.get("FIREBASE_PRIVATE_KEY")?.replace(/\\n/g, '\n')!;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// Auth for FCM V1
const auth = new GoogleAuth({
  credentials: {
    client_email: FIREBASE_CLIENT_EMAIL,
    private_key: FIREBASE_PRIVATE_KEY,
  },
  scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
});

serve(async (_req) => {
  try {
    const today = new Date();
    const todayStr = today.toISOString().split("T")[0];

    const targetDates = {
      due_today: todayStr,
      overdue_3d: _subtractDays(today, 3),
      overdue_7d: _subtractDays(today, 7),
    };

    // 1. Fetch invoices matching milestones
    const { data: milestoneInvoices, error: fetchErr } = await supabase
      .from("invoices")
      .select("id, invoice_number, total_amount, currency_code, due_date, team_id, clients(name)")
      .in("status", ["pending", "overdue"])
      .in("due_date", Object.values(targetDates));

    if (fetchErr) throw fetchErr;
    if (!milestoneInvoices || milestoneInvoices.length === 0) {
      return new Response(JSON.stringify({ sent: 0, message: "No reminders today." }), { status: 200 });
    }

    // 2. Get Access Token for FCM V1
    const client = await auth.getClient();
    const tokenResponse = await client.getAccessToken();
    const accessToken = tokenResponse.token;

    // 3. Process each invoice
    let sentCount = 0;
    for (const inv of milestoneInvoices) {
      // Find tokens for this team
      const { data: tokens } = await supabase
        .from("fcm_tokens")
        .select("token")
        .eq("team_id", inv.team_id);

      if (!tokens || tokens.length === 0) continue;

      const rType = _getReminderType(inv.due_date, targetDates);
      const payload = _buildPayload(inv, rType);

      for (const { token } of tokens) {
        const res = await fetch(`https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`, {
          method: "POST",
          headers: {
            "Authorization": `Bearer ${accessToken}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            message: {
              token: token,
              notification: payload.notification,
              data: {
                invoiceId: String(inv.id),
                screen: "invoice_detail",
                ...payload.data
              },
            },
          }),
        });

        if (res.ok) sentCount++;
      }
    }

    return new Response(JSON.stringify({ sent: sentCount }), { status: 200 });
  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify({ error: String(e) }), { status: 500 });
  }
});

function _subtractDays(date: Date, days: number) {
  const d = new Date(date);
  d.setDate(d.getDate() - days);
  return d.toISOString().split("T")[0];
}

function _getReminderType(dueDate: string, targets: any) {
  if (dueDate === targets.due_today) return "due_today";
  if (dueDate === targets.overdue_3d) return "overdue_3d";
  return "overdue_7d";
}

function _buildPayload(inv: any, type: string) {
  const clientName = inv.clients?.name ?? "Your client";
  switch (type) {
    case "due_today":
      return { 
        notification: { title: "⏰ Invoice Due Today", body: `${clientName}'s invoice ${inv.invoice_number} is due today.` },
        data: { type: "invoice" }
      };
    case "overdue_3d":
      return { 
        notification: { title: "⚠️ 3 Days Overdue", body: `Invoice ${inv.invoice_number} is now 3 days late.` },
        data: { type: "overdue_invoices" }
      };
    default:
      return { 
        notification: { title: "🔴 7 Days Overdue", body: `Final automated reminder sent for ${inv.invoice_number}.` },
        data: { type: "overdue_invoices" }
      };
  }
}
