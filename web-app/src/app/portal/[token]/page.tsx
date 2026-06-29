'use client';

import React, { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { clientService } from '@/lib/services/supabaseService';
import { geoService } from '@/lib/services/geoService';
import { currencyService, ExchangeRates } from '@/lib/services/currencyService';
import { 
    CreditCard, ArrowUpRight, CheckCircle2, 
    Clock, Receipt, FileText, ArrowRight,
    TrendingUp
} from 'lucide-react';
import { motion } from 'framer-motion';

export default function PortalDashboard() {
    const params = useParams();
    const router = useRouter();
    const token = params?.token as string;
    
    const [data, setData] = useState<{ client: any, invoices: any[], ledger: any[] } | null>(null);
const [clientCurrency, setClientCurrency] = useState<string>('NGN');
const [exchangeRates, setExchangeRates] = useState<ExchangeRates | null>(null);

    useEffect(() => {
        if (!token) return;
        clientService.getPortalData(token).then(async res => {
            if (res) {
                setData(res as any);
                // Fetch client geo info
                const geo = await geoService.getClientGeo();
                if (geo && geo.currency) {
                    setClientCurrency(geo.currency);
                }
                // Fetch exchange rates based on owner's base currency
                const baseCurr = res.client?.preferred_currency || 'NGN';
                const rates = await currencyService.getExchangeRates(baseCurr);
                if (rates) setExchangeRates(rates);
            }
        }).catch(console.error);
    }, [token]);

    if (!data) return null; // handled by layout loader

    const invoices = data.invoices || [];
    
    // Computations
    const totalOutstanding = invoices
        .filter(inv => inv.status !== 'paid' && inv.status !== 'draft')
        .reduce((sum, inv) => sum + (inv.total_amount || 0), 0);
        
    const totalPaid = invoices
        .filter(inv => inv.status === 'paid')
        .reduce((sum, inv) => sum + (inv.total_amount || 0), 0);

    const formatCurrency = (amount: number, currency: string = 'NGN') => {
        return currencyService.format(amount, currency, { decimals: 2 });
    };
    const formatAmount = (amount: number, currency: string) => {
        if (clientCurrency && clientCurrency !== currency && exchangeRates) {
            // Use convertBetween to convert from invoice currency to client currency via base rates.
            const converted = currencyService.convertBetween(amount, currency, clientCurrency, exchangeRates);
            return currencyService.format(converted, clientCurrency, { decimals: 2 });
        }
        return formatCurrency(amount, currency);
    };

    const getStatusStyle = (status: string) => {
        switch (status) {
            case 'paid': return 'text-emerald-500 bg-emerald-50 border-emerald-100';
            case 'pending': return 'text-amber-500 bg-amber-50 border-amber-100';
            case 'overdue': return 'text-rose-500 bg-rose-50 border-rose-100';
            default: return 'text-slate-500 bg-slate-50 border-slate-100';
        }
    };

    return (
        <div className="max-w-6xl mx-auto px-8 py-12">
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-12">
                <h1 className="text-4xl font-black text-slate-900 tracking-tighter mb-2">Welcome Back,</h1>
                <p className="text-lg text-slate-500 font-medium max-w-2xl">
                    This is your secure portal to view and manage your billing history with your provider. 
                    No passwords required—this link is unique to you.
                </p>
            </motion.div>

            {/* Metrics Glass Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="bg-white/40 backdrop-blur-xl p-8 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.02)] relative overflow-hidden group">
                    <div className="absolute top-0 right-0 w-32 h-32 bg-amber-400/10 rounded-bl-[100px] transition-transform group-hover:scale-110" />
                    <div className="w-12 h-12 bg-amber-50 text-amber-500 rounded-2xl flex items-center justify-center mb-6 border border-amber-100/50">
                        <Clock size={24} />
                    </div>
                    <div className="text-sm font-black text-slate-400 uppercase tracking-widest mb-2">Total Outstanding</div>
                    <div className="text-4xl font-black text-slate-900 tracking-tighter">{formatCurrency(totalOutstanding, data.client?.preferred_currency || 'NGN')}</div>
                </motion.div>

                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="bg-white/40 backdrop-blur-xl p-8 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.02)] relative overflow-hidden group">
                    <div className="absolute top-0 right-0 w-32 h-32 bg-emerald-400/10 rounded-bl-[100px] transition-transform group-hover:scale-110" />
                    <div className="w-12 h-12 bg-emerald-50 text-emerald-500 rounded-2xl flex items-center justify-center mb-6 border border-emerald-100/50">
                        <CheckCircle2 size={24} />
                    </div>
                    <div className="text-sm font-black text-slate-400 uppercase tracking-widest mb-2">Total Paid</div>
                    <div className="text-4xl font-black text-slate-900 tracking-tighter">{formatCurrency(totalPaid, data.client?.preferred_currency || 'NGN')}</div>
                </motion.div>

                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }} className="bg-white/40 backdrop-blur-xl p-8 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.02)] relative overflow-hidden group lg:col-span-1 md:col-span-2">
                    <div className="absolute top-0 right-0 w-32 h-32 bg-noble-blue/10 rounded-bl-[100px] transition-transform group-hover:scale-110" />
                    <div className="w-12 h-12 bg-noble-blue/5 text-noble-blue rounded-2xl flex items-center justify-center mb-6 border border-noble-blue/10">
                        <TrendingUp size={24} />
                    </div>
                    <div className="text-sm font-black text-slate-400 uppercase tracking-widest mb-2">Total Invoices</div>
                    <div className="text-4xl font-black text-slate-900 tracking-tighter">{invoices.length}</div>
                </motion.div>
            </div>

            {/* Invoices List */}
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.4 }} className="bg-white/60 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] overflow-hidden p-2">
                <div className="p-8 border-b border-slate-100/50 flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-slate-50 border border-slate-100 rounded-2xl flex items-center justify-center text-slate-400">
                            <Receipt size={20} />
                        </div>
                        <h2 className="text-2xl font-black text-slate-900 tracking-tight">Recent Statements</h2>
                    </div>
                </div>

                <div className="p-4">
                    {invoices.length === 0 ? (
                        <div className="text-center py-20">
                            <FileText className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                            <h3 className="text-lg font-bold text-slate-800">No Invoices Found</h3>
                            <p className="text-slate-500 text-sm">Your provider hasn't generated any invoices for you yet.</p>
                        </div>
                    ) : (
                        <div className="space-y-2">
                            {invoices.slice(0, 10).map((inv, idx) => (
                                <motion.div 
                                    initial={{ opacity: 0, x: -10 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.5 + (idx * 0.05) }}
                                    key={inv.id} 
                                    onClick={() => router.push(`/portal/${token}/invoices/${inv.id}`)}
                                    className="flex items-center justify-between p-6 rounded-3xl hover:bg-white/80 transition-all cursor-pointer group border border-transparent hover:border-white shadow-sm hover:shadow-md"
                                >
                                    <div className="flex items-center gap-6">
                                        <div className="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-100 flex items-center justify-center group-hover:scale-105 transition-transform">
                                            <FileText className="w-6 h-6 text-noble-blue/60" />
                                        </div>
                                        <div>
                                            <div className="font-black text-lg text-slate-900 tracking-tight">{inv.invoice_number}</div>
                                            <div className="text-xs font-bold text-slate-400 mt-1">Issued: {inv.issue_date}</div>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-8">
                                        <div className="text-right">
                                            <div className="font-black text-lg text-slate-900">{formatAmount(inv.total_amount, inv.currency_code)}</div>
                                            <div className="mt-1 flex justify-end">
                                                <span className={`px-3 py-1 text-[10px] font-black uppercase tracking-widest rounded-lg border ${getStatusStyle(inv.status)}`}>
                                                    {inv.status}
                                                </span>
                                            </div>
                                        </div>
                                        <div className="w-10 h-10 rounded-xl bg-slate-50 text-slate-400 flex items-center justify-center group-hover:bg-noble-blue group-hover:text-white transition-colors border border-slate-100">
                                            <ArrowRight size={18} />
                                        </div>
                                    </div>
                                </motion.div>
                            ))}
                        </div>
                    )}
                </div>
            </motion.div>
        </div>
    );
}
