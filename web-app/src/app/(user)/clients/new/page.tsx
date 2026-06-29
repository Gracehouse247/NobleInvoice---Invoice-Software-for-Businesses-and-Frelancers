'use client';

import React, { useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { 
    ChevronLeft, User, Mail, Phone, MapPin, 
    Globe, Briefcase, Save, Plus,
    Flag, Tag, Zap, Badge, FileText
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { clientService, teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

function NewClientForm() {
    const { user } = useAuth();
    const router = useRouter();
    const searchParams = useSearchParams();
    const fromInvoice = searchParams?.get('from') === 'invoice';
    const [loading, setLoading] = useState(false);
    const [showImportModal, setShowImportModal] = useState(false);

    const [formData, setFormData] = useState({
        name: '',
        email: '',
        phone: '',
        country: '',
        country_code: '+234',
        address: '',
        company: '',
        position: '',
        tags: '',
        lead_status: 'active',
        notes: ''
    });

    const handleSubmit = async (e: React.FormEvent, redirectToInvoice = false) => {
        e.preventDefault();
        if (!user) return;
        
        setLoading(true);
        try {
            const tData = await teamService.getTeamByUserId(user.id);
            const teamId = tData?.id || user.id;

            const saved = await clientService.createClient({
                ...formData,
                tags: formData.tags.split(',').map(t => t.trim()).filter(Boolean),
                team_id: teamId,
                user_id: user.id
            });
            toast.success('Client added successfully');

            if (fromInvoice || redirectToInvoice) {
                // Return to invoice creator with new client pre-selected
                router.push(`/invoices/new?newClientId=${saved.id}`);
            } else {
                router.push('/clients');
            }
        } catch (error) {
            console.error('Error adding client:', error);
            toast.error('Failed to add client');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="p-4 md:p-5 lg:p-8 max-w-5xl mx-auto space-y-6 pb-8">
            <button 
                onClick={() => fromInvoice ? router.push('/invoices/new') : router.back()}
                className="flex items-center gap-2 text-slate-500 hover:text-[#166FBB] transition-colors font-black text-[10px] uppercase tracking-widest"
            >
                <ChevronLeft className="w-4 h-4" />
                {fromInvoice ? 'Back to Invoice' : 'Back to CRM'}
            </button>

            <form onSubmit={handleSubmit}>
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                
                {/* LEFT COLUMN: Contact & Advanced CRM */}
                <div className="space-y-6">
                    <h3 className="text-[11px] font-black text-[#166FBB] uppercase tracking-[0.15em] mb-4">Contact Information</h3>
                    
                    <div className="space-y-4 bg-white p-5 rounded-3xl border border-[#E2E8F0] shadow-sm">
                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Client Name *</label>
                            <div className="relative">
                                <User className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-[#166FBB]" />
                                <input 
                                    required
                                    type="text"
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A]"
                                    placeholder="e.g. Major EC Opumie"
                                    value={formData.name}
                                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                                />
                            </div>
                        </div>

                        <button 
                            type="button" 
                            onClick={() => setShowImportModal(true)}
                            className="inline-flex items-center gap-2 px-4 py-2.5 bg-[#E8F2FB] text-[#166FBB] rounded-xl text-sm font-bold hover:bg-[#D4E8F9] transition-colors w-fit"
                        >
                            <User className="w-4 h-4" /> Import from contacts
                        </button>

                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Email Address *</label>
                            <div className="relative">
                                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-[#166FBB]" />
                                <input 
                                    required
                                    type="email"
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A]"
                                    placeholder="e.g. info@domain.com"
                                    value={formData.email}
                                    onChange={(e) => setFormData({...formData, email: e.target.value})}
                                />
                            </div>
                        </div>

                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Phone Number</label>
                            <div className="flex gap-2">
                                <div className="relative w-[120px]">
                                    <Flag className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-emerald-600" />
                                    <select 
                                        className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-10 pr-2 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#166FBB] appearance-none"
                                        value={formData.country_code}
                                        onChange={(e) => setFormData({...formData, country_code: e.target.value})}
                                    >
                                        <option value="+234">+234</option>
                                        <option value="+1">+1</option>
                                        <option value="+44">+44</option>
                                    </select>
                                </div>
                                <div className="relative flex-1">
                                    <input 
                                        type="tel"
                                        className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A]"
                                        placeholder="07045507824"
                                        value={formData.phone}
                                        onChange={(e) => setFormData({...formData, phone: e.target.value})}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* ADVANCED CRM (Moved to Left Column to balance height) */}
                    <div>
                        <h3 className="text-[11px] font-black text-[#166FBB] uppercase tracking-[0.15em] mb-4">Advanced CRM Details</h3>
                        <div className="space-y-4 bg-white p-5 rounded-3xl border border-[#E2E8F0] shadow-sm">
                            <div className="space-y-2">
                                <label className="text-[11px] font-bold text-[#0F172A]">CRM Lead Status</label>
                                <select 
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A] appearance-none"
                                    value={formData.lead_status}
                                    onChange={(e) => setFormData({...formData, lead_status: e.target.value})}
                                >
                                    <option value="lead">🎯 Lead (Potential)</option>
                                    <option value="active">✅ Active Client</option>
                                    <option value="vip">⭐ VIP Client</option>
                                    <option value="churned">💤 Churned / Inactive</option>
                                </select>
                            </div>
                            <div className="space-y-2">
                                <label className="text-[11px] font-bold text-[#0F172A]">Tags (Comma Separated)</label>
                                <input 
                                    type="text"
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A]"
                                    placeholder="e.g. VIP, B2B, Tech"
                                    value={formData.tags}
                                    onChange={(e) => setFormData({...formData, tags: e.target.value})}
                                />
                            </div>
                        </div>
                    </div>
                </div>

                {/* RIGHT COLUMN: Business Information & Actions */}
                <div className="space-y-6">
                    <div>
                        <h3 className="text-[11px] font-black text-[#166FBB] uppercase tracking-[0.15em] mb-4">Business Information</h3>
                        
                        <div className="space-y-4 bg-white p-5 rounded-3xl border border-[#E2E8F0] shadow-sm">
                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Business Name *</label>
                            <div className="relative">
                                <Briefcase className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-[#166FBB]" />
                                <input 
                                    required
                                    type="text"
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A]"
                                    placeholder="e.g. Opuforty Nigeria Limited"
                                    value={formData.company}
                                    onChange={(e) => setFormData({...formData, company: e.target.value})}
                                />
                            </div>
                        </div>

                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Position / Role</label>
                            <div className="relative">
                                <Briefcase className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-[#166FBB]" />
                                <select 
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A] appearance-none"
                                    value={formData.position}
                                    onChange={(e) => setFormData({...formData, position: e.target.value})}
                                >
                                    <option value="" disabled>Select position...</option>
                                    <option value="CEO">CEO</option>
                                    <option value="Co-founder">Co-founder</option>
                                    <option value="Managing Director">Managing Director</option>
                                    <option value="Director">Director</option>
                                    <option value="General Manager">General Manager</option>
                                    <option value="Manager">Manager</option>
                                    <option value="Team Lead">Team Lead</option>
                                    <option value="Supervisor">Supervisor</option>
                                    <option value="Senior Executive">Senior Executive</option>
                                    <option value="Executive">Executive</option>
                                    <option value="Consultant">Consultant</option>
                                    <option value="Partner">Partner</option>
                                    <option value="Owner">Owner</option>
                                    <option value="Procurement Officer">Procurement Officer</option>
                                    <option value="Account Manager">Account Manager</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>

                        <div className="space-y-2">
                            <label className="text-[11px] font-bold text-[#0F172A]">Business Address</label>
                            <div className="relative">
                                <MapPin className="absolute left-4 top-4 w-4 h-4 text-[#166FBB]" />
                                <textarea 
                                    className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-[#166FBB] transition-all text-[#0F172A] min-h-[100px]"
                                    placeholder="32 Mobolaji Bank Anthony Way, Maryland Lagos Nigeria"
                                    value={formData.address}
                                    onChange={(e) => setFormData({...formData, address: e.target.value})}
                                />
                            </div>
                        </div>
                    </div>
                </div>

                {/* ACTION BUTTONS (Exact match to screenshot) */}
                    <div className="flex flex-col gap-3 pt-6">
                        <button 
                            disabled={loading}
                            type="submit"
                            className="w-full h-12 bg-[#1C64F2] text-white rounded-2xl font-bold text-base hover:bg-blue-700 transition-colors disabled:opacity-50"
                        >
                            {loading ? 'Saving...' : 'Save Client'}
                        </button>
                        
                        <button 
                            type="button"
                            onClick={(e) => handleSubmit(e as any, true)}
                            className="w-full h-12 bg-transparent text-[#1C64F2] rounded-2xl font-bold text-base flex items-center justify-center gap-2 hover:bg-blue-50 transition-colors"
                        >
                            <FileText className="w-4 h-4" />
                            Save & Create Invoice
                        </button>
                    </div>
                </div>
                
                </div>
            </form>

            {/* Import from Contacts Modal */}
            {showImportModal && (
                <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div className="bg-white rounded-[32px] p-8 max-w-md w-full shadow-2xl relative animate-in fade-in zoom-in duration-200">
                        <div className="w-16 h-16 bg-[#E8F2FB] text-[#166FBB] rounded-full flex items-center justify-center mx-auto mb-6">
                            <User className="w-8 h-8" />
                        </div>
                        
                        <h2 className="text-2xl font-black text-[#0F172A] text-center mb-3">
                            Import from Contacts
                        </h2>
                        
                        <p className="text-slate-500 text-center text-sm font-medium leading-relaxed mb-8">
                            Native contact importing is an exclusive feature of the NobleInvoice Mobile App. Download the app to seamlessly sync your phone's address book.
                        </p>
                        
                        <div className="space-y-3">
                            {/* App Store Links (Placeholders for now) */}
                            <button 
                                onClick={() => alert('App Store link coming soon!')}
                                className="w-full h-12 bg-black text-white rounded-2xl font-bold text-sm hover:bg-slate-800 transition-colors flex items-center justify-center gap-2"
                            >
                                Download on the App Store
                            </button>
                            <button 
                                onClick={() => alert('Play Store link coming soon!')}
                                className="w-full h-12 bg-black text-white rounded-2xl font-bold text-sm hover:bg-slate-800 transition-colors flex items-center justify-center gap-2"
                            >
                                Get it on Google Play
                            </button>
                            
                            <button 
                                onClick={() => setShowImportModal(false)}
                                className="w-full h-12 bg-transparent text-[#64748B] hover:bg-slate-50 rounded-2xl font-bold text-sm transition-colors mt-2"
                            >
                                Cancel
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

export default function NewClientPage() {
    return (
        <Suspense fallback={
            <div className="h-screen flex items-center justify-center bg-[#F8FAFC]">
                <div className="w-10 h-10 border-4 border-[#166FBB] border-t-transparent rounded-full animate-spin" />
            </div>
        }>
            <NewClientForm />
        </Suspense>
    );
}
