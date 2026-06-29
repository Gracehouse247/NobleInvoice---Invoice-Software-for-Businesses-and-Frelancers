import { supabase } from '../supabase';

export const storageService = {
    async uploadFile(bucket: string, path: string, file: File) {
        const { data, error } = await supabase.storage
            .from(bucket)
            .upload(path, file, { 
                upsert: true,
                cacheControl: '3600'
            });
        
        if (error) throw error;
        
        const { data: { publicUrl } } = supabase.storage
            .from(bucket)
            .getPublicUrl(data.path);
            
        return publicUrl;
    }
};
