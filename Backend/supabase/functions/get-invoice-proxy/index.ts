// supabase/functions/get-invoice-proxy/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);
  const url = new URL(req.url);
  const id = url.searchParams.get("id");
  const token = url.searchParams.get("token");

  if (!id || !token) {
    return new Response("Missing ID or Token", { status: 400 });
  }

  try {
    // 1. Verify tracking token and increment view count
    const { data: invoice, error: fetchErr } = await supabase
      .from("invoices")
      .select("id, team_id, opened_at, pdf_url, view_count") // Assuming pdf_url exists or we generate a signed one
      .eq("id", id)
      .eq("tracking_token", token)
      .single();

    if (fetchErr || !invoice) {
        return new Response("Invoice not found or invalid token", { status: 404 });
    }

    // 2. Trigger Read Receipt Hook
    const updatePayload: Record<string, unknown> = { 
        view_count: (invoice.view_count || 0) + 1 
    };
    if (!invoice.opened_at) {
        updatePayload.opened_at = new Date().toISOString();
    }

    await supabase
      .from("invoices")
      .update(updatePayload)
      .eq("id", id);

    // 3. Serve PDF via Redirect to Signed URL (Storage)
    // We assume PDFs are stored in 'invoices' bucket with name 'invoice_{id}.pdf'
    const { data: signedUrl, error: signErr } = await supabase.storage
      .from("invoices")
      .createSignedUrl(`invoice_${id}.pdf`, 60);

    if (signErr || !signedUrl) {
        // Fallback: If no PDF pre-generated, we might need a generator, 
        // but typically enterprise apps pre-generate on 'Finalize'.
        return new Response("PDF not generated yet.", { status: 404 });
    }

    return Response.redirect(signedUrl.signedUrl, 302);

  } catch (e) {
    return new Response(String(e), { status: 500 });
  }
});
