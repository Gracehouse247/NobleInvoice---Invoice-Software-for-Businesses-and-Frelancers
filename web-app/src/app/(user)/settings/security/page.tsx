'use client';

import React, { useState } from 'react';
import { useAuth } from '@/context/AuthContext';
import { KeyRound, LogOut, ShieldAlert, Loader2, Eye, EyeOff, Trash2, AlertTriangle } from 'lucide-react';
import { toast } from 'react-hot-toast';
import { supabase } from '@/lib/supabase';

export default function SecuritySettingsPage() {
    const { user, logout } = useAuth();
    const [passwordData, setPasswordData] = useState({ current: '', new: '', confirm: '' });
    const [showPasswords, setShowPasswords] = useState(false);
    const [loading, setLoading] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [deleteConfirmText, setDeleteConfirmText] = useState('');
    const [deleting, setDeleting] = useState(false);

    const handlePasswordUpdate = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!user?.email) {
            toast.error('No email-based account found.');
            return;
        }

        if (passwordData.new.length < 8) {
            toast.error('New password must be at least 8 characters.');
            return;
        }
        if (passwordData.new !== passwordData.confirm) {
            toast.error('New passwords do not match.');
            return;
        }

        setLoading(true);
        try {
            // First, re-authenticate to verify current password
            const { error: signInError } = await supabase.auth.signInWithPassword({
                email: user.email,
                password: passwordData.current
            });

            if (signInError) {
                toast.error('Current password is incorrect.');
                setLoading(false);
                return;
            }

            const { error: updateError } = await supabase.auth.updateUser({
                password: passwordData.new
            });

            if (updateError) {
                throw updateError;
            }

            setPasswordData({ current: '', new: '', confirm: '' });
            toast.success('Password updated successfully!');
        } catch (error: any) {
            toast.error('Password update failed. Please try again.');
            console.error('Password update error:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteAccount = async () => {
        if (deleteConfirmText !== 'DELETE') {
            toast.error('Please type DELETE to confirm.');
            return;
        }

        setDeleting(true);
        try {
            const { data: { session } } = await supabase.auth.getSession();
            if (!session) {
                toast.error('Session expired. Please log in again.');
                return;
            }

            const res = await fetch('/api/account/delete', {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${session.access_token}`,
                    'Content-Type': 'application/json'
                }
            });

            const data = await res.json();

            if (res.ok && data.success) {
                toast.success('Your account has been deleted. Goodbye.');
                await supabase.auth.signOut();
                window.location.href = '/';
            } else {
                toast.error(data.error || 'Failed to delete account.');
            }
        } catch (err) {
            toast.error('An error occurred. Please try again.');
            console.error('Delete account error:', err);
        } finally {
            setDeleting(false);
        }
    };

    const isEmailProvider = user?.app_metadata?.providers?.includes('email');

    return (
        <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
            <div>
                <h3 className="text-xl md:text-[26px] font-semibold text-slate-900 tracking-tight">Access &amp; Security</h3>
                <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Manage passwords and active sessions.</p>
            </div>

            {!isEmailProvider ? (
                <div className="p-6 bg-amber-50 border border-amber-200 rounded-3xl shadow-sm">
                    <p className="text-xs font-black text-amber-700 flex items-center gap-2 uppercase tracking-wider">
                        <ShieldAlert className="w-4 h-4" /> Social Sign-In Account
                    </p>
                    <p className="text-xs text-slate-500 font-bold mt-2 leading-relaxed uppercase tracking-wide">
                        Your account is linked via Google or another OAuth provider. Password management is handled by your provider and cannot be changed here.
                    </p>
                </div>
            ) : (
                <form onSubmit={handlePasswordUpdate} className="space-y-6">
                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-3 px-1">Change Password</label>
                        <div className="space-y-4">
                            <input
                                type={showPasswords ? 'text' : 'password'}
                                placeholder="Current Password"
                                value={passwordData.current}
                                onChange={e => setPasswordData(p => ({ ...p, current: e.target.value }))}
                                className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                                required
                            />
                            <input
                                type={showPasswords ? 'text' : 'password'}
                                placeholder="New Password (min 8 characters)"
                                value={passwordData.new}
                                onChange={e => setPasswordData(p => ({ ...p, new: e.target.value }))}
                                className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                                required
                            />
                            <input
                                type={showPasswords ? 'text' : 'password'}
                                placeholder="Confirm New Password"
                                value={passwordData.confirm}
                                onChange={e => setPasswordData(p => ({ ...p, confirm: e.target.value }))}
                                className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                                required
                            />
                        </div>
                        <button
                            type="button"
                            onClick={() => setShowPasswords(v => !v)}
                            className="flex items-center gap-1.5 mt-3 text-[10px] text-slate-500 hover:text-noble-blue transition-colors font-black uppercase tracking-widest px-1"
                        >
                            {showPasswords ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                            {showPasswords ? 'Hide' : 'Show'} passwords
                        </button>
                    </div>

                    <div className="pt-6 flex flex-col sm:flex-row gap-4 sm:items-center justify-between border-b border-white/40 pb-8">
                        <button
                            type="submit"
                            disabled={loading}
                            className="px-8 py-4 bg-noble-blue hover:bg-blue-600 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all disabled:opacity-50 flex items-center justify-center gap-2 shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 min-w-[180px]"
                        >
                            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <KeyRound className="w-4 h-4" />}
                            {loading ? 'Updating...' : 'Update Password'}
                        </button>
                        <div className="flex items-center gap-2 text-amber-600 text-[10px] font-black uppercase tracking-wider bg-amber-50 border border-amber-100 px-3 py-1.5 rounded-xl">
                            <ShieldAlert className="w-4 h-4" /> Recommended every 90 days
                        </div>
                    </div>
                </form>
            )}

            {/* Two-Factor Authentication */}
            <div className="space-y-4 pt-4 border-t border-white/40">
                <div>
                    <h3 className="text-lg font-black text-slate-900 tracking-tight">Two-Factor Authentication (2FA)</h3>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1 mb-4">Add an extra layer of security to your account.</p>
                </div>
                <div className="flex flex-col sm:flex-row sm:items-center justify-between p-6 bg-white/60 border border-noble-blue/20 rounded-3xl shadow-sm gap-4">
                    <div>
                        <p className="text-sm font-black text-slate-800">Authenticator App</p>
                        <p className="text-xs text-slate-500 font-medium mt-1">Use an app like Google Authenticator or Authy to generate one-time codes.</p>
                    </div>
                    <button
                        type="button"
                        onClick={() => toast.success('2FA configuration will be available in the next release.')}
                        className="px-6 py-3 bg-white border border-noble-blue/30 text-noble-blue hover:bg-noble-blue hover:text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all shadow-sm active:scale-95 whitespace-nowrap"
                    >
                        Enable 2FA
                    </button>
                </div>
            </div>

            {/* Danger Zone */}
            <div className="space-y-4 pt-4">
                <h3 className="text-[10px] font-black uppercase tracking-[0.2em] text-red-500 px-1">Danger Zone</h3>
                
                {/* Global Sign Out */}
                <div className="flex flex-col md:flex-row md:items-center justify-between p-6 bg-red-50 border border-red-200 rounded-3xl gap-4 shadow-sm">
                    <div>
                        <p className="text-xs font-black text-red-600 flex items-center gap-2 uppercase tracking-wider">
                            <LogOut className="w-4 h-4" /> Global Sign Out
                        </p>
                        <p className="text-[10px] text-slate-500 mt-2 font-bold uppercase tracking-wider max-w-[320px] leading-relaxed">
                            Disconnect your account from all currently active sessions and devices immediately.
                        </p>
                    </div>
                    <button
                        onClick={() => logout()}
                        className="px-8 py-4 bg-red-600 hover:bg-red-700 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all shadow-[0_10px_20px_rgba(220,38,38,0.15)] active:scale-95 whitespace-nowrap"
                    >
                        Sign Out Now
                    </button>
                </div>

                {/* Delete Account */}
                <div className="flex flex-col md:flex-row md:items-center justify-between p-6 bg-red-50 border border-red-200 rounded-3xl gap-4 shadow-sm">
                    <div>
                        <p className="text-xs font-black text-red-600 flex items-center gap-2 uppercase tracking-wider">
                            <Trash2 className="w-4 h-4" /> Delete Account
                        </p>
                        <p className="text-[10px] text-slate-500 mt-2 font-bold uppercase tracking-wider max-w-[320px] leading-relaxed">
                            Permanently delete your account and all associated data. This action is irreversible per our GDPR/CCPA commitments.
                        </p>
                    </div>
                    <button
                        onClick={() => setShowDeleteModal(true)}
                        className="px-8 py-4 bg-white hover:bg-red-600 hover:text-white text-red-600 border border-red-200 hover:border-red-600 rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all active:scale-95 whitespace-nowrap"
                    >
                        Delete Account
                    </button>
                </div>
            </div>

            {/* Delete Confirmation Modal */}
            {showDeleteModal && (
                <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-[32px] p-8 max-w-md w-full shadow-2xl border border-red-100">
                        <div className="flex items-center gap-3 mb-6">
                            <div className="p-3 bg-red-100 rounded-2xl text-red-600">
                                <AlertTriangle className="w-6 h-6" />
                            </div>
                            <div>
                                <h3 className="text-lg font-black text-slate-900 tracking-tight">Delete Account</h3>
                                <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">This cannot be undone</p>
                            </div>
                        </div>

                        <p className="text-sm font-semibold text-slate-600 mb-6 leading-relaxed">
                            This will permanently erase your NobleInvoice account, all invoices, clients, billing history, and brand data. 
                            <span className="font-black text-red-600"> Your data cannot be recovered after deletion.</span>
                        </p>

                        <div className="mb-6">
                            <label className="block text-[10px] font-black uppercase tracking-widest text-slate-500 mb-2">
                                Type <span className="text-red-600">DELETE</span> to confirm
                            </label>
                            <input
                                type="text"
                                value={deleteConfirmText}
                                onChange={e => setDeleteConfirmText(e.target.value)}
                                placeholder="DELETE"
                                className="w-full bg-red-50 border border-red-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-900 placeholder:text-red-300 focus:outline-none focus:border-red-400 focus:ring-4 focus:ring-red-100 transition-all"
                            />
                        </div>

                        <div className="flex gap-3">
                            <button
                                onClick={() => { setShowDeleteModal(false); setDeleteConfirmText(''); }}
                                className="flex-1 py-3.5 bg-slate-100 text-slate-700 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-slate-200 transition-all"
                            >
                                Cancel
                            </button>
                            <button
                                onClick={handleDeleteAccount}
                                disabled={deleting || deleteConfirmText !== 'DELETE'}
                                className="flex-1 py-3.5 bg-red-600 hover:bg-red-700 text-white rounded-xl text-[10px] font-black uppercase tracking-widest disabled:opacity-40 disabled:cursor-not-allowed transition-all flex items-center justify-center gap-2"
                            >
                                {deleting ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Trash2 className="w-3.5 h-3.5" />}
                                {deleting ? 'Deleting...' : 'Delete Forever'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

