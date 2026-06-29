'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface PulseData {
    day: string;
    minutes: number;
}

interface PulseLineChartProps {
    data: PulseData[];
    width?: number;
    height?: number;
}

export default function PulseLineChart({ 
    data, 
    width = 600, 
    height = 200 
}: PulseLineChartProps) {
    const padding = 40;
    const chartW = width - padding * 2;
    const chartH = height - padding * 2;

    const maxMins = Math.max(...data.map(d => d.minutes), 60); // Min 60 for scale
    const xStep = chartW / (data.length - 1);

    const getPoint = (val: number, i: number) => {
        const x = padding + i * xStep;
        const y = height - (padding + (val / maxMins) * chartH);
        return { x, y };
    };

    // Build the cubic bezier path
    const buildPath = () => {
        if (data.length < 2) return '';
        let d = `M ${getPoint(data[0].minutes, 0).x},${getPoint(data[0].minutes, 0).y}`;
        
        for (let i = 0; i < data.length - 1; i++) {
            const p0 = getPoint(data[i].minutes, i);
            const p1 = getPoint(data[i+1].minutes, i+1);
            const cp1x = p0.x + (p1.x - p0.x) / 2;
            d += ` C ${cp1x},${p0.y} ${cp1x},${p1.y} ${p1.x},${p1.y}`;
        }
        return d;
    };

    const points = data.map((d, i) => getPoint(d.minutes, i));
    const mainPath = buildPath();
    const areaPath = `${mainPath} L ${points[points.length-1].x},${height-padding} L ${points[0].x},${height-padding} Z`;

    return (
        <div className="relative w-full overflow-hidden">
            <svg width="100%" height={height} viewBox={`0 0 ${width} ${height}`} className="overflow-visible">
                <defs>
                    <linearGradient id="pulseGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                        <stop offset="0%" stopColor="#1E2A78" stopOpacity="0.2" />
                        <stop offset="100%" stopColor="#1E2A78" stopOpacity="0" />
                    </linearGradient>
                </defs>

                {/* ── Grid Lines ── */}
                {[0, 0.25, 0.5, 0.75, 1].map((p, i) => (
                    <line 
                        key={`grid-${i}`}
                        x1={padding} y1={height - padding - p * chartH}
                        x2={width - padding} y2={height - padding - p * chartH}
                        stroke="currentColor"
                        strokeWidth="1"
                        strokeDasharray="4 4"
                        className="text-black/[0.03] "
                    />
                ))}

                {/* ── Area and Stroke ── */}
                <motion.path
                    initial={{ pathLength: 0, opacity: 0 }}
                    animate={{ pathLength: 1, opacity: 1 }}
                    transition={{ duration: 2, ease: "easeInOut" }}
                    d={areaPath}
                    fill="url(#pulseGradient)"
                />
                <motion.path
                    initial={{ pathLength: 0, opacity: 0 }}
                    animate={{ pathLength: 1, opacity: 1 }}
                    transition={{ duration: 2, ease: "easeInOut" }}
                    d={mainPath}
                    fill="none"
                    stroke="#1E2A78"
                    strokeWidth="3"
                    className=""
                />

                {/* ── Data Points ── */}
                {points.map((p, i) => (
                    <motion.circle
                        key={`point-${i}`}
                        initial={{ r: 0 }}
                        animate={{ r: 5 }}
                        transition={{ delay: 1 + i * 0.1 }}
                        cx={p.x} cy={p.y}
                        fill="#1E2A78"
                        stroke="white"
                        strokeWidth="2"
                        className=" #0F172A] shadow-xl cursor-help"
                    />
                ))}

                {/* ── Labels ── */}
                {data.map((d, i) => (
                    <text
                        key={`label-${i}`}
                        x={padding + i * xStep}
                        y={height - padding + 24}
                        textAnchor="middle"
                        className="text-[10px] font-black uppercase tracking-widest fill-slate-500 font-sans"
                    >
                        {d.day}
                    </text>
                ))}
            </svg>
        </div>
    );
}

