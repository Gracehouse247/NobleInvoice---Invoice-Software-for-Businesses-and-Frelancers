'use client';

import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Trophy, Medal, Crown } from 'lucide-react';
import { gamificationService } from '@/lib/services/gamificationService';

export default function Leaderboard() {
    const [players, setPlayers] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const unsub = gamificationService.subscribeToLeaderboard((data: any[]) => {
            setPlayers(data);
            setLoading(false);
        });
        return () => unsub();
    }, []);

    if (loading) return <div className="animate-pulse space-y-4">
        {[1, 2, 3].map(i => <div key={i} className="h-16 bg-black/5  rounded-2xl" />)}
    </div>;

    return (
        <div className="space-y-4">
            <div className="flex items-center justify-between mb-6">
                <h3 className="text-lg font-extrabold text-foreground  font-manrope uppercase tracking-wider flex items-center gap-2">
                    <Trophy className="w-5 h-5 text-[#F4B400]" />
                    Elite Rankings
                </h3>
            </div>

            <div className="space-y-3">
                {players.map((player, index) => (
                    <motion.div
                        key={player.id}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: index * 0.05 }}
                        className={`flex items-center justify-between p-4 rounded-[24px] ${
                            index === 0 ? 'bg-gradient-to-r from-[#F4B400]/20 to-transparent border border-[#F4B400]/30' : 
                            index === 1 ? 'bg-gradient-to-r from-slate-400/10 to-transparent border border-slate-400/20' :
                            index === 2 ? 'bg-gradient-to-r from-amber-700/10 to-transparent border border-amber-700/20' :
                            'bg-black/5  border border-black/5 '
                        }`}
                    >
                        <div className="flex items-center gap-4">
                            <div className="w-8 flex justify-center">
                                {index === 0 ? <Crown className="w-6 h-6 text-[#F4B400]" /> : 
                                 index === 1 ? <Medal className="w-5 h-5 text-slate-700 " /> :
                                 index === 2 ? <Medal className="w-5 h-5 text-amber-600" /> :
                                 <span className="text-sm font-extrabold text-slate-500">#{index + 1}</span>}
                            </div>
                            <div className="h-10 w-10 rounded-full bg-[#1E2A78]/20 flex items-center justify-center font-bold text-xs text-foreground  uppercase border border-black/10 ">
                                {player.name?.substring(0, 2) || 'NM'}
                            </div>
                            <div>
                                <p className="text-sm font-extrabold text-foreground  font-manrope">{player.name || 'Anonymous'}</p>
                                <p className="text-[10px] font-extrabold text-slate-500 uppercase tracking-widest">Level {player.level || 1}</p>
                            </div>
                        </div>
                        <div className="text-right">
                            <p className="text-sm font-extrabold text-[#F4B400] font-manrope">{player.xp?.toLocaleString() || 0}</p>
                            <p className="text-[10px] font-extrabold text-slate-500 uppercase tracking-widest">XP</p>
                        </div>
                    </motion.div>
                ))}
            </div>
        </div>
    );
}

