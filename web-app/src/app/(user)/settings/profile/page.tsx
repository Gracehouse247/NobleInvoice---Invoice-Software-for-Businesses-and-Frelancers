'use client';

import React, { useState, useEffect, useRef } from 'react';
import { useAuth } from '@/context/AuthContext';
import { Loader2, Camera, CheckCircle, AlertCircle, Save } from 'lucide-react';
import { supabase } from '@/lib/supabase';
import { storageService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

export default function ProfileSettingsPage() {
    const { user, userData, refreshUserData } = useAuth();
    const [loading, setLoading] = useState(false);
    const [uploading, setUploading] = useState(false);
    const fileInputRef = useRef<HTMLInputElement>(null);

    const [form, setForm] = useState({
        displayName: '',
        phone: '',
        preferredCurrency: 'NGN',
        themeMode: 'system',
        locale: 'en',
    });

    useEffect(() => {
        if (userData) {
            const data = userData as any;
            setForm({
                displayName: data.display_name || data.name || '',
                phone: data.phone || '',
                preferredCurrency: data.preferred_currency || 'NGN',
                themeMode: data.theme_mode || 'system',
                locale: data.locale || 'en',
            });
        }
    }, [userData]);

    const handleAvatarUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        if (!user || !e.target.files?.[0]) return;
        const file = e.target.files[0];

        if (file.size > 2 * 1024 * 1024) {
            toast.error('Avatar must be under 2MB.');
            return;
        }
        if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
            toast.error('Only JPEG, PNG, or WebP files are accepted.');
            return;
        }

        setUploading(true);
        try {
            const fileExt = file.name.split('.').pop();
            const filePath = `${user.id}/avatar-${Date.now()}.${fileExt}`;
            const publicUrl = await storageService.uploadFile('avatars', filePath, file);
            
            const { error } = await supabase
                .from('profiles')
                .update({ avatar_url: publicUrl, updated_at: new Date().toISOString() })
                .eq('id', user.id);

            if (error) throw error;

            await refreshUserData();
            toast.success('Avatar updated successfully!');
        } catch (error: any) {
            console.error('Avatar upload error:', error);
            toast.error('Avatar upload failed. Try again.');
        } finally {
            setUploading(false);
        }
    };

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!user) return;

        if (!form.displayName.trim()) {
            toast.error('Display name cannot be empty.');
            return;
        }

        setLoading(true);
        try {
            const { error } = await supabase
                .from('profiles')
                .update({
                    display_name: form.displayName.trim(),
                    phone: form.phone.trim(),
                    preferred_currency: form.preferredCurrency,
                    theme_mode: form.themeMode,
                    locale: form.locale,
                    updated_at: new Date().toISOString()
                })
                .eq('id', user.id);

            if (error) throw error;

            await refreshUserData();
            toast.success('Profile saved successfully!');
        } catch (error: any) {
            console.error('Profile save error:', error);
            toast.error('Failed to save profile. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    const avatarSrc = (userData as any)?.avatar_url || userData?.photoUrl;
    const initials = form.displayName.charAt(0).toUpperCase() || 'U';

    return (
        <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
            <div>
                <h3 className="text-xl md:text-[26px] font-semibold text-slate-900 tracking-tight">Profile Details</h3>
                <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Manage your public persona and display information.</p>
            </div>

            {/* Avatar Uploader */}
            <div className="flex items-center gap-6 p-6 rounded-3xl bg-white/40 backdrop-blur-md border border-white/50 shadow-inner">
                <div className="relative group cursor-pointer" onClick={() => fileInputRef.current?.click()}>
                    <div className="w-24 h-24 rounded-full bg-noble-blue/10 flex items-center justify-center border-2 border-noble-blue/30 overflow-hidden shadow-md">
                        {avatarSrc ? (
                            <img src={avatarSrc} alt="Avatar" className="w-full h-full object-cover" />
                        ) : (
                            <span className="text-3xl font-black text-noble-blue" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>{initials}</span>
                        )}
                    </div>
                    <div className="absolute inset-0 bg-slate-900/60 rounded-full flex flex-col items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity gap-1">
                        <Camera className="w-5 h-5 text-white" />
                        <span className="text-[9px] text-white font-black uppercase tracking-widest">Change</span>
                    </div>
                    {uploading && (
                        <div className="absolute inset-0 rounded-full flex items-center justify-center bg-slate-900/80">
                            <Loader2 className="w-6 h-6 text-white animate-spin" />
                        </div>
                    )}
                </div>
                <div>
                    <button
                        type="button"
                        onClick={() => fileInputRef.current?.click()}
                        disabled={uploading}
                        className="px-5 py-2.5 bg-white/60 backdrop-blur-md border border-white/60 rounded-xl text-[10px] font-black text-slate-700 uppercase tracking-widest hover:bg-white hover:text-noble-blue hover:shadow-sm transition-all disabled:opacity-50"
                    >
                        {uploading ? 'Uploading...' : 'Upload Avatar'}
                    </button>
                    <p className="text-[10px] text-slate-500 mt-2 font-bold uppercase tracking-wide">JPEG, PNG, or WebP under 2MB.</p>
                </div>
                <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/jpeg,image/png,image/webp"
                    className="hidden"
                    onChange={handleAvatarUpload}
                />
            </div>

            <form onSubmit={handleSave} className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-2 px-1">Display Name</label>
                        <input
                            type="text"
                            value={form.displayName}
                            onChange={(e) => setForm({ ...form, displayName: e.target.value })}
                            className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4.5 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            required
                            maxLength={50}
                        />
                    </div>

                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-2 px-1">Phone Number</label>
                        <input
                            type="tel"
                            value={form.phone}
                            onChange={(e) => setForm({ ...form, phone: e.target.value })}
                            className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4.5 text-sm font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            placeholder="Optional"
                        />
                    </div>

                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-2 px-1">Preferred Currency</label>
                        <select
                            value={form.preferredCurrency}
                            onChange={(e) => setForm({ ...form, preferredCurrency: e.target.value })}
                            className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner cursor-pointer"
                        >
                            <option value="NGN">NGN (₦) - Nigerian Naira</option>
                            <option value="USD">USD ($) - US Dollar</option>
                            <option value="EUR">EUR (€) - Euro</option>
                            <option value="GBP">GBP (£) - British Pound</option>
                            <option value="CAD">CAD ($) - Canadian Dollar</option>
                            <option value="AUD">AUD ($) - Australian Dollar</option>
                            <option value="GHS">GHS (₵) - Ghanaian Cedi</option>
                            <option value="KES">KES (KSh) - Kenyan Shilling</option>
                            <option value="ZAR">ZAR (R) - South African Rand</option>
                        </select>
                    </div>

                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-2 px-1">Theme Mode</label>
                        <select
                            value={form.themeMode}
                            onChange={(e) => setForm({ ...form, themeMode: e.target.value })}
                            className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner cursor-pointer"
                        >
                            <option value="system">Follow System</option>
                            <option value="light">Light Mode</option>
                            <option value="dark">Dark Mode</option>
                        </select>
                    </div>

                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-2 px-1">Language</label>
                        <select
                            value={form.locale}
                            onChange={(e) => setForm({ ...form, locale: e.target.value })}
                            className="w-full bg-white/60 border border-white/60 rounded-xl px-4 py-4 text-sm font-bold text-slate-900 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner cursor-pointer"
                        >
                            <option value="en">English</option>
                            <option value="fr">Français</option>
                            <option value="es">Español</option>
                            <option value="de">Deutsch</option>
                        </select>
                    </div>
                </div>

                <div className="pt-6 border-t border-white/40 flex flex-col gap-6">
                    <div>
                        <label className="block text-[10px] font-black uppercase text-noble-blue tracking-[0.2em] mb-3 px-1">Subscription Status</label>
                        <div className="inline-flex items-center gap-3 px-4 py-2.5 bg-white/60 border border-white/60 rounded-xl shadow-sm">
                            {(() => {
                                const plan = userData?.plan || 'explorer';
                                const isElite = plan === 'elite';
                                const isPro = (plan as string) === 'pro' || (plan as string) === 'active';
                                return (
                                    <>
                                        <div className={`w-2.5 h-2.5 rounded-full ${
                                            isElite ? 'bg-amber-400 shadow-[0_0_8px_rgba(250,204,21,0.5)]' :
                                            isPro ? 'bg-noble-blue shadow-[0_0_8px_rgba(22,111,187,0.5)]' : 'bg-slate-400'
                                        }`} />
                                        <span className="text-[10px] font-black uppercase tracking-[0.15em] text-slate-700">
                                            {isElite ? 'Noble Elite' : isPro ? 'Noble Pro' : 'Free Plan'}
                                        </span>
                                    </>
                                );
                            })()}
                        </div>
                    </div>

                    <div className="flex flex-col sm:flex-row gap-4 sm:items-center justify-between pt-2">
                        <button
                            type="submit"
                            disabled={loading}
                            className="px-8 py-4 bg-noble-blue hover:bg-blue-600 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] transition-all disabled:opacity-50 flex items-center justify-center min-w-[160px] shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 cursor-pointer"
                        >
                            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4 mr-2" />}
                            Save Profile
                        </button>
                        <p className="text-[10px] text-slate-500 font-bold uppercase tracking-wider">
                            Account: <span className="text-slate-800 lowercase">{userData?.email || user?.email}</span>
                        </p>
                    </div>
                </div>
            </form>
        </div>
    );
}
