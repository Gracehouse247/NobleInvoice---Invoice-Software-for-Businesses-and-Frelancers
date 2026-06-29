import { NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export async function POST(request: Request) {
    try {
        const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey);

        // 1. Authenticate user from Bearer token
        const authHeader = request.headers.get('Authorization');
        if (!authHeader) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
        }

        const token = authHeader.replace('Bearer ', '');
        const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(token);

        if (authError || !user) {
            return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
        }

        const userId = user.id;

        // 2. Cascade delete all user data in order (foreign keys first)
        // Invoices and related data
        await supabaseAdmin.from('invoice_items').delete().eq('user_id', userId);
        await supabaseAdmin.from('invoices').delete().eq('user_id', userId);

        // Clients
        await supabaseAdmin.from('clients').delete().eq('user_id', userId);

        // Products / expenses
        await supabaseAdmin.from('products').delete().eq('user_id', userId);
        await supabaseAdmin.from('expenses').delete().eq('user_id', userId);

        // Billing history
        await supabaseAdmin.from('billing_history').delete().eq('user_id', userId);

        // QR codes / digital identities
        await supabaseAdmin.from('digital_identities').delete().eq('user_id', userId);
        await supabaseAdmin.from('qr_codes').delete().eq('user_id', userId);

        // Team memberships
        await supabaseAdmin.from('team_members').delete().eq('user_id', userId);
        // Delete team if user is the owner
        await supabaseAdmin.from('teams').delete().eq('owner_id', userId);

        // Profile (must come after all referencing tables)
        await supabaseAdmin.from('profiles').delete().eq('id', userId);

        // 3. Delete the auth user account
        const { error: deleteAuthError } = await supabaseAdmin.auth.admin.deleteUser(userId);

        if (deleteAuthError) {
            console.error('[API Delete Account] Auth user delete failed:', deleteAuthError);
            return NextResponse.json({ error: 'Failed to delete auth account.' }, { status: 500 });
        }

        return NextResponse.json({ 
            success: true, 
            message: 'Account and all associated data permanently deleted.' 
        }, { status: 200 });

    } catch (error: any) {
        console.error('[API Delete Account] Unexpected error:', error);
        return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
    }
}
