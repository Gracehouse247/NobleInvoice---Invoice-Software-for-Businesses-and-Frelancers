'use client';

import React, { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { clientService } from '@/lib/services/supabaseService';
import { Shield, Loader2 } from 'lucide-react';
import { motion } from 'framer-motion';

export default function ClientLayout({ children }: { children: React.ReactNode }) {
    const params = useParams();
    const router = useRouter();
    const token = params?.token as string;
    
    const [loading, setLoading] = useState(true);
    const [valid, setValid] = useState(false);
    const [clientName, setClientName] = useState('');

    useEffect(() => {
        if (!token) {
            setLoading(false);
            return;
        }

        const verifyToken = async () => {
            try {
                const data = await clientService.getPortalData(token);
                if (data && data.client) {
                    setClientName(data.client.name || data.client.company);
                    setValid(true);
                } else {
                    setValid(false);
                }
            } catch (err) {
                console.error("Portal access error:", err);
                setValid(false);
            } finally {
                setLoading(false);
            }
        };

        verifyToken();
    }, [token]);

    if (loading) {
        return (
            <div className="min-h-screen bg-[#F0F4F8] flex items-center justify-center font-inter relative overflow-hidden">
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-noble-blue/10 blur-[100px] rounded-full" />
                <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} className="flex flex-col items-center gap-4 relative z-10">
                    <Loader2 className="w-12 h-12 text-noble-blue animate-spin" />
                    <h2 className="text-xl font-black tracking-tight text-slate-800">Unlocking Portal Vault...</h2>
                </motion.div>
            </div>
        );
    }

    if (!valid) {
        return (
            <div className="min-h-screen bg-[#F0F4F8] flex items-center justify-center font-inter relative overflow-hidden">
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-red-500/10 blur-[100px] rounded-full" />
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-white/60 backdrop-blur-2xl p-12 rounded-[40px] border border-white/60 shadow-2xl text-center max-w-md relative z-10">
                    <div className="w-20 h-20 bg-red-50 text-red-500 rounded-[24px] flex items-center justify-center mx-auto mb-6">
                        <Shield className="w-10 h-10" />
                    </div>
                    <h2 className="text-3xl font-black text-slate-900 tracking-tight mb-2">Access Denied</h2>
                    <p className="text-slate-500 font-medium">This secure portal link is invalid or has expired. Please request a new link from your provider.</p>
                </motion.div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 font-inter selection:bg-noble-blue/20">
            {/* Ambient Lighting */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/5 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Portal Header */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-5 shadow-sm">
                <div className="max-w-6xl mx-auto flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-2xl bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center border border-white/50 shadow-inner">
                            <Shield className="w-5 h-5 text-noble-blue" />
                        </div>
                        <div>
                            <div className="text-[10px] text-slate-400 font-black uppercase tracking-[0.2em] mb-0.5">Secure Client Portal</div>
                            <div className="font-bold text-slate-800 text-sm">{clientName}</div>
                        </div>
                    </div>
                    <div className="text-xs font-bold text-slate-400 px-4 py-2 bg-white/60 border border-white/50 rounded-xl shadow-inner">
                        End-to-End Encrypted
                    </div>
                </div>
            </header>

            <main className="relative z-10">
                {children}
            </main>
        </div>
    );
}
