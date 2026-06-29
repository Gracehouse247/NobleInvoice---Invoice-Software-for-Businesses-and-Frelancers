'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { 
    Users, QrCode, TrendingUp, Globe, 
    MessageSquare, Calendar, ChevronRight, 
    ArrowUpRight, MapPin, Shield,
    UserPlus, Target, Zap, Share2, Sparkles
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { NFCProvisioningModal } from '@/components/identity/NFCProvisioningModal';
import { identityService, clientService, teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import { useAuth } from '@/context/AuthContext';
import InteractiveMap from '@/components/shared/InteractiveMap';

export default function NetworkingDashboard() {
    const { user } = useAuth();
    const [loading, setLoading] = useState(true);
    const [showNFCModal, setShowNFCModal] = useState(false);
    const [analytics, setAnalytics] = useState<any>(null);
    const [leads, setLeads] = useState<any[]>([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [stats, leadData] = await Promise.all([
                    identityService.getIdentityAnalytics('my-identity'),
                    identityService.getLeads('my-identity')
                ]);
                setAnalytics(stats);
                setLeads(leadData);
            } catch (err) {
                console.error('Failed to fetch networking data:', err);
            } finally {
                setLoading(false);
            }
        };
        fetchData();
    }, []);

    const containerVariants = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: { staggerChildren: 0.1, delayChildren: 0.2 }
        }
    };

    const itemVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.6 } }
    };

    if (loading) {
        return (
            <div className="min-h-screen bg-[#F0F4F8] flex items-center justify-center relative overflow-hidden">
                <div className="fixed top-[20%] left-[20%] w-[500px] h-[500px] bg-noble-blue/10 blur-[120px] rounded-full pointer-events-none z-0" />
                <div className="flex flex-col items-center gap-4 relative z-10">
                    <div className="w-12 h-12 border-4 border-white/60 border-t-noble-blue rounded-full animate-spin" />
                    <p className="text-slate-500 font-bold uppercase tracking-widest text-xs">Accessing Node...</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed top-[40%] right-[20%] w-[400px] h-[400px] bg-[#F4B400]/5 blur-[120px] rounded-full pointer-events-none z-0" />

            {/* Header */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <motion.div initial={{ opacity: 0, x: -30 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.8, ease: "easeOut" }} className="space-y-2">
                        <div className="flex items-center gap-2 mb-2">
                            <div className="w-2 h-2 rounded-full bg-noble-blue animate-pulse" />
                            <span className="text-xs font-bold text-noble-blue uppercase tracking-[0.2em]">Real-time Telemetry</span>
                        </div>
                        <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            Identity <span className="text-noble-blue">Node</span>
                        </h1>
                        <p className="text-slate-500 font-bold uppercase tracking-[0.2em] text-[10px]">Profile Engagement Analytics</p>
                    </motion.div>

                    <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 0.8, delay: 0.2 }} className="flex items-center gap-4">
                        <button className="flex items-center gap-2 px-6 py-3.5 bg-white/60 backdrop-blur-md border border-white hover:border-noble-blue/30 text-slate-700 font-black text-[10px] uppercase tracking-widest rounded-2xl hover:bg-white transition-all shadow-[0_10px_20px_rgba(0,0,0,0.02)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.1)]">
                            <Calendar size={16} className="text-noble-blue" />
                            Last 30 Days
                        </button>
                        <Link href="/networking/event-mode">
                            <button className="flex items-center gap-2 px-8 py-3.5 bg-noble-blue text-white font-black text-[10px] uppercase tracking-widest rounded-2xl hover:scale-105 active:scale-95 transition-all shadow-[0_20px_40px_rgba(22,111,187,0.25)] hover:shadow-[0_25px_50px_rgba(22,111,187,0.35)]">
                                <Zap size={16} />
                                Event Mode
                            </button>
                        </Link>
                    </motion.div>
                </div>
            </header>

            <motion.main 
                variants={containerVariants}
                initial="hidden"
                animate="visible"
                className="max-w-7xl mx-auto px-8 py-12 space-y-12 relative z-10"
            >
                {/* Executive Summary Cards */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                    {[
                        { title: 'Total Scans', value: analytics.totalScans, icon: QrCode, trend: '+12.4%', color: 'text-noble-blue', bg: 'bg-noble-blue/10' },
                        { title: 'Leads Captured', value: analytics.leadsCaptured, icon: UserPlus, trend: '+8.2%', color: 'text-emerald-500', bg: 'bg-emerald-500/10' },
                        { title: 'Conversion Rate', value: `${analytics.conversionRate}%`, icon: Target, trend: 'Optimal', color: 'text-amber-500', bg: 'bg-amber-500/10' },
                        { title: 'Presence Score', value: '94/100', icon: Zap, trend: 'Peak', color: 'text-electric-cyan', bg: 'bg-electric-cyan/10' }
                    ].map((stat, i) => (
                        <motion.div 
                            key={i}
                            variants={itemVariants}
                            whileHover={{ y: -5, scale: 1.02 }}
                            className="bg-white/40 backdrop-blur-2xl rounded-[32px] p-8 border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.03)] relative overflow-hidden group transition-all duration-500"
                        >
                            <div className="flex items-center justify-between mb-8">
                                <div className={`w-14 h-14 rounded-2xl flex items-center justify-center ${stat.bg} ${stat.color} border border-white/50 shadow-inner group-hover:scale-110 transition-transform duration-500`}>
                                    <stat.icon className="w-6 h-6" />
                                </div>
                                <span className={`text-[9px] font-black uppercase tracking-[0.2em] px-3 py-1.5 rounded-full border shadow-sm ${stat.trend.includes('+') ? 'bg-emerald-50/80 border-emerald-100 text-emerald-600' : 'bg-white/60 border-slate-100 text-slate-500'}`}>
                                    {stat.trend}
                                </span>
                            </div>
                            <div className="space-y-1">
                                <h3 className="text-slate-400 text-[10px] font-black uppercase tracking-[0.3em] mb-2">{stat.title}</h3>
                                <p className="text-4xl font-black text-slate-900 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                    {stat.value}
                                </p>
                            </div>
                            {/* Hover Glow */}
                            <div className={`absolute -bottom-10 -right-10 w-32 h-32 rounded-full blur-[40px] opacity-0 group-hover:opacity-100 transition-opacity duration-700 ${stat.bg}`} />
                        </motion.div>
                    ))}
                </div>

                {/* Quick Actions & High-Speed Networking */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <Link href="/networking/event-mode" className="md:col-span-2 group relative overflow-hidden rounded-[40px] bg-slate-900 p-12 flex items-center justify-between shadow-[0_40px_80px_rgba(0,0,0,0.2)] transition-all hover:scale-[1.01] border border-white/10">
                        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMSIgY3k9IjEiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wNykiLz48L3N2Zz4=')] opacity-50" />
                        <div className="absolute inset-0 bg-gradient-to-tr from-noble-blue/30 via-transparent to-white/5 pointer-events-none" />
                        <div className="absolute top-[-50%] right-[-20%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[100px] rounded-full group-hover:bg-electric-cyan/20 transition-all duration-700 pointer-events-none" />
                        
                        <div className="relative z-10 space-y-6">
                            <div className="flex items-center gap-4">
                                <div className="w-12 h-12 rounded-[20px] bg-noble-blue flex items-center justify-center text-white shadow-[0_0_30px_rgba(22,111,187,0.5)]">
                                    <Zap size={20} className="animate-pulse" />
                                </div>
                                <h3 className="text-3xl font-black text-white uppercase tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Enter Event Mode</h3>
                            </div>
                            <p className="text-slate-400 text-[11px] font-bold uppercase tracking-widest max-w-sm leading-relaxed">
                                Transform your screen into a high-speed networking broadcast node. Optimized for conferences and live events.
                            </p>
                            <div className="flex items-center gap-6 pt-6">
                                <div className="flex -space-x-4">
                                    {[1, 2, 3, 4].map(i => (
                                        <div key={i} className="w-10 h-10 rounded-full border-2 border-slate-900 bg-slate-800 flex items-center justify-center text-[10px] font-black shadow-lg">
                                            {String.fromCharCode(64 + i)}
                                        </div>
                                    ))}
                                </div>
                                <span className="text-[10px] font-black text-electric-cyan uppercase tracking-[0.2em] bg-electric-cyan/10 px-4 py-2 rounded-full border border-electric-cyan/20">1.2k Scans Today</span>
                            </div>
                        </div>
                        <div className="relative z-10 p-8 rounded-[2rem] bg-white/5 border border-white/10 group-hover:bg-white/10 group-hover:scale-105 transition-all duration-500 backdrop-blur-md shadow-2xl">
                            <QrCode size={80} className="text-white opacity-90" />
                        </div>
                    </Link>

                    <motion.div variants={itemVariants} className="rounded-[40px] bg-white/40 backdrop-blur-2xl border border-white/60 p-10 flex flex-col justify-between shadow-[0_30px_60px_rgba(0,0,0,0.03)] relative overflow-hidden group">
                        <div className="absolute top-[-20%] left-[50%] w-[200px] h-[200px] bg-emerald-500/10 blur-[80px] rounded-full pointer-events-none transition-all duration-700 group-hover:bg-emerald-500/20" />
                        <div className="space-y-6 relative z-10">
                            <div className="flex items-center gap-4">
                                <div className="w-12 h-12 rounded-[20px] bg-white/60 border border-white shadow-inner flex items-center justify-center text-emerald-600">
                                    <Share2 size={20} />
                                </div>
                                <h3 className="text-xl font-black text-slate-900 uppercase tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Rapid Share</h3>
                            </div>
                            <p className="text-slate-500 text-[10px] font-bold uppercase tracking-[0.2em] leading-loose">
                                Deploy your professional identity via NFC, SMS, or Digital Wallet instantly.
                            </p>
                        </div>
                        <button 
                            onClick={() => setShowNFCModal(true)}
                            className="w-full py-4 mt-8 rounded-2xl bg-white border border-white shadow-[0_15px_30px_rgba(0,0,0,0.05)] text-slate-900 font-black text-[10px] uppercase tracking-widest hover:border-noble-blue/30 hover:shadow-[0_20px_40px_rgba(22,111,187,0.15)] transition-all relative z-10"
                        >
                            Setup NFC Card
                        </button>
                    </motion.div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Scan Velocity Chart */}
                    <motion.div 
                        variants={itemVariants}
                        className="lg:col-span-1 bg-white/40 backdrop-blur-2xl border border-white/60 rounded-[40px] p-10 shadow-[0_30px_60px_rgba(0,0,0,0.03)] space-y-10 relative overflow-hidden"
                    >
                        <div className="absolute top-[-20%] left-[50%] w-[300px] h-[300px] bg-noble-blue/10 blur-[80px] rounded-full pointer-events-none" />
                        
                        <div className="flex items-center justify-between relative z-10">
                            <h3 className="text-2xl font-black text-slate-900 flex items-center gap-4 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                <div className="p-2 bg-noble-blue/10 rounded-xl">
                                    <TrendingUp className="text-noble-blue w-5 h-5" />
                                </div>
                                Scan Velocity
                            </h3>
                            <div className="flex gap-2">
                                <div className="w-2 h-2 rounded-full bg-noble-blue" />
                                <div className="w-2 h-2 rounded-full bg-slate-200" />
                            </div>
                        </div>

                        <div className="h-64 flex items-end justify-between gap-3 px-4 border-b border-slate-200/50 pb-6 relative z-10">
                            {analytics?.scansByDay?.map((h: number, i: number) => (
                                <div key={i} className="flex-1 flex flex-col items-center gap-4 group">
                                    <div className="relative w-full">
                                        <motion.div 
                                            initial={{ height: 0 }}
                                            animate={{ height: `${(h / 100) * 200}px` }}
                                            className="w-full bg-white/60 border border-white rounded-t-xl group-hover:bg-noble-blue/10 transition-colors shadow-sm"
                                        />
                                        <motion.div 
                                            initial={{ height: 0 }}
                                            animate={{ height: `${(h / 100) * 100}px` }}
                                            className="absolute bottom-0 w-full bg-noble-blue/30 backdrop-blur-md border border-noble-blue/20 rounded-t-xl group-hover:bg-noble-blue transition-colors shadow-inner"
                                        />
                                    </div>
                                    <span className="text-[8px] font-black text-slate-400 uppercase tracking-[0.1em]">Day {i + 1}</span>
                                </div>
                            ))}
                        </div>

                        <div className="grid grid-cols-2 gap-4 pt-4 relative z-10">
                            <div className="space-y-1">
                                <p className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Peak Exposure</p>
                                <p className="text-xl font-black text-slate-900 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>90 <span className="text-[10px] tracking-widest text-slate-400">SCANS/DAY</span></p>
                            </div>
                            <div className="space-y-1">
                                <p className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em]">Penetration</p>
                                <p className="text-xl font-black text-slate-900 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>84.2% <span className="text-[10px] tracking-widest text-slate-400">GROWTH</span></p>
                            </div>
                        </div>
                    </motion.div>

                    {/* Geography Heatmap */}
                    <motion.div 
                        variants={itemVariants}
                        className="lg:col-span-2 bg-white/40 backdrop-blur-2xl border border-white/60 rounded-[40px] p-10 shadow-[0_30px_60px_rgba(0,0,0,0.03)] space-y-6 relative overflow-hidden"
                    >
                        <div className="absolute top-[50%] right-[-20%] w-[250px] h-[250px] bg-[#F4B400]/10 blur-[80px] rounded-full pointer-events-none" />
                        
                        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 relative z-10 mb-4">
                            <h3 className="text-2xl font-black text-slate-900 flex items-center gap-4 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                <div className="p-2 bg-amber-500/10 rounded-xl">
                                    <Globe className="text-amber-500 w-5 h-5" />
                                </div>
                                Geographic Reach
                            </h3>
                            {analytics?.topRegions && analytics.topRegions.length > 0 && (
                                <div className="flex flex-wrap gap-2">
                                    {analytics.topRegions.map((region: any, i: number) => (
                                        <div key={i} className="flex items-center gap-1.5 px-3 py-1.5 bg-white/80 border border-slate-200/50 rounded-xl text-[10px] font-black text-slate-700 shadow-sm">
                                            <MapPin size={10} className="text-noble-blue" />
                                            {region.name} ({region.count})
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>

                        <div className="relative z-10 w-full">
                            <InteractiveMap topRegions={analytics?.topRegions || []} />
                        </div>

                        <div className="p-6 rounded-2xl bg-white/60 backdrop-blur-md border border-white shadow-sm space-y-3 relative z-10 mt-4">
                            <div className="flex items-center gap-2">
                                <Sparkles size={14} className="text-noble-blue" />
                                <p className="text-[10px] font-black text-noble-blue uppercase tracking-[0.2em]">Smart Insight</p>
                            </div>
                            <p className="text-xs font-bold text-slate-600 leading-relaxed italic">
                                {analytics?.topRegions && analytics.topRegions.length > 0 
                                    ? `Your digital presence is gaining significant traction in ${analytics.topRegions[0]?.name || 'new regions'}.`
                                    : "Your digital presence is active. Scans will populate geographic reach data."}
                            </p>
                        </div>
                    </motion.div>
                </div>

                {/* Lead Intelligence Feed */}
                <motion.section variants={itemVariants} className="space-y-10 pt-8">
                    <div className="flex items-center justify-between">
                        <h3 className="text-3xl font-black text-slate-900 flex items-center gap-4 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            <div className="p-2 bg-emerald-500/10 rounded-xl">
                                <Users className="text-emerald-500 w-6 h-6" />
                            </div>
                            Recent Leads
                        </h3>
                        <button className="text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] hover:underline flex items-center gap-1">
                            View All CRM Leads <ArrowUpRight size={12} />
                        </button>
                    </div>

                    {leads.length === 0 ? (
                        <motion.div 
                            variants={itemVariants}
                            className="col-span-full flex flex-col items-center justify-center p-16 text-center bg-white/40 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-sm"
                        >
                            <div className="w-24 h-24 mb-6 rounded-full bg-noble-blue/10 flex items-center justify-center relative">
                                <div className="absolute inset-0 rounded-full border-2 border-noble-blue/20 animate-ping" style={{ animationDuration: '3s' }} />
                                <Users className="w-10 h-10 text-noble-blue" />
                            </div>
                            <h3 className="text-2xl font-black text-slate-900 tracking-tighter mb-2" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Your Pipeline is Clear</h3>
                            <p className="text-slate-500 font-bold max-w-md mx-auto mb-8">
                                Deploy your digital business card at your next event to start capturing high-quality leads directly into your CRM.
                            </p>
                            <Link href="/networking/event-mode">
                                <button className="px-8 py-4 bg-noble-blue text-white rounded-2xl font-black text-[10px] uppercase tracking-widest shadow-lg hover:shadow-xl hover:scale-105 transition-all">
                                    Launch Event Mode
                                </button>
                            </Link>
                        </motion.div>
                    ) : (
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                            {leads.map((lead, i) => (
                            <motion.div 
                                key={lead.id}
                                variants={itemVariants}
                                whileHover={{ y: -5, scale: 1.02 }}
                                className="bg-white/40 backdrop-blur-2xl border border-white/60 p-8 rounded-[32px] shadow-[0_30px_60px_rgba(0,0,0,0.03)] space-y-6 relative overflow-hidden group transition-all duration-500"
                            >
                                <div className="absolute top-0 right-0 w-32 h-32 bg-white/60 rounded-full -mr-16 -mt-16 group-hover:scale-[1.5] transition-transform duration-700 shadow-inner" />
                                
                                <div className="flex items-start justify-between relative z-10">
                                    <div className="space-y-2">
                                        <p className="text-xl font-black text-slate-900 tracking-tighter" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>{lead.name}</p>
                                        <p className="text-[10px] font-black text-slate-500 uppercase tracking-[0.2em]">{lead.email}</p>
                                    </div>
                                    <div className="p-3 bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white group-hover:shadow-md transition-all">
                                        <MessageSquare size={16} className="text-noble-blue" />
                                    </div>
                                </div>

                                <p className="text-xs text-slate-600 font-medium leading-relaxed italic relative z-10 line-clamp-2">
                                    "{lead.message || 'No message provided'}"
                                </p>

                                <div className="pt-6 border-t border-white/60 flex items-center justify-between relative z-10">
                                    <span className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] flex items-center gap-2">
                                        <Calendar size={10} />
                                        {new Date(lead.created_at).toLocaleDateString()}
                                    </span>
                                    <button 
                                        onClick={async () => {
                                            if (!user) {
                                                toast.error('You must be logged in');
                                                return;
                                            }
                                            try {
                                                const tData = await teamService.getTeamByUserId(user.id);
                                                const teamId = tData?.id || user.id;
                                                await toast.promise(
                                                    clientService.createClient({
                                                        name: lead.name,
                                                        email: lead.email,
                                                        team_id: teamId,
                                                        user_id: user.id,
                                                        notes: lead.message
                                                    }),
                                                    {
                                                        loading: 'Promoting Lead to CRM...',
                                                        success: 'Lead successfully converted to Client!',
                                                        error: 'Promotion failed.'
                                                    }
                                                );
                                                await identityService.convertLead(lead.id);
                                                setLeads(prev => prev.filter(l => l.id !== lead.id));
                                            } catch (err) {
                                                console.error(err);
                                            }
                                        }}
                                        className="p-3 rounded-xl bg-noble-blue/10 text-noble-blue hover:bg-noble-blue hover:text-white transition-all shadow-sm"
                                    >
                                        <UserPlus size={16} />
                                    </button>
                                </div>
                            </motion.div>
                        ))}
                    </div>
                    )}
                </motion.section>

                <div className="pt-16 pb-8 flex flex-col items-center gap-6 border-t border-white/40">
                    <div className="flex items-center gap-3 text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] bg-white/40 px-6 py-3 rounded-full border border-white/60 shadow-sm backdrop-blur-md">
                        <Shield size={14} className="text-emerald-500" />
                        End-to-End Encrypted Networking
                    </div>
                </div>
            </motion.main>

            <AnimatePresence>
                {showNFCModal && (
                    <NFCProvisioningModal 
                        identityId="noble-node-7712" 
                        onClose={() => setShowNFCModal(false)} 
                    />
                )}
            </AnimatePresence>
        </div>
    );
}

