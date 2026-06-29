'use client';

import React, { useEffect, useState } from 'react';
import { useAuth } from '@/context/AuthContext';
import { supabase } from '@/lib/supabase';
import { CreditCard, Download, CheckCircle2, AlertCircle, Package, ArrowRight, X } from 'lucide-react';
import { SUBSCRIPTION_PLANS } from '@/lib/plans';
import Link from 'next/link';
import { toast } from 'react-hot-toast';

export default function BillingPage() {
    const { user, userData } = useAuth();
    const [history, setHistory] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    const isExplorer = !userData?.plan || userData?.plan === 'explorer';
    const isPro = userData?.plan === 'pro';
    const isElite = userData?.plan === 'elite';

    const currentPlanDetails = SUBSCRIPTION_PLANS.find(p => p.id === userData?.plan) || SUBSCRIPTION_PLANS[0];

    useEffect(() => {
        if (!user) return;

        const fetchBillingHistory = async () => {
            try {
                const { data } = await supabase
                    .from('billing_history')
                    .select('*')
                    .eq('user_id', user.id)
                    .order('created_at', { ascending: false });

                if (data) {
                    setHistory(data);
                }
            } catch (err) {
                console.error('Error fetching billing history:', err);
            } finally {
                setLoading(false);
            }
        };

        fetchBillingHistory();
    }, [user]);

    if (!user) return null;

    return (
        <div className="max-w-5xl space-y-8">
            <div className="border-b border-slate-100 pb-6">
                <h3 className="text-xl md:text-[26px] font-semibold text-slate-900 tracking-tight">
                    Billing & Plans
                </h3>
                <p className="text-sm text-slate-500 mt-1">
                    Manage your subscription, payment methods, and billing history.
                </p>
            </div>

            {/* Current Plan Card */}
            <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div className="p-6 sm:p-8 flex flex-col md:flex-row gap-8 justify-between">
                    <div className="space-y-4 flex-1">
                        <div className="flex items-center gap-3">
                            <div className="w-12 h-12 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center text-slate-600">
                                <Package className="w-5 h-5" />
                            </div>
                            <div>
                                <p className="text-xs font-medium text-slate-500 uppercase tracking-wide">Current Plan</p>
                                <div className="flex items-baseline gap-2">
                                    <h3 className="text-2xl font-semibold text-slate-900 capitalize">
                                        {currentPlanDetails.name}
                                    </h3>
                                    {isExplorer && <span className="px-2 py-0.5 rounded-full bg-slate-100 text-slate-600 text-xs font-medium">Free</span>}
                                    {(isPro || isElite) && <span className="px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-600 text-xs font-medium">Active</span>}
                                </div>
                            </div>
                        </div>
                        
                        <div className="bg-slate-50 rounded-xl p-4 border border-slate-100">
                            <h4 className="text-sm font-medium text-slate-700 mb-3">Plan includes:</h4>
                            <ul className="grid sm:grid-cols-2 gap-y-2 gap-x-4">
                                {currentPlanDetails.features.slice(0, 4).map((feature, i) => (
                                    <li key={i} className="flex items-start gap-2 text-sm text-slate-600">
                                        <CheckCircle2 className="w-4 h-4 text-emerald-500 shrink-0 mt-0.5" />
                                        <span>{feature}</span>
                                    </li>
                                ))}
                            </ul>
                        </div>
                    </div>

                    <div className="w-full md:w-64 flex flex-col gap-3 justify-center border-t md:border-t-0 md:border-l border-slate-100 pt-6 md:pt-0 md:pl-8">
                        {!isElite && (
                            <Link 
                                href="/upgrade"
                                className="w-full py-2.5 px-4 bg-slate-900 hover:bg-slate-800 text-white rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2 shadow-sm"
                            >
                                Upgrade Plan
                                <ArrowRight className="w-4 h-4" />
                            </Link>
                        )}
                        {isExplorer && (
                            <Link 
                                href="/upgrade"
                                className="w-full py-2.5 px-4 bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 rounded-lg text-sm font-medium transition-colors flex items-center justify-center"
                            >
                                Buy PAYG Bundle
                            </Link>
                        )}
                        {(isPro || isElite) && (
                            <button 
                                onClick={async () => {
                                    if (!window.confirm('Are you sure you want to cancel your subscription? You will lose access to premium features at the end of your billing cycle.')) return;
                                    try {
                                        const { data: { session } } = await supabase.auth.getSession();
                                        if (!session) return;

                                        const res = await fetch('/api/subscription/cancel', {
                                            method: 'POST',
                                            headers: {
                                                'Authorization': `Bearer ${session.access_token}`
                                            }
                                        });

                                        const data = await res.json();
                                        if (res.ok) {
                                            toast.success(data.message || 'Subscription cancelled');
                                            window.location.reload();
                                        } else {
                                            toast.error(data.error || 'Failed to cancel subscription.');
                                        }
                                    } catch (err) {
                                        console.error('Cancel sub error:', err);
                                        toast.error('An error occurred. Please try again.');
                                    }
                                }}
                                className="w-full py-2.5 px-4 text-red-600 hover:bg-red-50 rounded-lg text-sm font-medium transition-colors flex items-center justify-center gap-2 mt-auto"
                            >
                                <X className="w-4 h-4" />
                                Cancel Subscription
                            </button>
                        )}
                    </div>
                </div>
            </div>

            {/* Billing History */}
            <div>
                <div className="flex items-center gap-2 mb-4">
                    <CreditCard className="w-4 h-4 text-slate-400" />
                    <h3 className="text-base font-semibold text-slate-900">Payment History</h3>
                </div>
                
                <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                    {loading ? (
                        <div className="p-8 text-center text-sm text-slate-500">Loading history...</div>
                    ) : history.length === 0 ? (
                        <div className="p-12 text-center flex flex-col items-center">
                            <div className="w-12 h-12 bg-slate-50 rounded-full flex items-center justify-center mb-3">
                                <CreditCard className="w-5 h-5 text-slate-400" />
                            </div>
                            <p className="text-sm font-medium text-slate-900">No payment history</p>
                            <p className="text-sm text-slate-500 mt-1">Your future payments and invoices will appear here.</p>
                        </div>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left text-sm whitespace-nowrap">
                                <thead className="bg-slate-50 border-b border-slate-100">
                                    <tr>
                                        <th className="px-6 py-3 font-medium text-slate-500">Date</th>
                                        <th className="px-6 py-3 font-medium text-slate-500">Description</th>
                                        <th className="px-6 py-3 font-medium text-slate-500">Amount</th>
                                        <th className="px-6 py-3 font-medium text-slate-500">Status</th>
                                        <th className="px-6 py-3 font-medium text-slate-500 text-right">Receipt</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-slate-100">
                                    {history.map((tx) => (
                                        <tr key={tx.id} className="hover:bg-slate-50/50 transition-colors">
                                            <td className="px-6 py-4 text-slate-600">
                                                {new Date(tx.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}
                                            </td>
                                            <td className="px-6 py-4 font-medium text-slate-900 capitalize">
                                                {tx.tier} Plan Subscription
                                            </td>
                                            <td className="px-6 py-4 text-slate-900">
                                                ${tx.amount.toFixed(2)}
                                            </td>
                                            <td className="px-6 py-4">
                                                <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700 border border-emerald-200/50">
                                                    Paid
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 text-right">
                                                <button onClick={() => toast('Receipt generation coming soon', { icon: '🧾' })} className="text-noble-blue hover:text-blue-700 font-medium transition-colors inline-flex items-center gap-1.5">
                                                    <Download className="w-3.5 h-3.5" />
                                                    <span>Download</span>
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
