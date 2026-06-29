import { supabase } from '../supabase';

export const pricingService = {
    async getTemplatePrice() {
        try {
            const { data, error } = await supabase
                .from('system_config')
                .select('value')
                .eq('key', 'template_unit_price')
                .single();
            
            if (error) {
                console.warn('Pricing not found in system_config, falling back to $1.00');
                return 1.00;
            }
            
            return parseFloat(data.value);
        } catch (err) {
            return 1.00; // Final fallback
        }
    }
};
