'use client';

import React, { useEffect, useState } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import AdminSidebar from '@/components/layout/AdminSidebar';
import CommandPalette from '@/components/layout/CommandPalette';
import NotificationCenter from '@/components/layout/NotificationCenter';
import { Loader2, Search, Bell, ChevronRight, UserCircle } from 'lucide-react';
import { supabase } from '@/lib/supabase';
import Link from 'next/link';

export default function AdminLayout({ children }: { children: React.ReactNode }) {
    const pathname = usePathname();
    const router = useRouter();
    const [authorized, setAuthorized] = useState(false);
    const [loading, setLoading] = useState(true);
    const [adminName, setAdminName] = useState('Admin User');
    const [adminRole, setAdminRole] = useState('Superadmin');

    // Feature UI States
    const [isCmdOpen, setIsCmdOpen] = useState(false);
    const [isNotifOpen, setIsNotifOpen] = useState(false);

    const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

    // List of pages that do NOT require authentication or the sidebar
    const isPublicPage = pathname === '/admin/login';

    useEffect(() => {
        if (isPublicPage) {
            setLoading(false);
            return;
        }

        let destroyed = false;

        const verifyAdminAccess = async (userId: string, userEmail?: string) => {
            try {
                const { data: profile } = await supabase
                    .from('profiles')
                    .select('full_name:display_name, subscription_tier, role, is_superadmin')
                    .eq('id', userId)
                    .single();

                if (destroyed) return;

                const adminRoles = ['super_admin', 'seo_manager', 'support_staff'];
                const isAdmin =
                    profile?.is_superadmin === true ||
                    adminRoles.includes(profile?.role ?? '');

                if (!isAdmin) {
                    router.push('/');
                    return;
                }

                // Set display name and role label for header
                setAdminName(profile?.full_name || userEmail?.split('@')[0] || 'Admin');
                if (profile?.is_superadmin) {
                    setAdminRole('Superadmin');
                } else {
                    const roleLabelMap: Record<string, string> = {
                        super_admin: 'Super Admin',
                        seo_manager: 'SEO Manager',
                        support_staff: 'Support Staff',
                    };
                    setAdminRole(roleLabelMap[profile?.role ?? ''] ?? 'Admin');
                }

                setAuthorized(true);
            } catch (err) {
                console.error('Admin profile check failed:', err);
                if (!destroyed) router.push('/admin/login');
            } finally {
                if (!destroyed) setLoading(false);
            }
        };

        // Fallback: if onAuthStateChange hasn't fired within 8 seconds, redirect
        const safetyTimer = setTimeout(() => {
            if (!destroyed) {
                setLoading(false);
                router.push('/admin/login');
            }
        }, 8000);

        const { data: { subscription } } = supabase.auth.onAuthStateChange(
            (event, session) => {
                if (destroyed) return;

                // We got an event, so clear the fallback timer to prevent delayed forced-logout
                clearTimeout(safetyTimer);

                if (session?.user) {
                    verifyAdminAccess(session.user.id, session.user.email);
                } else {
                    // No session — only redirect if this isn't the initial
                    // INITIAL_SESSION event with a null session (which fires
                    // momentarily before the real session is loaded).
                    if (event !== 'INITIAL_SESSION') {
                        setLoading(false);
                        router.push('/admin/login');
                    }
                }
            }
        );

        return () => {
            destroyed = true;
            clearTimeout(safetyTimer);
            subscription.unsubscribe();
        };
    }, [pathname, isPublicPage, router]);

    // Command Palette Keyboard Listener
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
                e.preventDefault();
                setIsCmdOpen(true);
            }
        };
        window.addEventListener('keydown', handleKeyDown);
        return () => window.removeEventListener('keydown', handleKeyDown);
    }, []);

    if (loading && !isPublicPage) {
        return (
            <div className="flex h-screen bg-slate-50 items-center justify-center">
                <Loader2 className="w-10 h-10 text-[#006970] animate-spin" />
            </div>
        );
    }

    if (isPublicPage) {
        return <>{children}</>;
    }

    if (!authorized) {
        return null;
    }

    // Helper to format breadcrumbs
    const getBreadcrumbs = () => {
        if (!pathname || pathname === '/admin' || pathname === '/admin/dashboard') {
            return [{ label: 'Dashboard', href: '/admin/dashboard' }];
        }
        const parts = pathname.split('/').filter(Boolean).slice(1);
        const breadcrumbs = [];
        let currentPath = '/admin';
        for (let i = 0; i < parts.length; i++) {
            currentPath += `/${parts[i]}`;
            let label = parts[i].charAt(0).toUpperCase() + parts[i].slice(1);
            if (label.toLowerCase() === 'cms') label = 'CMS';
            breadcrumbs.push({ label, href: currentPath });
        }
        return breadcrumbs;
    };

    const breadcrumbs = getBreadcrumbs();

    return (
        <div className="flex min-h-screen bg-slate-50 text-slate-900 font-sans">
            <CommandPalette isOpen={isCmdOpen} onClose={() => setIsCmdOpen(false)} />
            <AdminSidebar isOpen={isMobileSidebarOpen} onClose={() => setIsMobileSidebarOpen(false)} />
            
            <main className="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
                {/* Top Header Bar */}
                <header className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-4 lg:px-8 shrink-0 z-10 relative shadow-sm">
                    {/* Breadcrumbs & Mobile Menu */}
                    <div className="flex items-center text-sm">
                        <button 
                            onClick={() => setIsMobileSidebarOpen(true)}
                            className="lg:hidden mr-4 text-slate-500 hover:text-slate-900 p-1"
                        >
                            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                            </svg>
                        </button>
                        <span className="text-slate-400 font-semibold hidden sm:inline">Admin</span>
                        {breadcrumbs.map((crumb, index) => (
                            <React.Fragment key={crumb.href}>
                                <ChevronRight className="w-4 h-4 mx-2 text-slate-300 hidden sm:block" />
                                {index === breadcrumbs.length - 1 ? (
                                    <span className="font-bold text-slate-900">{crumb.label}</span>
                                ) : (
                                    <Link href={crumb.href} className="text-slate-500 hover:text-[#006970] font-semibold transition-colors hidden sm:block">
                                        {crumb.label}
                                    </Link>
                                )}
                            </React.Fragment>
                        ))}
                    </div>

                    {/* Actions */}
                    <div className="flex items-center gap-5">
                        {/* Global Search / Command Palette Trigger */}
                        <button onClick={() => setIsCmdOpen(true)} className="flex items-center sm:gap-3 gap-2 sm:pl-3 sm:pr-2 px-2 py-1.5 bg-slate-50 border border-slate-200 hover:border-slate-300 rounded-lg text-sm text-slate-400 transition-all sm:w-64 w-auto text-left shadow-sm">
                            <Search className="w-4 h-4" />
                            <span className="flex-1 font-medium text-[13px] hidden sm:inline">Search anything...</span>
                            <div className="hidden sm:flex items-center gap-1">
                                <kbd className="inline-block bg-white border border-slate-200 rounded px-1.5 py-0.5 text-[10px] font-bold text-slate-400 shadow-sm">⌘</kbd>
                                <kbd className="inline-block bg-white border border-slate-200 rounded px-1.5 py-0.5 text-[10px] font-bold text-slate-400 shadow-sm">K</kbd>
                            </div>
                        </button>

                        <div className="h-6 w-[1px] bg-slate-200 mx-1"></div>

                        {/* Notifications */}
                        <div className="relative">
                            <button onClick={() => setIsNotifOpen(!isNotifOpen)} className="text-slate-500 hover:text-[#006970] transition-colors relative p-1.5 rounded-full hover:bg-[#f0fafa]">
                                <Bell className="w-5 h-5" />
                                <span className="absolute top-1 right-1 w-2 h-2 bg-rose-500 border-2 border-white rounded-full"></span>
                            </button>
                            <NotificationCenter isOpen={isNotifOpen} onClose={() => setIsNotifOpen(false)} />
                        </div>
                        
                        {/* Profile */}
                        <div className="flex items-center gap-3 pl-2 cursor-pointer group">
                            <div className="text-right hidden sm:block">
                                <p className="text-[13px] font-bold text-slate-900 leading-none">{adminName}</p>
                                <p className="text-[11px] font-semibold text-slate-500 mt-1">{adminRole}</p>
                            </div>
                            <div className="w-9 h-9 rounded-full bg-[#f0fafa] flex items-center justify-center text-[#006970] border border-[#d0eded] group-hover:bg-[#e0f5f5] group-hover:border-[#b9cacb] transition-all shadow-sm">
                                <UserCircle className="w-5 h-5" />
                            </div>
                        </div>
                    </div>
                </header>

                {/* Main Content Area */}
                <div className="flex-1 overflow-y-auto custom-scrollbar p-8 bg-slate-50/50">
                    <div className="max-w-[1600px] mx-auto">
                        {children}
                    </div>
                </div>
            </main>
        </div>
    );
}
