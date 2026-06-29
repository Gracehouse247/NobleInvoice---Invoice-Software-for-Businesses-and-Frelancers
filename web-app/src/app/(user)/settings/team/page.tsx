'use client';

import React from 'react';
import { Users, Plus, Shield, ShieldAlert, Mail, MoreHorizontal } from 'lucide-react';

export default function TeamSettingsPage() {
    return (
        <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
            {/* Header Area */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-6 pb-6 border-b border-white/40">
                <div>
                    <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                        Team & <span className="text-noble-blue">Roles</span>
                    </h1>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Manage your team members and control their access levels.</p>
                </div>
                <div>
                    <button className="flex items-center gap-3 px-8 py-4 bg-noble-blue text-white font-black text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-blue-600 transition-all shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 whitespace-nowrap">
                        <Plus className="w-4 h-4" />
                        Invite Member
                    </button>
                </div>
            </div>

            <div className="space-y-8">
                {/* Active Members */}
                <div className="bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm overflow-hidden">
                    <div className="p-6 border-b border-white/40 flex items-center gap-3 bg-white/20">
                        <Users className="w-5 h-5 text-noble-blue" />
                        <h3 className="text-xs font-medium text-slate-700" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Active Members</h3>
                    </div>
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-white/40 bg-white/30">
                                    <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest">User</th>
                                    <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest">Role</th>
                                    <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest">Status</th>
                                    <th className="px-6 py-4 text-[10px] font-black text-slate-500 uppercase tracking-widest text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {/* Owner Row */}
                                <tr className="border-b border-white/40 hover:bg-white/30 transition-colors">
                                    <td className="px-6 py-4">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-full bg-noble-blue/10 border border-noble-blue/20 text-noble-blue flex items-center justify-center font-black text-xs shadow-inner">
                                                ME
                                            </div>
                                            <div>
                                                <p className="text-xs font-black text-slate-800 uppercase tracking-wider">My Account</p>
                                                <p className="text-xs text-slate-400 font-bold">owner@nobleinvoice.com</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-wider bg-noble-blue/10 border border-noble-blue/20 text-noble-blue shadow-sm">
                                            <ShieldAlert className="w-3.5 h-3.5" />
                                            Owner
                                        </span>
                                    </td>
                                    <td className="px-6 py-4">
                                        <span className="inline-flex items-center gap-1.5 text-[10px] font-black uppercase tracking-wider text-emerald-600 bg-emerald-50 border border-emerald-100 px-2.5 py-1 rounded-xl">
                                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                                            Active
                                        </span>
                                    </td>
                                    <td className="px-6 py-4 text-right text-xs text-slate-400 font-bold uppercase tracking-wider">
                                        —
                                    </td>
                                </tr>

                                {/* Example Staff Row */}
                                <tr className="border-b border-white/40 hover:bg-white/30 transition-colors">
                                    <td className="px-6 py-4">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-full bg-white/60 border border-white/80 text-slate-600 flex items-center justify-center font-black text-xs shadow-sm">
                                                JD
                                            </div>
                                            <div>
                                                <p className="text-xs font-black text-slate-800 uppercase tracking-wider">Jane Doe</p>
                                                <p className="text-xs text-slate-400 font-bold">jane@nobleinvoice.com</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-wider bg-white/60 border border-white/85 text-slate-500 shadow-sm">
                                            <Shield className="w-3.5 h-3.5" />
                                            Staff
                                        </span>
                                    </td>
                                    <td className="px-6 py-4">
                                        <span className="inline-flex items-center gap-1.5 text-[10px] font-black uppercase tracking-wider text-emerald-600 bg-emerald-50 border border-emerald-100 px-2.5 py-1 rounded-xl">
                                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                                            Active
                                        </span>
                                    </td>
                                    <td className="px-6 py-4 text-right">
                                        <button className="p-2 hover:bg-white/60 border border-transparent hover:border-white/60 rounded-xl text-slate-400 hover:text-slate-700 transition-all shadow-sm">
                                            <MoreHorizontal className="w-4 h-4" />
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Pending Invites */}
                <div className="bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm overflow-hidden">
                    <div className="p-6 border-b border-white/40 flex items-center gap-3 bg-white/20">
                        <Mail className="w-5 h-5 text-noble-blue" />
                        <h3 className="text-xs font-medium text-slate-700" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Pending Invitations</h3>
                    </div>
                    <div className="p-12 flex flex-col items-center justify-center text-center">
                        <div className="w-16 h-16 bg-white/40 rounded-2xl flex items-center justify-center border border-white/60 mb-4 shadow-inner">
                            <Mail className="w-6 h-6 text-slate-400" />
                        </div>
                        <h3 className="text-base font-black text-slate-800 uppercase tracking-wider" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>No pending invites</h3>
                        <p className="text-xs text-slate-400 font-bold uppercase tracking-wider mt-1 max-w-sm mx-auto leading-relaxed">
                            When you invite a new team member, their pending status will appear here until they accept.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    );
}
