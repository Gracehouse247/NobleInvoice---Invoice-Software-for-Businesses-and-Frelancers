import { supabase } from '../supabase';

export interface InvoiceItemPayload {
    product_id?: number | null;
    name?: string;
    description?: string;
    quantity: number | string;
    price?: number | string;
    unit_price?: number | string;
}

export interface InvoicePayload {
    team_id?: string;
    user_id?: string;
    client_id?: number | string | null;
    invoice_number: string;
    invoice_type?: string;
    issue_date?: string;
    due_date?: string;
    status?: string;
    currency_code?: string;
    tax_rate?: number | string;
    tax_type?: string;
    tax_amount?: number | string;
    tax_total?: number | string;
    discount_type?: string;
    discount_value?: number | string;
    discount_amount?: number | string;
    subtotal?: number | string;
    total_amount?: number | string;
    notes?: string | null;
    metadata?: Record<string, any>;
    bank_name?: string | null;
    account_name?: string | null;
    account_number?: string | null;
    signature_url?: string | null;
    items?: InvoiceItemPayload[];
}

/** Matches the `invoices` table columns for INSERT/UPDATE operations. */
export interface DbInvoicePayload {
    team_id?: string;
    client_id: number | null;
    invoice_number: string;
    invoice_type: string;
    issue_date: string;
    due_date: string;
    status: string;
    currency_code: string;
    tax_rate: number;
    tax_type: string;
    tax_amount: number;
    discount_type: string;
    discount_value: number;
    discount_amount: number;
    subtotal: number;
    total_amount: number;
    notes: string | null;
    metadata: Record<string, any>;
    updated_at?: string;
}

export const invoiceService = {
    async getInvoices(teamId: string, limit = 50, offset = 0) {
        const { data, error } = await supabase
            .from('invoices')
            .select('*, clients(name, email, phone)')
            .eq('team_id', teamId)
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);
        
        if (error) {
            console.warn('[invoiceService.getInvoices]', error.message, { teamId, code: error.code });
            return [];
        }
        return data ?? [];
    },

    async getInvoiceById(invoiceId: string) {
        const { data, error } = await supabase
            .from('invoices')
            .select('*, clients(*), invoice_items(*)')
            .eq('id', invoiceId)
            .single();
            
        if (error) throw error;
        return data;
    },

    async createInvoice(invoiceData: InvoicePayload) {
        const { items, ...rawInvoice } = invoiceData;

        const dbInvoice: DbInvoicePayload = {
            team_id: rawInvoice.team_id || rawInvoice.user_id,
            client_id: rawInvoice.client_id ? Number(rawInvoice.client_id) : null,
            invoice_number: rawInvoice.invoice_number,
            invoice_type: rawInvoice.invoice_type || 'standard',
            issue_date: rawInvoice.issue_date || new Date().toISOString().split('T')[0],
            due_date: rawInvoice.due_date ? new Date(rawInvoice.due_date).toISOString().split('T')[0] : new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
            status: rawInvoice.status || 'draft',
            currency_code: rawInvoice.currency_code || 'NGN',
            tax_rate: parseFloat(String(rawInvoice.tax_rate ?? 0)) || 0,
            tax_type: rawInvoice.tax_type || 'exclusive',
            tax_amount: parseFloat(String(rawInvoice.tax_total ?? rawInvoice.tax_amount ?? 0)) || 0,
            discount_type: rawInvoice.discount_type || 'none',
            discount_value: parseFloat(String(rawInvoice.discount_value ?? 0)) || 0,
            discount_amount: parseFloat(String(rawInvoice.discount_amount ?? 0)) || 0,
            subtotal: parseFloat(String(rawInvoice.subtotal ?? 0)) || 0,
            total_amount: parseFloat(String(rawInvoice.total_amount ?? 0)) || 0,
            notes: rawInvoice.notes || null,
            metadata: {
                bank_name: rawInvoice.bank_name || null,
                account_name: rawInvoice.account_name || null,
                account_number: rawInvoice.account_number || null,
                signature_url: rawInvoice.signature_url || null,
                ...(rawInvoice.metadata || {})
            }
        };

        const { data: invoice, error: invoiceError } = await supabase
            .from('invoices')
            .insert(dbInvoice)
            .select()
            .single();

        if (invoiceError) {
            console.error('[invoiceService.createInvoice] Parent insert failed:', invoiceError);
            throw invoiceError;
        }

        if (items && items.length > 0) {
            const dbItems = items.map((item: InvoiceItemPayload) => ({
                invoice_id: invoice.id,
                product_id: item.product_id || null,
                description: item.name || item.description || 'Line Item',
                quantity: parseFloat(String(item.quantity ?? 1)) || 1,
                unit_price: parseFloat(String(item.price ?? 0)) || parseFloat(String(item.unit_price ?? 0)) || 0,
                total: (parseFloat(String(item.quantity ?? 1)) || 1) * (parseFloat(String(item.price ?? 0)) || parseFloat(String(item.unit_price ?? 0)) || 0)
            }));

            const { error: itemsError } = await supabase
                .from('invoice_items')
                .insert(dbItems);

            if (itemsError) {
                console.error('[invoiceService.createInvoice] Items insert failed:', itemsError);
                await supabase.from('invoices').delete().eq('id', invoice.id);
                throw itemsError;
            }
        }

        return invoice;
    },

    async updateInvoice(invoiceId: string, invoiceData: InvoicePayload, lastUpdatedAt?: string) {
        const { items, ...rawInvoice } = invoiceData;

        const dbInvoice: DbInvoicePayload = {
            client_id: rawInvoice.client_id ? Number(rawInvoice.client_id) : null,
            invoice_number: rawInvoice.invoice_number,
            invoice_type: rawInvoice.invoice_type || 'standard',
            issue_date: rawInvoice.issue_date || new Date().toISOString().split('T')[0],
            due_date: rawInvoice.due_date ? new Date(rawInvoice.due_date).toISOString().split('T')[0] : new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
            status: rawInvoice.status || 'draft',
            currency_code: rawInvoice.currency_code || 'NGN',
            tax_rate: parseFloat(String(rawInvoice.tax_rate ?? 0)) || 0,
            tax_type: rawInvoice.tax_type || 'exclusive',
            tax_amount: parseFloat(String(rawInvoice.tax_total ?? rawInvoice.tax_amount ?? 0)) || 0,
            discount_type: rawInvoice.discount_type || 'none',
            discount_value: parseFloat(String(rawInvoice.discount_value ?? 0)) || 0,
            discount_amount: parseFloat(String(rawInvoice.discount_amount ?? 0)) || 0,
            subtotal: parseFloat(String(rawInvoice.subtotal ?? 0)) || 0,
            total_amount: parseFloat(String(rawInvoice.total_amount ?? 0)) || 0,
            notes: rawInvoice.notes || null,
            updated_at: new Date().toISOString(),
            metadata: {
                bank_name: rawInvoice.bank_name || null,
                account_name: rawInvoice.account_name || null,
                account_number: rawInvoice.account_number || null,
                signature_url: rawInvoice.signature_url || null,
                ...(rawInvoice.metadata || {})
            }
        };

        let currentInvoice = null;
        if (lastUpdatedAt) {
            const { data, error: fetchError } = await supabase
                .from('invoices')
                .select('updated_at')
                .eq('id', invoiceId)
                .single();

            if (fetchError) throw fetchError;
            currentInvoice = data;

            if (new Date(currentInvoice.updated_at) > new Date(lastUpdatedAt)) {
                throw new Error('Conflict: Data was modified by another device since last sync.');
            }
        }

        const dbItems = items?.length ? items.map((item: InvoiceItemPayload) => ({
            product_id: item.product_id || null,
            description: item.name || item.description || 'Line Item',
            quantity: parseFloat(String(item.quantity ?? 1)) || 1,
            unit_price: parseFloat(String(item.price ?? 0)) || parseFloat(String(item.unit_price ?? 0)) || 0,
            total: (parseFloat(String(item.quantity ?? 1)) || 1) * (parseFloat(String(item.price ?? 0)) || parseFloat(String(item.unit_price ?? 0)) || 0)
        })) : [];

        const { data: updatedInvoice, error: rpcError } = await supabase.rpc('update_invoice_with_items', {
            p_invoice_id: invoiceId,
            p_invoice_data: dbInvoice,
            p_items: dbItems
        });

        if (rpcError) {
            console.error('[invoiceService.updateInvoice] RPC failed:', rpcError);
            throw rpcError;
        }

        return updatedInvoice;
    },

    async updateInvoiceStatus(invoiceId: string, status: string, lastUpdatedAt?: string) {
        let query = supabase
            .from('invoices')
            .update({ status, updated_at: new Date().toISOString() })
            .eq('id', invoiceId);
        
        if (lastUpdatedAt) {
            query = query.lte('updated_at', lastUpdatedAt);
        }

        const { error } = await query.select().single();
        
        if (error) {
            if (error.code === 'PGRST116') {
                throw new Error('Conflict: Data was modified by another device since last sync.');
            }
            throw error;
        }
    },

    async getInvoiceByToken(token: string) {
        // Calls the Next.js API route that uses the Service Role key
        const response = await fetch(`/api/portal/invoice/${token}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
            // Don't cache so we always get the latest invoice status
            cache: 'no-store'
        });

        if (!response.ok) {
            const errData = await response.json().catch(() => null);
            throw new Error(errData?.error || 'Failed to fetch invoice');
        }

        const data = await response.json();
        return data.invoice;
    }
};
