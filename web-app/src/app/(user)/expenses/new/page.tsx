'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { motion, AnimatePresence } from 'framer-motion';
import { 
    ArrowLeft, Calendar, Link as LinkIcon, 
    Tag, Building2, AlignLeft, Sparkles, Loader2,
    ScanLine, DollarSign, CheckCircle2
} from 'lucide-react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/context/AuthContext';
import { expenseService, teamService, invoiceService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import ReceiptScannerModal from '@/components/features/expenses/ReceiptScannerModal';

export default function AddExpensePage() {
    const router = useRouter();
    const { user } = useAuth();

    // Form state
    const [amount, setAmount] = useState('');
    const [notes, setNotes] = useState('');
    const [expenseDate, setExpenseDate] = useState(new Date().toISOString().split('T')[0]);
    const [categoryId, setCategoryId] = useState('');
    const [vendor, setVendor] = useState('');
    const [invoiceId, setInvoiceId] = useState('');
    const [currencyCode, setCurrencyCode] = useState('NGN');
    const [saving, setSaving] = useState(false);
    const [aiPrefilled, setAiPrefilled] = useState(false);

    // Data from backend
    const [categories, setCategories] = useState<any[]>([]);
    const [invoices, setInvoices] = useState<any[]>([]);

    // Scanner modal state
    const [scannerOpen, setScannerOpen] = useState(false);

    useEffect(() => {
        if (!user) return;
        const loadInitialData = async () => {
            try {
                const cats = await expenseService.getExpenseCategories();
                setCategories(cats || []);

                const tData = await teamService.getTeamByUserId(user.id);
                const teamId = tData?.id || user.id;
                const invs = await invoiceService.getInvoices(teamId);
                setInvoices(invs || []);
            } catch (err) {
                console.error('Error loading initial data:', err);
            }
        };
        loadInitialData();
    }, [user]);

    // Called when AI Scanner extracts data from a receipt
    const handleScannedData = (data: {
        vendor?: string;
        amount?: number;
        currency_code?: string;
        expense_date?: string;
        category?: string;
        notes?: string;
    }) => {
        if (data.vendor) setVendor(data.vendor);
        if (data.amount) setAmount(String(data.amount));
        if (data.currency_code) setCurrencyCode(data.currency_code);
        if (data.expense_date) setExpenseDate(data.expense_date);
        if (data.notes) setNotes(data.notes);

        // Auto-match category name to a category ID
        if (data.category && categories.length > 0) {
            const matched = categories.find(c =>
                c.name?.toLowerCase().includes(data.category!.toLowerCase()) ||
                data.category!.toLowerCase().includes(c.name?.toLowerCase())
            );
            if (matched) setCategoryId(String(matched.id));
        }

        setAiPrefilled(true);
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!user) return;
        if (!amount || isNaN(parseFloat(amount))) {
            toast.error('Please enter a valid amount');
            return;
        }

        setSaving(true);
        try {
            const tData = await teamService.getTeamByUserId(user.id);
            const teamId = tData?.id || user.id;

            // Resolve vendor ID
            let resolvedVendorId: number | null = null;
            if (vendor.trim()) {
                resolvedVendorId = await expenseService.resolveVendor(teamId, user.id, vendor);
            }

            const payload = {
                team_id: teamId,
                user_id: user.id,
                amount: parseFloat(amount),
                currency_code: currencyCode,
                notes: notes,
                expense_date: expenseDate,
                category_id: categoryId ? parseInt(categoryId) : null,
                vendor_id: resolvedVendorId,
                invoice_id: invoiceId ? parseInt(invoiceId) : null,
            };

            await expenseService.createExpense(payload);
            toast.success('Expense saved successfully');
            router.push('/expenses');
        } catch (err) {
            console.error('Failed to save expense:', err);
            toast.error('Failed to save expense');
        } finally {
            setSaving(false);
        }
    };

    const CURRENCIES = ['NGN', 'USD', 'EUR', 'GBP', 'GHS', 'KES', 'ZAR', 'CAD', 'AUD'];

    return (
        <div className="min-h-screen bg-[#F0F4F8] relative overflow-hidden pb-24">
            {/* Ambient gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[700px] h-[700px] bg-noble-blue/8 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/8 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header */}
            <div className="bg-white/60 backdrop-blur-3xl border-b border-white/60 px-8 py-6 sticky top-0 z-20 shadow-[0_10px_30px_rgba(0,0,0,0.02)]">
                <div className="max-w-3xl mx-auto flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <Link
                            href="/expenses"
                            className="p-2 -ml-2 text-slate-500 hover:text-slate-900 hover:bg-white/60 rounded-xl transition-all"
                        >
                            <ArrowLeft className="w-5 h-5" />
                        </Link>
                        <div>
                            <h1 className="text-xl font-black text-slate-900 tracking-tight">Record Expense</h1>
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Spend Control Hub</p>
                        </div>
                    </div>
                    <div className="flex items-center gap-3">
                        {/* AI Scan button in header */}
                        <motion.button
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setScannerOpen(true)}
                            className="flex items-center gap-2 px-5 py-2.5 bg-white/80 border border-white/60 text-noble-blue font-black text-[10px] uppercase tracking-widest rounded-xl hover:bg-noble-blue hover:text-white hover:border-noble-blue transition-all shadow-sm"
                        >
                            <ScanLine className="w-3.5 h-3.5" />
                            Scan Receipt
                        </motion.button>
                        <motion.button
                            whileTap={{ scale: 0.95 }}
                            onClick={handleSave}
                            disabled={saving}
                            className="flex items-center gap-2 px-6 py-2.5 bg-noble-blue text-white font-black text-[10px] uppercase tracking-widest rounded-xl hover:bg-blue-600 transition-all shadow-[0_8px_20px_rgba(22,111,187,0.2)] disabled:opacity-60"
                        >
                            {saving ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <CheckCircle2 className="w-3.5 h-3.5" />}
                            Save Expense
                        </motion.button>
                    </div>
                </div>
            </div>

            <div className="max-w-3xl mx-auto px-8 mt-8 relative z-10">
                <form onSubmit={handleSave} className="space-y-6">

                    {/* AI Pre-fill banner */}
                    <AnimatePresence>
                        {aiPrefilled && (
                            <motion.div
                                initial={{ opacity: 0, height: 0, y: -10 }}
                                animate={{ opacity: 1, height: 'auto', y: 0 }}
                                exit={{ opacity: 0, height: 0 }}
                                className="bg-emerald-50/80 backdrop-blur-sm border border-emerald-200/60 rounded-3xl p-5 flex items-start gap-3"
                            >
                                <div className="w-8 h-8 rounded-xl bg-emerald-100 flex items-center justify-center shrink-0">
                                    <Sparkles className="w-4 h-4 text-emerald-600" />
                                </div>
                                <div>
                                    <p className="text-sm font-black text-emerald-800">AI Pre-filled from Receipt</p>
                                    <p className="text-xs text-emerald-600 font-semibold mt-0.5">
                                        Gemini Vision extracted your expense details. Review and confirm below.
                                    </p>
                                </div>
                            </motion.div>
                        )}
                    </AnimatePresence>

                    {/* Amount + Currency Card */}
                    <div className="bg-white/60 backdrop-blur-2xl border border-white/60 rounded-[28px] p-8 shadow-[0_15px_30px_rgba(0,0,0,0.02)]">
                        <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-4 text-center">
                            Total Amount
                        </label>
                        <div className="flex items-center justify-center gap-4">
                            <select
                                value={currencyCode}
                                onChange={(e) => setCurrencyCode(e.target.value)}
                                className="bg-slate-100/80 border border-slate-200/60 rounded-2xl px-4 py-3 text-sm font-black text-slate-700 outline-none focus:border-noble-blue transition-colors cursor-pointer appearance-none"
                            >
                                {CURRENCIES.map(c => (
                                    <option key={c} value={c}>{c}</option>
                                ))}
                            </select>
                            <input
                                type="number"
                                step="0.01"
                                min="0"
                                placeholder="0.00"
                                value={amount}
                                onChange={(e) => setAmount(e.target.value)}
                                className="text-5xl font-black text-slate-900 bg-transparent outline-none w-48 text-center placeholder:text-slate-200 tracking-tight"
                                required
                            />
                        </div>
                    </div>

                    {/* Details Card */}
                    <div className="bg-white/60 backdrop-blur-2xl border border-white/60 rounded-[28px] shadow-[0_15px_30px_rgba(0,0,0,0.02)] overflow-hidden divide-y divide-slate-100/60">

                        {/* Date */}
                        <div className="flex items-center p-6 hover:bg-white/40 transition-colors group">
                            <div className="w-10 h-10 rounded-xl bg-slate-100/80 flex items-center justify-center mr-4 shrink-0 group-hover:bg-white transition-colors">
                                <Calendar className="w-5 h-5 text-slate-500" />
                            </div>
                            <div className="flex-1">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Date</label>
                                <input
                                    type="date"
                                    value={expenseDate}
                                    onChange={(e) => setExpenseDate(e.target.value)}
                                    className="block w-full bg-transparent font-bold text-slate-800 outline-none mt-1 cursor-pointer text-sm"
                                />
                            </div>
                        </div>

                        {/* Vendor */}
                        <div className="flex items-center p-6 hover:bg-white/40 transition-colors group">
                            <div className="w-10 h-10 rounded-xl bg-slate-100/80 flex items-center justify-center mr-4 shrink-0 group-hover:bg-white transition-colors">
                                <Building2 className="w-5 h-5 text-slate-500" />
                            </div>
                            <div className="flex-1">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Vendor / Merchant</label>
                                <input
                                    type="text"
                                    placeholder="e.g. Uber, Amazon, Shoprite"
                                    value={vendor}
                                    onChange={(e) => setVendor(e.target.value)}
                                    className="block w-full bg-transparent font-bold text-slate-800 outline-none mt-1 placeholder:text-slate-300 text-sm"
                                />
                            </div>
                        </div>

                        {/* Category */}
                        <div className="flex items-center p-6 hover:bg-white/40 transition-colors group">
                            <div className="w-10 h-10 rounded-xl bg-slate-100/80 flex items-center justify-center mr-4 shrink-0 group-hover:bg-white transition-colors">
                                <Tag className="w-5 h-5 text-slate-500" />
                            </div>
                            <div className="flex-1">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Category</label>
                                <select
                                    value={categoryId}
                                    onChange={(e) => setCategoryId(e.target.value)}
                                    className="block w-full bg-transparent font-bold text-slate-800 outline-none mt-1 cursor-pointer appearance-none text-sm"
                                >
                                    <option value="">Select a category...</option>
                                    {categories.map((c) => (
                                        <option key={c.id} value={c.id}>
                                            {c.icon || '🏷️'} {c.name}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>

                        {/* Link to Invoice */}
                        <div className="flex items-center p-6 hover:bg-white/40 transition-colors group">
                            <div className="w-10 h-10 rounded-xl bg-slate-100/80 flex items-center justify-center mr-4 shrink-0 group-hover:bg-white transition-colors">
                                <LinkIcon className="w-5 h-5 text-slate-500" />
                            </div>
                            <div className="flex-1">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Link to Invoice</label>
                                <select
                                    value={invoiceId}
                                    onChange={(e) => setInvoiceId(e.target.value)}
                                    className="block w-full bg-transparent font-bold text-slate-800 outline-none mt-1 cursor-pointer appearance-none text-sm"
                                >
                                    <option value="">Optional — tag to a project</option>
                                    {invoices.map((inv) => (
                                        <option key={inv.id} value={inv.id}>
                                            #{inv.invoice_number || inv.id} — {inv.clients?.company || inv.clients?.name || 'Direct'}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* Notes */}
                    <div className="bg-white/60 backdrop-blur-2xl border border-white/60 rounded-[28px] p-6 shadow-[0_15px_30px_rgba(0,0,0,0.02)]">
                        <div className="flex items-start gap-4">
                            <div className="w-10 h-10 rounded-xl bg-slate-100/80 flex items-center justify-center shrink-0 mt-1">
                                <AlignLeft className="w-5 h-5 text-slate-500" />
                            </div>
                            <div className="flex-1">
                                <label className="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">
                                    Notes / Description
                                </label>
                                <textarea
                                    rows={3}
                                    placeholder="Add extra context about this expense..."
                                    value={notes}
                                    onChange={(e) => setNotes(e.target.value)}
                                    className="w-full bg-slate-50/80 border border-slate-200/60 rounded-2xl p-4 text-sm font-semibold text-slate-800 outline-none focus:border-noble-blue focus:bg-white transition-all resize-none placeholder:text-slate-300"
                                />
                            </div>
                        </div>
                    </div>

                    {/* AI Scan CTA — bottom shortcut */}
                    <motion.button
                        type="button"
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setScannerOpen(true)}
                        className="w-full flex items-center justify-center gap-3 py-5 bg-gradient-to-r from-noble-blue/10 to-electric-cyan/10 border border-noble-blue/20 border-dashed text-noble-blue font-black text-[11px] uppercase tracking-[0.15em] rounded-3xl hover:from-noble-blue/15 hover:to-electric-cyan/15 transition-all"
                    >
                        <ScanLine className="w-4 h-4" />
                        Scan Receipt with AI — Auto-fill this form
                    </motion.button>

                </form>
            </div>

            {/* Receipt Scanner Modal */}
            <ReceiptScannerModal
                isOpen={scannerOpen}
                onClose={() => setScannerOpen(false)}
                onDataExtracted={handleScannedData}
            />
        </div>
    );
}
