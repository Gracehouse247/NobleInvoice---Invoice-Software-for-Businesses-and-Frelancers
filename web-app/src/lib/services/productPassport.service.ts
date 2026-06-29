import { supabase } from '../supabase';

export const productPassportService = {
    async getPassportByProductId(productId: string) {
        const { data, error } = await supabase
            .from('product_passports')
            .select('*')
            .eq('product_id', productId)
            .maybeSingle();
        
        if (error) throw error;
        return data;
    },

    async getPassports(teamId: string) {
        const { data, error } = await supabase
            .from('product_passports')
            .select(`*, products(name, sku)`)
            .eq('team_id', teamId);
            
        if (error) {
            console.error('[productPassportService.getPassports]', error);
            return [];
        }
        return data || [];
    },

    async getPassportBySlug(slug: string) {
        const { data, error } = await supabase
            .from('product_passports')
            .select(`
                *,
                products (
                    name,
                    description,
                    unit_price,
                    sku
                ),
                teams (
                    name,
                    logo_url,
                    brand_voice
                )
            `)
            .eq('slug', slug)
            .eq('public_status', 'published')
            .maybeSingle();
            
        if (error) throw error;
        return data;
    },

    async upsertPassport(passportData: any) {
        const { data, error } = await supabase
            .from('product_passports')
            .upsert(passportData, { onConflict: 'product_id' })
            .select()
            .single();
        
        if (error) throw error;
        return data;
    },

    async recordScan(passportId: string, userAgent?: string, ipAddress?: string) {
        const { error } = await supabase
            .from('product_passport_scans')
            .insert({
                passport_id: passportId,
                user_agent: userAgent,
                ip_address: ipAddress
            });
            
        if (error) console.error('[productPassportService] Failed to record scan:', error);
    }
};
