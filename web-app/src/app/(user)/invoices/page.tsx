'use client';

import React from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { 
    Plus, Search, Filter, 
    FileText, CheckCircle2, Clock, AlertCircle,
    Download, Send, Sparkles,
    Loader2, Mail
} from 'lucide-react';
import NobleEmptyState from '@/components/shared/NobleEmptyState';
import MagneticCard from '@/components/shared/MagneticCard';
import { useAuth, useFeatureGate } from '@/context/AuthContext';
import { currencyService } from '@/lib/services/currencyService';
import { toast } from 'react-hot-toast';
import { useInvoices } from '@/hooks/useInvoices';
import { supabase } from '@/lib/supabase';
import { teamService } from '@/lib/services/supabaseService';

const TABS = ['All Invoices', 'Drafts', 'Outstanding', 'Paid', 'Overdue'];

export default function InvoicesPage() {
    const { user } = useAuth();
    const { limits } = useFeatureGate();
    const router = useRouter();
    const [activeTab, setActiveTab] = React.useState('All Invoices');
    const [searchQuery, setSearchQuery] = React.useState('');
    const [page, setPage] = React.useState(1);
    const [monthlyCount, setMonthlyCount] = React.useState<number | null>(null);

    React.useEffect(() => {
        if (!user) return;
        const fetchCount = async () => {
            const tData = await teamService.getTeamByUserId(user.id);
            const teamId = tData?.id || user.id;
            const startOfMonth = new Date();
            startOfMonth.setDate(1);
            startOfMonth.setHours(0, 0, 0, 0);
            const { count } = await supabase
                .from('invoices')
                .select('*', { count: 'exact', head: true })
                .eq('team_id', teamId)
                .gte('created_at', startOfMonth.toISOString());
            setMonthlyCount(count || 0);
        };
        fetchCount();
    }, [user]);

    React.useEffect(() => {
        setPage(1);
    }, [searchQuery, activeTab]);
    const PAGE_SIZE = 50;

    const { 
        invoices, 
        loading, 
        hasMore, 
        baseCurrency, 
        exchangeRates, 
        handleMarkAsPaid 
    } = useInvoices(page, PAGE_SIZE);

    const formatCurrency = (amount: number, currencyCode: string) => {
        // Use Number() instead of parseFloat() — safer when value is already numeric
        const rawAmount = Number(amount) || 0;
        const targetCurrency = currencyCode || 'NGN';
        
        if (targetCurrency === baseCurrency || !exchangeRates) {
            return (
                <span className="text-slate-900 font-semibold text-[13px]">
                    {currencyService.format(rawAmount, targetCurrency, { decimals: 2 })}
                </span>
            );
        }

        // Convert rawAmount from original currency to base currency
        const converted = currencyService.convert(rawAmount, targetCurrency, baseCurrency, exchangeRates);
        return (
            <div className="flex flex-col">
                <span className="text-slate-900 font-semibold text-[13px]">
                    {currencyService.format(converted, baseCurrency, { decimals: 2 })}
                </span>
                <span className="text-[10px] text-slate-400 font-medium uppercase tracking-wider mt-0.5">
                    Original: {currencyService.format(rawAmount, targetCurrency, { decimals: 2 })}
                </span>
            </div>
        );
    };

    const getStatusBadge = (status: string) => {
        switch (status?.toLowerCase()) {
            case 'paid':
                return <span className="px-2 py-0.5 rounded-full text-[8px] font-bold uppercase tracking-wider bg-emerald-100 text-emerald-800 border border-emerald-200">PAID</span>;
            case 'overdue':
                return <span className="px-2 py-0.5 rounded-full text-[8px] font-bold uppercase tracking-wider bg-rose-100 text-rose-800 border border-rose-200">OVERDUE</span>;
            case 'unpaid':
            case 'sent':
            case 'pending':
                return <span className="px-2 py-0.5 rounded-full text-[8px] font-bold uppercase tracking-wider bg-blue-100 text-blue-800 border border-blue-200">OUTSTANDING</span>;
            case 'draft':
            default:
                return <span className="px-2 py-0.5 rounded-full text-[8px] font-bold uppercase tracking-wider bg-slate-100 text-slate-800 border border-slate-200">DRAFT</span>;
        }
    };

    const filteredInvoices = React.useMemo(() => {
        return invoices.filter(invoice => {
            const matchesSearch = 
                invoice.invoice_number?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                invoice.clients?.name?.toLowerCase().includes(searchQuery.toLowerCase());
            
            if (!matchesSearch) return false;

            if (activeTab === 'All Invoices') return true;
            if (activeTab === 'Drafts') return invoice.status === 'draft';
            if (activeTab === 'Outstanding') return invoice.status === 'pending' || invoice.status === 'sent' || invoice.status === 'unpaid';
            if (activeTab === 'Paid') return invoice.status === 'paid';
            if (activeTab === 'Overdue') return invoice.status === 'overdue';
            return true;
        });
    }, [invoices, searchQuery, activeTab]);

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header Area with Cinematic Glass */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-8">
                    <motion.div
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                    >
                        <div className="flex items-center gap-3 mb-3">
                            <div className="w-12 h-12 rounded-[20px] bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center text-noble-blue border border-white/50 shadow-inner">
                                <FileText className="w-6 h-6 fill-current opacity-80" />
                            </div>
                            <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                Master <span className="text-noble-blue">Ledger</span>
                            </h1>
                        </div>
                        <p className="text-slate-500 text-sm font-bold max-w-md mt-1">Orchestrate your revenue with pixel-perfect tracking.</p>
                    </motion.div>
                    
                    <motion.div 
                        initial={{ opacity: 0, scale: 0.9 }}
                        animate={{ opacity: 1, scale: 1 }}
                        className="flex items-center gap-4"
                    >
                        <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                            {(() => {
                                const canCreate = !limits || limits.max_invoices_per_month === -1 || (monthlyCount ?? 0) < limits.max_invoices_per_month;

                                return canCreate ? (
                                    <Link 
                                        href="/invoices/new"
                                        className="group relative overflow-hidden flex items-center gap-2 px-8 py-4 bg-white/60 backdrop-blur-md border border-white hover:border-noble-blue/30 text-slate-900 font-black text-[11px] uppercase tracking-[0.2em] rounded-2xl hover:bg-white transition-all shadow-[0_10px_20px_rgba(0,0,0,0.02)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.1)]"
                                    >
                                        <div className="w-6 h-6 rounded-full bg-noble-blue flex items-center justify-center group-hover:scale-110 transition-transform shadow-inner">
                                            <Plus className="w-3.5 h-3.5 text-white" />
                                        </div>
                                        <span>Create Invoice</span>
                                    </Link>
                                ) : (
                                    <button 
                                        onClick={() => {
                                            toast('You have reached your monthly limit. Please upgrade.', { icon: '🚀' });
                                            router.push('/pricing');
                                        }}
                                        className="group relative overflow-hidden flex items-center gap-2 px-8 py-4 bg-slate-100 backdrop-blur-md border border-white text-slate-500 font-black text-[11px] uppercase tracking-[0.2em] rounded-2xl transition-all shadow-[0_10px_20px_rgba(0,0,0,0.02)] cursor-pointer"
                                    >
                                        <div className="w-6 h-6 rounded-full bg-slate-300 flex items-center justify-center shadow-inner">
                                            <Plus className="w-3.5 h-3.5 text-white" />
                                        </div>
                                        <span>Upgrade to Create</span>
                                    </button>
                                );
                            })()}
                        </motion.div>
                    </motion.div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 mt-12 relative z-10">
                {/* Filters & Search - Noble Glass Upgrade */}
                <motion.div 
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="bg-white/40 backdrop-blur-2xl p-4 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.03)] mb-8 flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden"
                >
                    <div className="absolute top-[-20%] right-[-10%] w-[300px] h-[300px] bg-noble-blue/5 blur-[80px] rounded-full pointer-events-none z-0" />

                    <div className="flex items-center overflow-x-auto w-full md:w-auto hide-scrollbar gap-2 p-1 relative z-10">
                        {TABS.map((tab) => (
                            <motion.button
                                whileTap={{ scale: 0.95 }}
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`relative px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-[0.2em] transition-all ${
                                    activeTab === tab 
                                    ? 'text-noble-blue bg-white shadow-sm' 
                                    : 'text-slate-400 hover:text-slate-700 hover:bg-white/50'
                                }`}
                            >
                                <span className="relative z-10">{tab}</span>
                            </motion.button>
                        ))}
                    </div>
                    
                    <div className="flex items-center gap-4 w-full md:w-auto relative z-10">
                        <div className="relative w-full md:w-80">
                            <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 z-10" />
                            <input 
                                type="text"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                placeholder="Search ledger..."
                                className="w-full pl-12 pr-6 py-4 bg-white/60 backdrop-blur-md border border-white/60 rounded-2xl text-xs font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>
                        <motion.button 
                            whileTap={{ scale: 0.95 }} 
                            onClick={() => toast('Advanced filters coming soon', { icon: '🔧' })}
                            className="p-4 bg-white/60 backdrop-blur-md border border-white/60 text-slate-500 rounded-2xl hover:border-noble-blue/30 hover:bg-white transition-all shadow-sm"
                        >
                            <Filter className="w-[18px] h-[18px]" />
                        </motion.button>
                    </div>
                </motion.div>

                {/* Invoices Table Area */}
                <motion.div 
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.1 }}
                    className="bg-white/40 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] overflow-hidden"
                >
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-near-black/[0.03] bg-near-black/[0.01] table-row w-full">
                                    <th className="px-4 md:px-8 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Invoice Reference</th>
                                    <th className="px-4 md:px-8 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Client Entity</th>
                                    <th className="px-4 md:px-8 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Asset Value</th>
                                    <th className="px-4 md:px-8 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Timeline</th>
                                    <th className="px-2 md:px-3 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle w-[120px]">Lifecycle Status</th>
                                    <th className="px-2 py-4 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Operations</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading ? (
                                    <tr>
                                        <td colSpan={6} className="px-8 py-32 text-center">
                                            <div className="flex flex-col items-center justify-center gap-4">
                                                <Loader2 className="w-10 h-10 text-noble-blue animate-spin" />
                                                <p className="text-slate-500 text-xs font-bold uppercase tracking-widest">Decrypting ledger transactions...</p>
                                            </div>
                                        </td>
                                    </tr>
                                ) : filteredInvoices.length === 0 ? (
                                    <tr>
                                        <td colSpan={6} className="px-8 py-16">
                                            <NobleEmptyState
                                                icon={FileText}
                                                accentIcon={Sparkles}
                                                title="No Invoices Yet"
                                                description="Your financial pipeline is clear. Start billing for your expertise by drafting your first professional invoice."
                                                actions={[
                                                    { label: '+ Create Invoice', onClick: () => router.push('/invoices/new') }
                                                ]}
                                            />
                                        </td>
                                    </tr>
                                ) : (
                                    filteredInvoices.map((invoice, i) => (
                                        <motion.tr 
                                            key={invoice.id}
                                            initial={{ opacity: 0, y: 10 }}
                                            animate={{ opacity: 1, y: 0 }}
                                            transition={{ delay: i * 0.03 }}
                                            className="border-b border-near-black/[0.03] hover:bg-white/60 transition-colors group cursor-pointer"
                                            onClick={() => router.push(`/invoices/${invoice.id}`)}
                                        >
                                            <td className="px-4 md:px-8 py-3.5 font-medium text-slate-800 text-[13px]">
                                                #{invoice.invoice_number}
                                            </td>
                                            <td className="px-4 md:px-8 py-3.5 text-slate-600 text-[13px] font-medium">
                                                {invoice.clients?.name || 'Unnamed Client'}
                                            </td>
                                            <td className="px-4 md:px-8 py-3.5 font-semibold text-slate-900 text-[13px]">
                                                {formatCurrency(invoice.total_amount || 0, invoice.currency_code)}
                                            </td>
                                            <td className="px-4 md:px-8 py-3.5 text-slate-500 text-[12px] font-medium">
                                                Due: {invoice.due_date ? new Date(invoice.due_date).toLocaleDateString() : 'N/A'}
                                            </td>
                                            <td className="px-2 md:px-3 py-3.5">
                                                {getStatusBadge(invoice.status)}
                                            </td>
                                            <td className="px-2 py-3.5 text-left">
                                                <div className="flex items-center justify-start gap-2">
                                                    {invoice.status !== 'paid' && (
                                                        <motion.button
                                                            whileTap={{ scale: 0.95 }}
                                                            onClick={(e) => { e.stopPropagation(); handleMarkAsPaid(invoice.id); }}
                                                            className="px-3 py-1.5 rounded-xl bg-emerald-50 text-emerald-600 hover:bg-emerald-600 hover:text-white text-[10px] font-black uppercase tracking-wider transition-all border border-emerald-100"
                                                            title="Mark as Paid"
                                                        >
                                                            Mark Paid
                                                        </motion.button>
                                                    )}
                                                    {(invoice.pdf_url || invoice.tracking_token) && (
                                                        <>
                                                            <motion.div whileTap={{ scale: 0.95 }} className="inline-flex mr-2">
                                                                <div className="flex bg-slate-50 border border-slate-200 rounded-xl overflow-hidden">
                                                                    <button
                                                                        onClick={(e) => {
                                                                            e.stopPropagation();
                                                                            const email = invoice.clients?.email || '';
                                                                            const rawAmount = Number(invoice.total_amount) || 0;
                                                                            const amountStr = currencyService.format(rawAmount, invoice.currency_code || 'NGN', { decimals: 2 });
                                                                            const portalUrl = `${window.location.origin}/portal/${invoice.tracking_token}`;
                                                                            const subject = encodeURIComponent(`Invoice #${invoice.invoice_number} from NobleInvoice`);
                                                                            const body = encodeURIComponent(`Hello ${invoice.clients?.name || ''},\n\nHere is your invoice #${invoice.invoice_number} for ${amountStr}.\n\nYou can view and pay it securely here:\n${portalUrl}\n\nThank you for your business!`);
                                                                            window.open(`mailto:${email}?subject=${subject}&body=${body}`, '_blank', 'noopener,noreferrer');
                                                                        }}
                                                                        className="p-2 text-slate-500 hover:bg-blue-500 hover:text-white transition-all border-r border-slate-200"
                                                                        title="Send via Email"
                                                                    >
                                                                        <Mail className="w-3.5 h-3.5" />
                                                                    </button>
                                                                    <button
                                                                        onClick={(e) => {
                                                                            e.stopPropagation();
                                                                            const phone = invoice.clients?.phone ? String(invoice.clients.phone).replace(/\D/g, '') : '';
                                                                            const rawAmount = Number(invoice.total_amount) || 0;
                                                                            const amountStr = currencyService.format(rawAmount, invoice.currency_code || 'NGN', { decimals: 2 });
                                                                            const portalUrl = `${window.location.origin}/portal/${invoice.tracking_token}`;
                                                                            const text = `Hello ${invoice.clients?.name || ''}, here is your invoice #${invoice.invoice_number} for ${amountStr}. You can view and pay it securely here: ${portalUrl}`;
                                                                            window.open(`https://wa.me/${phone}?text=${encodeURIComponent(text)}`, '_blank', 'noopener,noreferrer');
                                                                        }}
                                                                        className="p-2 text-slate-500 hover:bg-emerald-500 hover:text-white transition-all"
                                                                        title="Send via WhatsApp"
                                                                    >
                                                                        <Send className="w-3.5 h-3.5" />
                                                                    </button>
                                                                </div>
                                                            </motion.div>
                                                            <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                                                                <a
                                                                    href={invoice.pdf_url || `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/get-invoice-proxy?id=${invoice.id}&token=${invoice.tracking_token}`}
                                                                    target="_blank"
                                                                    rel="noreferrer"
                                                                    onClick={(e) => e.stopPropagation()}
                                                                    className="p-2 rounded-xl bg-noble-blue/10 text-noble-blue hover:bg-noble-blue hover:text-white transition-all border border-noble-blue/10"
                                                                    title="View PDF"
                                                                >
                                                                    <Download className="w-3.5 h-3.5" />
                                                                </a>
                                                            </motion.div>
                                                        </>
                                                    )}
                                                </div>
                                            </td>
                                        </motion.tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                        
                        {/* Pagination Controls */}
                        <div className="p-4 border-t border-near-black/[0.03] flex items-center justify-between bg-white/30 backdrop-blur-md">
                            <span className="text-[10px] font-bold uppercase tracking-[0.15em] text-slate-500">
                                Page {page}
                            </span>
                            <div className="flex gap-2">
                                <button
                                    onClick={() => setPage(p => Math.max(1, p - 1))}
                                    disabled={page === 1 || loading}
                                    className="px-4 py-2 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-700 bg-white border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 transition-all shadow-sm"
                                >
                                    Previous
                                </button>
                                <button
                                    onClick={() => setPage(p => p + 1)}
                                    disabled={!hasMore || loading}
                                    className="px-4 py-2 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-700 bg-white border border-slate-200 rounded-xl hover:bg-slate-50 disabled:opacity-50 transition-all shadow-sm"
                                >
                                    Next
                                </button>
                            </div>
                        </div>
                    </div>
                </motion.div>
            </div>
        </div>
    );
}
