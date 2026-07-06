import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { Invoice } from '@/types';

export interface DashboardStats {
    totalRevenue: number;
    outstanding: number;
    paidCount: number;
    strengthIndex: number;
}

interface DashboardCacheStore {
    cachedInvoices: Invoice[];
    cachedStats: DashboardStats;
    currencyCode: string;
    setCache: (invoices: Invoice[], stats: DashboardStats, currencyCode: string) => void;
    clearCache: () => void;
}

export const useDashboardCache = create<DashboardCacheStore>()(
    persist(
        (set) => ({
            cachedInvoices: [],
            cachedStats: {
                totalRevenue: 0,
                outstanding: 0,
                paidCount: 0,
                strengthIndex: 0
            },
            currencyCode: 'NGN',
            setCache: (invoices, stats, currencyCode) => set({ cachedInvoices: invoices, cachedStats: stats, currencyCode }),
            clearCache: () => set({ 
                cachedInvoices: [], 
                cachedStats: { totalRevenue: 0, outstanding: 0, paidCount: 0, strengthIndex: 0 },
                currencyCode: 'NGN'
            })
        }),
        {
            name: 'noble-dashboard-cache',
            storage: createJSONStorage(() => sessionStorage),
        }
    )
);
