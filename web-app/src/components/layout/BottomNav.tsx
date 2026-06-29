'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { MENU_GROUPS } from '@/lib/constants';
import { useAuth } from '@/context/AuthContext';
import { useUpgradeModal } from '@/context/UpgradeModalContext';
import { Lock, Crown } from 'lucide-react';

export default function BottomNav() {
    const pathname = usePathname();
    const router = useRouter();
    const { userData } = useAuth();
    const { openUpgradeModal } = useUpgradeModal();

    const hasPlanAccess = (requiredPlan?: 'pro' | 'elite') => {
        if (!requiredPlan) return true;
        const plan = userData?.plan || 'explorer';
        if (plan === 'admin' || plan === 'elite') return true;
        if (requiredPlan === 'pro' && plan === 'pro' && userData?.subscriptionStatus === 'active') return true;
        return false;
    };

    const handleItemClick = (e: React.MouseEvent, item: any) => {
        if (item.requiredPlan && !hasPlanAccess(item.requiredPlan)) {
            e.preventDefault();
            openUpgradeModal({ featureName: item.name, requiredPlan: item.requiredPlan });
        } else {
            router.push(item.href);
        }
    };

    return (
        <nav className="md:hidden fixed bottom-0 left-0 right-0 h-16 bg-background/80 backdrop-blur-xl border-t border-card-border flex items-center justify-around px-2 z-50">
            {MENU_GROUPS[0].items.concat(MENU_GROUPS[1].items).slice(0, 5).map(item => {
                const isActive = pathname === item.href;
                return (
                    <button 
                        key={item.name} 
                        onClick={(e) => handleItemClick(e, item)}
                        className={`relative flex flex-col items-center justify-center w-14 h-14 rounded-xl transition-all ${
                            isActive ? 'text-primary bg-primary/5 shadow-inner' : 'text-text-secondary hover:text-foreground'
                        }`}
                    >
                        <item.icon className="w-5 h-5 mb-1" />
                        <span className="text-[8px] font-bold uppercase tracking-widest">{item.name}</span>
                        {(item as any).requiredPlan && !hasPlanAccess((item as any).requiredPlan) && (
                            <div className={`absolute top-1 right-2 flex items-center justify-center w-3.5 h-3.5 rounded-full flex-shrink-0 shadow-sm ${
                                (item as any).requiredPlan === 'elite' ? 'bg-amber-100 text-amber-600' : 'bg-blue-100 text-primary'
                            }`}>
                                {(item as any).requiredPlan === 'elite' ? <Crown className="w-2 h-2" /> : <Lock className="w-2 h-2" />}
                            </div>
                        )}
                    </button>
                );
            })}
        </nav>
    );
}

