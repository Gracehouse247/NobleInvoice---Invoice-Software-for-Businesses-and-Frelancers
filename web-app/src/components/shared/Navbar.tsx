'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { motion, AnimatePresence } from 'framer-motion';
import { useAuth } from '@/context/AuthContext';
import { X, Menu, ChevronDown, ChevronRight, Zap } from 'lucide-react';

export default function Navbar() {
    const [isScrolled, setIsScrolled] = useState(false);
    const [activeMenu, setActiveMenu] = useState<string | null>(null);
    const [mobileOpen, setMobileOpen] = useState(false);
    const [mobileSubmenu, setMobileSubmenu] = useState<string | null>(null);
    const [announcementVisible, setAnnouncementVisible] = useState(true);
    const { user } = useAuth();

    useEffect(() => {
        const handleScroll = () => setIsScrolled(window.scrollY > 20);
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    // Lock body scroll when mobile drawer is open
    useEffect(() => {
        document.body.style.overflow = mobileOpen ? 'hidden' : '';
        return () => { document.body.style.overflow = ''; };
    }, [mobileOpen]);

    const solutions = [
        {
            category: "Core Financials",
            items: [
                { title: "Invoicing Pro", desc: "High-end PDF generation", icon: "description", href: "/features/how-to-make-an-invoice-for-free" },
                { title: "Expense Manager", desc: "Track spending & deductions", icon: "receipt_long", href: "/features/how-to-make-an-invoice-on-my-phone" },
                { title: "Global Settlements", desc: "Get paid across borders", icon: "account_balance_wallet", href: "/features/best-free-invoice-app" },
                { title: "Products Catalog", desc: "Standardize your billing", icon: "category", href: "/features/products-services" },
                { title: "Growth Reports", desc: "Data-driven decisions", icon: "bar_chart", href: "/features/growth-reports" },
            ]
        },
        {
            category: "Growth & CRM",
            items: [
                { title: "CRM Engine", desc: "Full client lifecycle", icon: "hub", href: "/features/crm-engine" },
                { title: "Client Portal", desc: "White-label dashboard", icon: "vpn_key", href: "/features/billing-software-online" },
                { title: "Lead Intelligence", desc: "Track prospects to paid", icon: "track_changes", href: "/features/lead-intelligence" },
                { title: "Digital Cards", desc: "NFC & QR networking", icon: "contactless", href: "/features/digital-business-cards" },
                { title: "QR Payments", desc: "Scan to pay instantly", icon: "qr_code_scanner", href: "/features/how-to-generate-a-qr-code" },
            ]
        },
        {
            category: "Elite & Enterprise",
            items: [
                { title: "Shopify Invoice Generator", desc: "Automate B2B billing", icon: "inventory_2", href: "/features/shopify-invoice-generator" },
                { title: "AI Invoice Generator", desc: "AI text-to-invoice engine", icon: "auto_awesome", href: "/features/ai-invoice-generator" },
                { title: "Team Workspace", desc: "Multi-user collaboration", icon: "groups", href: "/features/team-workspace" },
                { title: "Enterprise Scaling", desc: "High-volume infrastructure", icon: "domain", href: "/features/enterprise-scaling" },
                { title: "Professional Identity", desc: "Premium custom branding", icon: "palette", href: "/features/professional-identity" },
            ]
        }
    ];

    const platforms = [
        { name: "Windows App", desc: "Desktop client", icon: "laptop_windows", href: "/about", img: "/images/platforms/windows.jpg" },
        { name: "Android App", desc: "Mobile client", icon: "phone_android", href: "/about", img: "/images/platforms/android.jpg" },
        { name: "iOS App", desc: "Apple client", icon: "phone_iphone", href: "/about", img: "/images/platforms/ios.jpg" },
    ];

    const companyLinks = [
        { label: "Our Story", href: "/about" },
        { label: "Press Kit", href: "/blog" },
    ];

    const navLinks = [
        { label: 'Features', href: '/#features' },
        { label: 'Pricing', href: '/pricing' },
        { label: 'Blog', href: '/blog' },
    ];

    return (
        <>
            {/* ── Announcement Bar ── */}
            <AnimatePresence>
                {announcementVisible && (
                    <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: 'auto', opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        transition={{ duration: 0.3 }}
                        className="fixed top-0 left-0 right-0 z-[130] bg-gradient-to-r from-noble-blue via-[#0599D5] to-noble-blue overflow-hidden"
                    >
                        <div className="flex items-center justify-center gap-3 px-6 py-2.5 text-white text-xs font-bold relative">
                            <Zap className="w-3.5 h-3.5 text-electric-cyan shrink-0" />
                            <span className="tracking-wide">
                                🎉 <span className="font-black">New:</span> QR Code Payments are now live —{' '}
                                <Link href="/register" className="underline underline-offset-2 hover:text-electric-cyan transition-colors inline-block p-2">
                                    Try it free today →
                                </Link>
                            </span>
                            <button
                                onClick={() => setAnnouncementVisible(false)}
                                className="absolute right-4 top-1/2 -translate-y-1/2 w-11 h-11 flex items-center justify-center opacity-60 hover:opacity-100 transition-opacity"
                                aria-label="Dismiss announcement"
                            >
                                <X className="w-5 h-5" />
                            </button>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* ── Main Navbar ── */}
            <nav
                className={`fixed left-0 right-0 z-[120] transition-all duration-500 ${announcementVisible ? 'top-[38px]' : 'top-0'} ${
                    isScrolled ? 'bg-white/90 backdrop-blur-md border-b border-near-black/5 shadow-sm' : 'bg-transparent'
                }`}
            >
                <div className="max-w-[1430px] mx-auto flex justify-between items-center px-4 md:px-16 h-[80px] w-full">

                    {/* Logo */}
                    <div className="flex items-center">
                        <Link href="/">
                            <Image src="/images/logo.png" alt="NobleInvoice Logo" width={130} height={48} className="h-11 w-auto object-contain" style={{ width: 'auto' }} priority />
                        </Link>
                    </div>

                    {/* Desktop Nav Links */}
                    <div className="hidden lg:flex items-center gap-10 h-full">
                        {navLinks.map((link) => (
                            <Link
                                key={link.label}
                                href={link.href}
                                className="text-sm font-bold uppercase tracking-widest text-near-black/70 hover:text-noble-blue transition-colors"
                            >
                                {link.label}
                            </Link>
                        ))}

                        {/* Solutions Mega Menu */}
                        <div
                            className="relative h-full flex items-center"
                            onMouseEnter={() => setActiveMenu('solutions')}
                            onMouseLeave={() => setActiveMenu(null)}
                        >
                            <button className={`text-sm font-bold uppercase tracking-widest transition-colors flex items-center gap-1 ${activeMenu === 'solutions' ? 'text-noble-blue' : 'text-near-black/70 hover:text-noble-blue'}`}>
                                Solutions <ChevronDown className={`w-3.5 h-3.5 transition-transform ${activeMenu === 'solutions' ? 'rotate-180' : ''}`} />
                            </button>
                            <AnimatePresence>
                                {activeMenu === 'solutions' && (
                                    <motion.div
                                        initial={{ opacity: 0, y: 10 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        exit={{ opacity: 0, y: 10 }}
                                        transition={{ duration: 0.18 }}
                                        className="absolute top-[70px] left-1/2 -translate-x-1/2 w-[800px] bg-white/95 backdrop-blur-2xl rounded-3xl p-8 shadow-[0_50px_100px_rgba(0,0,0,0.1)] border border-near-black/5 grid grid-cols-3 gap-6"
                                    >
                                        {platforms.map((p) => (
                                            <Link href={p.href} key={p.name} className="group cursor-pointer block">
                                                <div className="relative h-40 w-full rounded-2xl overflow-hidden mb-4 shadow-lg bg-gradient-to-br from-slate-100 via-slate-50 to-blue-50">
                                                    <div className="absolute inset-0 flex items-center justify-center">
                                                        <span className="material-symbols-outlined text-6xl text-slate-300 group-hover:text-noble-blue/40 transition-colors duration-500">{p.icon}</span>
                                                    </div>
                                                    <div className="absolute inset-0 bg-gradient-to-t from-black/10 to-transparent" />
                                                    <div className="absolute top-4 left-4 w-10 h-10 rounded-full bg-white flex items-center justify-center text-noble-blue shadow-md">
                                                        <span className="material-symbols-outlined">{p.icon}</span>
                                                    </div>
                                                    <div className="absolute bottom-3 right-3 px-2.5 py-1 bg-white/90 backdrop-blur-sm rounded-full text-[9px] font-black uppercase tracking-widest text-slate-500 border border-slate-200">Coming Soon</div>
                                                </div>
                                                <h4 className="font-bold text-lg text-near-black/60 group-hover:text-noble-blue transition-colors">{p.name}</h4>
                                                <p className="text-xs text-near-black/40 font-medium">{p.desc}</p>
                                            </Link>
                                        ))}
                                    </motion.div>
                                )}
                            </AnimatePresence>
                        </div>

                        {/* Products Mega Menu */}
                        <div
                            className="relative h-full flex items-center"
                            onMouseEnter={() => setActiveMenu('products')}
                            onMouseLeave={() => setActiveMenu(null)}
                        >
                            <button className={`text-sm font-bold uppercase tracking-widest transition-colors flex items-center gap-1 ${activeMenu === 'products' ? 'text-noble-blue' : 'text-near-black/70 hover:text-noble-blue'}`}>
                                Products <ChevronDown className={`w-3.5 h-3.5 transition-transform ${activeMenu === 'products' ? 'rotate-180' : ''}`} />
                            </button>
                            <AnimatePresence>
                                {activeMenu === 'products' && (
                                    <motion.div
                                        initial={{ opacity: 0, y: 10 }}
                                        animate={{ opacity: 1, y: 0 }}
                                        exit={{ opacity: 0, y: 10 }}
                                        transition={{ duration: 0.18 }}
                                        className="absolute top-[70px] left-1/2 -translate-x-1/2 w-[900px] bg-white/95 backdrop-blur-2xl rounded-3xl p-10 shadow-[0_50px_100px_rgba(0,0,0,0.1)] border border-near-black/5"
                                    >
                                        <div className="grid grid-cols-3 gap-x-12 gap-y-10">
                                            {solutions.map((category) => (
                                                <div key={category.category} className="space-y-4">
                                                    <h5 className="text-[10px] font-black text-near-black uppercase tracking-[0.2em] opacity-40">{category.category}</h5>
                                                    <div className="space-y-4">
                                                        {category.items.map((prod) => (
                                                            <Link key={prod.title} href={prod.href} className="flex gap-4 group cursor-pointer">
                                                                <div className="shrink-0 w-9 h-9 rounded-xl bg-noble-blue/10 flex items-center justify-center text-noble-blue group-hover:bg-noble-blue group-hover:text-white transition-all">
                                                                    <span className="material-symbols-outlined text-sm">{prod.icon}</span>
                                                                </div>
                                                                <div>
                                                                    <h4 className="font-bold text-near-black group-hover:text-noble-blue transition-colors text-sm mb-0.5">{prod.title}</h4>
                                                                    <p className="text-[10px] text-near-black/50 leading-normal">{prod.desc}</p>
                                                                </div>
                                                            </Link>
                                                        ))}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </motion.div>
                                )}
                            </AnimatePresence>
                        </div>
                    </div>

                    {/* Desktop CTA Group */}
                    <div className="hidden lg:flex items-center gap-4">
                        <Link
                            className="text-sm font-bold text-near-black/60 hover:text-near-black transition-colors"
                            href={user ? '/dashboard' : '/login'}
                        >
                            {user ? 'Dashboard' : 'Log In'}
                        </Link>

                        {/* Visual separator */}
                        <div className="w-px h-5 bg-near-black/10"></div>

                        <Link
                            href="/register"
                            className="text-white px-7 py-3 rounded-xl font-extrabold text-sm hover:shadow-xl transition-all flex items-center gap-2 scale-100 hover:scale-105 active:scale-95 shadow-lg shadow-noble-blue/30"
                            style={{ backgroundColor: '#166FBB' }}
                        >
                            Start Free Today
                            <span className="material-symbols-outlined text-base" aria-hidden="true">arrow_forward</span>
                        </Link>
                    </div>

                    {/* Mobile Hamburger Button */}
                    <button
                        onClick={() => setMobileOpen(true)}
                        className="lg:hidden flex items-center justify-center w-10 h-10 rounded-xl bg-near-black/5 text-near-black hover:bg-near-black/10 transition-colors"
                        aria-label="Open menu"
                    >
                        <Menu className="w-5 h-5" />
                    </button>
                </div>
            </nav>

            {/* ── Mobile Drawer ── */}
            <AnimatePresence>
                {mobileOpen && (
                    <>
                        {/* Backdrop */}
                        <motion.div
                            initial={{ opacity: 0 }}
                            animate={{ opacity: 1 }}
                            exit={{ opacity: 0 }}
                            transition={{ duration: 0.2 }}
                            className="fixed inset-0 z-[140] bg-near-black/40 backdrop-blur-sm"
                            onClick={() => setMobileOpen(false)}
                        />

                        {/* Drawer Panel */}
                        <motion.div
                            initial={{ x: '100%' }}
                            animate={{ x: 0 }}
                            exit={{ x: '100%' }}
                            transition={{ type: 'spring', damping: 28, stiffness: 280 }}
                            className="fixed top-0 right-0 bottom-0 z-[150] w-[85vw] max-w-sm bg-white shadow-2xl flex flex-col overflow-y-auto"
                        >
                            {/* Drawer Header */}
                            <div className="flex items-center justify-between px-6 py-5 border-b border-near-black/5">
                                <Image src="/images/logo.png" alt="NobleInvoice Logo" width={120} height={40} className="h-9 w-auto object-contain" priority />
                                <button
                                    onClick={() => setMobileOpen(false)}
                                    className="w-9 h-9 flex items-center justify-center rounded-xl bg-near-black/5 text-near-black hover:bg-near-black/10 transition-colors"
                                    aria-label="Close menu"
                                >
                                    <X className="w-5 h-5" />
                                </button>
                            </div>

                            {/* Drawer Nav Links */}
                            <nav className="flex-1 px-6 py-8 space-y-1">
                                {navLinks.map((link) => (
                                    <Link
                                        key={link.label}
                                        href={link.href}
                                        onClick={() => setMobileOpen(false)}
                                        className="flex items-center justify-between px-4 py-3.5 rounded-2xl text-near-black font-bold text-sm hover:bg-noble-blue/5 hover:text-noble-blue transition-colors"
                                    >
                                        {link.label}
                                        <ChevronRight className="w-4 h-4 opacity-30" />
                                    </Link>
                                ))}

                                {/* Mobile Solutions Accordion */}
                                <div>
                                    <button
                                        onClick={() => setMobileSubmenu(mobileSubmenu === 'solutions' ? null : 'solutions')}
                                        className="flex items-center justify-between w-full px-4 py-3.5 rounded-2xl text-near-black font-bold text-sm hover:bg-noble-blue/5 hover:text-noble-blue transition-colors"
                                    >
                                        Solutions
                                        <ChevronDown className={`w-4 h-4 opacity-50 transition-transform ${mobileSubmenu === 'solutions' ? 'rotate-180' : ''}`} />
                                    </button>
                                    <AnimatePresence>
                                        {mobileSubmenu === 'solutions' && (
                                            <motion.div
                                                initial={{ height: 0, opacity: 0 }}
                                                animate={{ height: 'auto', opacity: 1 }}
                                                exit={{ height: 0, opacity: 0 }}
                                                transition={{ duration: 0.2 }}
                                                className="overflow-hidden pl-4 mt-1 space-y-1"
                                            >
                                                {platforms.map((p) => (
                                                    <Link key={p.name} href={p.href} onClick={() => setMobileOpen(false)} className="flex items-center gap-3 px-4 py-3 rounded-xl text-near-black/70 hover:text-noble-blue hover:bg-noble-blue/5 transition-colors">
                                                        <span className="material-symbols-outlined text-sm text-slate-400">{p.icon}</span>
                                                        <div className="flex-1">
                                                            <div className="font-bold text-sm text-near-black">{p.name}</div>
                                                            <div className="text-[10px] text-near-black/50">{p.desc}</div>
                                                        </div>
                                                        <span className="text-[8px] font-black uppercase tracking-widest text-slate-400 bg-slate-100 px-2 py-0.5 rounded-full">Soon</span>
                                                    </Link>
                                                ))}
                                            </motion.div>
                                        )}
                                    </AnimatePresence>
                                </div>

                                {/* Mobile Products Accordion */}
                                <div>
                                    <button
                                        onClick={() => setMobileSubmenu(mobileSubmenu === 'products' ? null : 'products')}
                                        className="flex items-center justify-between w-full px-4 py-3.5 rounded-2xl text-near-black font-bold text-sm hover:bg-noble-blue/5 hover:text-noble-blue transition-colors"
                                    >
                                        Products
                                        <ChevronDown className={`w-4 h-4 opacity-50 transition-transform ${mobileSubmenu === 'products' ? 'rotate-180' : ''}`} />
                                    </button>
                                    <AnimatePresence>
                                        {mobileSubmenu === 'products' && (
                                            <motion.div
                                                initial={{ height: 0, opacity: 0 }}
                                                animate={{ height: 'auto', opacity: 1 }}
                                                exit={{ height: 0, opacity: 0 }}
                                                transition={{ duration: 0.2 }}
                                                className="overflow-hidden pl-4 mt-1 space-y-1"
                                            >
                                                {solutions.flatMap(cat => cat.items).map((prod) => (
                                                    <Link
                                                        key={prod.title}
                                                        href={prod.href}
                                                        onClick={() => setMobileOpen(false)}
                                                        className="flex items-center gap-3 px-4 py-3 rounded-xl text-near-black/70 hover:text-noble-blue hover:bg-noble-blue/5 transition-colors"
                                                    >
                                                        <span className="material-symbols-outlined text-sm text-noble-blue">{prod.icon}</span>
                                                        <div>
                                                            <div className="font-bold text-sm">{prod.title}</div>
                                                            <div className="text-[10px] text-near-black/40">{prod.desc}</div>
                                                        </div>
                                                    </Link>
                                                ))}
                                            </motion.div>
                                        )}
                                    </AnimatePresence>
                                </div>
                            </nav>

                            {/* Drawer Footer CTAs */}
                            <div className="px-6 py-6 border-t border-near-black/5 space-y-3">
                                <Link
                                    href="/register"
                                    onClick={() => setMobileOpen(false)}
                                    className="flex items-center justify-center gap-2 w-full py-4 rounded-2xl text-white font-extrabold text-sm shadow-lg shadow-noble-blue/30 hover:opacity-90 transition-all active:scale-95"
                                    style={{ backgroundColor: '#166FBB' }}
                                >
                                    Start Free Today
                                    <span className="material-symbols-outlined text-base">arrow_forward</span>
                                </Link>
                                <Link
                                    href={user ? '/dashboard' : '/login'}
                                    onClick={() => setMobileOpen(false)}
                                    className="flex items-center justify-center w-full py-4 rounded-2xl text-near-black font-bold text-sm bg-near-black/5 hover:bg-near-black/10 transition-colors"
                                >
                                    {user ? 'Go to Dashboard' : 'Log In'}
                                </Link>
                            </div>
                        </motion.div>
                    </>
                )}
            </AnimatePresence>
        </>
    );
}
