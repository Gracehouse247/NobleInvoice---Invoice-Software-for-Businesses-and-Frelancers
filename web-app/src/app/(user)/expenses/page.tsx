'use client';

import React from 'react';
import Link from 'next/link';
import { 
    Plus, Search, Filter, Receipt, 
    MoreHorizontal, Calendar, ArrowDownRight, Tag,
    Loader2, Trash2, FileDown
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { expenseService, teamService } from '@/lib/services/supabaseService';
import { currencyService } from '@/lib/services/currencyService';
import { toast } from 'react-hot-toast';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import NobleEmptyState from '@/components/shared/NobleEmptyState';
import { Sparkles } from 'lucide-react';

const TABS = ['All Expenses', 'Pending', 'Approved', 'Reimbursed'];

export default function ExpensesPage() {
    const { user } = useAuth();
    const router = useRouter();
    const [activeTab, setActiveTab] = React.useState('All Expenses');
    const [expenses, setExpenses] = React.useState<any[]>([]);
    const [loading, setLoading] = React.useState(true);
    const [searchQuery, setSearchQuery] = React.useState('');

    React.useEffect(() => {
        if (!user) return;
        
        const fetchExpenses = async () => {
            try {
                const tData = await teamService.getTeamByUserId(user.id);
                const teamId = tData?.id || user.id;
                const data = await expenseService.getExpenses(teamId);
                setExpenses(data || []);
            } catch (err) {
                console.error('Error fetching expenses:', err);
                toast.error('Failed to load expenses');
            } finally {
                setLoading(false);
            }
        };

        fetchExpenses();
    }, [user]);

    const handleDeleteExpense = async (id: string) => {
        if (!confirm('Are you sure you want to delete this expense?')) return;
        try {
            await expenseService.deleteExpense(id);
            setExpenses(prev => prev.filter(e => e.id !== id));
            toast.success('Expense deleted successfully');
        } catch (err) {
            console.error('Failed to delete expense:', err);
            toast.error('Failed to delete expense');
        }
    };

    const formatCurrency = (amount: number, currencyCode = 'NGN') => {
        return currencyService.format(amount, currencyCode, { decimals: 2 });
    };

    const filteredExpenses = React.useMemo(() => {
        return expenses.filter(expense => {
            const matchesSearch = 
                expense.notes?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                expense.vendors?.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                expense.expense_categories?.name?.toLowerCase().includes(searchQuery.toLowerCase());
            
            if (!matchesSearch) return false;

            if (activeTab === 'All Expenses') return true;
            if (activeTab === 'Pending') return expense.status === 'pending';
            if (activeTab === 'Approved') return expense.status === 'approved';
            if (activeTab === 'Reimbursed') return expense.status === 'reimbursed';
            return true;
        });
    }, [expenses, searchQuery, activeTab]);

    return (
        <div className="min-h-screen bg-[#F0F4F8] selection:bg-noble-blue/20 relative overflow-hidden pb-24 font-inter">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header Area */}
            <div className="bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 relative z-10 shadow-[0_20px_40px_rgba(0,0,0,0.01)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="space-y-1">
                        <div className="flex items-center gap-2">
                            <span className="text-[10px] font-black text-noble-blue uppercase tracking-[0.2em]">Spend Control Hub</span>
                        </div>
                        <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            Expense <span className="text-noble-blue">Manager</span>
                        </h1>
                        <p className="text-slate-500 text-[10px] font-bold">Track your outgoing costs, upload receipts, and manage business spending.</p>
                    </div>
                    <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                        <Link 
                            href="/expenses/new"
                            className="flex items-center gap-2 px-8 py-4 bg-noble-blue text-white font-black text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-blue-600 transition-all shadow-[0_10px_20px_rgba(22,111,187,0.15)] whitespace-nowrap"
                        >
                            <Plus className="w-4 h-4" />
                            Record Expense
                        </Link>
                    </motion.div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-8 mt-10 relative z-10">
                {/* Filters & Search */}
                <div className="bg-white/40 backdrop-blur-2xl p-2.5 rounded-3xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] mb-8 flex flex-col md:flex-row items-center justify-between gap-4">
                    <div className="flex items-center overflow-x-auto w-full md:w-auto pb-2 md:pb-0 no-scrollbar">
                        {TABS.map((tab) => (
                            <motion.button
                                whileTap={{ scale: 0.95 }}
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-wider transition-all whitespace-nowrap ${
                                    activeTab === tab 
                                    ? 'bg-white/80 border-white text-noble-blue shadow-[0_10px_20px_rgba(22,111,187,0.05)]' 
                                    : 'text-slate-500 hover:text-slate-900 hover:bg-white/40'
                                }`}
                            >
                                {tab}
                            </motion.button>
                        ))}
                    </div>
                    
                    <div className="flex items-center gap-3 w-full md:w-auto px-2 md:px-0">
                        <div className="relative w-full md:w-64">
                            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                            <input 
                                type="text"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                placeholder="Search expenses..."
                                className="w-full bg-white/60 border border-white/60 text-slate-800 text-xs font-semibold rounded-2xl pl-11 pr-4 py-3.5 outline-none focus:border-noble-blue transition-colors placeholder:text-slate-400"
                            />
                        </div>
                        <motion.button whileTap={{ scale: 0.95 }} onClick={() => toast('Advanced filters coming soon', { icon: '🔧' })} className="p-3.5 bg-white/60 border border-white/60 text-slate-500 rounded-2xl hover:bg-white hover:border-noble-blue/30 transition-all shadow-sm">
                            <Filter className="w-4 h-4" />
                        </motion.button>
                    </div>
                </div>

                {/* Expenses Table Area */}
                <div className="bg-white/40 backdrop-blur-2xl rounded-[35px] border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.02)] overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-white/60 bg-white/40">
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em]">Date</th>
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em]">Merchant</th>
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em]">Category</th>
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em]">Amount</th>
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em]">Status</th>
                                    <th className="px-8 py-3 text-[9px] font-medium text-slate-500 uppercase tracking-[0.2em] text-right">Receipt / Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading ? (
                                    <tr>
                                        <td colSpan={6} className="px-8 py-24 text-center">
                                            <div className="flex flex-col items-center justify-center gap-4">
                                                <Loader2 className="w-10 h-10 text-noble-blue animate-spin" />
                                                <p className="text-slate-500 text-[10px] font-black uppercase tracking-widest">Retrieving cost audit ledger...</p>
                                            </div>
                                        </td>
                                    </tr>
                                ) : filteredExpenses.length === 0 ? (
                                    <tr>
                                        <td colSpan={6} className="px-8 py-16">
                                            <NobleEmptyState
                                                icon={Receipt}
                                                accentIcon={Sparkles}
                                                title="No expenses recorded"
                                                description="You haven't tracked any expenses yet. Record your first expense to keep your cash flow accurate."
                                                actions={[
                                                    { label: '+ Add Expense', onClick: () => router.push('/expenses/new') }
                                                ]}
                                            />
                                        </td>
                                    </tr>
                                ) : (
                                    filteredExpenses.map((expense) => (
                                        <tr 
                                            key={expense.id}
                                            className="border-b border-white/60 hover:bg-white/40 transition-colors group"
                                        >
                                            <td className="px-8 py-2.5 text-slate-500 font-normal text-xs">
                                                {new Date(expense.expense_date).toLocaleDateString(undefined, {
                                                    year: 'numeric',
                                                    month: 'short',
                                                    day: 'numeric'
                                                })}
                                            </td>
                                            <td className="px-8 py-2.5">
                                                <div className="flex flex-col">
                                                    <span className="font-medium text-slate-700 text-sm">
                                                        {expense.vendors?.name || 'General Overhead'}
                                                    </span>
                                                    {expense.notes && (
                                                        <span className="text-[10px] text-slate-400 font-normal max-w-xs truncate mt-0.5">
                                                            {expense.notes}
                                                        </span>
                                                    )}
                                                </div>
                                            </td>
                                            <td className="px-8 py-2.5">
                                                <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider" style={{
                                                    backgroundColor: `${expense.expense_categories?.color}15` || '#94A3B815',
                                                    color: expense.expense_categories?.color || '#64748B',
                                                    border: `1px solid ${expense.expense_categories?.color}30`
                                                }}>
                                                    {expense.expense_categories?.name || 'Other'}
                                                </span>
                                            </td>
                                            <td className="px-8 py-2.5 font-medium text-slate-700 text-sm">
                                                {formatCurrency(expense.amount, expense.currency_code)}
                                            </td>
                                            <td className="px-8 py-2.5">
                                                <span className={`px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider ${
                                                    expense.status === 'approved' || expense.status === 'reimbursed'
                                                    ? 'bg-emerald-50 text-emerald-700 border border-emerald-100' 
                                                    : 'bg-amber-50 text-amber-700 border border-amber-100'
                                                }`}>
                                                    {expense.status}
                                                </span>
                                            </td>
                                            <td className="px-8 py-2.5 text-right">
                                                <div className="flex items-center justify-end gap-2">
                                                    {expense.receipt_url && (
                                                        <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                                                            <a 
                                                                href={expense.receipt_url}
                                                                target="_blank"
                                                                rel="noreferrer"
                                                                className="p-2 rounded-xl bg-noble-blue/10 text-noble-blue hover:bg-noble-blue hover:text-white transition-all"
                                                                title="Download Receipt"
                                                            >
                                                                <FileDown className="w-3.5 h-3.5" />
                                                            </a>
                                                        </motion.div>
                                                    )}
                                                    <motion.button
                                                        whileTap={{ scale: 0.95 }}
                                                        onClick={() => handleDeleteExpense(expense.id)}
                                                        className="p-2 rounded-xl bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white border border-rose-100 transition-all"
                                                        title="Delete Expense"
                                                    >
                                                        <Trash2 className="w-3.5 h-3.5" />
                                                    </motion.button>
                                                </div>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    );
}
