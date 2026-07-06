'use client';

import React, { useState, useRef, useEffect } from 'react';
import { AreaChart, Area, XAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';
import { Activity, ChevronDown, Check } from 'lucide-react';

import { Invoice } from '@/types';
import { currencyService } from '@/lib/services/currencyService';

const ranges = [
  { label: 'Last 3 Months', value: '3m', count: 3 },
  { label: 'Last 6 Months', value: '6m', count: 6 },
  { label: 'Last 12 Months', value: '12m', count: 12 },
];

export default function CashFlowChart({ invoices = [], currencyCode = 'USD' }: { invoices?: Invoice[], currencyCode?: string }) {
    const [selectedRange, setSelectedRange] = useState(ranges[1]);
    const [dropdownOpen, setDropdownOpen] = useState(false);
    const dropdownRef = useRef<HTMLDivElement>(null);

    const data = React.useMemo(() => {
        const result = [];
        const now = new Date();
        for (let i = selectedRange.count - 1; i >= 0; i--) {
            const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const monthName = d.toLocaleString('default', { month: 'short' });
            
            // Sum paid invoices for this month
            const monthlyTotal = invoices.filter(inv => {
                if (inv.status !== 'paid') return false;
                const invDate = new Date(inv.issue_date || Date.now());
                return invDate.getMonth() === d.getMonth() && invDate.getFullYear() === d.getFullYear();
            }).reduce((sum, inv) => sum + (inv.total_amount || 0), 0);

            result.push({ name: monthName, value: monthlyTotal });
        }
        return result;
    }, [invoices, selectedRange.count]);

    const hasData = data.some(d => d.value > 0);

    // Close dropdown when clicking outside
    useEffect(() => {
        function handleClickOutside(e: MouseEvent) {
            if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
                setDropdownOpen(false);
            }
        }
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    return (
        <div className="bg-white/80 backdrop-blur-xl border border-white rounded-[32px] p-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)] h-full flex flex-col">
            <div className="flex justify-between items-start mb-8">
                <div>
                    <div className="flex items-center gap-2 mb-1">
                        <h3 className="text-base font-bold text-slate-900">Cash Flow Analysis</h3>
                        <div className="w-6 h-6 rounded bg-cyan-50 flex items-center justify-center">
                            <Activity className="w-3 h-3 text-cyan-500" />
                        </div>
                    </div>
                    <p className="text-sm text-slate-500 font-medium">Income Velocity &amp; Settlement Cycles</p>
                </div>

                {/* Dropdown */}
                <div className="relative" ref={dropdownRef}>
                    <button
                        onClick={() => setDropdownOpen(prev => !prev)}
                        className="px-4 py-2 rounded-xl border border-slate-200 bg-white shadow-sm flex items-center gap-2 hover:border-noble-blue/40 hover:bg-blue-50/30 transition-all"
                    >
                        <span className="text-sm font-medium text-slate-700">{selectedRange.label}</span>
                        <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform duration-200 ${dropdownOpen ? 'rotate-180' : ''}`} />
                    </button>

                    {dropdownOpen && (
                        <div className="absolute right-0 mt-2 w-44 bg-white rounded-xl border border-slate-200 shadow-[0_8px_30px_rgb(0,0,0,0.08)] z-50 overflow-hidden">
                            {ranges.map(range => (
                                <button
                                    key={range.value}
                                    onClick={() => {
                                        setSelectedRange(range);
                                        setDropdownOpen(false);
                                    }}
                                    className="w-full flex items-center justify-between px-4 py-3 text-sm text-slate-700 hover:bg-blue-50/50 hover:text-noble-blue transition-colors"
                                >
                                    <span className={selectedRange.value === range.value ? 'font-semibold text-noble-blue' : 'font-medium'}>{range.label}</span>
                                    {selectedRange.value === range.value && <Check className="w-3.5 h-3.5 text-noble-blue" />}
                                </button>
                            ))}
                        </div>
                    )}
                </div>
            </div>

            <div className="flex-1 w-full h-[250px] relative -ml-4 mt-4">
                {!hasData ? (
                    <div className="absolute inset-0 flex flex-col items-center justify-center text-center ml-4">
                        <Activity className="w-8 h-8 text-slate-300 mb-3" />
                        <h4 className="text-slate-600 font-bold mb-1">Not enough data yet</h4>
                        <p className="text-sm text-slate-400 max-w-[200px]">Create and mark invoices as paid to see your cash flow.</p>
                    </div>
                ) : (
                    <ResponsiveContainer width="100%" height="100%">
                        <AreaChart data={data} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                            <defs>
                                <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="5%" stopColor="#166FBB" stopOpacity={0.4}/>
                                    <stop offset="95%" stopColor="#166FBB" stopOpacity={0}/>
                                </linearGradient>
                            </defs>
                            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                            <XAxis
                                dataKey="name"
                                axisLine={false}
                                tickLine={false}
                                tick={{ fontSize: 11, fill: '#64748b', fontWeight: 500 }}
                                dy={10}
                            />
                            <Tooltip
                                formatter={(value: any) => [currencyService.format(Number(value), currencyCode, { decimals: 0 }), 'Revenue']}
                                contentStyle={{ borderRadius: '12px', border: '1px solid #e2e8f0', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)' }}
                                itemStyle={{ color: '#166FBB', fontWeight: 600 }}
                                labelStyle={{ color: '#64748b', fontWeight: 500, fontSize: '11px', marginBottom: '4px' }}
                                cursor={{ stroke: '#cbd5e1', strokeWidth: 1, strokeDasharray: '4 4' }}
                            />
                            <Area
                                type="monotone"
                                dataKey="value"
                                stroke="#166FBB"
                                strokeWidth={3}
                                fillOpacity={1}
                                fill="url(#colorValue)"
                            />
                        </AreaChart>
                    </ResponsiveContainer>
                )}
            </div>
        </div>
    );
}
