'use client';

import React, { useState, useEffect } from 'react';
import { 
    Settings, Save, Upload, Building, 
    Palette, Layout, FileText, CheckCircle2,
    Loader2
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

export default function BrandSettingsPage() {
    const { user } = useAuth();
    
    // Controlled State Variables
    const [isLoading, setIsLoading] = useState(false);
    const [isSaving, setIsSaving] = useState(false);
    
    const [brandColor, setBrandColor] = useState('#166FBB');
    const [logoUrl, setLogoUrl] = useState('/images/logo.png');
    const [companyName, setCompanyName] = useState('NobleInvoice Inc.');
    const [email, setEmail] = useState('support@nobleinvoice.com');
    const [phone, setPhone] = useState('+1 (555) 123-4567');
    const [address, setAddress] = useState('123 Innovation Drive\nSuite 400\nSan Francisco, CA 94103');
    const [taxId, setTaxId] = useState('');
    const [website, setWebsite] = useState('https://nobleinvoice.com');
    const [defaultTemplate, setDefaultTemplate] = useState('modern');
    const [paymentTerms, setPaymentTerms] = useState('Please make payment within 14 days of receiving this invoice. Late payments may be subject to a 1.5% monthly fee.');

    // Fetch user brand details from Supabase on mount
    useEffect(() => {
        if (!user) return;
        
        const loadBrandData = async () => {
            setIsLoading(true);
            try {
                const teamData = await teamService.getTeamByUserId(user.id);
                if (teamData) {
                    const td = teamData as any;
                    if (td.brand_color || td.primary_color) setBrandColor(td.brand_color || td.primary_color);
                    if (td.brand_logo_url || td.logo_url) setLogoUrl(td.brand_logo_url || td.logo_url);
                    const resolvedName = td.business_name || td.name || td.full_name || td.display_name;
                    if (resolvedName) setCompanyName(resolvedName);
                    if (td.business_email) setEmail(td.business_email);
                    if (td.business_phone) setPhone(td.business_phone);
                    if (td.business_address) setAddress(td.business_address);
                    if (td.tax_number) setTaxId(td.tax_number);
                    if (td.website) setWebsite(td.website);
                }
            } catch (err) {
                console.error("Failed to load brand data from Supabase:", err);
            } finally {
                setIsLoading(false);
            }
        };
        
        loadBrandData();
    }, [user]);

    // Handle uploader changes
    const handleLogoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setLogoUrl(reader.result as string);
                toast.success('Professional logo pre-loaded! Click Save to apply.', { icon: '💎' });
            };
            reader.readAsDataURL(file);
        }
    };

    // Save brand profile globally
    const handleSave = async () => {
        if (!user) {
            toast.error('Authentication required to update Brand Settings.');
            return;
        }
        setIsSaving(true);
        try {
            await toast.promise(
                teamService.updateBrandKit(user.id, {
                    fullName: companyName,
                    companyName,
                    brandColor,
                    logoUrl,
                    email,
                    phone,
                    address,
                    taxId,
                    website
                }),
                {
                    loading: 'Syncing brand parameters globally...',
                    success: 'Visual Brand Strategy Saved Successfully!',
                    error: 'Global Sync Failed. Please retry.'
                }
            );
        } catch (err) {
            console.error("Failed to update global brand settings:", err);
        } finally {
            setIsSaving(false);
        }
    };

    if (isLoading) {
        return (
            <div className="flex flex-col items-center justify-center py-20 gap-4">
                <Loader2 className="w-12 h-12 text-noble-blue animate-spin" />
                <p className="text-slate-500 text-xs font-black uppercase tracking-widest">Loading Brand Configuration...</p>
            </div>
        );
    }

    return (
        <div className="space-y-10 animate-in fade-in slide-in-from-bottom-4 duration-500 relative z-10 text-slate-800">
            {/* Header Area */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-6 pb-6 border-b border-white/40">
                <div>
                    <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                        Brand <span className="text-noble-blue">Kit</span>
                    </h1>
                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-[0.15em] mt-1">Customize how your invoices, portal, and business cards appear to clients.</p>
                </div>
                <div>
                    <button 
                        onClick={handleSave}
                        disabled={isSaving}
                        className="flex items-center gap-3 px-8 py-4 bg-noble-blue text-white font-black text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-blue-600 transition-all shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 disabled:opacity-50 cursor-pointer"
                    >
                        {isSaving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Save className="w-4 h-4" />}
                        Save Changes
                    </button>
                </div>
            </div>

            <div className="space-y-8">
                {/* Visual Branding Section */}
                <div className="bg-white/40 backdrop-blur-md rounded-3xl p-8 border border-white/60 shadow-sm">
                    <div className="flex items-center gap-3 mb-6 pb-4 border-b border-white/40">
                        <Palette className="w-5 h-5 text-noble-blue" />
                        <h3 className="text-xl md:text-[26px] font-semibold text-slate-800">Visual Identity</h3>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-4">Company Logo</label>
                            <input 
                                type="file" 
                                id="logo-file-input" 
                                className="hidden" 
                                accept="image/*"
                                onChange={handleLogoUpload}
                            />
                            <div className="flex items-center gap-6 p-4 rounded-2xl bg-white/40 border border-white/60 shadow-inner">
                                <div 
                                    onClick={() => document.getElementById('logo-file-input')?.click()}
                                    className="w-20 h-20 rounded-xl bg-white border border-slate-200 flex items-center justify-center relative overflow-hidden group cursor-pointer hover:border-noble-blue transition-colors shadow-sm"
                                >
                                    {logoUrl ? (
                                        <img src={logoUrl} alt="Logo" className="w-full h-full object-cover" />
                                    ) : (
                                        <Upload className="w-5 h-5 text-slate-300" />
                                    )}
                                    <div className="absolute inset-0 bg-slate-955/60 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                        <Upload className="w-5 h-5 text-white" />
                                    </div>
                                </div>
                                <div>
                                    <p className="text-xs font-black text-slate-800 uppercase tracking-widest mb-1">Upload Logo Kit</p>
                                    <p className="text-[9px] text-slate-400 font-bold uppercase tracking-wide leading-relaxed">PNG, JPG, or SVG up to 2MB. Recommended: 512x512px.</p>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-4">Brand Accent Color</label>
                            <div className="flex items-center gap-4 p-4 rounded-2xl bg-white/40 border border-white/60 shadow-inner">
                                <input 
                                    type="color"
                                    value={brandColor}
                                    onChange={e => setBrandColor(e.target.value)}
                                    className="w-12 h-12 rounded-xl cursor-pointer border border-white/80 shadow-md p-0 overflow-hidden"
                                />
                                <div className="flex-1">
                                    <input 
                                        type="text" 
                                        value={brandColor}
                                        onChange={e => setBrandColor(e.target.value)}
                                        className="w-full bg-white/60 border border-white/60 text-slate-900 font-black text-xs rounded-xl px-4 py-3 outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all uppercase"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Company Information Section */}
                <div className="bg-white/40 backdrop-blur-md rounded-3xl p-8 border border-white/60 shadow-sm">
                    <div className="flex items-center gap-3 mb-6 pb-4 border-b border-white/40">
                        <Building className="w-5 h-5 text-noble-blue" />
                        <h3 className="text-xl md:text-[26px] font-semibold text-slate-800">Company Profile</h3>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div className="sm:col-span-2">
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Legal Business Name</label>
                            <input 
                                type="text" 
                                value={companyName}
                                onChange={e => setCompanyName(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>

                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Support Email</label>
                            <input 
                                type="email" 
                                value={email}
                                onChange={e => setEmail(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>

                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Business Phone</label>
                            <input 
                                type="tel" 
                                value={phone}
                                onChange={e => setPhone(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>

                        <div className="sm:col-span-2">
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Business Address</label>
                            <textarea 
                                rows={3}
                                value={address}
                                onChange={e => setAddress(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all resize-none shadow-inner h-24"
                            />
                        </div>

                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Tax ID / VAT Number</label>
                            <input 
                                type="text" 
                                value={taxId}
                                placeholder="Optional"
                                onChange={e => setTaxId(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>
                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Website URL</label>
                            <input 
                                type="url" 
                                value={website}
                                onChange={e => setWebsite(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>
                    </div>
                </div>

                {/* Invoicing Defaults Section */}
                <div className="bg-white/40 backdrop-blur-md rounded-3xl p-8 border border-white/60 shadow-sm mb-12">
                    <div className="flex items-center gap-3 mb-6 pb-4 border-b border-white/40">
                        <FileText className="w-5 h-5 text-noble-blue" />
                        <h3 className="text-xl md:text-[26px] font-semibold text-slate-800">Invoicing Defaults</h3>
                    </div>

                    <div className="space-y-8">
                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-4">Default Invoice Design Template</label>
                            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                                <div 
                                    onClick={() => setDefaultTemplate('modern')}
                                    className={`border-2 rounded-[24px] p-4 cursor-pointer relative transition-all shadow-sm ${defaultTemplate === 'modern' ? 'border-noble-blue bg-white/80' : 'border-white/60 bg-white/20'}`}
                                >
                                    {defaultTemplate === 'modern' && (
                                        <div className="absolute top-3 right-3 w-5 h-5 bg-noble-blue rounded-full flex items-center justify-center shadow-md">
                                            <CheckCircle2 className="w-3 h-3 text-white" />
                                        </div>
                                    )}
                                    <div className="w-full aspect-[1/1.4] bg-white border border-slate-100 rounded-lg shadow-sm mb-3" />
                                    <p className={`text-[10px] font-black text-center uppercase tracking-widest ${defaultTemplate === 'modern' ? 'text-noble-blue' : 'text-slate-500'}`}>Modern Minimal</p>
                                </div>
                                <div 
                                    onClick={() => setDefaultTemplate('classic')}
                                    className={`border-2 rounded-[24px] p-4 cursor-pointer relative transition-all shadow-sm ${defaultTemplate === 'classic' ? 'border-noble-blue bg-white/80' : 'border-white/60 bg-white/20'}`}
                                >
                                    {defaultTemplate === 'classic' && (
                                        <div className="absolute top-3 right-3 w-5 h-5 bg-noble-blue rounded-full flex items-center justify-center shadow-md">
                                            <CheckCircle2 className="w-3 h-3 text-white" />
                                        </div>
                                    )}
                                    <div className="w-full aspect-[1/1.4] bg-white border border-slate-100 rounded-lg shadow-sm mb-3" />
                                    <p className={`text-[10px] font-black text-center uppercase tracking-widest ${defaultTemplate === 'classic' ? 'text-noble-blue' : 'text-slate-500'}`}>Classic Business</p>
                                </div>
                                <div 
                                    onClick={() => setDefaultTemplate('bold')}
                                    className={`border-2 rounded-[24px] p-4 cursor-pointer relative transition-all shadow-sm ${defaultTemplate === 'bold' ? 'border-noble-blue bg-white/80' : 'border-white/60 bg-white/20'}`}
                                >
                                    {defaultTemplate === 'bold' && (
                                        <div className="absolute top-3 right-3 w-5 h-5 bg-noble-blue rounded-full flex items-center justify-center shadow-md">
                                            <CheckCircle2 className="w-3 h-3 text-white" />
                                        </div>
                                    )}
                                    <div className="w-full aspect-[1/1.4] bg-white border border-slate-100 rounded-lg shadow-sm mb-3 flex items-center justify-center flex-col gap-2">
                                        <Layout className="w-6 h-6 text-slate-300" />
                                    </div>
                                    <p className={`text-[10px] font-black text-center uppercase tracking-widest ${defaultTemplate === 'bold' ? 'text-noble-blue' : 'text-slate-500'}`}>Bold Creative</p>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label className="block text-[10px] font-black text-noble-blue uppercase tracking-[0.2em] mb-2 px-1">Default Payment Terms & Notes</label>
                            <textarea 
                                rows={4}
                                value={paymentTerms}
                                onChange={e => setPaymentTerms(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-900 font-bold text-sm rounded-xl px-4 py-4 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all resize-none shadow-inner h-28"
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
