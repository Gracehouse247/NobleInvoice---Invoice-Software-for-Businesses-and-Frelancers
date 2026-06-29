// supabase/functions/handle-flutterwave-webhook/index.ts
//
// ⛔ DEPRECATED — This function is retired as of 2026-06-15.
//
// All logic (invoices, subscriptions, PAYG bundles, transfer confirmations) has been
// consolidated into the canonical webhook handler:
//   /functions/v1/flw-webhook
//
// ACTION REQUIRED (if you still have this URL configured in Flutterwave Dashboard):
//   Settings → Webhooks → Update webhook URL to:
//   https://iyvikdxzcpcjivmbiwik.supabase.co/functions/v1/flw-webhook
//
// This stub returns a clear error so you know immediately if it's still being called.
//
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

serve(async (_req) => {
  console.error(
    "[DEPRECATED] handle-flutterwave-webhook was called. " +
    "Update your Flutterwave webhook URL to /functions/v1/flw-webhook immediately."
  );

  return new Response(
    JSON.stringify({
      error: "This webhook endpoint is deprecated. Please update your Flutterwave dashboard to point to /functions/v1/flw-webhook",
      canonical_url: "https://iyvikdxzcpcjivmbiwik.supabase.co/functions/v1/flw-webhook",
    }),
    {
      status:  410, // 410 Gone — signals this endpoint is permanently removed
      headers: { "Content-Type": "application/json" },
    }
  );
});
