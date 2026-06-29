'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { 
    ChevronRight
} from 'lucide-react';
import { MENU_GROUPS } from '@/lib/constants';
import { UserData } from '@/types';
import { useUpgradeModal } from '@/context/UpgradeModalContext';
import { Lock, Crown } from 'lucide-react';

interface SidebarProps {
    userData: UserData | null;
    mounted: boolean;
    setIsSearchOpen: (val: boolean) => void;
    setIsProfileModalOpen: (val: boolean) => void;
}

export default function Sidebar({
    userData,
    mounted,
    setIsSearchOpen,
    setIsProfileModalOpen,
}: SidebarProps) {
    const pathname = usePathname();
    const router = useRouter();
    const { openUpgradeModal } = useUpgradeModal();

    const hasPlanAccess = (requiredPlan?: 'pro' | 'elite') => {
        if (!requiredPlan) return true;
        const plan = userData?.plan || 'explorer';
        if (plan === 'admin' || plan === 'elite') return true;
        if (requiredPlan === 'pro' && plan === 'pro' && userData?.subscriptionStatus === 'active') return true;
        return false;
    };

    const handleItemClick = (e: React.MouseEvent, item: any) => {
        e.preventDefault();
        if (item.requiredPlan && !hasPlanAccess(item.requiredPlan)) {
            openUpgradeModal({ featureName: item.name, requiredPlan: item.requiredPlan });
        } else {
            router.push(item.href);
        }
    };

    return (
        <aside className="hidden lg:flex w-[260px] bg-[#F8FAFC] border-r border-[#E2E8F0] flex-col py-6 flex-shrink-0 z-20 relative transition-all duration-300">
            {/* Logo */}
            <div className="px-5 mb-8">
                <Link href="/" className="flex items-center gap-3">
                    <div className="relative">
                        {/* Assuming the logo has a dark mode version or looks good on dark. If not, this can be inverted */}
                        <img 
                            src="/images/logo.png" 
                            alt="NobleInvoice" 
                            className="h-8 w-auto object-contain" 
                        />
                        <div className="absolute -top-1 -right-1 w-2 h-2 bg-[#10B981] rounded-full ring-2 ring-[#F8FAFC]" />
                    </div>
                </Link>
            </div>

            {/* Navigation Groups - High Density, Light Mode */}
            <nav className="flex flex-col gap-5 flex-1 overflow-y-auto px-3 pb-4 min-h-0 [&::-webkit-scrollbar]:w-[3px] [&::-webkit-scrollbar-thumb]:bg-slate-300 [&::-webkit-scrollbar-thumb]:rounded-full">
                {MENU_GROUPS.map((group) => (
                    <div key={group.label} className="space-y-1">
                        <h3 className="px-3 mb-1 text-[10px] font-black text-[#94A3B8] uppercase tracking-widest">{group.label}</h3>
                        <div className="flex flex-col gap-0.5">
                            {group.items.map(item => {
                                const isActive = pathname === item.href || pathname.startsWith(item.href + '/');
                                
                                return (
                                    <button 
                                        key={item.name} 
                                        onClick={(e) => handleItemClick(e, item)}
                                        className={`relative flex w-full items-center justify-between px-3 py-2 rounded-xl transition-all group overflow-hidden ${
                                            isActive 
                                            ? 'bg-gradient-to-r from-[#166FBB] to-[#125A96] text-white font-black shadow-md shadow-[#166FBB]/20' 
                                            : 'text-[#64748B] hover:bg-slate-200/50 hover:text-[#0F172A] font-bold'
                                        }`}
                                    >
                                        <div className="flex items-center gap-3">
                                            <div className={`flex items-center justify-center w-6 h-6 rounded-md transition-colors ${
                                                isActive ? 'text-white' : 'text-[#94A3B8] group-hover:text-[#166FBB]'
                                            }`}>
                                                <item.icon className="w-4 h-4" strokeWidth={isActive ? 2.5 : 2} />
                                            </div>
                                            <span className="text-[13px] tracking-tight">{item.name}</span>
                                            {(item as any).requiredPlan && !hasPlanAccess((item as any).requiredPlan) && (
                                                <div className={`ml-1 flex items-center justify-center w-4 h-4 rounded flex-shrink-0 ${
                                                    (item as any).requiredPlan === 'elite' ? 'bg-amber-100 text-amber-600' : 'bg-blue-100 text-noble-blue'
                                                }`}>
                                                    {(item as any).requiredPlan === 'elite' ? <Crown className="w-2.5 h-2.5" /> : <Lock className="w-2.5 h-2.5" />}
                                                </div>
                                            )}
                                        </div>
                                        {isActive && (
                                            <ChevronRight className="w-3.5 h-3.5 text-white/70" />
                                        )}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                ))}
            </nav>
        </aside>
    );
}
