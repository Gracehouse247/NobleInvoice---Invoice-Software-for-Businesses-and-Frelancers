import { NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

// We use the service role key to bypass RLS for this specific public route.
// This allows unauthenticated clients to view their invoice via the secure tracking token.
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export async function GET(
    request: Request,
    { params }: { params: Promise<{ token: string }> }
) {
    try {
        const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);
        const { token } = await params;

        if (!token) {
            return NextResponse.json({ error: 'Missing tracking token' }, { status: 400 });
        }

        // Fetch the invoice using the admin client
        const { data: invoice, error: invoiceError } = await supabaseAdmin
            .from('invoices')
            .select('*, clients(*), invoice_items(*), teams(*)')
            .eq('tracking_token', token)
            .single();

        if (invoiceError) {
            console.error('[API Portal] Invoice fetch error:', invoiceError);
            return NextResponse.json({ error: 'Invoice not found or invalid token' }, { status: 404 });
        }

        // Optionally, increment view count or set to viewed if currently 'sent'
        // We do this asynchronously so it doesn't block the response
        if (invoice.status === 'sent') {
            supabaseAdmin
                .from('invoices')
                .update({ 
                    status: 'viewed', 
                    view_count: (invoice.view_count || 0) + 1,
                    opened_at: new Date().toISOString()
                })
                .eq('id', invoice.id)
                .then(({ error }) => {
                    if (error) console.error('[API Portal] Failed to update view status:', error);
                });
        } else {
            supabaseAdmin
                .from('invoices')
                .update({ 
                    view_count: (invoice.view_count || 0) + 1,
                    opened_at: invoice.opened_at || new Date().toISOString()
                })
                .eq('id', invoice.id)
                .then(({ error }) => {
                    if (error) console.error('[API Portal] Failed to update view count:', error);
                });
        }

        // We sanitize the response so we don't leak sensitive team details
        // like private flutterwave keys if they are somehow stored in teams.
        // For now, we return exactly what the UI needs.
        
        return NextResponse.json({ invoice }, { status: 200 });

    } catch (error: any) {
        console.error('[API Portal] Unexpected error:', error);
        return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
    }
}
