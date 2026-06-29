'use client';

import React, { useState } from 'react';
import { usePathname } from 'next/navigation';
import { Menu, Bell } from 'lucide-react';
import NotificationCenter from './NotificationCenter';
import HeaderSearch from './HeaderSearch';
import UserDropdown from './UserDropdown';

interface HeaderProps {
    setIsMobileMenuOpen: (val: boolean) => void;
}

export default function Header({
    setIsMobileMenuOpen
}: HeaderProps) {
    const pathname = usePathname();
    const [isNotifOpen, setIsNotifOpen] = useState(false);

    // Format the pathname for display
    const currentPathName = pathname.split('/')[1] || 'Dashboard';
    const formattedPathName = currentPathName.charAt(0).toUpperCase() + currentPathName.slice(1);

    return (
        <header className="h-[72px] border-b border-[#E2E8F0] flex items-center justify-between px-6 md:px-10 flex-shrink-0 bg-white/80 backdrop-blur-xl z-40 sticky top-0 transition-all">
            <div className="flex items-center gap-6 flex-1">
                <button 
                    type="button"
                    onClick={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        setIsMobileMenuOpen(true);
                    }}
                    className="lg:hidden p-2.5 -ml-2 text-[#64748B] hover:text-[#0F172A] transition-all active:scale-90 bg-[#F8FAFC] rounded-xl border border-[#E2E8F0]"
                    aria-label="Toggle Navigation Drawer"
                >
                    <Menu className="w-5 h-5" />
                </button>
                
                <div className="hidden lg:flex items-center gap-3 shrink-0">
                    <span className="text-[10px] font-black text-[#94A3B8] uppercase tracking-widest">Workspace</span>
                    <div className="w-1.5 h-1.5 rounded-full bg-[#166FBB]" />
                    <span className="text-sm font-black text-[#0F172A] tracking-tight">{formattedPathName}</span>
                </div>

                <div className="hidden lg:flex items-center gap-6 ml-6 flex-1 pr-12 overflow-visible">
                    <HeaderSearch />
                </div>
            </div>

            <div className="flex items-center gap-4">
                <div className="relative">
                    <button onClick={() => setIsNotifOpen(!isNotifOpen)} className="text-slate-500 hover:text-slate-900 transition-colors p-1.5 rounded-full hover:bg-slate-100">
                        <Bell className="w-5 h-5" />
                    </button>
                    <NotificationCenter isOpen={isNotifOpen} onClose={() => setIsNotifOpen(false)} />
                </div>
                <UserDropdown />
            </div>
        </header>
    );
}
