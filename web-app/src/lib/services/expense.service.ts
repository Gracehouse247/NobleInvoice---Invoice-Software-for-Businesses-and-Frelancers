import { supabase } from '../supabase';

export const expenseService = {
    async getExpenses(teamId: string) {
        const { data, error } = await supabase
            .from('expenses')
            .select(`
                *,
                expense_categories (name, color, icon),
                vendors (name)
            `)
            .eq('team_id', teamId)
            .order('expense_date', { ascending: false });
        
        if (error) {
            console.warn('[expenseService.getExpenses] error:', error.message);
            return [];
        }
        return data ?? [];
    },

    async getExpenseCategories() {
        const { data, error } = await supabase
            .from('expense_categories')
            .select('*')
            .order('name');
        
        if (error) {
            console.warn('[expenseService.getExpenseCategories] error:', error.message);
            return [];
        }
        return data ?? [];
    },

    async resolveVendor(teamId: string, userId: string, vendorName: string): Promise<number | null> {
        if (!vendorName || !vendorName.trim()) return null;
        const nameTrimmed = vendorName.trim();

        const { data: existing, error } = await supabase
            .from('vendors')
            .select('id')
            .eq('team_id', teamId)
            .ilike('name', nameTrimmed)
            .maybeSingle();
        
        if (existing) return Number(existing.id);

        const { data: newVendor, error: insertError } = await supabase
            .from('vendors')
            .insert({ team_id: teamId, user_id: userId, name: nameTrimmed })
            .select('id')
            .single();

        if (insertError) {
            console.error('[expenseService.resolveVendor] failed:', insertError);
            return null;
        }
        return newVendor ? Number(newVendor.id) : null;
    },

    async createExpense(expenseData: any) {
        const { data, error } = await supabase
            .from('expenses')
            .insert(expenseData)
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async uploadReceipt(userId: string, file: File): Promise<string | null> {
        const fileExt = file.name.split('.').pop();
        const fileName = `${userId}/${Date.now()}.${fileExt}`;

        const { data, error } = await supabase.storage
            .from('receipts')
            .upload(fileName, file, {
                cacheControl: '3600',
                upsert: false
            });

        if (error) {
            console.error('[expenseService.uploadReceipt] error:', error.message);
            throw error;
        }

        const { data: { publicUrl } } = supabase.storage
            .from('receipts')
            .getPublicUrl(fileName);

        return publicUrl;
    },

    async updateExpense(id: string, expenseData: any, lastUpdatedAt?: string) {
        let query = supabase
            .from('expenses')
            .update({ ...expenseData, updated_at: new Date().toISOString() })
            .eq('id', id);
            
        if (lastUpdatedAt) {
            query = query.lte('updated_at', lastUpdatedAt);
        }

        const { data, error } = await query.select().single();

        if (error) {
            if (error.code === 'PGRST116') {
                throw new Error('Conflict: Data was modified by another device since last sync.');
            }
            throw error;
        }
        return data;
    },

    async deleteExpense(id: string) {
        const { error } = await supabase
            .from('expenses')
            .delete()
            .eq('id', id);

        if (error) throw error;
    }
};
