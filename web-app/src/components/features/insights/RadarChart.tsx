'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface RadarData {
    name: string;
    value: number; // 0 to 100
    color: string;
}

interface RadarChartProps {
    data: RadarData[];
    size?: number;
    className?: string;
}

export default function RadarChart({ data, size = 300, className = '' }: RadarChartProps) {
    const center = size / 2;
    const radius = size * 0.4;
    const angleStep = (Math.PI * 2) / data.length;

    // Calculate point coordinates
    const getPoint = (value: number, index: number) => {
        const r = (value / 100) * radius;
        const angle = index * angleStep - Math.PI / 2;
        return {
            x: center + r * Math.cos(angle),
            y: center + r * Math.sin(angle)
        };
    };

    // Build the main polygon path
    const polygonPath = data.map((d, i) => {
        const { x, y } = getPoint(d.value, i);
        return i === 0 ? `M ${x},${y}` : `L ${x},${y}`;
    }).join(' ') + ' Z';

    return (
        <div className={`relative flex items-center justify-center ${className}`}>
            <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="overflow-visible">
                {/* ── Background Grid (Pentagon rings) ── */}
                {[0.2, 0.4, 0.6, 0.8, 1].map((rScale, ringIdx) => {
                    const ringPath = data.map((_, i) => {
                        const { x, y } = getPoint(100 * rScale, i);
                        return i === 0 ? `M ${x},${y}` : `L ${x},${y}`;
                    }).join(' ') + ' Z';
                    return (
                        <path
                            key={`ring-${ringIdx}`}
                            d={ringPath}
                            fill="none"
                            stroke="currentColor"
                            strokeWidth="1"
                            className="text-black/5 "
                        />
                    );
                })}

                {/* ── Axis Lines ── */}
                {data.map((_, i) => {
                    const { x, y } = getPoint(100, i);
                    return (
                        <line
                            key={`axis-${i}`}
                            x1={center} y1={center}
                            x2={x} y2={y}
                            stroke="currentColor"
                            strokeWidth="1"
                            className="text-black/5 "
                        />
                    );
                })}

                {/* ── Data Polygon ── */}
                <motion.path
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ duration: 1.5, ease: "easeOut" }}
                    d={polygonPath}
                    fill="url(#radarGradient)"
                    stroke="#1E2A78"
                    strokeWidth="2"
                    className=""
                />

                {/* ── Vertices ── */}
                {data.map((d, i) => {
                    const { x, y } = getPoint(d.value, i);
                    return (
                        <motion.circle
                            key={`vertex-${i}`}
                            initial={{ r: 0 }}
                            animate={{ r: 4 }}
                            transition={{ delay: 0.5 + i * 0.1 }}
                            cx={x} cy={y}
                            fill="#1E2A78"
                            className=" shadow-lg"
                        />
                    );
                })}

                {/* ── Labels ── */}
                {data.map((d, i) => {
                    const { x, y } = getPoint(115, i); // Place labels further out
                    return (
                        <text
                            key={`label-${i}`}
                            x={x} y={y}
                            textAnchor="middle"
                            dominantBaseline="middle"
                            className="text-[10px] font-black uppercase tracking-widest fill-slate-500"
                        >
                            {d.name}
                        </text>
                    );
                })}

                <defs>
                    <linearGradient id="radarGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stopColor="#1E2A78" stopOpacity="0.4" />
                        <stop offset="100%" stopColor="#3B82F6" stopOpacity="0.2" />
                    </linearGradient>
                </defs>
            </svg>
        </div>
    );
}

