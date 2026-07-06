'use client';

import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { Cookie } from 'lucide-react';

export default function CookieConsent() {
    const [mounted, setMounted] = useState(false);
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        setMounted(true);
        const consent = localStorage.getItem('noble_cookie_consent');
        if (!consent) {
            setIsVisible(true);
        }
    }, []);

    const handleConsent = (status: 'accepted' | 'declined') => {
        localStorage.setItem('noble_cookie_consent', status);
        if (status === 'accepted') {
            document.cookie = "noble_consent=1; max-age=31536000; path=/";
        }
        setIsVisible(false);
    };

    if (!mounted) return null;

    return (
        <AnimatePresence>
            {isVisible && (
                <motion.div
                    initial={{ x: -40, opacity: 0 }}
                    animate={{ x: 0, opacity: 1 }}
                    exit={{ x: -40, opacity: 0 }}
                    transition={{ type: 'spring', damping: 28, stiffness: 220 }}
                    className="fixed bottom-5 left-5 z-[100] pointer-events-auto max-w-[300px] w-full"
                >
                    <div className="bg-white/95 backdrop-blur-xl border border-slate-200/80 rounded-2xl shadow-2xl shadow-black/10 overflow-hidden">
                        {/* Top accent bar */}
                        <div className="h-0.5 w-full bg-gradient-to-r from-noble-blue via-blue-400 to-cyan-400" />

                        <div className="p-4">
                            {/* Icon + Title */}
                            <div className="flex items-center gap-2 mb-2">
                                <div className="w-7 h-7 rounded-lg bg-noble-blue/10 flex items-center justify-center shrink-0">
                                    <Cookie className="w-3.5 h-3.5 text-noble-blue" />
                                </div>
                                <h3 className="font-bold text-slate-900 text-sm tracking-tight">
                                    Your Privacy Matters
                                </h3>
                            </div>

                            {/* Body */}
                            <p className="text-slate-500 text-[11px] leading-relaxed mb-4">
                                We use essential cookies to keep our platform secure and running smoothly. Optional cookies help us improve performance and personalize your experience. Manage your preferences anytime in our{' '}
                                <Link
                                    href="/privacy"
                                    className="text-noble-blue font-semibold hover:underline underline-offset-2"
                                >
                                    Privacy Policy
                                </Link>
                                .
                            </p>

                            {/* Buttons */}
                            <div className="flex items-center gap-2">
                                <button
                                    onClick={() => handleConsent('declined')}
                                    className="flex-1 py-1.5 text-[11px] font-semibold text-slate-500 bg-slate-100 hover:bg-slate-200 rounded-lg transition-colors"
                                >
                                    Decline
                                </button>
                                <button
                                    onClick={() => handleConsent('accepted')}
                                    className="flex-1 py-1.5 text-[11px] font-bold text-white bg-noble-blue hover:bg-blue-700 rounded-lg transition-all shadow-md shadow-noble-blue/25 hover:shadow-noble-blue/40"
                                >
                                    Accept All
                                </button>
                            </div>
                        </div>
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    );
}
