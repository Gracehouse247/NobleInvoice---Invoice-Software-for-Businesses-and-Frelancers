import { supabase } from '../supabase';
import { storageService } from './storage.service';

export const identityService = {
    async getIdentity(id: string) {
        const { data, error } = await supabase
            .from('identities')
            .select('*')
            .eq('id', id)
            .single();
        if (error) throw error;
        return data;
    },

    async getIdentities(userId: string) {
        const { data, error } = await supabase
            .from('identities')
            .select('*')
            .eq('user_id', userId)
            .order('created_at', { ascending: false });

        if (error) {
            console.warn('[identityService.getIdentities]', error.message);
            return [];
        }
        return data ?? [];
    },

    async updateIdentity(id: string, updates: any, lastUpdatedAt?: string) {
        let query = supabase
            .from('identities')
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

    async createIdentity(identityData: any) {
        const { data, error } = await supabase
            .from('identities')
            .insert(identityData)
            .select()
            .single();
        if (error) throw error;
        return data;
    },

    async saveIdentityWithDesign(params: {
        userId: string;
        teamId: string;
        name: string;
        title: string;
        email: string;
        phone: string;
        website?: string;
        designSchema: any;
        imageDataUrl: string;
        existingId?: string;
    }) {
        const res = await fetch(params.imageDataUrl);
        const blob = await res.blob();
        const file = new File([blob], `${params.userId}/${Date.now()}_card.png`, { type: 'image/png' });

        const publicUrl = await storageService.uploadFile('identities', file.name, file);

        const identityRow = {
            user_id: params.userId,
            team_id: params.teamId,
            full_name: params.name,
            job_title: params.title,
            email: params.email,
            phone: params.phone,
            website: params.website || null,
            card_image_url: publicUrl,
            design_schema: params.designSchema,
            updated_at: new Date().toISOString(),
        };

        if (params.existingId) {
            const { data, error } = await supabase
                .from('identities')
                .update(identityRow)
                .eq('id', params.existingId)
                .select()
                .single();
            if (error) throw error;
            return data;
        } else {
            const { data, error } = await supabase
                .from('identities')
                .insert({ ...identityRow, is_primary: false })
                .select()
                .single();
            if (error) throw error;
            return data;
        }
    },

    async deleteIdentity(id: string) {
        const { error } = await supabase
            .from('identities')
            .delete()
            .eq('id', id);
        if (error) throw error;
    },

    async setPrimaryIdentity(userId: string, identityId: string) {
        await supabase
            .from('identities')
            .update({ is_primary: false })
            .eq('user_id', userId);

        const { error } = await supabase
            .from('identities')
            .update({ is_primary: true })
            .eq('id', identityId);
        if (error) throw error;
    },

    async saveLead(leadData: any) {
        const { data, error } = await supabase
            .from('identity_leads')
            .insert(leadData)
            .select()
            .single();
        if (error) throw error;
        return data;
    },

    async getIdentityAnalytics(identityId: string) {
        try {
            // Query total scans
            const { count: totalScans, error: scansError } = await supabase
                .from('scan_logs')
                .select('*', { count: 'exact', head: true })
                .eq('identity_id', identityId);

            // Query leads captured
            const { count: leadsCaptured, error: leadsError } = await supabase
                .from('identity_leads')
                .select('*', { count: 'exact', head: true })
                .eq('identity_id', identityId);

            if (scansError || leadsError) {
                console.warn('[identityService.getIdentityAnalytics] Error fetching counters', { scansError, leadsError });
            }

            const scansVal = totalScans || 0;
            const leadsVal = leadsCaptured || 0;
            const conversionRate = scansVal > 0 ? parseFloat(((leadsVal / scansVal) * 100).toFixed(1)) : 0;

            // Query scans by day (for the last 7 days)
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
            
            const { data: recentScans, error: recentScansError } = await supabase
                .from('scan_logs')
                .select('scanned_at')
                .eq('identity_id', identityId)
                .gte('scanned_at', sevenDaysAgo.toISOString());

            const scansByDay = [0, 0, 0, 0, 0, 0, 0];
            if (recentScans && !recentScansError) {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                recentScans.forEach(scan => {
                    const scanDate = new Date(scan.scanned_at);
                    scanDate.setHours(0, 0, 0, 0);
                    const diffTime = today.getTime() - scanDate.getTime();
                    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
                    if (diffDays >= 0 && diffDays < 7) {
                        scansByDay[6 - diffDays]++;
                    }
                });
            }

            // Query top regions from scan logs
            const { data: regionData, error: regionError } = await supabase
                .from('scan_logs')
                .select('location')
                .eq('identity_id', identityId);

            const regionCounts: Record<string, number> = {};
            if (regionData && !regionError) {
                regionData.forEach(scan => {
                    if (scan.location) {
                        regionCounts[scan.location] = (regionCounts[scan.location] || 0) + 1;
                    }
                });
            }

            const topRegions = Object.entries(regionCounts)
                .map(([name, count]) => ({ name, count }))
                .sort((a, b) => b.count - a.count)
                .slice(0, 4);

            return {
                totalScans: scansVal,
                leadsCaptured: leadsVal,
                conversionRate: conversionRate,
                scansByDay: scansByDay,
                topRegions: topRegions
            };
        } catch (e) {
            console.error('[identityService.getIdentityAnalytics]', e);
            return {
                totalScans: 0,
                leadsCaptured: 0,
                conversionRate: 0,
                scansByDay: [0, 0, 0, 0, 0, 0, 0],
                topRegions: []
            };
        }
    },

    async getLeads(identityId: string) {
        try {
            const { data, error } = await supabase
                .from('identity_leads')
                .select('*')
                .eq('identity_id', identityId)
                .or('is_converted.eq.false,is_converted.is.null')
                .order('created_at', { ascending: false });

            if (error) {
                console.error('[identityService.getLeads] Supabase fetch error:', error.message);
                return [];
            }
            
            return data || [];
        } catch (e) {
            console.error('[identityService.getLeads]', e);
            return [];
        }
    },

    async convertLead(leadId: string) {
        const { error } = await supabase
            .from('identity_leads')
            .update({ is_converted: true })
            .eq('id', leadId);
        if (error) throw error;
    }
};
