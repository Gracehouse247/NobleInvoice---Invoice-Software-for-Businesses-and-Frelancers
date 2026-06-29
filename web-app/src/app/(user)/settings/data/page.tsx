'use client';

import React, { useState } from 'react';
import { useAuth } from '@/context/AuthContext';
import { Database, DownloadCloud, AlertTriangle, Trash2, Loader2, X } from 'lucide-react';
import { toast } from 'react-hot-toast';
import { supabase } from '@/lib/supabase';

// ─── Delete Confirmation Modal ─────────────────────────────────────────────────
function DeleteConfirmModal({ onConfirm, onCancel, loading }: {
    onConfirm: (password: string) => void;
    onCancel: () => void;
    loading: boolean;
}) {
    const { user } = useAuth();
    const [password, setPassword] = useState('');

    return (
        <div className="fixed inset-0 z-[200] flex items-center justify-center p-4">
            <div className="absolute inset-0 bg-slate-900/40 backdrop-blur-md" onClick={onCancel} />
            <div className="relative z-10 w-full max-w-md bg-white/95 backdrop-blur-2xl border border-white/80 rounded-[2.5rem] p-8 shadow-2xl shadow-slate-900/10">
                <button onClick={onCancel} className="absolute top-5 right-5 p-2 text-slate-400 hover:text-slate-700 transition-colors">
                    <X className="w-4 h-4" />
                </button>

                <div className="flex flex-col items-center text-center gap-4 mb-8">
                    <div className="w-16 h-16 rounded-[20px] bg-red-50 border border-red-200 flex items-center justify-center shadow-sm">
                        <Trash2 className="w-6 h-6 text-red-600 animate-bounce" />
                    </div>
                    <div>
                        <h3 className="text-xl font-black text-slate-900 tracking-tight" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Delete Account?</h3>
                        <p className="text-[10px] text-slate-500 font-bold uppercase tracking-wider mt-2 leading-relaxed">
                            This permanently removes all your data — Invoices, Clients, and your account. <span className="text-red-500 font-black">This cannot be undone.</span>
                        </p>
                    </div>
                </div>

                <div className="mb-6">
                    <label className="block text-[10px] font-black uppercase text-red-600 tracking-[0.2em] mb-2 px-1">
                        Confirm with current password
                    </label>
                    <input
                        type="password"
                        placeholder="Enter password to confirm..."
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-red-500 focus:ring-4 focus:ring-red-100 transition-all shadow-inner"
                    />
                </div>

                <div className="flex gap-3">
                    <button
                        onClick={onCancel}
                        className="flex-1 py-4 rounded-xl bg-white/60 hover:bg-white border border-white/60 text-slate-600 text-[10px] font-black uppercase tracking-[0.2em] transition-all active:scale-95 shadow-sm"
                    >
                        Cancel
                    </button>
                    <button
                        onClick={() => onConfirm(password)}
                        disabled={loading || !password}
                        className="flex-1 py-4 rounded-xl bg-red-600 hover:bg-red-700 text-white text-[10px] font-black uppercase tracking-[0.2em] transition-all shadow-[0_10px_20px_rgba(220,38,38,0.15)] active:scale-95 disabled:opacity-50 flex items-center justify-center gap-2"
                    >
                        {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Trash2 className="w-4 h-4" />}
                        {loading ? 'Deleting...' : 'Delete Forever'}
                    </button>
                </div>
            </div>
        </div>
    );
}

// ─── Main Page ─────────────────────────────────────────────────────────────────
export default function DataBackupPage() {
    const { user, logout } = useAuth();
    const [exporting, setExporting] = useState(false);
    const [deleting, setDeleting] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);

    const handleExport = async () => {
        if (!user) return;
        setExporting(true);
        try {
            const { data: invoices } = await supabase.from('invoices').select('*').eq('user_id', user.id);
            const { data: clients } = await supabase.from('clients').select('*');
            
            const exportData = {
                metadata: {
                    exportedAt: new Date().toISOString(),
                    userId: user.id,
                    email: user.email,
                    version: '2.0',
                },
                invoices: invoices || [],
                clients: clients || [],
            };

            const blob = new Blob([JSON.stringify(exportData, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `nobleinvoice_archive_${Date.now()}.json`;
            a.click();
            URL.revokeObjectURL(url);
            toast.success(`Archive exported — ${exportData.invoices.length} invoices, ${exportData.clients.length} clients.`);
        } catch (error) {
            console.error('Export error:', error);
            toast.error('Export failed. Please try again.');
        } finally {
            setExporting(false);
        }
    };

    const handleDelete = async (password: string) => {
        if (!user) return;
        setDeleting(true);
        try {
            const { error } = await supabase.auth.signInWithPassword({ email: user.email || '', password });
            if (error) throw error;
            
            // Delete account using rpc or contact support
            toast.success('Account permanently deleted (Mocked).');
            await logout();
        } catch (error: any) {
            console.error('Delete account error:', error);
            toast.error('Account deletion failed. Check password and try again.');
        } finally {
            setDeleting(false);
            setShowDeleteModal(false);
        }
    };

    return (
        <>
            {showDeleteModal && (
                <DeleteConfirmModal
                    onConfirm={handleDelete}
                    onCancel={() => setShowDeleteModal(false)}
                    loading={deleting}
                />
            )}

            <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
                <div>
                    <h3 className="text-xl md:text-[26px] font-semibold text-slate-900 tracking-tight">Data &amp; Archival</h3>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Control your digital footprint. Export or erase your cognitive data.</p>
                </div>

                <div className="space-y-6">
                    <div className="p-8 bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm">
                        <div className="flex items-start gap-4 mb-6">
                            <div className="p-3.5 bg-noble-blue/10 rounded-2xl border border-noble-blue/10">
                                <Database className="w-5 h-5 text-noble-blue" />
                            </div>
                            <div>
                                <h3 className="text-sm font-black text-slate-800 uppercase tracking-wider">Full Archive Export</h3>
                                <p className="text-[10px] text-slate-400 font-bold uppercase tracking-wide mt-2 max-w-[420px] leading-relaxed">
                                    Download a complete JSON archive of your Invoices and Clients.
                                </p>
                            </div>
                        </div>
                        <button
                            onClick={handleExport}
                            disabled={exporting}
                            className="px-8 py-4 bg-noble-blue hover:bg-blue-600 disabled:opacity-50 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all flex items-center justify-center gap-2 shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95"
                        >
                            {exporting ? <Loader2 className="w-4 h-4 animate-spin" /> : <DownloadCloud className="w-4 h-4" />}
                            {exporting ? 'Packaging Data...' : 'Download JSON Archive'}
                        </button>
                        <p className="text-[9px] text-slate-400/80 mt-6 uppercase font-black tracking-widest text-center">Your data belongs to you.</p>
                    </div>
                </div>

                <div className="space-y-4 pt-6 mt-6 border-t border-white/40">
                    <h3 className="text-[10px] font-black uppercase tracking-[0.2em] text-red-500 flex items-center gap-2 px-1">
                        <AlertTriangle className="w-4 h-4 text-red-500 animate-pulse" /> Irreversible Actions
                    </h3>
                    <div className="p-8 bg-red-50 rounded-3xl border border-red-200 shadow-sm">
                        <h4 className="text-xs font-black text-red-600 uppercase tracking-wider mb-2">Delete Account</h4>
                        <p className="text-[10px] text-slate-500 font-bold uppercase tracking-wide mb-6 max-w-[500px] leading-relaxed">
                            Permanently remove your account and all associated data. This action cannot be undone and you will lose access to all features instantly.
                        </p>
                        <button
                            onClick={() => setShowDeleteModal(true)}
                            disabled={deleting}
                            className="px-8 py-4 bg-red-600 hover:bg-red-700 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all flex items-center justify-center gap-2 shadow-[0_10px_20px_rgba(220,38,38,0.15)] active:scale-95 whitespace-nowrap"
                        >
                            <Trash2 className="w-4 h-4" />
                            Delete My NobleInvoice Account
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}

