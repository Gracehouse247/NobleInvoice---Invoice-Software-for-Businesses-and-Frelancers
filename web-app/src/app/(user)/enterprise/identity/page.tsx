'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
    Users, Building2, ShieldCheck, 
    ArrowUpRight, Download, Filter, 
    Search, Plus, MoreHorizontal,
    Zap, CreditCard, LayoutGrid
} from 'lucide-react';
import { getTemplatesByType } from '@/lib/templates/templateRegistry';

export default function EnterpriseIdentityPage() {
    const [searchTerm, setSearchTerm] = useState('');

    const employees = [
        { id: 1, name: 'Sarah Chen', role: 'VP Engineering', status: 'Active', leads: 42, lastScan: '2h ago', template: 'Obsidian Glass' },
        { id: 2, name: 'Marcus Thorne', role: 'Head of Sales', status: 'Active', leads: 156, lastScan: '15m ago', template: 'Cyber Pulse' },
        { id: 3, name: 'Elena Rodriguez', role: 'Senior Architect', status: 'Pending', leads: 0, lastScan: '-', template: 'Arctic Minimal' },
        { id: 4, name: 'David Kim', role: 'Solutions Consultant', status: 'Active', leads: 89, lastScan: '1h ago', template: 'Obsidian Glass' },
    ];

    const stats = [
        { label: 'Total Members', value: '1,284', trend: '+12', icon: Users, color: 'text-noble-blue' },
        { label: 'Identity Velocity', value: '8.4k', trend: '+24%', icon: Zap, color: 'text-amber-500' },
        { label: 'Lead Intelligence', value: '12,402', trend: '+856', icon: ShieldCheck, color: 'text-emerald-500' },
    ];

    return (
        <div className="min-h-screen bg-[#F0F4F8] selection:bg-noble-blue/20 relative overflow-hidden pb-24 font-inter">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Enterprise Header */}
            <div className="bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-10 relative z-10 shadow-[0_20px_40px_rgba(0,0,0,0.01)]">
                <div className="max-w-7xl mx-auto space-y-8">
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
                        <div className="space-y-1">
                            <div className="flex items-center gap-2 text-[10px] font-black text-noble-blue uppercase tracking-[0.2em]">
                                <Building2 size={12} />
                                Enterprise Management
                            </div>
                            <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                Organization <span className="text-noble-blue">Identity Hub</span>
                            </h1>
                            <p className="text-slate-500 text-[10px] font-bold uppercase tracking-wider">Configure organization branding presets and manage corporate assets.</p>
                        </div>
                        
                        <div className="flex items-center gap-3">
                            <button className="px-6 py-4 bg-white/60 border border-white/60 rounded-2xl text-[10px] font-black uppercase tracking-[0.15em] hover:bg-white hover:text-noble-blue hover:shadow-sm transition-all flex items-center gap-2 active:scale-95">
                                <Download size={14} className="text-slate-500" />
                                Export Analytics
                            </button>
                            <button className="px-8 py-4 bg-noble-blue text-white rounded-2xl text-[10px] font-black uppercase tracking-[0.2em] hover:bg-blue-600 transition-all shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 flex items-center gap-2">
                                <Plus size={14} />
                                Provision Members
                            </button>
                        </div>
                    </div>

                    {/* Stats Grid */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {stats.map((stat, i) => (
                            <div key={i} className="p-8 rounded-[2.5rem] bg-white/40 backdrop-blur-2xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] flex flex-col justify-between hover:scale-[1.02] transition-all group">
                                <div className="flex items-center justify-between">
                                    <div className="p-3 rounded-2xl bg-white/60 border border-white/60 text-slate-400 group-hover:text-noble-blue transition-colors shadow-sm">
                                        <stat.icon size={20} className="text-noble-blue" />
                                    </div>
                                    <span className="text-[9px] font-black text-emerald-700 bg-emerald-50 border border-emerald-100 px-2.5 py-1 rounded-lg uppercase tracking-wider">{stat.trend}</span>
                                </div>
                                <div className="mt-6">
                                    <p className="text-3xl font-black text-slate-900 tracking-tighter">{stat.value}</p>
                                    <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest mt-1">{stat.label}</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-8 mt-12 space-y-8 relative z-10">
                {/* Search & Filters */}
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div className="relative flex-1 max-w-md">
                        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                        <input 
                            type="text"
                            placeholder="Search by name, role, or department..."
                            className="w-full bg-white/60 border border-white/60 text-slate-800 text-xs font-semibold rounded-2xl pl-12 pr-4 py-4 focus:outline-none focus:border-noble-blue transition-all"
                            value={searchTerm}
                            onChange={e => setSearchTerm(e.target.value)}
                        />
                    </div>
                    <div className="flex items-center gap-3">
                        <button className="p-4 rounded-2xl bg-white/60 border border-white/60 text-slate-500 hover:text-noble-blue transition-all shadow-sm active:scale-95">
                            <Filter size={18} />
                        </button>
                        <button className="p-4 rounded-2xl bg-white/60 border border-white/60 text-slate-500 hover:text-noble-blue transition-all shadow-sm active:scale-95">
                            <LayoutGrid size={18} />
                        </button>
                    </div>
                </div>

                {/* Member Table */}
                <div className="bg-white/40 backdrop-blur-2xl border border-white/60 rounded-[3.5rem] overflow-hidden shadow-[0_30px_60px_rgba(0,0,0,0.02)]">
                    <table className="w-full text-left">
                        <thead>
                            <tr className="bg-white/40 border-b border-white/60">
                                <th className="px-8 py-6 text-[9px] font-black uppercase text-slate-500 tracking-[0.2em]">Member Node</th>
                                <th className="px-8 py-6 text-[9px] font-black uppercase text-slate-500 tracking-[0.2em]">Role / Dept</th>
                                <th className="px-8 py-6 text-[9px] font-black uppercase text-slate-500 tracking-[0.2em]">Status</th>
                                <th className="px-8 py-6 text-[9px] font-black uppercase text-slate-500 tracking-[0.2em]">Performance</th>
                                <th className="px-8 py-6 text-[9px] font-black uppercase text-slate-500 tracking-[0.2em] text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-white/40">
                            {employees.map(emp => (
                                <tr key={emp.id} className="group hover:bg-white/40 transition-colors">
                                    <td className="px-8 py-6">
                                        <div className="flex items-center gap-4">
                                            <div className="w-12 h-12 rounded-2xl bg-white/60 border border-white/60 flex items-center justify-center text-xs font-black text-slate-500 group-hover:bg-noble-blue group-hover:text-white transition-all shadow-sm">
                                                {emp.name.split(' ').map(n => n[0]).join('')}
                                            </div>
                                            <div>
                                                <p className="text-sm font-black text-slate-900 tracking-tight">{emp.name}</p>
                                                <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest mt-1">{emp.template}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-8 py-6">
                                        <p className="text-[9px] font-black text-slate-600 uppercase tracking-widest">{emp.role}</p>
                                    </td>
                                    <td className="px-8 py-6">
                                        <div className="flex items-center gap-2">
                                            <div className={`w-1.5 h-1.5 rounded-full ${emp.status === 'Active' ? 'bg-emerald-500 animate-pulse' : 'bg-slate-300'}`} />
                                            <span className="text-[9px] font-black uppercase tracking-wider text-slate-800">{emp.status}</span>
                                        </div>
                                    </td>
                                    <td className="px-8 py-6">
                                        <div className="flex items-center gap-4">
                                            <div>
                                                <p className="text-sm font-black text-slate-950">{emp.leads}</p>
                                                <p className="text-[8px] font-black text-slate-400 uppercase tracking-[0.2em] mt-0.5">Captured Leads</p>
                                            </div>
                                            <div className="h-8 w-px bg-white/60" />
                                            <div>
                                                <p className="text-sm font-black text-slate-950">{emp.lastScan}</p>
                                                <p className="text-[8px] font-black text-slate-400 uppercase tracking-[0.2em] mt-0.5">Velocity</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-8 py-6 text-right">
                                        <button className="p-2 rounded-xl text-slate-400 hover:text-noble-blue transition-colors">
                                            <MoreHorizontal size={20} />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    
                    {/* Empty State / Footer */}
                    <div className="p-8 border-t border-white/60 bg-white/20 flex items-center justify-between">
                        <p className="text-[9px] font-black text-slate-400 uppercase tracking-wider">Showing {employees.length} of 1,284 Members</p>
                        <div className="flex gap-2">
                            <button className="px-5 py-2.5 rounded-xl bg-white/60 border border-white/60 text-[9px] font-black uppercase tracking-widest disabled:opacity-50 hover:bg-white transition-colors active:scale-95 shadow-sm">Prev</button>
                            <button className="px-5 py-2.5 rounded-xl bg-white/60 border border-white/60 text-[9px] font-black uppercase tracking-widest hover:bg-white transition-colors active:scale-95 shadow-sm">Next</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
