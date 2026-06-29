'use client';

import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { 
    User, Settings, CreditCard, LogOut, Sparkles, Award, Shield, ChevronRight 
} from 'lucide-react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/context/AuthContext';

export default function UserDropdown() {
    const [isOpen, setIsOpen] = useState(false);
    const dropdownRef = useRef<HTMLDivElement>(null);
    const router = useRouter();
    const { userData: authUserData, user } = useAuth();

    // Derive display data from real auth context
    const displayName = authUserData?.name || user?.email?.split('@')[0] || 'Noble User';
    const displayEmail = authUserData?.email || user?.email || '';
    const displayPlan = authUserData?.plan || 'explorer';
    const initials = displayName
        .split(' ')
        .map((n: string) => n[0])
        .slice(0, 2)
        .join('')
        .toUpperCase() || 'NU';

    const userData = {
        name: displayName,
        email: displayEmail,
        plan: displayPlan,
        initials,
    };

    // Handle clicking outside to close
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    const isPremium = ['elite', 'pro'].includes(userData.plan);

    return (
        <div className="relative" ref={dropdownRef}>
            {/* Trigger Button */}
            <button 
                onClick={() => setIsOpen(!isOpen)}
                className={`flex items-center gap-2 p-1 pl-2 pr-1 rounded-full border transition-all ${
                    isOpen 
                    ? 'bg-[#F8FAFC] border-[#CBD5E1] shadow-inner' 
                    : 'bg-white border-[#E2E8F0] hover:border-[#CBD5E1] hover:bg-[#F8FAFC] shadow-sm'
                }`}
            >
                <div className="hidden sm:flex flex-col items-end mr-1">
                    <span className="text-[11px] font-black text-[#0F172A] leading-tight tracking-tight">{userData.name}</span>
                    <span className="text-[9px] font-bold text-[#166FBB] uppercase tracking-widest">{userData.plan}</span>
                </div>
                <div className="w-8 h-8 rounded-full bg-[#166FBB]/10 border border-[#166FBB]/20 flex items-center justify-center overflow-hidden shrink-0">
                    <span className="text-[11px] font-black text-[#166FBB]">{userData.initials}</span>
                </div>
            </button>

            {/* Dropdown Menu */}
            <AnimatePresence>
                {isOpen && (
                    <motion.div
                        initial={{ opacity: 0, y: 10, scale: 0.95 }}
                        animate={{ opacity: 1, y: 0, scale: 1 }}
                        exit={{ opacity: 0, y: 10, scale: 0.95 }}
                        transition={{ duration: 0.2, ease: "easeOut" }}
                        className="absolute right-0 mt-3 w-72 bg-white rounded-3xl border border-[#CBD5E1] shadow-[0_20px_50px_rgba(15,23,42,0.12)] z-[9999] overflow-hidden origin-top-right"
                    >
                        {/* Header Profile Area */}
                        <div className="p-5 border-b border-[#E2E8F0] bg-gradient-to-b from-[#F8FAFC] to-white">
                            <div className="flex items-center gap-4">
                                <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#166FBB] to-[#125A96] flex items-center justify-center shrink-0 shadow-md shadow-[#166FBB]/20">
                                    <span className="text-sm font-black text-white">{userData.initials}</span>
                                </div>
                                <div className="flex-1 min-w-0">
                                    <h3 className="text-sm font-black text-[#0F172A] truncate">{userData.name}</h3>
                                    <p className="text-xs text-[#64748B] font-medium truncate mt-0.5">{userData.email}</p>
                                </div>
                            </div>
                        </div>

                        {/* Upgrade / Plan Status Card */}
                        <div className="p-3">
                            <div className="bg-[#166FBB]/5 rounded-2xl p-4 border border-[#166FBB]/10">
                                <div className="flex items-center justify-between mb-2">
                                    <p className="text-[11px] font-black text-[#166FBB] uppercase tracking-widest flex items-center gap-1.5">
                                        <Sparkles className="w-3.5 h-3.5" /> 
                                        {userData.plan === 'elite' ? 'Noble Elite' : userData.plan === 'pro' ? 'Noble Pro' : 'Free Tier'}
                                    </p>
                                    {userData.plan === 'elite' && <Award className="w-4 h-4 text-[#166FBB]" />}
                                </div>
                                <p className="text-[10px] text-[#64748B] font-medium leading-relaxed mb-3">
                                    {isPremium ? 'Your business systems are fully powered.' : 'Unlock advanced invoicing and priority tools.'}
                                </p>
                                <Link 
                                    href={isPremium ? '/pro/manage' : '/upgrade'}
                                    onClick={() => setIsOpen(false)}
                                    className="flex items-center justify-center w-full py-2 bg-white border border-[#E2E8F0] rounded-xl text-[10px] font-black text-[#0F172A] uppercase tracking-widest hover:border-[#166FBB] hover:text-[#166FBB] transition-colors"
                                >
                                    {isPremium ? 'Manage Plan' : 'Upgrade Now'}
                                </Link>
                            </div>
                        </div>

                        {/* Menu Links */}
                        <div className="p-2 border-t border-[#E2E8F0]">
                            <Link 
                                href="/settings/brand"
                                onClick={() => setIsOpen(false)}
                                className="flex items-center justify-between p-3 rounded-xl hover:bg-[#F8FAFC] text-[#475569] hover:text-[#0F172A] transition-colors group"
                            >
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-lg bg-[#F8FAFC] border border-[#E2E8F0] flex items-center justify-center group-hover:bg-white transition-colors">
                                        <Settings className="w-4 h-4" />
                                    </div>
                                    <span className="text-xs font-bold">Workspace Settings</span>
                                </div>
                                <ChevronRight className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
                            </Link>

                            <Link 
                                href="/settings/billing"
                                onClick={() => setIsOpen(false)}
                                className="flex items-center justify-between p-3 rounded-xl hover:bg-[#F8FAFC] text-[#475569] hover:text-[#0F172A] transition-colors group"
                            >
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-lg bg-[#F8FAFC] border border-[#E2E8F0] flex items-center justify-center group-hover:bg-white transition-colors">
                                        <CreditCard className="w-4 h-4" />
                                    </div>
                                    <span className="text-xs font-bold">Billing & Invoices</span>
                                </div>
                                <ChevronRight className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
                            </Link>

                            <Link 
                                href="/settings/security"
                                onClick={() => setIsOpen(false)}
                                className="flex items-center justify-between p-3 rounded-xl hover:bg-[#F8FAFC] text-[#475569] hover:text-[#0F172A] transition-colors group"
                            >
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-lg bg-[#F8FAFC] border border-[#E2E8F0] flex items-center justify-center group-hover:bg-white transition-colors">
                                        <Shield className="w-4 h-4" />
                                    </div>
                                    <span className="text-xs font-bold">Security & Identity</span>
                                </div>
                                <ChevronRight className="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity" />
                            </Link>
                        </div>

                        {/* Logout Section */}
                        <div className="p-2 border-t border-[#E2E8F0] bg-[#F8FAFC]">
                            <button 
                                onClick={() => {
                                    setIsOpen(false);
                                    router.push('/logout');
                                }}
                                className="w-full flex items-center gap-3 p-3 rounded-xl hover:bg-rose-50 text-[#64748B] hover:text-rose-600 transition-colors"
                            >
                                <div className="w-8 h-8 rounded-lg bg-white border border-[#E2E8F0] flex items-center justify-center">
                                    <LogOut className="w-4 h-4" />
                                </div>
                                <span className="text-xs font-bold">Sign Out securely</span>
                            </button>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
}
