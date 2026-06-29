'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface HeatmapData {
    date: string;
    intensity: number; // 0 to 1
    completedCount: number;
}

interface HeatmapGridProps {
    data: HeatmapData[];
}

export default function HeatmapGrid({ data }: HeatmapGridProps) {
    // Determine cell colors based on intensity
    const getCellColor = (intensity: number) => {
        if (intensity === 0) return 'bg-black/5 ';
        if (intensity < 0.25) return 'bg-[#006970]/20';
        if (intensity < 0.5) return 'bg-[#006970]/40';
        if (intensity < 0.75) return 'bg-[#006970]/60';
        return 'bg-[#006970]';
    };

    return (
        <div className="flex flex-col gap-4">
            <div className="grid grid-cols-10 sm:grid-cols-15 md:grid-cols-30 gap-1.5 auto-rows-fr">
                {data.map((d, i) => (
                    <motion.div
                        key={d.date}
                        initial={{ opacity: 0, scale: 0.5 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: i * 0.01, duration: 0.5 }}
                        className={`aspect-square rounded-sm border border-white/5 ${getCellColor(d.intensity)} group relative cursor-help`}
                    >
                        <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 p-2 bg-slate-900 border border-white/10 rounded-lg text-[8px] font-black uppercase tracking-widest text-white whitespace-nowrap opacity-0 group-hover:opacity-100 transition-all z-20 pointer-events-none shadow-2xl">
                            {d.date}: {d.completedCount} Rituals Synchronized
                        </div>
                    </motion.div>
                ))}
            </div>
            
            <div className="flex items-center gap-2 mt-2">
                <span className="text-[8px] font-black uppercase tracking-widest text-slate-500 mr-2">Discipline Gradient</span>
                <div className="w-3 h-3 rounded-sm bg-black/5 " />
                <div className="w-3 h-3 rounded-sm bg-[#006970]/20" />
                <div className="w-3 h-3 rounded-sm bg-[#006970]/40" />
                <div className="w-3 h-3 rounded-sm bg-[#006970]/60" />
                <div className="w-3 h-3 rounded-sm bg-[#006970]" />
                <span className="text-[8px] font-black uppercase tracking-widest text-slate-500 mx-2">Peak Stability</span>
            </div>
        </div>
    );
}

