'use client';

import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { ShieldCheck, X } from 'lucide-react';

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
                    initial={{ y: 100, opacity: 0 }}
                    animate={{ y: 0, opacity: 1 }}
                    exit={{ y: 100, opacity: 0 }}
                    transition={{ type: "spring", damping: 25, stiffness: 200 }}
                    className="fixed bottom-0 left-0 right-0 z-[100] p-4 md:p-6 pointer-events-none"
                >
                    <div className="max-w-4xl mx-auto bg-white/90 backdrop-blur-xl border border-noble-blue/20 rounded-2xl shadow-2xl p-5 md:p-6 pointer-events-auto flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
                        <div className="flex items-start gap-4">
                            <div className="p-3 bg-noble-blue/10 rounded-xl hidden sm:block shrink-0">
                                <ShieldCheck className="w-6 h-6 text-noble-blue" />
                            </div>
                            <div>
                                <h3 className="font-bold text-slate-900 text-sm md:text-base mb-1">We respect your privacy</h3>
                                <p className="text-slate-600 text-xs md:text-sm max-w-2xl leading-relaxed">
                                    We use essential cookies to make our site work. With your consent, we may also use non-essential cookies to improve user experience, personalize content, and analyze website traffic. For these reasons, we may share your site usage data with our analytics partners. By clicking "Accept All", you agree to our website's cookie use as described in our <Link href="/privacy" className="text-noble-blue hover:underline font-semibold">Privacy Policy</Link>.
                                </p>
                            </div>
                        </div>
                        
                        <div className="flex items-center gap-3 w-full md:w-auto shrink-0 justify-end mt-2 md:mt-0">
                            <button
                                onClick={() => handleConsent('declined')}
                                className="px-5 py-2.5 text-xs font-bold text-slate-600 bg-slate-100 hover:bg-slate-200 rounded-xl transition-colors whitespace-nowrap"
                            >
                                Decline Optional
                            </button>
                            <button
                                onClick={() => handleConsent('accepted')}
                                className="px-6 py-2.5 text-xs font-bold text-white bg-noble-blue hover:bg-blue-700 rounded-xl transition-colors shadow-lg shadow-noble-blue/20 whitespace-nowrap"
                            >
                                Accept All
                            </button>
                            <button 
                                onClick={() => setIsVisible(false)}
                                className="p-2.5 text-slate-400 hover:bg-slate-100 rounded-xl ml-2 md:hidden transition-colors"
                            >
                                <X className="w-4 h-4" />
                            </button>
                        </div>
                    </div>
                </motion.div>
            )}
        </AnimatePresence>
    );
}
