'use client';

import React from 'react';
import Link from 'next/link';
import { Zap, Wallet, Clock, CheckCircle2, Shield, Plus, RefreshCw } from 'lucide-react';
import StatCard from '@/components/dashboard/StatCard';
import PredictiveHub from '@/components/dashboard/PredictiveHub';
import AccountsReceivable from '@/components/dashboard/AccountsReceivable';
import CashFlowChart from '@/components/dashboard/CashFlowChart';
import RecentAssets from '@/components/dashboard/RecentAssets';
import { currencyService } from '@/lib/services/currencyService';
import { QuickTourOverlay } from '@/components/ui/QuickTourOverlay';
import { useDashboardData } from '@/hooks/useDashboardData';

export default function DashboardPage() {
    const { invoices, loading, error, stats, currencyCode, firstName } = useDashboardData();

    // Show a non-blocking error banner with a retry button when data fails to load
    if (error && !loading && invoices.length === 0) {
        return (
            <div className="min-h-full bg-slate-50 flex flex-col items-center justify-center p-10">
                <div className="bg-white rounded-3xl shadow-xl p-10 max-w-md w-full text-center">
                    <RefreshCw className="w-10 h-10 text-noble-blue mx-auto mb-4 opacity-60" />
                    <h2 className="text-xl font-black text-slate-900 mb-2">Couldn't Load Dashboard</h2>
                    <p className="text-slate-500 text-sm mb-6">{error}</p>
                    <button
                        onClick={() => window.location.reload()}
                        className="px-8 py-3 bg-noble-blue text-white rounded-full font-black text-xs uppercase tracking-widest hover:bg-noble-blue/90 transition-colors shadow-lg"
                    >
                        Retry
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-full bg-slate-50 p-6 md:p-10 pb-24 relative overflow-hidden">
            <QuickTourOverlay />
            {/* Background lighting effects from mockup */}
            <div className="absolute top-0 left-1/4 w-[150vw] max-w-[800px] h-[150vw] max-h-[800px] bg-white/40 blur-[120px] rounded-full pointer-events-none -translate-y-1/2"></div>
            
            <div className="max-w-[1600px] mx-auto relative z-10">
                {/* 1. Welcome Header Section */}
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-12">
                    <div className="flex items-center gap-4">
                        <div className="w-14 h-14 rounded-full bg-noble-blue/10 flex items-center justify-center border border-noble-blue/20">
                            <Zap className="w-6 h-6 text-noble-blue fill-noble-blue/20" />
                        </div>
                        <div>
                            <h1 className="text-2xl md:text-3xl font-bold text-slate-900">Hello {firstName}, 👋</h1>
                            <p className="text-slate-500 text-sm mt-1">Manage your business performance and cash flow</p>
                        </div>
                    </div>
                    
                    <div className="flex items-center gap-4">
                        <Link 
                            href="/studio"
                            className="px-6 py-4 rounded-full bg-white/80 backdrop-blur-md border border-white shadow-sm flex items-center gap-3 hover:bg-white transition-colors">
                            <Shield className="w-4 h-4 text-cyan-500" />
                            <span className="text-sm font-medium text-slate-700">Business Card</span>
                        </Link>
                        <Link 
                            href="/invoices/new"
                            className="px-8 py-4 rounded-full bg-noble-blue text-white shadow-[0_10px_30px_rgba(22,111,187,0.3)] flex items-center gap-2 hover:bg-noble-blue/90 hover:-translate-y-0.5 transition-all">
                            <Plus className="w-4 h-4" />
                            <span className="text-sm font-medium text-white">Create Invoice</span>
                        </Link>
                    </div>
                </div>

                {/* 2. Top Stats Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <StatCard 
                        title="TOTAL REVENUE" 
                        value={currencyService.format(stats.totalRevenue, currencyCode, { decimals: 0 })} 
                        icon={Wallet} 
                        badgeText="PAID" 
                        badgeType="positive"
                        iconBgColor="bg-blue-50"
                        iconColor="text-noble-blue"
                        loading={loading}
                    />
                    <StatCard 
                        title="OUTSTANDING" 
                        value={currencyService.format(stats.outstanding, currencyCode, { decimals: 0 })} 
                        icon={Clock} 
                        badgeText="PENDING" 
                        badgeType="warning"
                        iconBgColor="bg-orange-50"
                        iconColor="text-orange-500"
                        loading={loading}
                    />
                    <StatCard 
                        title="INVOICES PAID" 
                        value={stats.paidCount.toString()} 
                        icon={CheckCircle2} 
                        badgeText="CLEARED" 
                        badgeType="positive"
                        iconBgColor="bg-green-50"
                        iconColor="text-green-500"
                        loading={loading}
                    />
                    <StatCard 
                        title="STRENGTH INDEX" 
                        value={`${stats.strengthIndex}%`} 
                        icon={Zap} 
                        badgeText={stats.strengthIndex >= 70 ? "OPTIMAL" : stats.strengthIndex >= 40 ? "FAIR" : "LOW"} 
                        badgeType={stats.strengthIndex >= 70 ? "positive" : stats.strengthIndex >= 40 ? "neutral" : "warning"}
                        iconBgColor="bg-cyan-50"
                        iconColor="text-cyan-500"
                        loading={loading}
                    />
                </div>

                {/* 3. Middle Section: Predictive Hub & Accounts Receivable */}
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 mb-8 h-auto items-stretch">
                    <div className="lg:col-span-4 h-full">
                        <PredictiveHub invoices={invoices} currencyCode={currencyCode} />
                    </div>
                    <div className="lg:col-span-8 h-full">
                        <AccountsReceivable invoices={invoices} currencyCode={currencyCode} />
                    </div>
                </div>

                {/* 4. Bottom Section: Cash Flow Chart & Recent Assets */}
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 h-auto lg:h-[400px] mb-12">
                    <div className="lg:col-span-8 h-full">
                        <CashFlowChart invoices={invoices} currencyCode={currencyCode} />
                    </div>
                    <div className="lg:col-span-4 h-full">
                        <RecentAssets invoices={invoices} currencyCode={currencyCode} />
                    </div>
                </div>
            </div>
        </div>
    );
}
