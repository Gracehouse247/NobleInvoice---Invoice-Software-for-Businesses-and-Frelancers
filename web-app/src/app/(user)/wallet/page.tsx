'use client';

import React, { useState, useEffect, useCallback } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
    Wallet as WalletIcon, ArrowUpRight, ArrowDownRight, 
    CreditCard, RefreshCw, ShieldCheck,
    Banknote, History, Loader2, X, Check, AlertCircle,
    Building2, ExternalLink
} from 'lucide-react';
import { useAuth, useFeatureGate } from '@/context/AuthContext';
import { supabase } from '@/lib/supabase';
import { toast } from 'react-hot-toast';
import { useRouter } from 'next/navigation';

// ── Types ─────────────────────────────────────────────────────────────────────
interface Wallet {
    id: string;
    user_id: string;
    currency_code: string;
    balance: number;
    updated_at: string;
}

interface WalletTransaction {
    id: string;
    type: 'INVOICE_PAYMENT' | 'WITHDRAWAL' | 'REFUND';
    amount: number;
    fee: number;
    net_amount: number;
    currency_code: string;
    status: 'completed' | 'pending' | 'failed';
    reference: string;
    description: string;
    created_at: string;
    metadata: Record<string, number>;
}

interface WithdrawForm {
    account_number: string;
    account_bank: string;
    account_name: string;
    amount: string;
    narration: string;
}

// Nigerian banks (FLW bank codes)
const NIGERIAN_BANKS = [
    { name: 'Access Bank',         code: '044' },
    { name: 'Citibank Nigeria',    code: '023' },
    { name: 'Diamond Bank',        code: '063' },
    { name: 'Ecobank Nigeria',     code: '050' },
    { name: 'Fidelity Bank',       code: '070' },
    { name: 'First Bank Nigeria',  code: '011' },
    { name: 'First City Monument Bank (FCMB)', code: '214' },
    { name: 'Globus Bank',         code: '00103' },
    { name: 'GTBank',              code: '058' },
    { name: 'Heritage Bank',       code: '030' },
    { name: 'Keystone Bank',       code: '082' },
    { name: 'Kuda Bank',           code: '50211' },
    { name: 'OPay',                code: '999992' },
    { name: 'Palmpay',             code: '999991' },
    { name: 'Polaris Bank',        code: '076' },
    { name: 'Providus Bank',       code: '101' },
    { name: 'Stanbic IBTC Bank',   code: '221' },
    { name: 'Standard Chartered',  code: '068' },
    { name: 'Sterling Bank',       code: '232' },
    { name: 'Union Bank Nigeria',  code: '032' },
    { name: 'United Bank for Africa (UBA)', code: '033' },
    { name: 'Unity Bank',          code: '215' },
    { name: 'VFD Microfinance Bank', code: '566' },
    { name: 'Wema Bank',           code: '035' },
    { name: 'Zenith Bank',         code: '057' },
];

// Transfer fee calculator
function getTransferFee(amount: number, currency: string): number {
    if (currency !== 'NGN') return 0;
    if (amount <= 5000)  return 10.75;
    if (amount <= 50000) return 26.88;
    return 53.80;
}

function formatCurrency(amount: number, currency: string = 'NGN'): string {
    return new Intl.NumberFormat('en-NG', {
        style: 'currency',
        currency,
        minimumFractionDigits: 2,
    }).format(amount);
}

function formatDate(dateStr: string): string {
    return new Date(dateStr).toLocaleDateString('en-NG', {
        day: 'numeric', month: 'short', year: 'numeric',
        hour: '2-digit', minute: '2-digit',
    });
}

// ── Withdrawal Modal ──────────────────────────────────────────────────────────
function WithdrawModal({
    wallet,
    onClose,
    onSuccess,
}: {
    wallet: Wallet;
    onClose: () => void;
    onSuccess: () => void;
}) {
    const { user } = useAuth();
    const [form, setForm] = useState<WithdrawForm>({
        account_number: '',
        account_bank:   '',
        account_name:   '',
        amount:         '',
        narration:      '',
    });
    const [step, setStep] = useState<'form' | 'confirm' | 'success'>('form');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const parsedAmount = parseFloat(form.amount) || 0;
    const transferFee  = getTransferFee(parsedAmount, wallet.currency_code);
    const netReceived  = Math.max(0, parsedAmount - transferFee);
    const selectedBank = NIGERIAN_BANKS.find(b => b.code === form.account_bank);
    const isValidAmount = parsedAmount > transferFee && parsedAmount <= wallet.balance;

    const handleSubmit = async () => {
        setLoading(true);
        setError('');
        try {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) throw new Error('Not authenticated');

            const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL!;

            const res = await fetch(`${SUPABASE_URL}/functions/v1/withdraw-funds`, {
                method: 'POST',
                headers: {
                    'Content-Type':  'application/json',
                    'Authorization': `Bearer ${session.access_token}`,
                },
                body: JSON.stringify({
                    amount:         parsedAmount,
                    currency:       wallet.currency_code,
                    account_number: form.account_number,
                    account_bank:   form.account_bank,
                    account_name:   form.account_name,
                    narration:      form.narration || `NobleInvoice Withdrawal`,
                }),
            });

            const data = await res.json();
            if (!res.ok) throw new Error(data.error || 'Withdrawal failed');

            setStep('success');
            onSuccess();
        } catch (err: any) {
            setError(err.message || 'Withdrawal failed. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-md"
            onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
        >
            <motion.div
                initial={{ opacity: 0, scale: 0.95, y: 20 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 20 }}
                className="w-full max-w-md bg-white rounded-[2rem] shadow-[0_40px_80px_rgba(0,0,0,0.12)] border border-slate-100 overflow-hidden"
            >
                {/* Header */}
                <div className="flex items-center justify-between px-8 pt-8 pb-6 border-b border-slate-100">
                    <div>
                        <h2 className="text-lg font-black text-slate-900 tracking-tight" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            {step === 'success' ? 'Withdrawal Initiated' : 'Withdraw Funds'}
                        </h2>
                        <p className="text-xs text-slate-400 font-medium mt-0.5">
                            Available: {formatCurrency(wallet.balance, wallet.currency_code)}
                        </p>
                    </div>
                    <button onClick={onClose} className="p-2 rounded-xl hover:bg-slate-100 text-slate-400 transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                <div className="px-8 py-6">
                    {/* Success State */}
                    {step === 'success' && (
                        <div className="text-center py-4">
                            <div className="w-16 h-16 bg-emerald-50 rounded-2xl flex items-center justify-center mx-auto mb-4 border border-emerald-100">
                                <Check className="w-8 h-8 text-emerald-600" />
                            </div>
                            <h3 className="text-lg font-black text-slate-900 mb-2">Payout Submitted!</h3>
                            <p className="text-sm text-slate-500 leading-relaxed">
                                Your withdrawal of <span className="font-bold text-slate-700">{formatCurrency(netReceived, wallet.currency_code)}</span> is being processed.
                                Funds typically arrive within a few minutes.
                            </p>
                            <button
                                onClick={onClose}
                                className="mt-6 w-full bg-[#166FBB] text-white font-black text-[11px] uppercase tracking-[0.2em] py-4 rounded-xl hover:bg-[#1260a8] transition-colors"
                            >
                                Done
                            </button>
                        </div>
                    )}

                    {/* Confirm State */}
                    {step === 'confirm' && (
                        <div className="space-y-5">
                            <div className="bg-slate-50 rounded-2xl p-5 space-y-3 border border-slate-100">
                                <div className="flex justify-between text-sm">
                                    <span className="text-slate-500">Amount</span>
                                    <span className="font-black text-slate-900">{formatCurrency(parsedAmount, wallet.currency_code)}</span>
                                </div>
                                <div className="flex justify-between text-sm">
                                    <span className="text-slate-500">Transfer Fee</span>
                                    <span className="font-semibold text-rose-500">-{formatCurrency(transferFee, wallet.currency_code)}</span>
                                </div>
                                <div className="flex justify-between text-sm border-t border-slate-200 pt-3 mt-1">
                                    <span className="font-black text-slate-700">You Receive</span>
                                    <span className="font-black text-emerald-600 text-base">{formatCurrency(netReceived, wallet.currency_code)}</span>
                                </div>
                            </div>
                            <div className="bg-slate-50 rounded-2xl p-5 space-y-2 border border-slate-100">
                                <p className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-3">Recipient Details</p>
                                <p className="font-semibold text-slate-800">{form.account_name}</p>
                                <p className="text-sm text-slate-500">{form.account_number} · {selectedBank?.name}</p>
                            </div>
                            {error && (
                                <div className="flex items-center gap-2 bg-rose-50 text-rose-600 text-sm font-semibold p-4 rounded-xl border border-rose-100">
                                    <AlertCircle className="w-4 h-4 shrink-0" />
                                    {error}
                                </div>
                            )}
                            <div className="flex gap-3">
                                <button
                                    onClick={() => setStep('form')}
                                    disabled={loading}
                                    className="flex-1 py-4 rounded-xl border border-slate-200 text-slate-700 font-black text-[11px] uppercase tracking-[0.2em] hover:border-slate-300 transition-colors"
                                >
                                    Back
                                </button>
                                <button
                                    onClick={handleSubmit}
                                    disabled={loading}
                                    className="flex-1 py-4 rounded-xl bg-[#166FBB] text-white font-black text-[11px] uppercase tracking-[0.2em] hover:bg-[#1260a8] transition-colors disabled:opacity-60 flex items-center justify-center gap-2"
                                >
                                    {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : 'Confirm Withdrawal'}
                                </button>
                            </div>
                        </div>
                    )}

                    {/* Form State */}
                    {step === 'form' && (
                        <div className="space-y-4">
                            <div>
                                <label className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 block">Amount ({wallet.currency_code})</label>
                                <input
                                    type="number"
                                    min="0"
                                    max={wallet.balance}
                                    placeholder="0.00"
                                    value={form.amount}
                                    onChange={e => setForm(f => ({ ...f, amount: e.target.value }))}
                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl py-3.5 px-4 text-slate-900 text-lg font-black focus:outline-none focus:ring-2 focus:ring-[#166FBB]/30 focus:border-[#166FBB] transition-all"
                                />
                                {parsedAmount > 0 && (
                                    <p className={`text-xs mt-1.5 font-semibold ${isValidAmount ? 'text-slate-400' : 'text-rose-500'}`}>
                                        {parsedAmount > wallet.balance
                                            ? `Exceeds available balance of ${formatCurrency(wallet.balance, wallet.currency_code)}`
                                            : parsedAmount <= transferFee
                                            ? `Must be greater than the ${formatCurrency(transferFee, wallet.currency_code)} transfer fee`
                                            : `You will receive ${formatCurrency(netReceived, wallet.currency_code)} after ${formatCurrency(transferFee, wallet.currency_code)} fee`
                                        }
                                    </p>
                                )}
                            </div>

                            <div>
                                <label className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 block">Bank</label>
                                <select
                                    value={form.account_bank}
                                    onChange={e => setForm(f => ({ ...f, account_bank: e.target.value }))}
                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl py-3.5 px-4 text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#166FBB]/30 focus:border-[#166FBB] transition-all"
                                >
                                    <option value="">Select a bank...</option>
                                    {NIGERIAN_BANKS.map(bank => (
                                        <option key={bank.code} value={bank.code}>{bank.name}</option>
                                    ))}
                                </select>
                            </div>

                            <div>
                                <label className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 block">Account Number</label>
                                <input
                                    type="text"
                                    maxLength={10}
                                    placeholder="0123456789"
                                    value={form.account_number}
                                    onChange={e => setForm(f => ({ ...f, account_number: e.target.value.replace(/\D/g, '') }))}
                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl py-3.5 px-4 text-slate-900 font-mono tracking-widest focus:outline-none focus:ring-2 focus:ring-[#166FBB]/30 focus:border-[#166FBB] transition-all"
                                />
                            </div>

                            <div>
                                <label className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 block">Account Name</label>
                                <input
                                    type="text"
                                    placeholder="e.g. NOBLE ENTERPRISES LTD"
                                    value={form.account_name}
                                    onChange={e => setForm(f => ({ ...f, account_name: e.target.value.toUpperCase() }))}
                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl py-3.5 px-4 text-slate-900 uppercase font-semibold tracking-wide focus:outline-none focus:ring-2 focus:ring-[#166FBB]/30 focus:border-[#166FBB] transition-all"
                                />
                            </div>

                            <button
                                onClick={() => { setError(''); setStep('confirm'); }}
                                disabled={!isValidAmount || !form.account_bank || !form.account_number || form.account_number.length < 10 || !form.account_name}
                                className="w-full bg-[#166FBB] text-white font-black text-[11px] uppercase tracking-[0.2em] py-4 rounded-xl hover:bg-[#1260a8] transition-colors disabled:opacity-40 disabled:cursor-not-allowed mt-2"
                            >
                                Review Withdrawal
                            </button>
                        </div>
                    )}
                </div>
            </motion.div>
        </motion.div>
    );
}

// ── Main Wallet Page ──────────────────────────────────────────────────────────
export default function WalletPage() {
    const { user } = useAuth();
    const { hasFeature } = useFeatureGate();
    const router = useRouter();
    const [loading, setLoading] = useState(true);
    const [wallet, setWallet] = useState<Wallet | null>(null);
    const [transactions, setTransactions] = useState<WalletTransaction[]>([]);
    const [showWithdrawModal, setShowWithdrawModal] = useState(false);

    useEffect(() => {
        if (!loading && !hasFeature('wallet_payments')) {
            toast.error('Wallet access requires an active Noble Pulse or Elite subscription.', { icon: '🚀' });
            router.push('/pricing');
        }
    }, [hasFeature, loading, router]);

    const fetchWalletData = useCallback(async () => {
        if (!user) return;
        setLoading(true);
        try {
            // Fetch wallet balance
            const { data: walletData, error: walletErr } = await supabase
                .from('wallets')
                .select('*')
                .eq('user_id', user.id)
                .maybeSingle();

            if (walletErr) console.error('Wallet fetch error:', walletErr);
            setWallet(walletData ?? null);

            // Fetch recent transactions
            if (walletData?.id) {
                const { data: txData, error: txErr } = await supabase
                    .from('wallet_transactions')
                    .select('*')
                    .eq('wallet_id', walletData.id)
                    .order('created_at', { ascending: false })
                    .limit(20);

                if (txErr) console.error('Transaction fetch error:', txErr);
                setTransactions(txData ?? []);
            }
        } catch (err) {
            console.error('Failed to load wallet:', err);
        } finally {
            setLoading(false);
        }
    }, [user]);

    useEffect(() => {
        fetchWalletData();
    }, [fetchWalletData]);

    const currency       = wallet?.currency_code || 'NGN';
    const balance        = wallet?.balance || 0;
    const pendingTx      = transactions.filter(t => t.status === 'pending');
    const pendingAmount  = pendingTx.reduce((s, t) => s + t.amount, 0);
    const totalIncoming  = transactions.filter(t => t.type === 'INVOICE_PAYMENT' && t.status === 'completed').reduce((s, t) => s + t.net_amount, 0);
    const totalWithdrawn = transactions.filter(t => t.type === 'WITHDRAWAL' && t.status === 'completed').reduce((s, t) => s + t.amount, 0);

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 relative overflow-hidden">
            {/* Ambient Background */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-[#166FBB]/8 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-[#00E5FF]/8 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Withdrawal Modal */}
            <AnimatePresence>
                {showWithdrawModal && wallet && (
                    <WithdrawModal
                        wallet={wallet}
                        onClose={() => setShowWithdrawModal(false)}
                        onSuccess={() => {
                            setShowWithdrawModal(false);
                            toast.success('Withdrawal initiated! Funds are on their way.');
                            setTimeout(fetchWalletData, 2000);
                        }}
                    />
                )}
            </AnimatePresence>

            {/* Header */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)] mb-10">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 rounded-[20px] bg-gradient-to-br from-[#166FBB]/20 to-transparent flex items-center justify-center text-[#166FBB] border border-white/50 shadow-inner">
                            <WalletIcon className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                Wallet &amp; <span className="text-[#166FBB]">Payments</span>
                            </h1>
                            <p className="text-slate-500 font-bold uppercase tracking-widest text-[10px] mt-1">
                                Your real-time balance from invoice payments
                            </p>
                        </div>
                    </div>
                    <div className="flex items-center gap-3">
                        <button
                            onClick={fetchWalletData}
                            disabled={loading}
                            className="p-4 bg-white/60 backdrop-blur-md border border-white/60 text-slate-500 rounded-2xl hover:border-[#166FBB]/30 hover:bg-white transition-all shadow-sm active:scale-95 disabled:opacity-50"
                        >
                            <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
                        </button>
                        <button
                            onClick={() => {
                                if (!wallet || balance <= 0) {
                                    toast.error('No balance available to withdraw.');
                                    return;
                                }
                                setShowWithdrawModal(true);
                            }}
                            className="flex items-center gap-2 px-8 py-4 bg-[#166FBB] text-white font-black text-[11px] uppercase tracking-[0.2em] rounded-2xl hover:bg-[#1260a8] transition-all shadow-[0_10px_20px_rgba(22,111,187,0.25)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.35)] whitespace-nowrap active:scale-95"
                        >
                            <ArrowUpRight className="w-4 h-4" />
                            Withdraw Funds
                        </button>
                    </div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 space-y-8 relative z-10">
                {/* Balance Cards */}
                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Main Balance */}
                    <div className="lg:col-span-2 bg-gradient-to-br from-slate-800 via-[#0F172A] to-[#166FBB]/80 rounded-[32px] p-7 shadow-[0_30px_60px_rgba(0,0,0,0.1)] relative overflow-hidden text-white border border-white/10 flex flex-col justify-between min-h-[200px]">
                        <div className="absolute top-0 right-0 w-80 h-80 bg-white/10 rounded-full blur-[80px] -translate-y-1/2 translate-x-1/3" />
                        <div className="absolute bottom-[-20%] left-[-10%] w-[300px] h-[300px] bg-[#00E5FF]/15 blur-[100px] rounded-full pointer-events-none" />

                        <div className="relative z-10 flex flex-col h-full justify-between">
                            <div className="flex justify-between items-start mb-6">
                                <div>
                                    <h3 className="text-white/60 text-[10px] font-bold uppercase tracking-widest mb-2">Available Balance</h3>
                                    {loading ? (
                                        <div className="flex items-center gap-2">
                                            <Loader2 className="w-6 h-6 animate-spin text-white/50" />
                                            <span className="text-white/50 text-sm">Loading...</span>
                                        </div>
                                    ) : (
                                        <div className="text-4xl font-black tracking-tight" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                            {formatCurrency(balance, currency)}
                                        </div>
                                    )}
                                </div>
                                <div className="p-4 bg-white/10 backdrop-blur-md rounded-2xl border border-white/20">
                                    <WalletIcon className="w-6 h-6 text-white" />
                                </div>
                            </div>

                            <div className="grid grid-cols-3 gap-3 bg-black/20 p-5 rounded-2xl backdrop-blur-md border border-white/5">
                                <div>
                                    <p className="text-white/50 text-[9px] font-black uppercase tracking-widest mb-1 flex items-center gap-1">
                                        <ArrowDownRight className="w-3 h-3 text-emerald-400" /> Earned
                                    </p>
                                    <p className="text-lg font-black tracking-tight">{loading ? '...' : formatCurrency(totalIncoming, currency)}</p>
                                </div>
                                <div>
                                    <p className="text-white/50 text-[9px] font-black uppercase tracking-widest mb-1 flex items-center gap-1">
                                        <ArrowUpRight className="w-3 h-3 text-rose-400" /> Withdrawn
                                    </p>
                                    <p className="text-lg font-black tracking-tight">{loading ? '...' : formatCurrency(totalWithdrawn, currency)}</p>
                                </div>
                                <div>
                                    <p className="text-white/50 text-[9px] font-black uppercase tracking-widest mb-1 flex items-center gap-1">
                                        <Loader2 className="w-3 h-3 text-amber-400" /> Pending
                                    </p>
                                    <p className="text-lg font-black tracking-tight">{loading ? '...' : formatCurrency(pendingAmount, currency)}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Info Card */}
                    <div className="bg-white/40 backdrop-blur-2xl rounded-[32px] p-6 border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.03)] flex flex-col justify-between relative overflow-hidden">
                        <div className="absolute top-[-20%] right-[-20%] w-[200px] h-[200px] bg-amber-400/5 blur-[60px] rounded-full pointer-events-none" />
                        <div className="relative z-10">
                            <div className="w-14 h-14 rounded-2xl bg-emerald-50 flex items-center justify-center text-emerald-600 mb-5 border border-emerald-100 shadow-inner">
                                <ShieldCheck className="w-7 h-7" />
                            </div>
                            <h3 className="text-base font-bold text-slate-900 mb-2 tracking-tight">Secure Payouts</h3>
                            <p className="text-slate-500 text-xs font-medium leading-relaxed">
                                Funds are credited to your wallet automatically when clients pay invoices via your payment links. Withdraw anytime to your Nigerian bank account.
                            </p>
                        </div>
                        <div className="mt-6 space-y-2 relative z-10 text-[10px] text-slate-400 font-bold uppercase tracking-wider">
                            <div className="flex items-center gap-2"><Banknote className="w-3 h-3" /> NGN transfers arrive in minutes</div>
                            <div className="flex items-center gap-2"><Building2 className="w-3 h-3" /> All major Nigerian banks supported</div>
                            <div className="flex items-center gap-2"><CreditCard className="w-3 h-3" /> Powered by Flutterwave</div>
                        </div>
                    </div>
                </div>

                {/* Transactions */}
                <div className="bg-white/40 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] overflow-hidden">
                    <div className="px-10 py-7 border-b border-white/60 flex justify-between items-center bg-white/20">
                        <div className="flex items-center gap-4">
                            <div className="p-3 bg-white/60 rounded-xl shadow-sm border border-white">
                                <History className="w-5 h-5 text-[#166FBB]" />
                            </div>
                            <h3 className="text-base font-semibold text-slate-900 tracking-tight">Transaction History</h3>
                        </div>
                        <span className="text-[10px] font-black uppercase tracking-widest text-slate-400">
                            {transactions.length} transactions
                        </span>
                    </div>

                    {loading ? (
                        <div className="flex flex-col items-center justify-center py-20 text-center">
                            <Loader2 className="w-8 h-8 text-[#166FBB] animate-spin mb-3" />
                            <span className="text-xs font-bold text-slate-500 uppercase tracking-widest">Loading transactions...</span>
                        </div>
                    ) : transactions.length === 0 ? (
                        <div className="flex flex-col items-center justify-center py-20 text-center">
                            <div className="w-20 h-20 bg-white/80 rounded-[24px] flex items-center justify-center border border-white shadow-lg mb-6 mx-auto">
                                <Banknote className="w-8 h-8 text-slate-300" />
                            </div>
                            <h3 className="text-slate-900 font-black text-xl tracking-tight mb-2" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                No transactions yet
                            </h3>
                            <p className="text-slate-500 text-sm font-medium max-w-sm leading-relaxed">
                                Once your clients pay invoices via your payment links, their payments will appear here automatically.
                            </p>
                        </div>
                    ) : (
                        <div className="divide-y divide-white/40">
                            {transactions.map((tx) => {
                                const isIncoming   = tx.type === 'INVOICE_PAYMENT' || tx.type === 'REFUND';
                                const isPending    = tx.status === 'pending';
                                const isFailed     = tx.status === 'failed';

                                return (
                                    <div key={tx.id} className="px-10 py-4 flex items-center justify-between hover:bg-white/20 transition-all">
                                        <div className="flex items-center gap-4">
                                            <div className={`w-10 h-10 rounded-2xl flex items-center justify-center border shadow-inner ${
                                                isFailed     ? 'bg-slate-50 border-slate-100 text-slate-400' :
                                                isIncoming   ? 'bg-emerald-50 border-emerald-100 text-emerald-600' :
                                                               'bg-rose-50 border-rose-100 text-rose-600'
                                            }`}>
                                                {isIncoming
                                                    ? <ArrowDownRight className="w-4 h-4" />
                                                    : <ArrowUpRight className="w-4 h-4" />
                                                }
                                            </div>
                                            <div>
                                                <h4 className="text-sm font-semibold text-slate-900">{tx.description || tx.type}</h4>
                                                <div className="flex items-center gap-2 mt-0.5">
                                                    <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">
                                                        {formatDate(tx.created_at)}
                                                    </p>
                                                    {isPending && (
                                                        <span className="text-[9px] font-black uppercase tracking-widest text-amber-600 bg-amber-50 px-2 py-0.5 rounded-full border border-amber-100">
                                                            Pending
                                                        </span>
                                                    )}
                                                    {isFailed && (
                                                        <span className="text-[9px] font-black uppercase tracking-widest text-slate-500 bg-slate-100 px-2 py-0.5 rounded-full">
                                                            Failed (Refunded)
                                                        </span>
                                                    )}
                                                </div>
                                            </div>
                                        </div>
                                        <div className="text-right">
                                            <span className={`text-base font-bold ${
                                                isFailed   ? 'text-slate-400 line-through' :
                                                isIncoming ? 'text-emerald-600' : 'text-slate-700'
                                            }`}>
                                                {isIncoming ? '+' : '-'}{formatCurrency(isIncoming ? tx.net_amount : tx.amount, tx.currency_code)}
                                            </span>
                                            {tx.fee > 0 && (
                                                <p className="text-[9px] text-slate-400 font-bold mt-0.5">
                                                    {formatCurrency(tx.fee, tx.currency_code)} fee
                                                </p>
                                            )}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
