'use client';

import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
    Check, Sparkles, Brain, Rocket, Shield, 
    Clock, Zap, Crown, Flame
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { SUBSCRIPTION_PLANS, PAYG_PLAN, Plan } from '@/lib/plans';
import axios from 'axios';
import { toast } from 'react-hot-toast';
import Script from 'next/script';
import { supabase } from '@/lib/supabase';
import { useRouter } from 'next/navigation';

// Extracted PlanCard to allow individual Flutterwave hook instances per plan
function PlanCard({ 
    plan, 
    billingCycle, 
    user, 
    userData, 
    index 
}: { 
    plan: Plan, 
    billingCycle: 'monthly' | 'yearly', 
    user: any, 
    userData: any, 
    index: number 
}) {
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const isCurrent = userData?.plan === plan.id || (plan.id === 'explorer' && (userData?.plan === 'explorer' || !userData?.plan));
    const isElite = plan.id === 'elite';
    const isPro = plan.id === 'pro';

    const price = billingCycle === 'monthly' ? plan.priceMonthly : plan.priceYearly;
    const earlyBird = billingCycle === 'yearly' && plan.earlyBirdYearlyPrice;
    const finalPrice = earlyBird ? plan.earlyBirdYearlyPrice! : (plan.priceMonthly === 0 ? 0 : price);

    // Resolve Flutterwave Payment Plan ID based on selected cycle and tier
    const flwPlanId = billingCycle === 'monthly' 
        ? plan.flutterwavePlanIdMonthly 
        : (earlyBird ? plan.flutterwavePlanIdEarlyBird : plan.flutterwavePlanIdYearly);

    const shortId = Math.random().toString(36).substring(2, 10);
    const txRef = `sub_${plan.id}_${user?.id || 'user'}_${shortId}`;

    const fwConfig = {
        public_key: process.env.NEXT_PUBLIC_FLW_PUBLIC_KEY || '',
        tx_ref: txRef,
        amount: finalPrice,
        currency: 'USD',
        payment_plan: flwPlanId,
        payment_options: 'card',
        customer: {
            email: user?.email || '',
            name: userData?.name || user?.displayName || 'Noble Agent',
            phone_number: '',
        },
        customizations: {
            title: `NobleInvoice ${plan.name}`,
            description: plan.tagline || 'Subscription Upgrade',
            logo: '/images/logo.png',
        },
    };

    const handleUpgrade = async () => {
        if (plan.id === 'explorer') return;
        if (!user) return toast.error('Please sign in to upgrade');

        if (!fwConfig.public_key) {
            return toast.error('Payment system missing configuration.');
        }

        if (typeof window !== 'undefined' && (window as any).FlutterwaveCheckout) {
            (window as any).FlutterwaveCheckout({
                ...fwConfig,
                callback: async (response: any) => {
                    const txId = response.transaction_id || response.id;
                    if (response.status === 'successful' || response.status === 'success') {
                        setLoading(true);
                        const verifyingToast = toast.loading('Verifying payment... Please wait.');
                        try {
                            const { data: { session } } = await supabase.auth.getSession();
                            const verifyRes = await axios.post(
                                `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/verify-and-upgrade-subscription`,
                                {
                                    transaction_id: txId,
                                    tx_ref: response.tx_ref,
                                    user_id: user.id,
                                    tier: plan.id,
                                    expected_amount: finalPrice
                                },
                                {
                                    headers: { Authorization: `Bearer ${session?.access_token}` }
                                }
                            );

                            if (verifyRes.data.status === 'upgraded') {
                                toast.dismiss(verifyingToast);
                                toast.success(`Welcome to NobleInvoice ${plan.name}!`);
                                // Wait briefly for DB sync, then redirect
                                setTimeout(() => { router.push('/dashboard'); }, 2000);
                            } else {
                                toast.dismiss(verifyingToast);
                                toast.error('Verification failed: ' + (verifyRes.data.error || 'System error.'));
                                console.error('Verification details:', verifyRes.data);
                            }
                        } catch (error: any) {
                            toast.dismiss(verifyingToast);
                            toast.error(error.response?.data?.error || 'Network error during verification. Check your connection.');
                            console.error('Verification network error:', error.message);
                        } finally {
                            setLoading(false);
                            // Ensure the modal actually closes
                            if (response.close) response.close();
                        }
                    } else {
                        // User closed or failed early
                        if (response.close) response.close();
                    }
                },
                onclose: function () {
                   setLoading(false);
                }
            });
        } else {
            toast.error("Payment environment loading... Please wait or refresh the page.");
        }
    };

    return (
        <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 * index }}
            className={`group relative flex flex-col p-10 rounded-[40px] border transition-all duration-500 bg-white/40 backdrop-blur-2xl shadow-[0_30px_60px_rgba(0,0,0,0.02)] hover:shadow-[0_40px_80px_rgba(22,111,187,0.08)] hover:-translate-y-2 ${
                plan.popular 
                ? 'border-noble-blue/40 ring-4 ring-noble-blue/10 bg-white/50' 
                : 'border-white/60'
            }`}
        >
            {plan.popular && (
                <div className="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-noble-blue text-white text-[9px] font-black uppercase tracking-[0.2em] px-6 py-2.5 rounded-full shadow-lg shadow-noble-blue/30">
                    Most Popular
                </div>
            )}

            {/* Plan Name & Tagline */}
            <div className="space-y-2 mb-8">
                <div className="flex items-center justify-between">
                    <h3 className={`text-2xl font-black uppercase tracking-tight ${
                        isElite ? 'text-amber-600' : isPro ? 'text-noble-blue' : 'text-slate-500'
                    }`} style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                        {plan.name}
                    </h3>
                    {isElite && <Crown className="w-6 h-6 text-amber-500 animate-pulse" />}
                    {isPro && <Zap className="w-6 h-6 text-noble-blue" />}
                </div>
                <p className="text-[10px] font-black text-slate-400 uppercase tracking-[0.15em] leading-relaxed">
                    {plan.tagline}
                </p>
            </div>

            {/* Price */}
            <div className="mb-8">
                <div className="flex items-baseline gap-2">
                    <span className="text-6xl font-black text-slate-900 tracking-tighter transition-all" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                        ${finalPrice}
                    </span>
                    <span className="text-slate-400 font-bold uppercase text-[9px] tracking-[0.15em]">
                        {plan.priceMonthly === 0 ? '/ forever' : `/ ${billingCycle === 'monthly' ? 'mo' : 'yr'}`}
                    </span>
                </div>
                {earlyBird && (
                    <div className="mt-4 flex flex-col gap-2">
                        <div className="inline-flex items-center gap-2 px-3 py-1 bg-amber-500/10 text-amber-600 border border-amber-500/20 rounded-xl text-[9px] font-black uppercase tracking-[0.2em] w-fit shadow-sm">
                            <Flame className="w-3 h-3 fill-current" /> Early Bird Offer
                        </div>
                        <p className="text-[9px] font-bold text-slate-400 italic">
                            *Limit: First 500 subscribers. Normal: ${plan.priceYearly}/yr
                        </p>
                    </div>
                )}
            </div>

            {/* Features */}
            <div className="flex-1 space-y-4 mb-10 border-t border-white/40 pt-8">
                {plan.features.map((feature, idx) => (
                    <div key={idx} className="flex items-start gap-4 group/item">
                        <div className={`mt-0.5 flex-shrink-0 w-5 h-5 rounded-lg flex items-center justify-center transition-colors shadow-sm ${
                            isElite 
                                ? 'bg-amber-100 text-amber-600 border border-amber-200' 
                                : isPro 
                                    ? 'bg-blue-100 text-noble-blue border border-blue-200' 
                                    : 'bg-slate-100 text-slate-500 border border-slate-200'
                        }`}>
                            <Check className="w-3 h-3 stroke-[3]" />
                        </div>
                        <span className="text-[13px] font-bold text-slate-600 leading-tight group-hover/item:text-slate-900 transition-colors">
                            {feature}
                        </span>
                    </div>
                ))}
            </div>

            {/* CTA Button */}
            <button
                disabled={isCurrent || loading}
                onClick={handleUpgrade}
                className={`w-full py-5 rounded-[20px] text-[10px] font-black uppercase tracking-[0.2em] transition-all transform hover:scale-[1.02] active:scale-95 disabled:opacity-50 disabled:scale-100 disabled:shadow-none ${
                    isCurrent 
                    ? 'bg-slate-200/50 text-slate-400 cursor-default border border-slate-300/30' 
                    : isElite 
                        ? 'bg-gradient-to-r from-amber-500 to-amber-600 text-white shadow-[0_10px_20px_rgba(245,158,11,0.2)] hover:shadow-[0_15px_30px_rgba(245,158,11,0.3)]' 
                        : isPro 
                            ? 'bg-noble-blue text-white shadow-[0_10px_20px_rgba(22,111,187,0.2)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.3)]' 
                            : 'bg-white/60 text-slate-700 hover:bg-white/80 border border-white/60 shadow-sm'
                }`}
            >
                {loading ? (
                    <div className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin mx-auto" />
                ) : isCurrent ? (
                    'Active Plan'
                ) : plan.id === 'explorer' ? (
                    'Get Started'
                ) : (
                    `Upgrade to ${plan.name}`
                )}
            </button>
        </motion.div>
    );
}

export default function UpgradePage() {
    const { user, userData } = useAuth();
    const router = useRouter();
    const [billingCycle, setBillingCycle] = useState<'monthly' | 'yearly'>('monthly');

    // Elite users shouldn't see the upgrade page at all
    useEffect(() => {
        if (userData?.plan === 'elite') {
            router.push('/dashboard');
        }
    }, [userData?.plan, router]);

    if (userData?.plan === 'elite') return null;

    const displayedPlans = [
        ...SUBSCRIPTION_PLANS.filter(p => {
            if (p.id === 'explorer') return false;
            if (userData?.plan === 'pulse' && p.id === 'pro') return false;
            return true;
        }),
        PAYG_PLAN
    ];

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            <div className="max-w-7xl mx-auto px-8 relative z-10 pt-16">
                
                {/* Current Plan Banner */}
                {userData?.plan && userData?.plan !== 'admin' && (
                    <motion.div 
                        initial={{ opacity: 0, y: -20 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="w-full max-w-3xl mx-auto mb-12 p-6 bg-white/60 backdrop-blur-md rounded-2xl border border-white shadow-sm flex items-center justify-between"
                    >
                        <div>
                            <p className="text-[10px] font-black uppercase tracking-widest text-slate-500 mb-1">Your Current Plan</p>
                            <div className="flex items-center gap-3">
                                <h3 className="text-2xl font-black text-slate-900 uppercase" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                    {userData.plan === 'explorer' ? 'Starter' : userData.plan === 'pulse' ? 'Noble Pulse' : 'Elite'}
                                </h3>
                                <span className={`px-2.5 py-1 rounded-md text-[9px] font-black uppercase tracking-widest ${
                                    userData.subscriptionStatus === 'active' ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-100 text-slate-600'
                                }`}>
                                    {userData.subscriptionStatus === 'active' ? 'Active' : 'Free / Inactive'}
                                </span>
                            </div>
                        </div>
                        {userData.plan !== 'explorer' && (
                            <button onClick={() => router.push('/pro/manage')} className="px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-[10px] font-black uppercase tracking-widest rounded-xl transition-colors">
                                Manage Billing
                            </button>
                        )}
                    </motion.div>
                )}

                {/* Header */}
                <div className="text-center mb-16 space-y-6">
                    <motion.div 
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        className="inline-flex items-center gap-2 px-4 py-2 bg-noble-blue/10 rounded-full border border-noble-blue/20 mb-2 shadow-inner"
                    >
                        <Sparkles className="w-4 h-4 text-noble-blue" />
                        <span className="text-[9px] font-black text-noble-blue uppercase tracking-[0.2em]">Evolve Your Mind</span>
                    </motion.div>

                    <motion.h1 
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.1 }}
                        className="text-5xl md:text-7xl font-black text-slate-900 tracking-tighter"
                        style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}
                    >
                        Choose Your{' '}
                        <span className="text-noble-blue">
                            Cognitive Tier
                        </span>
                    </motion.h1>

                    <motion.p 
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.2 }}
                        className="text-slate-500 text-lg max-w-2xl mx-auto font-bold"
                    >
                        Join thousands of Noble Agents who use advanced AI to protect their energy and dominate their goals.
                    </motion.p>

                    {/* Billing Toggle */}
                    <motion.div
                        initial={{ opacity: 0, scale: 0.9 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: 0.3 }}
                        className="flex items-center justify-center gap-4 pt-4"
                    >
                        <span className={`text-[10px] font-black uppercase tracking-[0.15em] transition-colors ${billingCycle === 'monthly' ? 'text-slate-900' : 'text-slate-400'}`}>Monthly</span>
                        <button 
                            onClick={() => setBillingCycle(billingCycle === 'monthly' ? 'yearly' : 'monthly')}
                            className="w-16 h-8 bg-white/60 backdrop-blur-md rounded-full border border-white/60 relative p-1 transition-all shadow-inner"
                        >
                            <motion.div 
                                className="w-6 h-6 bg-noble-blue rounded-full shadow-md shadow-noble-blue/20"
                                animate={{ x: billingCycle === 'monthly' ? 0 : 32 }}
                                transition={{ type: 'spring', stiffness: 500, damping: 30 }}
                            />
                        </button>
                        <span className={`text-[10px] font-black uppercase tracking-[0.15em] transition-colors ${billingCycle === 'yearly' ? 'text-slate-900' : 'text-slate-400'}`}>
                            Yearly <span className="ml-2 px-2.5 py-1 bg-emerald-100 text-emerald-600 border border-emerald-200 rounded-lg text-[9px] font-black uppercase tracking-wider">Save 33%</span>
                        </span>
                    </motion.div>
                </div>

                {/* Plan Cards */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 items-start mb-24 relative z-10">
                    {displayedPlans.map((plan, i) => (
                        <PlanCard 
                            key={plan.id} 
                            plan={plan as Plan} 
                            billingCycle={billingCycle} 
                            user={user} 
                            userData={userData} 
                            index={i} 
                        />
                    ))}
                </div>

                {/* Feature Comparison Matrix */}
                <div className="mt-20 mb-20 relative z-10 bg-white/50 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm p-8 overflow-x-auto">
                    <h3 className="text-2xl font-black text-slate-900 mb-8 text-center" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Compare Plan Features</h3>
                    <table className="w-full text-left min-w-[700px]">
                        <thead>
                            <tr className="border-b border-slate-200">
                                <th className="py-4 px-6 text-[10px] font-black uppercase tracking-widest text-slate-400">Features</th>
                                <th className="py-4 px-6 text-[10px] font-black uppercase tracking-widest text-slate-500 text-center">Starter</th>
                                <th className="py-4 px-6 text-[10px] font-black uppercase tracking-widest text-noble-blue text-center">Noble Pulse</th>
                                <th className="py-4 px-6 text-[10px] font-black uppercase tracking-widest text-amber-600 text-center">Elite</th>
                            </tr>
                        </thead>
                        <tbody className="text-sm font-bold text-slate-600">
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Monthly Invoices</td>
                                <td className="py-4 px-6 text-center">10</td>
                                <td className="py-4 px-6 text-center text-noble-blue">Unlimited</td>
                                <td className="py-4 px-6 text-center text-amber-600">Unlimited</td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Active Clients</td>
                                <td className="py-4 px-6 text-center">5</td>
                                <td className="py-4 px-6 text-center text-noble-blue">Unlimited</td>
                                <td className="py-4 px-6 text-center text-amber-600">Unlimited</td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Premium Templates</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-noble-blue" /></td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Inventory Ledger</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-noble-blue" /></td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Flutterwave Payments</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-noble-blue" /></td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Lead Intelligence</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-noble-blue" /></td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                            <tr className="border-b border-slate-100 hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6">Team Intelligence (Multi-user)</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                            <tr className="hover:bg-white/40 transition-colors">
                                <td className="py-4 px-6 rounded-bl-2xl">Enterprise Scaling</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center text-slate-300">-</td>
                                <td className="py-4 px-6 text-center rounded-br-2xl"><Check className="w-4 h-4 mx-auto text-amber-600" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                {/* Trust Section */}
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-8 pt-12 border-t border-white/60 relative z-10">
                    <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/30 backdrop-blur-md border border-white/50 shadow-sm">
                        <div className="p-3 bg-blue-50 border border-blue-100 rounded-xl text-noble-blue shadow-inner flex-shrink-0">
                            <Shield className="w-5 h-5" />
                        </div>
                        <p className="text-[10px] font-black text-slate-500 uppercase tracking-widest leading-relaxed">Secure Payments via Flutterwave</p>
                    </div>
                    <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/30 backdrop-blur-md border border-white/50 shadow-sm">
                        <div className="p-3 bg-blue-50 border border-blue-100 rounded-xl text-noble-blue shadow-inner flex-shrink-0">
                            <Clock className="w-5 h-5" />
                        </div>
                        <p className="text-[10px] font-black text-slate-500 uppercase tracking-widest leading-relaxed">Cancel anytime with 1-click</p>
                    </div>
                    <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/30 backdrop-blur-md border border-white/50 shadow-sm">
                        <div className="p-3 bg-blue-50 border border-blue-100 rounded-xl text-noble-blue shadow-inner flex-shrink-0">
                            <Brain className="w-5 h-5" />
                        </div>
                        <p className="text-[10px] font-black text-slate-500 uppercase tracking-widest leading-relaxed">AI Trained on your data</p>
                    </div>
                    <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/30 backdrop-blur-md border border-white/50 shadow-sm">
                        <div className="p-3 bg-blue-50 border border-blue-100 rounded-xl text-noble-blue shadow-inner flex-shrink-0">
                            <Rocket className="w-5 h-5" />
                        </div>
                        <p className="text-[10px] font-black text-slate-500 uppercase tracking-widest leading-relaxed">Instant Provisioning</p>
                    </div>
                </div>
            </div>
        </div>
    );
}



