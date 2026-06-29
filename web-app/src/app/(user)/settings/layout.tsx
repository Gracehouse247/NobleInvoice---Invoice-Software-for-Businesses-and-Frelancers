'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useAuth } from '@/context/AuthContext';
import { UserCircle, Shield, Bell, HardDrive, Palette, Users, Settings as SettingsIcon, CreditCard } from 'lucide-react';
import { motion } from 'framer-motion';

export default function SettingsLayout({ children }: { children: React.ReactNode }) {
    const pathname = usePathname();
    const { userData } = useAuth();
    const isElite = userData?.plan === 'elite';

    const menuItems = [
        { name: 'Profile', path: '/settings/profile', icon: UserCircle },
        { name: 'Brand & Identity', path: '/settings/brand', icon: Palette },
        { name: 'Team & Roles', path: '/settings/team', icon: Users },
        { name: 'Billing & Plans', path: '/settings/billing', icon: CreditCard },
        { name: 'Security', path: '/settings/security', icon: Shield },
        { name: 'Preferences', path: '/settings/preferences', icon: Bell },
        { name: 'Data & Backup', path: '/settings/data', icon: HardDrive },
    ];

    const visibleMenuItems = menuItems.filter(item => {
        if (item.path === '/settings/team' && !isElite) return false;
        return true;
    });

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />
            
            {/* Header */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <motion.div initial={{ opacity: 0, x: -30 }} animate={{ opacity: 1, x: 0 }} transition={{ duration: 0.8, ease: "easeOut" }} className="space-y-2">
                        <div className="flex items-center gap-2 mb-2">
                            <div className="w-10 h-10 rounded-[14px] bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center text-noble-blue border border-white/50 shadow-inner">
                                <SettingsIcon className="w-5 h-5 fill-current opacity-20" />
                                <SettingsIcon className="w-5 h-5 absolute" />
                            </div>
                            <span className="text-xs font-bold text-noble-blue uppercase tracking-[0.2em]">Workspace Configuration</span>
                        </div>
                        <h1 className="text-3xl font-normal text-slate-900 tracking-tight" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            Settings <span className="text-noble-blue italic">Hub</span>
                        </h1>
                        <p className="text-slate-500 font-bold uppercase tracking-[0.2em] text-[10px]">Manage your profile, preferences, and data privacy</p>
                    </motion.div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 py-12 relative z-10">
                <div className="flex flex-col md:flex-row gap-10">
                    {/* Sidebar Navigation */}
                    <div className="w-full md:w-72 flex-shrink-0 space-y-3">
                        {visibleMenuItems.map((item) => {
                            const isActive = pathname === item.path;
                            return (
                                <motion.div key={item.path} whileTap={{ scale: 0.97 }}>
                                    <Link 
                                        href={item.path}
                                        className={`flex items-center gap-4 px-6 py-4 rounded-3xl transition-all duration-300 border ${
                                            isActive 
                                                ? 'bg-white/80 border-white text-noble-blue shadow-[0_15px_30px_rgba(22,111,187,0.1)] font-black backdrop-blur-xl' 
                                                : 'bg-white/20 border-white/30 text-slate-500 hover:bg-white/60 hover:text-slate-800 hover:border-white/60 hover:shadow-sm font-bold backdrop-blur-md'
                                        }`}
                                    >
                                        <div className={`w-8 h-8 rounded-xl flex items-center justify-center transition-colors ${isActive ? 'bg-noble-blue/10' : 'bg-slate-100/50'}`}>
                                            <item.icon className={`w-4 h-4 ${isActive ? 'text-noble-blue' : 'text-slate-400'}`} />
                                        </div>
                                        <span className="text-[11px] uppercase tracking-[0.15em]">{item.name}</span>
                                    </Link>
                                </motion.div>
                            );
                        })}
                    </div>

                    {/* Main Content Area */}
                    <motion.div 
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.6 }}
                        className="flex-1 bg-white/40 backdrop-blur-2xl rounded-[40px] p-10 border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.03)] relative overflow-hidden"
                    >
                        <div className="absolute top-[-20%] right-[-10%] w-[300px] h-[300px] bg-noble-blue/5 blur-[80px] rounded-full pointer-events-none z-0" />
                        <div className="relative z-10">
                            {children}
                        </div>
                    </motion.div>
                </div>
            </div>
        </div>
    );
}
