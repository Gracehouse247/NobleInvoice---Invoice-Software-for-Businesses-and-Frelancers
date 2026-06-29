import { supabase } from '@/lib/supabase';

export interface QrCodeData {
    id?: string;
    user_id?: string;
    folder_id?: string | null;
    name: string;
    type: string;
    content: Record<string, any>;
    color_primary?: string;
    asset_path?: string | null;
    asset_url?: string | null;
}

/**
 * Service to manage QR Codes synced with Supabase Backend.
 */
export const QrService = {
    /**
     * Upload an asset for a QR code directly to Supabase storage.
     * Enforces the 4.5MB limit on the client side before uploading.
     */
    async uploadAsset(file: File, userId: string): Promise<{ path: string; url: string }> {
        // Enforce 4.5MB Limit
        const MAX_FILE_SIZE = 4.5 * 1024 * 1024;
        if (file.size > MAX_FILE_SIZE) {
            throw new Error('File exceeds the 4.5MB limit. Please compress your file.');
        }

        const fileName = `${userId}/${Date.now()}_${file.name.replace(/[^a-zA-Z0-9.\-_]/g, '')}`;
        
        const { data, error } = await supabase.storage
            .from('qr_assets')
            .upload(fileName, file, {
                cacheControl: '3600',
                upsert: false
            });

        if (error) {
            console.error('Storage Upload Error:', error);
            throw new Error(`Upload failed: ${error.message}`);
        }

        const { data: urlData } = supabase.storage
            .from('qr_assets')
            .getPublicUrl(data.path);

        return {
            path: data.path,
            url: urlData.publicUrl
        };
    },

    /**
     * Save or update a QR code in the database.
     */
    async saveQrCode(qrData: QrCodeData): Promise<string> {
        const payload = {
            folder_id: qrData.folder_id,
            name: qrData.name || `Untitled ${qrData.type} QR`,
            type: qrData.type,
            content: qrData.content,
            color_primary: qrData.color_primary || '#0F172A',
            asset_path: qrData.asset_path,
            asset_url: qrData.asset_url,
            updated_at: new Date().toISOString()
        };

        if (qrData.id) {
            // Update existing
            const { error } = await supabase
                .from('qr_codes')
                .update(payload)
                .eq('id', qrData.id);

            if (error) throw error;
            return qrData.id;
        } else {
            // Insert new
            const { data, error } = await supabase
                .from('qr_codes')
                .insert([{ ...payload, user_id: qrData.user_id }])
                .select('id')
                .single();

            if (error) throw error;
            return data.id;
        }
    },

    /**
     * Fetch all QR codes for a user.
     */
    async fetchQrCodes() {
        const { data, error } = await supabase
            .from('qr_codes')
            .select(`
                *,
                folders (
                    id,
                    name,
                    icon_name
                )
            `)
            .order('created_at', { ascending: false });

        if (error) throw error;
        return data;
    },

    /**
     * Fetch analytics for a specific QR code.
     */
    async fetchAnalytics(qrId: string) {
        const { data, error } = await supabase
            .from('qr_scans')
            .select('*')
            .eq('qr_code_id', qrId)
            .order('scanned_at', { ascending: false });

        if (error) throw error;
        return data;
    }
};
