'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { 
    Plus, Search, Filter, MoreHorizontal, 
    Users, Phone, Mail, Building,
    ArrowUpRight, Tag, Zap, Sparkles,
    LayoutGrid, List, User
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { useAuth, useFeatureGate } from '@/context/AuthContext';
import { clientService, teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import NobleEmptyState from '@/components/shared/NobleEmptyState';
import PaygUnlockModal, { usePaygBundle } from '@/components/features/billing/PaygUnlockModal';

const TABS = ['Active Entities', 'High Value', 'Archived'];

export default function ClientsPage() {
    const { user, userData } = useAuth();
    const { limits } = useFeatureGate();
    const router = useRouter();
    const [activeTab, setActiveTab] = useState('Active Entities');
    const [searchQuery, setSearchQuery] = useState('');
    const [clients, setClients] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [viewMode, setViewMode] = useState<'list' | 'grid'>('list');
    
    // PAYG Bundle & Limits
    const isFreeUser = userData?.plan === 'explorer' || !userData;
    const paygBundle = usePaygBundle(user?.id);
    const maxClients = limits?.max_clients === -1 ? Infinity : (limits?.max_clients ?? (isFreeUser ? 5 : Infinity));
    const [showPaygModal, setShowPaygModal] = useState(false);

    useEffect(() => {
        if (!user) return;
        
        const fetchClients = async () => {
            try {
                const tData = await teamService.getTeamByUserId(user.id);
                const teamId = tData?.id || user.id;
                const data = await clientService.getClients(teamId);
                setClients(data || []);
            } catch (err) {
                console.error('Error fetching clients:', err);
                toast.error('Failed to load assets');
            } finally {
                setLoading(false);
            }
        };

        fetchClients();
    }, [user]);

    const getStrengthIndex = (client: any) => {
        // Deterministic score based on client data instead of Math.random()
        let score = 50; // Base score
        if (client.email) score += 10;
        if (client.phone) score += 10;
        if (client.company) score += 10;
        if (client.address || client.city || client.country) score += 5;
        if (client.lead_status === 'vip') score += 15;
        else if (client.lead_status === 'active') score += 10;
        else if (client.lead_status === 'lead') score += 5;
        return Math.min(100, score);
    };

    const getLeadBadge = (status: string) => {
        switch (status) {
            case 'vip':
                return <span className="status-neon status-neon-success"><Sparkles className="w-3 h-3" /> ELITE VIP</span>;
            case 'active':
                return <span className="status-neon status-neon-success">ACTIVE</span>;
            case 'lead':
                return <span className="status-neon" style={{ backgroundColor: 'rgba(5, 153, 213, 0.1)', color: '#0599D5', border: '1px solid rgba(5, 153, 213, 0.2)' }}>LEAD VETTING</span>;
            case 'churned':
                return <span className="status-neon status-neon-danger">INACTIVE</span>;
            default:
                return <span className="status-neon status-neon-success">ACTIVE</span>;
        }
    };

    const filteredClients = React.useMemo(() => {
        return clients.filter(client => {
            const matchesSearch = 
                client.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                client.company?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                client.email?.toLowerCase().includes(searchQuery.toLowerCase());
            
            if (!matchesSearch) return false;

            if (activeTab === 'Active Entities') return client.lead_status === 'active' || client.lead_status === 'vip' || client.lead_status === 'lead' || !client.lead_status;
            if (activeTab === 'High Value') return client.lead_status === 'vip';
            if (activeTab === 'Archived') return client.lead_status === 'churned';
            
            return true;
        });
    }, [clients, searchQuery, activeTab]);

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header Area - Noble Cinematic */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-8">
                    <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }}>
                        <div className="flex items-center gap-3 mb-3">
                            <div className="w-12 h-12 rounded-[20px] bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center text-noble-blue border border-white/50 shadow-inner">
                                <Users className="w-6 h-6 fill-current opacity-80" />
                            </div>
                            <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                Client <span className="text-noble-blue">CRM</span>
                            </h1>
                        </div>
                        <p className="text-slate-500 text-sm font-bold max-w-md mt-1">Your executive vault of business relationships.</p>
                    </motion.div>
                    
                    <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="flex items-center gap-4">
                        <div className="flex bg-white/40 backdrop-blur-md p-1 rounded-2xl border border-white/60 shadow-sm">
                            <motion.button whileTap={{ scale: 0.95 }} onClick={() => setViewMode('list')} className={`p-3 rounded-xl transition-all ${viewMode === 'list' ? 'bg-white shadow-sm text-noble-blue' : 'text-slate-400 hover:text-slate-600 hover:bg-white/50'}`}><List size={18} /></motion.button>
                            <motion.button whileTap={{ scale: 0.95 }} onClick={() => setViewMode('grid')} className={`p-3 rounded-xl transition-all ${viewMode === 'grid' ? 'bg-white shadow-sm text-noble-blue' : 'text-slate-400 hover:text-slate-600 hover:bg-white/50'}`}><LayoutGrid size={18} /></motion.button>
                        </div>
                        <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                            <button 
                                onClick={(e) => {
                                    e.preventDefault();
                                    if (clients.length >= maxClients) {
                                        setShowPaygModal(true);
                                    } else {
                                        router.push('/clients/new');
                                    }
                                }}
                                className="group relative overflow-hidden flex items-center gap-2 px-8 py-4 bg-white/60 backdrop-blur-md border border-white hover:border-noble-blue/30 text-slate-900 font-black text-[11px] uppercase tracking-[0.2em] rounded-2xl hover:bg-white transition-all shadow-[0_10px_20px_rgba(0,0,0,0.02)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.1)]"
                            >
                                <div className="w-6 h-6 rounded-full bg-noble-blue flex items-center justify-center group-hover:scale-110 transition-transform shadow-inner">
                                    <Plus className="w-3.5 h-3.5 text-white" />
                                </div>
                                <span>Add Asset</span>
                            </button>
                        </motion.div>
                    </motion.div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 mt-12 relative z-10">
                {/* Filters - Noble Glass */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-white/40 backdrop-blur-2xl p-4 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.03)] mb-8 flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden">
                    <div className="absolute top-[-20%] right-[-10%] w-[300px] h-[300px] bg-noble-blue/5 blur-[80px] rounded-full pointer-events-none z-0" />
                    
                    <div className="flex items-center gap-2 p-1 overflow-x-auto hide-scrollbar relative z-10">
                        {TABS.map((tab) => (
                            <motion.button whileTap={{ scale: 0.95 }} key={tab} onClick={() => setActiveTab(tab)} className={`relative px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-[0.2em] transition-all ${activeTab === tab ? 'text-noble-blue bg-white shadow-sm' : 'text-slate-400 hover:bg-white/50 hover:text-slate-700'}`}>
                                <span className="relative z-10">{tab}</span>
                            </motion.button>
                        ))}
                    </div>
                    <div className="flex items-center gap-4 w-full md:w-auto relative z-10">
                        <div className="relative w-full md:w-80">
                            <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 z-10" />
                            <input 
                                type="text" 
                                placeholder="Search assets..." 
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                className="w-full pl-12 pr-6 py-4 bg-white/60 backdrop-blur-md border border-white/60 rounded-2xl text-xs font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner" 
                            />
                        </div>
                        <motion.button 
                            whileTap={{ scale: 0.95 }} 
                            onClick={() => toast('Advanced filters coming soon', { icon: '🔧' })}
                            className="p-4 bg-white/60 backdrop-blur-md border border-white/60 text-slate-500 rounded-2xl hover:border-noble-blue/30 hover:bg-white transition-all shadow-sm"
                        >
                            <Filter size={18} />
                        </motion.button>
                    </div>
                </motion.div>

                {/* Clients Repository */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="bg-white/40 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-near-black/[0.03] bg-near-black/[0.01] table-row w-full">
                                    <th className="px-4 md:px-8 py-3 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Entity Profile</th>
                                    <th className="px-4 md:px-8 py-3 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Contact Vector</th>
                                    <th className="px-4 md:px-8 py-3 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Strength Index</th>
                                    <th className="px-4 md:px-8 py-3 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-left align-middle">Classification</th>
                                    <th className="px-4 md:px-8 py-3 text-[10px] font-bold uppercase tracking-[0.15em] text-slate-900/40 table-cell whitespace-nowrap text-right align-middle">Operations</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-20 text-center">
                                            <div className="flex justify-center"><div className="w-10 h-10 border-4 border-noble-blue border-t-transparent rounded-full animate-spin" /></div>
                                        </td>
                                    </tr>
                                ) : filteredClients.length === 0 ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-16">
                                            <NobleEmptyState
                                                icon={Users}
                                                accentIcon={Sparkles}
                                                title={searchQuery ? "No matches found" : "The vault is waiting"}
                                                description={searchQuery ? `No assets matched "${searchQuery}".` : "Secure your first client relationship and start building your financial legacy."}
                                                actions={[
                                                    { 
                                                        label: '+ Add Client', 
                                                        onClick: () => {
                                                            if (clients.length >= maxClients) {
                                                                setShowPaygModal(true);
                                                            } else {
                                                                router.push('/clients/new');
                                                            }
                                                        } 
                                                    }
                                                ]}
                                            />
                                        </td>
                                    </tr>
                                ) : (
                                    filteredClients.map((client, i) => {
                                        const strength = getStrengthIndex(client);
                                        return (
                                            <motion.tr 
                                                key={client.id}
                                                initial={{ opacity: 0, y: 10 }}
                                                animate={{ opacity: 1, y: 0 }}
                                                transition={{ delay: i * 0.05 }}
                                                className="border-b border-slate-100 hover:bg-white/40 transition-colors group cursor-pointer" 
                                                onClick={() => router.push(`/clients/${client.id}`)}
                                            >
                                                <td className="px-4 md:px-8 py-3">
                                                    <div className="flex items-center gap-4">
                                                        <div className="w-10 h-10 rounded-2xl bg-gradient-to-br from-noble-blue/10 to-electric-cyan/5 flex items-center justify-center text-noble-blue font-bold text-base border border-noble-blue/5">
                                                            {client.name.charAt(0)}
                                                        </div>
                                                        <div>
                                                            <div className="font-bold text-sm text-slate-900 tracking-tight">{client.name}</div>
                                                            <div className="text-[10px] text-slate-400 font-medium uppercase tracking-widest mt-1 flex items-center gap-2">
                                                                {client.company ? <><Building size={12} /> {client.company}</> : <><User size={12} /> Individual</>}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td className="px-4 md:px-8 py-3">
                                                    <div className="space-y-1">
                                                        <div className="flex items-center gap-2 text-xs font-medium text-slate-700"><Mail size={14} className="text-noble-blue/40" /> {client.email}</div>
                                                        {client.phone && <div className="flex items-center gap-2 text-[11px] font-medium text-slate-400"><Phone size={12} /> {client.country_code} {client.phone}</div>}
                                                    </div>
                                                </td>
                                                <td className="px-4 md:px-8 py-3">
                                                    <div className="w-48">
                                                        <div className="flex items-center justify-between mb-1.5">
                                                            <span className="text-[10px] font-bold text-noble-blue uppercase tracking-tighter">Strength Index</span>
                                                            <span className="text-[10px] font-bold text-slate-900">{strength}%</span>
                                                        </div>
                                                        <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden border border-slate-200/50">
                                                            <motion.div 
                                                                initial={{ width: 0 }} 
                                                                animate={{ width: `${strength}%` }} 
                                                                className={`h-full bg-gradient-to-r ${strength > 80 ? 'from-emerald-400 to-green-500' : 'from-noble-blue to-electric-cyan'}`} 
                                                            />
                                                        </div>
                                                    </div>
                                                </td>
                                                <td className="px-4 md:px-8 py-3">{getLeadBadge(client.lead_status)}</td>
                                                <td className="px-4 md:px-8 py-3 text-right">
                                                    <div className="flex items-center justify-end gap-2">
                                                        <motion.button 
                                                            whileTap={{ scale: 0.95 }}
                                                            onClick={(e) => {
                                                                e.stopPropagation();
                                                                toast('Dedicated Client Portals coming soon', { icon: '🚧' });
                                                            }}
                                                            title="Copy Client Portal Link"
                                                            className="w-8 h-8 rounded-lg bg-slate-50 border border-slate-100 text-noble-blue flex items-center justify-center hover:bg-noble-blue hover:text-white transition-all group-hover:shadow-lg"
                                                        >
                                                            <ArrowUpRight size={16} />
                                                        </motion.button>
                                                        <motion.button whileTap={{ scale: 0.95 }} onClick={(e) => { e.stopPropagation(); toast('Client options coming soon', { icon: '🔧' }); }} className="w-8 h-8 rounded-lg bg-slate-50 border border-slate-100 text-slate-400 flex items-center justify-center hover:bg-noble-blue hover:text-white transition-all group-hover:shadow-lg">
                                                            <MoreHorizontal size={18} />
                                                        </motion.button>
                                                    </div>
                                                </td>
                                            </motion.tr>
                                        );
                                    })
                                )}
                            </tbody>
                        </table>
                    </div>
                </motion.div>
            </div>
            
            {showPaygModal && (
                <PaygUnlockModal
                    isOpen={showPaygModal}
                    onClose={() => setShowPaygModal(false)}
                    templateName="Extra Client Slot"
                    onUnlocked={() => {
                        setShowPaygModal(false);
                        toast.success('Client slot unlocked! You can now add another client.');
                    }}
                />
            )}
        </div>
    );
}
