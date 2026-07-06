'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { motion, AnimatePresence } from 'framer-motion';
import { LogOut, Search, Lock, Crown } from 'lucide-react';
import { MENU_GROUPS } from '@/lib/constants';
import { useUpgradeModal } from '@/context/UpgradeModalContext';

interface MobileSidebarProps {
    isOpen: boolean;
    onClose: () => void;
    userData: any;
    mounted: boolean;
}

export default function MobileSidebar({
    isOpen,
    onClose,
    userData,
    mounted
}: MobileSidebarProps) {
    const pathname = usePathname();
    const { openUpgradeModal } = useUpgradeModal();

    const hasPlanAccess = (requiredPlan?: 'pulse' | 'elite') => {
        if (!requiredPlan) return true;
        const plan = userData?.plan || 'explorer';
        if (plan === 'admin' || plan === 'elite') return true;
        if (requiredPlan === 'pulse' && plan === 'pulse' && userData?.subscriptionStatus === 'active') return true;
        return false;
    };

    const handleItemClick = (e: React.MouseEvent, item: any) => {
        if (item.requiredPlan && !hasPlanAccess(item.requiredPlan)) {
            e.preventDefault();
            onClose(); // close mobile sidebar first
            setTimeout(() => {
                openUpgradeModal({ featureName: item.name, requiredPlan: item.requiredPlan });
            }, 100);
        } else {
            onClose();
        }
    };

    return (
        <AnimatePresence>
            {isOpen && (
                <>
                    <motion.div 
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={onClose}
                        className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[60] md:hidden"
                    />
                    <motion.aside 
                        initial={{ x: '-100%' }}
                        animate={{ x: 0 }}
                        exit={{ x: '-100%' }}
                        transition={{ type: 'spring', damping: 25, stiffness: 200 }}
                        className="fixed inset-y-0 left-0 w-[280px] bg-background z-[70] lg:hidden flex flex-col p-6 gap-6 shadow-2xl overflow-y-auto"
                    >
                        <div className="flex items-center justify-between">
                            <Link href="/" onClick={onClose}>
                                <img 
                                    src="/images/logo.png" 
                                    alt="NobleInvoice" 
                                    className="h-9 w-auto object-contain" 
                                />
                            </Link>
                            <button onClick={onClose} className="p-2 text-text-secondary">
                                <LogOut className="w-5 h-5 rotate-180" />
                            </button>
                        </div>

                        <div className="relative">
                            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-secondary" />
                            <input 
                                placeholder="Search workspace..." 
                                className="w-full bg-card-border/50 border border-card-border rounded-2xl py-3 pl-11 pr-4 text-xs tracking-widest uppercase text-foreground focus:outline-none"
                            />
                        </div>

                        <nav className="flex flex-col gap-6 flex-1 overflow-y-auto pr-2 pb-8">
                            {MENU_GROUPS.map(group => (
                                <div key={group.label} className="space-y-2">
                                    <h3 className="text-[10px] font-black text-text-secondary uppercase tracking-[0.2em] px-4">{group.label}</h3>
                                    <div className="flex flex-col gap-1">
                                        {group.items.map(item => {
                                            const isActive = pathname === item.href;
                                            return (
                                                <Link 
                                                    key={item.name} 
                                                    href={item.href}
                                                    onClick={(e) => handleItemClick(e, item)}
                                                    className={`flex items-center gap-3 px-4 py-3.5 rounded-2xl transition-all ${
                                                        isActive 
                                                        ? 'bg-primary text-secondary shadow-lg' 
                                                        : 'text-text-secondary hover:bg-card-border/50'
                                                    }`}
                                                >
                                                    <item.icon className={`w-4 h-4 ${isActive ? 'text-secondary' : 'opacity-70'}`} />
                                                    <span className={`flex-1 text-[11px] uppercase tracking-widest ${isActive ? 'font-black' : 'font-bold'}`}>{item.name}</span>
                                                    {(item as any).requiredPlan && !hasPlanAccess((item as any).requiredPlan) && (
                                                        <div className={`flex items-center justify-center w-4 h-4 rounded flex-shrink-0 ${
                                                            (item as any).requiredPlan === 'elite' ? 'bg-amber-100 text-amber-600' : 'bg-blue-100 text-primary'
                                                        }`}>
                                                            {(item as any).requiredPlan === 'elite' ? <Crown className="w-2.5 h-2.5" /> : <Lock className="w-2.5 h-2.5" />}
                                                        </div>
                                                    )}
                                                </Link>
                                            );
                                        })}
                                    </div>
                                </div>
                            ))}
                        </nav>
                        
                        <div className="pt-6 border-t border-card-border">
                            <Link 
                                href="/logout"
                                onClick={onClose}
                                className="flex items-center gap-3 px-4 py-3 text-error bg-error/5 rounded-2xl font-bold text-[10px] uppercase tracking-widest"
                            >
                                <LogOut className="w-4 h-4" />
                                Sign Out
                            </Link>
                        </div>
                    </motion.aside>
                </>
            )}
        </AnimatePresence>
    );
}




