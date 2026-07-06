import { useAuth } from '@/context/AuthContext';
import { useRealtime } from '@/components/providers/RealtimeProvider';
import { teamService, invoiceService } from '@/lib/services/supabaseService';
import { Invoice } from '@/types';
import { useSupabaseQuery } from './useSupabaseQuery';
import { useSyncStore } from '@/store/useSyncStore';
import { supabaseReadOnly } from '@/lib/supabaseReadOnly';

export interface DashboardStats {
    totalRevenue: number;
    outstanding: number;
    paidCount: number;
    strengthIndex: number;
}

export function useDashboardData() {
    const { userData, user } = useAuth();
    const { lastSyncTime } = useRealtime();
    const { isOnline } = useSyncStore();

    const userId = user?.id || userData?.uid;

    const { data, error, isLoading, isValidating } = useSupabaseQuery(
        userId && isOnline ? ['dashboard', userId, lastSyncTime] : null,
        async () => {
            try {
                const tData = await teamService.getTeamByUserId(userId!);
                const teamId = tData?.id || userId;
                const prefCurrency = tData?.preferred_currency || 'NGN';

                const { data: invsData, error: invsError } = await supabaseReadOnly
                    .from('invoices')
                    .select('*, clients(name, email, phone)')
                    .eq('team_id', teamId)
                    .order('created_at', { ascending: false })
                    .limit(100);

                if (invsError) {
                    console.warn('[useDashboardData] Read replica fetch error:', invsError.message);
                }
                const invs = invsData || [];

                let revenue = 0;
                let outstandingAmount = 0;
                let paid = 0;
                
                invs.forEach((inv: Record<string, any>) => {
                    const amount = Number(inv.total_amount) || 0;
                    if (inv.status === 'paid') {
                        revenue += amount;
                        paid++;
                    } else if (['pending', 'sent', 'unpaid', 'overdue'].includes(inv.status)) {
                        outstandingAmount += amount;
                    }
                });

                const totalInvs = invs.filter((i: Record<string, any>) => i.status !== 'draft').length;
                const strength = totalInvs > 0 ? Math.round(((paid || 0) / totalInvs) * 100) : 100;

                const newStats = {
                    totalRevenue: revenue,
                    outstanding: outstandingAmount,
                    paidCount: paid,
                    strengthIndex: strength
                };

                return { data: { invoices: invs as Invoice[], stats: newStats, currencyCode: prefCurrency as string }, error: null };
            } catch (err) {
                return { data: null, error: err };
            }
        }
    );

    const firstName = userData?.name ? userData.name.split(' ')[0] : 'Noble';

    const defaultStats = {
        totalRevenue: 0,
        outstanding: 0,
        paidCount: 0,
        strengthIndex: 0
    };

    return { 
        invoices: data?.invoices || [], 
        loading: isLoading || (!data && !error && isOnline), 
        error: error ? 'Failed to load dashboard data.' : null, 
        stats: data?.stats || defaultStats, 
        currencyCode: data?.currencyCode || 'NGN', 
        firstName,
        isValidating
    };
}
