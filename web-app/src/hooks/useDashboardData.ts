import { useState, useEffect } from 'react';
import { useAuth } from '@/context/AuthContext';
import { useRealtime } from '@/components/providers/RealtimeProvider';
import { useDashboardCache } from '@/store/useDashboardCache';
import { useSyncStore } from '@/store/useSyncStore';
import { teamService, invoiceService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

export interface DashboardStats {
    totalRevenue: number;
    outstanding: number;
    paidCount: number;
    strengthIndex: number;
}

export function useDashboardData() {
    const { userData, user } = useAuth();
    const { lastSyncTime } = useRealtime();
    const { cachedInvoices, cachedStats, currencyCode: cachedCurrency, setCache } = useDashboardCache();
    const { isOnline } = useSyncStore();
    
    const [invoices, setInvoices] = useState<Record<string, any>[]>(cachedInvoices || []);
    const [loading, setLoading] = useState(!cachedInvoices?.length);
    const [error, setError] = useState<string | null>(null);
    const [stats, setStats] = useState<DashboardStats>(cachedStats || {
        totalRevenue: 0,
        outstanding: 0,
        paidCount: 0,
        strengthIndex: 0
    });
    const [currencyCode, setCurrencyCode] = useState(cachedCurrency || 'NGN');

    useEffect(() => {
        if (!userData && !user) return;
        
        const fetchDashboardData = async () => {
            if (!isOnline) {
                setLoading(false);
                return;
            }

            try {
                const userId = user?.id || userData?.uid;
                if (!userId) return;
                
                const tData = await teamService.getTeamByUserId(userId);
                const teamId = tData?.id || userId;
                const prefCurrency = tData?.preferred_currency || 'NGN';
                setCurrencyCode(prefCurrency);

                const data = await invoiceService.getInvoices(teamId, 100); 
                const invs = data || [];
                setInvoices(invs);

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

                setStats(newStats);
                setCache(invs, newStats, prefCurrency);
            } catch (err) {
                console.error('Error fetching dashboard data:', err);
                setError('Failed to load dashboard data.');
                // Use already-destructured cachedInvoices from the hook — avoids getState() anti-pattern
                if (!cachedInvoices?.length) {
                    // Only show toast when there is truly no cached fallback
                    const { toast } = await import('react-hot-toast');
                    toast.error('Failed to load dashboard data. Please try refreshing.');
                }
            } finally {
                setLoading(false);
            }
        };

        fetchDashboardData();
    }, [userData, user, lastSyncTime, isOnline]);

    const firstName = userData?.name ? userData.name.split(' ')[0] : 'Noble';

    return { invoices, loading, error, stats, currencyCode, firstName };
}
