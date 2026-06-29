'use client';

import React, { useEffect, useState } from 'react';
import { WifiOff, Loader2 } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { useOfflineSync } from '@/lib/hooks/useOfflineSync';

export default function OfflineIndicator() {
    const { isOnline, queueLength } = useOfflineSync();
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    if (!mounted) return null;

    return (
        <AnimatePresence>
            {!isOnline && (
                <motion.div
                    initial={{ y: -100, opacity: 0 }}
                    animate={{ y: 0, opacity: 1 }}
                    exit={{ y: -100, opacity: 0 }}
                    transition={{ type: 'spring', damping: 20, stiffness: 300 }}
                    className="fixed top-4 left-1/2 -translate-x-1/2 z-[9999] flex items-center gap-3 px-6 py-3 bg-slate-900/90 backdrop-blur-md text-white rounded-full shadow-2xl border border-slate-700/50"
                >
                    <div className="p-2 bg-rose-500/20 rounded-full">
                        <WifiOff className="w-4 h-4 text-rose-400" />
                    </div>
                    <div className="flex flex-col">
                        <span className="text-xs font-black tracking-widest uppercase">Offline Mode Active</span>
                        {queueLength > 0 ? (
                            <span className="text-[10px] text-slate-300 font-medium">
                                {queueLength} change{queueLength !== 1 ? 's' : ''} queued for sync
                            </span>
                        ) : (
                            <span className="text-[10px] text-slate-300 font-medium">
                                Waiting for connection...
                            </span>
                        )}
                    </div>
                </motion.div>
            )}
            {isOnline && queueLength > 0 && (
                <motion.div
                    initial={{ y: -100, opacity: 0 }}
                    animate={{ y: 0, opacity: 1 }}
                    exit={{ y: -100, opacity: 0 }}
                    transition={{ type: 'spring', damping: 20, stiffness: 300 }}
                    className="fixed top-4 left-1/2 -translate-x-1/2 z-[9999] flex items-center gap-3 px-6 py-3 bg-noble-blue/90 backdrop-blur-md text-white rounded-full shadow-2xl border border-noble-blue/50"
                >
                    <Loader2 className="w-4 h-4 animate-spin text-white" />
                    <span className="text-xs font-black tracking-widest uppercase">Syncing Data...</span>
                </motion.div>
            )}
        </AnimatePresence>
    );
}
