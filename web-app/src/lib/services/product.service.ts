import { supabase } from '../supabase';

export const productService = {
    async getProducts(teamId: string) {
        const { data, error } = await supabase
            .from('products')
            .select('*')
            .eq('team_id', teamId)
            .order('name');
        
        if (error) {
            console.warn('[productService.getProducts]', error.message, { teamId, code: error.code });
            return [];
        }
        return data ?? [];
    },

    async resolveCategory(teamId: string, categoryName: string): Promise<number | null> {
        if (!categoryName || !categoryName.trim()) return null;
        const nameTrimmed = categoryName.trim();
        
        const { data, error } = await supabase
            .from('product_categories')
            .select('id')
            .eq('team_id', teamId)
            .ilike('name', nameTrimmed)
            .maybeSingle();
            
        if (data) return Number(data.id);
        
        const { data: newCat, error: insertError } = await supabase
            .from('product_categories')
            .insert({ team_id: teamId, name: nameTrimmed })
            .select('id')
            .single();
            
        if (insertError) {
            console.error('[productService.resolveCategory] failed to insert category:', insertError);
            return null;
        }
        return newCat ? Number(newCat.id) : null;
    },

    async createProduct(productData: any) {
        const { data, error } = await supabase
            .from('products')
            .insert(productData)
            .select()
            .single();
        
        if (error) throw error;
        return data;
    },

    async updateProduct(id: string, updates: any, lastUpdatedAt?: string) {
        let query = supabase
            .from('products')
            .update({ ...updates, updated_at: new Date().toISOString() })
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

    async deleteProduct(id: string) {
        const { error } = await supabase
            .from('products')
            .delete()
            .eq('id', id);
        
        if (error) throw error;
    }
};
