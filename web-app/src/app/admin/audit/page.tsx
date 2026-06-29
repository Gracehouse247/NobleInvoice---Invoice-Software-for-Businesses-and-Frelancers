'use client';

import React, { useState, useEffect, useCallback } from 'react';
import { Search, Calendar, Activity, Shield, FileText, User, ChevronLeft, ChevronRight, Loader2, Key } from 'lucide-react';
import { AdminCard } from '@/components/shared/AdminCard';
import { supabase } from '@/lib/supabase';

interface AuditLog {
    id: string;
    action: string;
    actor: string;
    resource: string | null;
    ip: string | null;
    status: 'success' | 'failure';
    type: 'security' | 'content' | 'user' | 'system';
    created_at: string;
}

const PAGE_SIZE = 20;

function timeAgo(dateStr: string): string {
    const diff = Date.now() - new Date(dateStr).getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 1) return 'just now';
    if (mins < 60) return `${mins}m ago`;
    const hrs = Math.floor(mins / 60);
    if (hrs < 24) return `${hrs}h ago`;
    const days = Math.floor(hrs / 24);
    return `${days}d ago`;
}

export default function AdminAuditLog() {
    const [logs, setLogs] = useState<AuditLog[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState('');
    const [typeFilter, setTypeFilter] = useState('all');
    const [page, setPage] = useState(0);
    const [totalCount, setTotalCount] = useState(0);
    const [error, setError] = useState<string | null>(null);

    const fetchLogs = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            let query = supabase
                .from('audit_logs')
                .select('*', { count: 'exact' })
                .order('created_at', { ascending: false })
                .range(page * PAGE_SIZE, (page + 1) * PAGE_SIZE - 1);

            if (typeFilter !== 'all') {
                query = query.eq('type', typeFilter);
            }
            if (search) {
                query = query.or(`action.ilike.%${search}%,actor.ilike.%${search}%`);
            }

            const { data, count, error: fetchErr } = await query;

            if (fetchErr) throw fetchErr;
            setLogs((data as AuditLog[]) || []);
            setTotalCount(count || 0);
        } catch (err: unknown) {
            const msg = err instanceof Error ? err.message : String(err);
            console.error('Failed to fetch audit logs:', msg);
            setError(msg);
            setLogs([]);
        } finally {
            setLoading(false);
        }
    }, [page, typeFilter, search]);

    useEffect(() => {
        const timer = setTimeout(fetchLogs, search ? 400 : 0);
        return () => clearTimeout(timer);
    }, [fetchLogs, search]);

    const getTypeIcon = (type: string) => {
        switch (type) {
            case 'security': return <Shield className="w-4 h-4" />;
            case 'content':  return <FileText className="w-4 h-4" />;
            case 'user':     return <User className="w-4 h-4" />;
            case 'system':   return <Activity className="w-4 h-4" />;
            default:         return <Key className="w-4 h-4" />;
        }
    };

    const exportCSV = () => {
        const header = ['Action', 'Actor', 'Resource', 'Type', 'Status', 'IP', 'Timestamp'];
        const rows = logs.map(l => [
            l.action, l.actor, l.resource || '', l.type, l.status,
            l.ip || '', new Date(l.created_at).toLocaleString()
        ]);
        const csv = [header, ...rows].map(r => r.map(v => `"${v}"`).join(',')).join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'audit_log.csv';
        a.click();
    };

    const totalPages = Math.ceil(totalCount / PAGE_SIZE);

    return (
        <div className="space-y-8 pb-10">
            <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4">
                <div>
                    <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Audit Log</h1>
                    <p className="mt-1.5 text-sm font-medium text-slate-500">
                        Track and monitor all system and user activity.
                        {totalCount > 0 && <span className="ml-2 font-bold text-slate-700">{totalCount.toLocaleString()} total events</span>}
                    </p>
                </div>
                <div className="flex items-center gap-3">
                    <button className="px-5 py-2.5 bg-white border border-slate-200 rounded-lg text-sm font-bold text-slate-700 hover:bg-slate-50 shadow-sm transition-all flex items-center gap-2">
                        <Calendar className="w-4 h-4" /> Last 30 Days
                    </button>
                    <button onClick={exportCSV} className="px-5 py-2.5 bg-[#006970] rounded-lg text-sm font-bold text-white hover:bg-[#005a60] shadow-sm transition-all">
                        Export Logs
                    </button>
                </div>
            </div>

            <AdminCard title="Activity Feed" description="A chronological record of system events.">
                <div className="mt-4 flex flex-col sm:flex-row gap-4 mb-6">
                    <div className="relative flex-1">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                        <input
                            type="text"
                            placeholder="Search actions or actors..."
                            value={search}
                            onChange={(e) => { setSearch(e.target.value); setPage(0); }}
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2.5 text-sm text-slate-900 focus:ring-2 focus:ring-[#006970]/20 focus:border-[#006970] outline-none transition-all"
                        />
                    </div>
                    <select
                        value={typeFilter}
                        onChange={(e) => { setTypeFilter(e.target.value); setPage(0); }}
                        className="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm font-bold text-slate-700 focus:ring-2 focus:ring-[#006970]/20 focus:border-[#006970] outline-none transition-all cursor-pointer"
                    >
                        <option value="all">All Events</option>
                        <option value="security">Security</option>
                        <option value="content">Content</option>
                        <option value="user">User Actions</option>
                        <option value="system">System</option>
                    </select>
                </div>

                {error && (
                    <div className="mb-4 px-4 py-3 bg-red-50 border border-red-200 rounded-xl text-sm font-bold text-red-700">
                        {error}
                    </div>
                )}

                <div className="border border-slate-200 rounded-xl overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="bg-slate-50 border-b border-slate-200 text-xs font-bold text-slate-500 uppercase tracking-widest">
                                    <th className="px-6 py-4">Event</th>
                                    <th className="px-6 py-4">Actor</th>
                                    <th className="px-6 py-4">Resource</th>
                                    <th className="px-6 py-4">IP Address</th>
                                    <th className="px-6 py-4 text-right">Time</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-100 bg-white">
                                {loading ? (
                                    <tr>
                                        <td colSpan={5} className="px-6 py-12 text-center">
                                            <div className="flex flex-col items-center gap-2 text-slate-400">
                                                <Loader2 className="w-6 h-6 animate-spin text-[#006970]" />
                                                <span className="text-sm font-medium">Loading audit logs...</span>
                                            </div>
                                        </td>
                                    </tr>
                                ) : logs.length === 0 ? (
                                    <tr>
                                        <td colSpan={5} className="px-6 py-12 text-center">
                                            <div className="flex flex-col items-center gap-2 text-slate-400">
                                                <Activity className="w-8 h-8 text-slate-200" />
                                                <span className="text-sm font-medium">
                                                    {search || typeFilter !== 'all'
                                                        ? 'No logs match your filters.'
                                                        : 'No audit logs yet. Events will appear here as they occur.'}
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                ) : (
                                    logs.map(log => (
                                        <tr key={log.id} className="hover:bg-slate-50/50 transition-colors">
                                            <td className="px-6 py-4">
                                                <div className="flex items-center gap-3">
                                                    <div className={`p-2 rounded-lg ${
                                                        log.status === 'success' ? 'bg-[#f0fafa] text-[#006970]' : 'bg-red-50 text-red-600'
                                                    }`}>
                                                        {getTypeIcon(log.type)}
                                                    </div>
                                                    <div>
                                                        <p className="text-sm font-bold text-slate-900">{log.action}</p>
                                                        <p className="text-[11px] font-bold uppercase tracking-widest text-slate-400 mt-0.5">{log.type}</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 text-sm font-medium text-slate-700">{log.actor || '—'}</td>
                                            <td className="px-6 py-4 text-sm font-medium text-slate-700">{log.resource || '—'}</td>
                                            <td className="px-6 py-4 text-xs font-mono text-slate-500">{log.ip || '—'}</td>
                                            <td className="px-6 py-4 text-right text-sm font-medium text-slate-500">{timeAgo(log.created_at)}</td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Pagination */}
                <div className="mt-6 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span className="text-sm font-medium text-slate-500">
                        {totalCount > 0
                            ? `Page ${page + 1} of ${totalPages || 1} · ${totalCount.toLocaleString()} events`
                            : 'No events'}
                    </span>
                    <div className="flex gap-2">
                        <button
                            onClick={() => setPage(p => Math.max(0, p - 1))}
                            disabled={page === 0 || loading}
                            className="p-2 border border-slate-200 rounded-lg text-slate-400 hover:text-slate-700 hover:bg-slate-50 transition-colors disabled:opacity-40"
                        >
                            <ChevronLeft className="w-4 h-4" />
                        </button>
                        <button
                            onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
                            disabled={page >= totalPages - 1 || loading}
                            className="p-2 border border-slate-200 rounded-lg text-slate-400 hover:text-slate-700 hover:bg-slate-50 transition-colors disabled:opacity-40"
                        >
                            <ChevronRight className="w-4 h-4" />
                        </button>
                    </div>
                </div>
            </AdminCard>
        </div>
    );
}
