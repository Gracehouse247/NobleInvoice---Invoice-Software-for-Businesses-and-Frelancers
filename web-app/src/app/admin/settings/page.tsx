'use client';

import React, { useState, useEffect } from 'react';
import { Settings, User, Bell, Shield, Key, CreditCard, Users, Loader2, Save, CheckCircle2 } from 'lucide-react';
import { AdminCard } from '@/components/shared/AdminCard';
import { supabase } from '@/lib/supabase';

interface AdminProfile {
    full_name: string | null;
    email: string;
    role: string | null;
    is_superadmin: boolean | null;
    avatar_url: string | null;
}

interface TeamMember {
    id: string;
    email: string;
    full_name: string | null;
    role: string | null;
}

export default function AdminSettings() {
    const [activeTab, setActiveTab] = useState('profile');
    const [profile, setProfile] = useState<AdminProfile | null>(null);
    const [teamMembers, setTeamMembers] = useState<TeamMember[]>([]);
    const [loadingProfile, setLoadingProfile] = useState(true);
    const [savingProfile, setSavingProfile] = useState(false);
    const [saveSuccess, setSaveSuccess] = useState(false);
    const [saveError, setSaveError] = useState<string | null>(null);

    // Profile form state
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');

    // Notification prefs (persisted in localStorage for now)
    const [emailNotif, setEmailNotif] = useState(true);
    const [sysNotif, setSysNotif] = useState(true);

    const tabs = [
        { id: 'profile', label: 'My Profile', icon: User },
        { id: 'team', label: 'Team Members', icon: Users },
        { id: 'notifications', label: 'Notifications', icon: Bell },
        { id: 'security', label: 'Security', icon: Shield },
    ];

    // Fetch current admin profile
    useEffect(() => {
        const fetchProfile = async () => {
            setLoadingProfile(true);
            try {
                const { data: { user } } = await supabase.auth.getUser();
                if (!user) return;

                const { data } = await supabase
                    .from('profiles')
                    .select('full_name:display_name, role, is_superadmin, avatar_url')
                    .eq('id', user.id)
                    .single();

                const fullName = data?.full_name ?? '';
                const parts = fullName.split(' ');
                setFirstName(parts[0] ?? '');
                setLastName(parts.slice(1).join(' ') ?? '');

                setProfile({
                    full_name: fullName,
                    email: user.email ?? '',
                    role: data?.role ?? null,
                    is_superadmin: data?.is_superadmin ?? false,
                    avatar_url: data?.avatar_url ?? null,
                });

                // Fetch other admins for the Team tab
                const { data: admins } = await supabase
                    .from('profiles')
                    .select('id, email, full_name:display_name, role')
                    .or('is_superadmin.eq.true,role.in.(super_admin,seo_manager,support_staff)')
                    .neq('id', user.id)
                    .limit(20);
                setTeamMembers((admins as TeamMember[]) || []);

            } catch (err) {
                console.error('Failed to load admin profile:', err);
            } finally {
                setLoadingProfile(false);
            }
        };
        fetchProfile();
    }, []);

    const handleSaveProfile = async () => {
        setSavingProfile(true);
        setSaveError(null);
        setSaveSuccess(false);
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) throw new Error('Not authenticated');

            const full_name = `${firstName} ${lastName}`.trim();
            const { error } = await supabase
                .from('profiles')
                .update({ display_name: full_name, updated_at: new Date().toISOString() })
                .eq('id', user.id);

            if (error) throw error;
            setProfile(prev => prev ? { ...prev, full_name } : prev);
            setSaveSuccess(true);
            setTimeout(() => setSaveSuccess(false), 3000);
        } catch (err: unknown) {
            setSaveError(err instanceof Error ? err.message : 'Failed to save changes.');
        } finally {
            setSavingProfile(false);
        }
    };

    const getRoleLabel = () => {
        if (profile?.is_superadmin) return 'Superadmin';
        const map: Record<string, string> = {
            super_admin: 'Super Admin',
            seo_manager: 'SEO Manager',
            support_staff: 'Support Staff',
        };
        return map[profile?.role ?? ''] ?? 'Admin';
    };

    return (
        <div className="space-y-8 pb-10 fade-in max-w-5xl">
            <div>
                <h1 className="text-3xl font-bold text-slate-900 tracking-tight">System Settings</h1>
                <p className="mt-1.5 text-sm font-medium text-slate-500">Manage your account and team preferences.</p>
            </div>

            <div className="flex flex-col md:flex-row gap-8">
                {/* Sidebar Navigation */}
                <aside className="w-full md:w-64 shrink-0">
                    <nav className="flex flex-col gap-1">
                        {tabs.map(tab => (
                            <button
                                key={tab.id}
                                onClick={() => setActiveTab(tab.id)}
                                className={`flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm font-bold transition-all duration-200 ${
                                    activeTab === tab.id
                                    ? 'bg-[#f0fafa] text-[#006970]'
                                    : 'text-slate-500 hover:bg-slate-100 hover:text-slate-900'
                                }`}
                            >
                                <tab.icon className={`w-4 h-4 ${activeTab === tab.id ? 'text-[#006970]' : 'text-slate-400'}`} />
                                {tab.label}
                            </button>
                        ))}
                    </nav>
                </aside>

                {/* Content Area */}
                <div className="flex-1">
                    {activeTab === 'profile' && (
                        <div className="space-y-6">
                            <AdminCard title="Personal Information" description="Update your display name. Email changes require support.">
                                {loadingProfile ? (
                                    <div className="py-8 flex items-center justify-center">
                                        <Loader2 className="w-6 h-6 text-[#006970] animate-spin" />
                                    </div>
                                ) : (
                                    <form onSubmit={(e) => { e.preventDefault(); handleSaveProfile(); }} className="space-y-5">
                                        {/* Avatar + Role Badge */}
                                        <div className="flex items-center gap-4 pb-4 border-b border-slate-100">
                                            <div className="w-14 h-14 rounded-2xl bg-[#f0fafa] border border-[#d0eded] flex items-center justify-center text-[#006970] font-bold text-xl shadow-sm">
                                                {(firstName || profile?.email || '?')[0].toUpperCase()}
                                            </div>
                                            <div>
                                                <p className="font-bold text-slate-900 text-base">{profile?.full_name || 'Admin User'}</p>
                                                <span className="inline-flex items-center px-2.5 py-1 rounded-lg bg-amber-50 border border-amber-200 text-amber-700 text-[10px] font-bold uppercase tracking-widest mt-1">
                                                    {getRoleLabel()}
                                                </span>
                                            </div>
                                        </div>

                                        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                                            <div>
                                                <label className="block text-[11px] font-bold uppercase tracking-widest text-slate-500 mb-1.5">First Name</label>
                                                <input
                                                    type="text"
                                                    value={firstName}
                                                    onChange={e => setFirstName(e.target.value)}
                                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#006970]/20 focus:border-[#006970] font-semibold transition-all"
                                                />
                                            </div>
                                            <div>
                                                <label className="block text-[11px] font-bold uppercase tracking-widest text-slate-500 mb-1.5">Last Name</label>
                                                <input
                                                    type="text"
                                                    value={lastName}
                                                    onChange={e => setLastName(e.target.value)}
                                                    className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#006970]/20 focus:border-[#006970] font-semibold transition-all"
                                                />
                                            </div>
                                        </div>
                                        <div>
                                            <label className="block text-[11px] font-bold uppercase tracking-widest text-slate-500 mb-1.5">Email Address</label>
                                            <input
                                                type="email"
                                                value={profile?.email ?? ''}
                                                disabled
                                                className="w-full bg-slate-100 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-500 font-semibold cursor-not-allowed"
                                            />
                                            <p className="text-xs text-slate-400 mt-1.5 font-medium">Email cannot be changed here. Contact support.</p>
                                        </div>

                                        {saveError && (
                                            <p className="text-sm font-bold text-red-600 bg-red-50 border border-red-200 rounded-xl px-4 py-3">{saveError}</p>
                                        )}

                                        <div className="flex items-center gap-3 pt-2">
                                            <button
                                                type="submit"
                                                disabled={savingProfile}
                                                className="flex items-center gap-2 px-5 py-2.5 bg-[#006970] hover:bg-[#005a60] text-white text-sm font-bold rounded-xl shadow-sm transition-all disabled:opacity-50"
                                            >
                                                {savingProfile ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                                                Save Changes
                                            </button>
                                            {saveSuccess && (
                                                <span className="flex items-center gap-1.5 text-sm font-bold text-emerald-600">
                                                    <CheckCircle2 className="w-4 h-4" /> Saved!
                                                </span>
                                            )}
                                        </div>
                                    </form>
                                )}
                            </AdminCard>
                        </div>
                    )}

                    {activeTab === 'team' && (
                        <div className="space-y-6">
                            <AdminCard title="Admin Team Members" description="View all accounts with admin access to this panel.">
                                {loadingProfile ? (
                                    <div className="py-8 flex items-center justify-center">
                                        <Loader2 className="w-6 h-6 text-[#006970] animate-spin" />
                                    </div>
                                ) : (
                                    <div className="divide-y divide-slate-100">
                                        {/* Current admin always shown first */}
                                        <div className="py-4 flex items-center justify-between">
                                            <div className="flex items-center gap-3">
                                                <div className="w-10 h-10 rounded-full bg-[#f0fafa] text-[#006970] font-bold flex items-center justify-center border border-[#d0eded]">
                                                    {(firstName || '?')[0].toUpperCase()}
                                                </div>
                                                <div>
                                                    <p className="text-sm font-bold text-slate-900">{profile?.full_name || 'You'} <span className="text-slate-400 font-medium text-xs">(You)</span></p>
                                                    <p className="text-xs font-medium text-slate-500">{profile?.email}</p>
                                                </div>
                                            </div>
                                            <span className="px-3 py-1 bg-emerald-50 text-emerald-700 text-[10px] font-bold uppercase tracking-widest rounded-lg border border-emerald-200">{getRoleLabel()}</span>
                                        </div>
                                        {teamMembers.length === 0 ? (
                                            <div className="py-6 text-center text-sm text-slate-500 font-medium">No other admin accounts found.</div>
                                        ) : teamMembers.map(member => (
                                            <div key={member.id} className="py-4 flex items-center justify-between">
                                                <div className="flex items-center gap-3">
                                                    <div className="w-10 h-10 rounded-full bg-slate-100 text-slate-600 font-bold flex items-center justify-center">
                                                        {(member.full_name || member.email || '?')[0].toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <p className="text-sm font-bold text-slate-900">{member.full_name || '—'}</p>
                                                        <p className="text-xs font-medium text-slate-500">{member.email}</p>
                                                    </div>
                                                </div>
                                                <span className="px-3 py-1 bg-slate-50 text-slate-600 text-[10px] font-bold uppercase tracking-widest rounded-lg border border-slate-200">
                                                    {member.role?.replace('_', ' ') ?? 'Admin'}
                                                </span>
                                            </div>
                                        ))}
                                    </div>
                                )}
                                <p className="text-xs text-slate-400 font-medium mt-4 pt-4 border-t border-slate-100">
                                    To add or remove admins, use the <strong className="text-slate-600">User Management</strong> page.
                                </p>
                            </AdminCard>
                        </div>
                    )}

                    {activeTab === 'notifications' && (
                        <div className="space-y-6">
                            <AdminCard title="Notification Preferences" description="Choose what alerts you receive via email and in-app.">
                                <div className="space-y-4">
                                    {[
                                        { id: 'email-notif', label: 'Email Notifications', desc: 'Receive daily summaries and critical alerts.', checked: emailNotif, onChange: setEmailNotif },
                                        { id: 'sys-notif', label: 'System Alerts', desc: 'In-app notifications for background jobs (SEO, Sync).', checked: sysNotif, onChange: setSysNotif },
                                    ].map(pref => (
                                        <div key={pref.id} className="flex items-center justify-between p-4 bg-slate-50 border border-slate-200 rounded-xl shadow-sm hover:shadow-md transition-shadow">
                                            <div>
                                                <p className="text-sm font-bold text-slate-900">{pref.label}</p>
                                                <p className="text-xs font-medium text-slate-500 mt-0.5">{pref.desc}</p>
                                            </div>
                                            <div className="relative inline-block w-10 h-6">
                                                <input
                                                    type="checkbox"
                                                    className="peer sr-only"
                                                    id={pref.id}
                                                    checked={pref.checked}
                                                    onChange={e => pref.onChange(e.target.checked)}
                                                />
                                                <label
                                                    htmlFor={pref.id}
                                                    className="block w-10 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#006970] cursor-pointer shadow-sm"
                                                ></label>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </AdminCard>
                        </div>
                    )}

                    {activeTab === 'security' && (
                        <div className="space-y-6">
                            <AdminCard title="Security Settings" description="Protect your account with advanced security features.">
                                <div className="space-y-6">
                                    <div className="p-4 bg-[#f0fafa] border border-[#b9cacb] rounded-xl">
                                        <div className="flex items-start gap-3">
                                            <Shield className="w-5 h-5 text-[#006970] shrink-0 mt-0.5" />
                                            <div>
                                                <p className="text-sm font-bold text-[#006970]">Magic Link / OTP Authentication</p>
                                                <p className="text-xs text-slate-600 font-medium mt-1">
                                                    Your account uses passwordless email OTP authentication via Supabase Auth. 
                                                    To log in, a one-time code is sent to your registered email. No password is stored.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <h3 className="text-sm font-bold text-slate-900 mb-1">Two-Factor Authentication (2FA)</h3>
                                        <p className="text-sm font-medium text-slate-500 mb-4">Add an extra layer of security using an authenticator app (TOTP).</p>
                                        <button className="px-5 py-2.5 bg-white border border-slate-200 text-slate-700 rounded-lg text-sm font-bold hover:bg-slate-50 transition-all shadow-sm flex items-center gap-2">
                                            <Shield className="w-4 h-4 text-slate-400" /> Enable 2FA App
                                        </button>
                                    </div>
                                    <div className="pt-6 border-t border-slate-100">
                                        <h3 className="text-sm font-bold text-red-600 mb-1">Danger Zone</h3>
                                        <p className="text-xs text-slate-500 font-medium mb-3">These actions are irreversible.</p>
                                        <button
                                            onClick={async () => { await supabase.auth.signOut(); window.location.href = '/admin/login'; }}
                                            className="px-5 py-2.5 bg-white border border-red-200 text-red-600 rounded-lg text-sm font-bold hover:bg-red-50 transition-all shadow-sm"
                                        >
                                            Sign Out of Admin Panel
                                        </button>
                                    </div>
                                </div>
                            </AdminCard>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
