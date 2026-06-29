'use client';

import React, { useState, useEffect } from 'react';
import { Bell, Smartphone, Mail, Eye, Loader2 } from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { supabase } from '@/lib/supabase';
import { toast } from 'react-hot-toast';

interface Preferences {
    emailReminders: boolean;
    pushFocusAlerts: boolean;
    publicProfile: boolean;
    aiDataSharing: boolean;
}

const DEFAULT_PREFS: Preferences = {
    emailReminders: true,
    pushFocusAlerts: true,
    publicProfile: false,
    aiDataSharing: true,
};

function ToggleSwitch({ checked, onChange, disabled }: { checked: boolean; onChange: () => void; disabled?: boolean }) {
    return (
        <button
            type="button"
            onClick={onChange}
            disabled={disabled}
            className={`w-12 h-6 rounded-full p-0.5 transition-colors duration-300 ease-in-out relative border border-white/80 disabled:opacity-40 shadow-inner ${checked ? 'bg-noble-blue' : 'bg-slate-200'}`}
        >
            <div className={`w-4 h-4 rounded-full bg-white transition-transform duration-300 shadow-[0_2px_4px_rgba(0,0,0,0.1)] ${checked ? 'translate-x-6' : 'translate-x-0'}`} />
        </button>
    );
}

export default function PreferencesPage() {
    const { user, userData, refreshUserData } = useAuth();
    const [preferences, setPreferences] = useState<Preferences>(DEFAULT_PREFS);
    const [saving, setSaving] = useState(false);
    const [loaded, setLoaded] = useState(false);

    // Load preferences from Supabase userData on mount
    useEffect(() => {
        if (userData && !loaded) {
            const prefs = (userData as any).notification_preferences;
            if (prefs) {
                setPreferences({ ...DEFAULT_PREFS, ...prefs });
            }
            setLoaded(true);
        }
    }, [userData, loaded]);

    const handleToggle = async (key: keyof Preferences) => {
        if (!user) return;
        const updated = { ...preferences, [key]: !preferences[key] };
        setPreferences(updated);
        setSaving(true);
        try {
            const { error } = await supabase
                .from('profiles')
                .update({
                    notification_preferences: updated,
                    updated_at: new Date().toISOString(),
                })
                .eq('id', user.id);

            if (error) throw error;

            await refreshUserData();
            toast.success('Preference saved.', { duration: 1200 });
        } catch (error) {
            console.error('Preference save error:', error);
            // Revert on failure
            setPreferences(preferences);
            toast.error('Failed to save preference.');
        } finally {
            setSaving(false);
        }
    };

    return (
        <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
            <div className="flex items-center justify-between pb-6 border-b border-white/40">
                <div>
                    <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                        System <span className="text-noble-blue">Preferences</span>
                    </h1>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Configure your notification delivery and privacy scope.</p>
                </div>
                {saving && (
                    <div className="flex items-center gap-2 text-noble-blue text-[10px] font-black uppercase tracking-widest bg-white/60 border border-white/60 px-4 py-2 rounded-xl shadow-sm">
                        <Loader2 className="w-3.5 h-3.5 animate-spin" /> Saving...
                    </div>
                )}
            </div>

            <div className="space-y-6">
                <h3 className="text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] px-1">Notifications</h3>

                <div className="flex items-center justify-between p-5 bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="p-3 bg-noble-blue/10 rounded-2xl border border-noble-blue/10"><Mail className="w-5 h-5 text-noble-blue" /></div>
                        <div>
                            <p className="text-xs font-black text-slate-800 uppercase tracking-wider">Daily Digest Emails</p>
                            <p className="text-[10px] text-slate-400 font-bold mt-1 uppercase tracking-wide">Receive a summary of your tasks and focus metrics.</p>
                        </div>
                    </div>
                    <ToggleSwitch checked={preferences.emailReminders} onChange={() => handleToggle('emailReminders')} disabled={saving} />
                </div>

                <div className="flex items-center justify-between p-5 bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="p-3 bg-emerald-500/10 rounded-2xl border border-emerald-500/10"><Smartphone className="w-5 h-5 text-emerald-600" /></div>
                        <div>
                            <p className="text-xs font-black text-slate-800 uppercase tracking-wider">Focus Alerts (Mobile)</p>
                            <p className="text-[10px] text-slate-400 font-bold mt-1 uppercase tracking-wide">Push notifications when your biological prime-time begins.</p>
                        </div>
                    </div>
                    <ToggleSwitch checked={preferences.pushFocusAlerts} onChange={() => handleToggle('pushFocusAlerts')} disabled={saving} />
                </div>
            </div>

            <div className="space-y-6 pt-4">
                <h3 className="text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] px-1">Privacy &amp; AI Data</h3>

                <div className="flex items-center justify-between p-5 bg-white/40 backdrop-blur-md rounded-3xl border border-white/60 shadow-sm">
                    <div className="flex items-center gap-4">
                        <div className="p-3 bg-purple-500/10 rounded-2xl border border-purple-500/10"><Eye className="w-5 h-5 text-purple-600" /></div>
                        <div>
                            <p className="text-xs font-black text-slate-800 uppercase tracking-wider">Public Profile Identity</p>
                            <p className="text-[10px] text-slate-400 font-bold mt-1 uppercase tracking-wide">Allow other users to see your shared Mind Maps and profile.</p>
                        </div>
                    </div>
                    <ToggleSwitch checked={preferences.publicProfile} onChange={() => handleToggle('publicProfile')} disabled={saving} />
                </div>

                <div className="p-6 bg-amber-50 rounded-3xl border border-amber-200 border-l-4 border-l-amber-500 shadow-sm">
                    <p className="text-xs font-black text-amber-700 uppercase tracking-wider mb-2">AI Model Contribution</p>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-wide leading-relaxed mb-6">
                        By default, your anonymized focus and task completion timings are used to improve the Biological Synchronization engine for all users. You can opt-out at any time.
                    </p>
                    <div className="flex items-center justify-end">
                        <ToggleSwitch checked={preferences.aiDataSharing} onChange={() => handleToggle('aiDataSharing')} disabled={saving} />
                    </div>
                </div>
            </div>
        </div>
    );
}
