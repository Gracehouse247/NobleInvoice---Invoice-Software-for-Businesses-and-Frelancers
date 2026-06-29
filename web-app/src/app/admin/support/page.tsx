'use client';

import React, { useState, useEffect } from 'react';
import { 
    MessageSquare, Search, Filter, CheckCircle2, 
    Clock, AlertCircle, Send, User, ChevronRight,
    Loader2, Mail, Phone, Calendar
} from 'lucide-react';
import { cmsApi } from '@/lib/cmsApi';

interface Inquiry {
    id: number;
    user_name: string;
    user_email: string;
    subject: string;
    status: 'open' | 'pending' | 'resolved' | 'closed';
    priority: 'low' | 'medium' | 'high' | 'urgent';
    created_at: string;
    updated_at: string;
}

export default function AdminSupportPage() {
    const [inquiries, setInquiries] = useState<Inquiry[]>([]);
    const [selectedInquiry, setSelectedInquiry] = useState<Inquiry | null>(null);
    const [loading, setLoading] = useState(true);
    const [reply, setReply] = useState('');
    const [sending, setSending] = useState(false);
    const [search, setSearch] = useState('');

    const fetchInquiries = async () => {
        setLoading(true);
        try {
            const { data } = await cmsApi.getInquiries();
            setInquiries(data);
            if (data.length > 0 && !selectedInquiry) setSelectedInquiry(data[0]);
        } catch (err) {
            console.error('Failed to fetch inquiries:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => { fetchInquiries(); }, []);

    const handleSendReply = async () => {
        if (!selectedInquiry || !reply.trim()) return;
        setSending(true);
        try {
            await cmsApi.sendSupportReply({
                inquiryId: selectedInquiry.id,
                message: reply,
                userEmail: selectedInquiry.user_email
            });
            setReply('');
            // Optional: Update local status or refresh
            fetchInquiries();
        } catch (err) {
            console.error('Failed to send reply:', err);
        } finally {
            setSending(false);
        }
    };

    const StatusIcon = ({ status }: { status: string }) => {
        switch (status) {
            case 'open': return <Clock className="w-3 h-3 text-emerald-600" />;
            case 'pending': return <AlertCircle className="w-3 h-3 text-amber-600" />;
            case 'resolved': return <CheckCircle2 className="w-3 h-3 text-[#006970]" />;
            default: return <Clock className="w-3 h-3 text-slate-500" />;
        }
    };

    const filteredInquiries = inquiries.filter(i => 
        i.user_name.toLowerCase().includes(search.toLowerCase()) ||
        i.user_email.toLowerCase().includes(search.toLowerCase()) ||
        i.subject.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="flex h-screen overflow-hidden bg-slate-50">
            {/* Inquiry List Area */}
            <aside className="w-96 border-r border-slate-200 flex flex-col bg-slate-50">
                <div className="p-6 border-b border-slate-200 bg-white space-y-4">
                    <h1 className="text-2xl font-bold tracking-tight text-slate-900">Support Desk</h1>
                    <div className="relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                        <input 
                            placeholder="Search requests..."
                            value={search}
                            onChange={e => setSearch(e.target.value)}
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#006970]/20 focus:border-[#006970] transition-all font-medium placeholder:text-slate-400 shadow-sm"
                        />
                    </div>
                </div>

                <div className="flex-1 overflow-y-auto">
                    {loading ? (
                        <div className="p-10 flex flex-col items-center justify-center gap-3">
                            <Loader2 className="w-6 h-6 text-[#006970] animate-spin" />
                            <p className="text-[11px] font-bold text-slate-500 uppercase tracking-widest">Loading Inbox...</p>
                        </div>
                    ) : filteredInquiries.length === 0 ? (
                        <div className="p-10 text-center space-y-3 opacity-60">
                            <MessageSquare className="w-10 h-10 mx-auto text-slate-400" />
                            <p className="text-[11px] font-bold text-slate-500 uppercase tracking-widest">No active inquiries</p>
                        </div>
                    ) : (
                        filteredInquiries.map((inquiry) => (
                            <div 
                                key={inquiry.id}
                                onClick={() => setSelectedInquiry(inquiry)}
                                className={`p-4 border-b border-slate-200 cursor-pointer transition-all hover:bg-white ${selectedInquiry?.id === inquiry.id ? 'bg-white border-l-4 border-l-[#006970] shadow-sm' : 'bg-transparent border-l-4 border-l-transparent'}`}
                            >
                                <div className="flex justify-between items-start mb-1">
                                    <h4 className={`font-bold text-sm truncate pr-2 ${selectedInquiry?.id === inquiry.id ? 'text-[#006970]' : 'text-slate-900'}`}>{inquiry.user_name}</h4>
                                    <span className="text-[11px] font-bold text-slate-500 whitespace-nowrap uppercase tracking-widest">
                                        {new Date(inquiry.created_at).toLocaleDateString()}
                                    </span>
                                </div>
                                <p className="text-xs text-slate-600 font-medium line-clamp-1 mb-2">{inquiry.subject}</p>
                                <div className="flex items-center gap-3">
                                    <div className="flex items-center gap-1.5 px-2 py-0.5 rounded-full bg-slate-100 border border-slate-200">
                                        <StatusIcon status={inquiry.status} />
                                        <span className="text-[11px] font-bold uppercase tracking-widest text-slate-600">{inquiry.status}</span>
                                    </div>
                                    <span className={`text-[11px] font-bold uppercase tracking-widest ${
                                        inquiry.priority === 'urgent' ? 'text-red-600' : 
                                        inquiry.priority === 'high' ? 'text-amber-600' : 'text-slate-500'
                                    }`}>{inquiry.priority}</span>
                                </div>
                            </div>
                        ))
                    )}
                </div>
            </aside>

            {/* Conversation Area */}
            <main className="flex-1 flex flex-col bg-slate-50">
                {selectedInquiry ? (
                    <>
                        {/* Selected Inquiry Header */}
                        <header className="p-8 border-b border-slate-200 flex justify-between items-start flex-shrink-0 bg-white">
                            <div className="flex items-start gap-5">
                                <div className="w-14 h-14 bg-[#f0fafa] border border-[#d0eded] rounded-2xl flex items-center justify-center text-[#006970] font-bold text-xl">
                                    {selectedInquiry.user_name[0]}
                                </div>
                                <div>
                                    <h2 className="text-2xl font-bold tracking-tight text-slate-900 mb-1">{selectedInquiry.user_name}</h2>
                                    <div className="flex items-center gap-4 text-slate-600 text-sm font-medium">
                                        <div className="flex items-center gap-1.5"><Mail className="w-4 h-4 text-slate-400" /> {selectedInquiry.user_email}</div>
                                        <div className="w-1 h-1 bg-slate-300 rounded-full" />
                                        <div className="flex items-center gap-1.5"><Calendar className="w-4 h-4 text-slate-400" /> {new Date(selectedInquiry.created_at).toLocaleString()}</div>
                                    </div>
                                </div>
                            </div>
                            <div className="flex gap-2">
                                <button className="px-4 py-2 bg-emerald-50 border border-emerald-200 hover:bg-emerald-100 rounded-xl text-xs font-bold text-emerald-700 transition-all">Resolve Ticket</button>
                                <button className="px-4 py-2 bg-white border border-slate-200 hover:bg-slate-50 rounded-xl text-xs font-bold text-slate-700 transition-all shadow-sm hover:shadow-md duration-300">Close</button>
                            </div>
                        </header>

                        {/* Message History */}
                        <div className="flex-1 overflow-y-auto p-8 space-y-6">
                            <div className="flex flex-col items-center gap-4 py-4">
                                <span className="text-[11px] font-bold uppercase tracking-widest text-slate-500">
                                    {new Date(selectedInquiry.created_at).toLocaleDateString()}
                                </span>
                            </div>

                            {/* User Query Bubble */}
                            <div className="flex items-start gap-4 max-w-3xl">
                                <div className="w-10 h-10 bg-[#f0fafa] border border-[#d0eded] rounded-xl flex items-center justify-center text-[#006970] font-bold flex-shrink-0">
                                    {selectedInquiry.user_name[0]}
                                </div>
                                <div className="flex flex-col gap-1">
                                    <div className="flex items-center gap-2">
                                        <span className="font-bold text-sm text-slate-900">{selectedInquiry.user_name}</span>
                                        <span className="text-[11px] font-bold uppercase tracking-widest text-slate-500">User</span>
                                    </div>
                                    <div className="p-5 rounded-2xl rounded-tl-none bg-white border border-slate-200 shadow-sm hover:shadow-md transition-shadow duration-300">
                                        <h3 className="text-sm font-bold text-slate-900 mb-2">Subject: {selectedInquiry.subject}</h3>
                                        {(selectedInquiry as unknown as { message?: string }).message ? (
                                            <p className="text-slate-700 leading-relaxed text-sm whitespace-pre-wrap">
                                                {(selectedInquiry as unknown as { message: string }).message}
                                            </p>
                                        ) : (
                                            <p className="text-slate-400 italic text-sm">
                                                Message body not available. View the full ticket in your support system.
                                            </p>
                                        )}
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Reply Area */}
                        <div className="p-8 bg-slate-50 flex-shrink-0">
                            <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm hover:shadow-md transition-all duration-300 focus-within:ring-2 focus-within:ring-[#006970]/20 focus-within:border-[#006970]">
                                <textarea 
                                    rows={4}
                                    value={reply}
                                    onChange={e => setReply(e.target.value)}
                                    placeholder="Type your official reply here... Use Markdown for formatting if needed."
                                    className="w-full bg-transparent text-slate-900 text-sm focus:outline-none resize-none mb-4 font-medium placeholder:text-slate-400"
                                />
                                <div className="flex justify-between items-center">
                                    <div className="flex gap-2">
                                        <button className="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-xl text-xs font-bold text-slate-600 transition-colors">Apply Template</button>
                                        <button className="px-4 py-2 bg-[#f0fafa] hover:bg-[#e0f5f5] rounded-xl text-xs font-bold text-[#006970] transition-colors">AI Draft</button>
                                    </div>
                                    <button 
                                        onClick={handleSendReply}
                                        disabled={sending || !reply.trim()}
                                        className="bg-[#006970] hover:bg-[#005a60] text-white px-6 py-2.5 rounded-lg flex items-center gap-2 font-bold shadow-sm hover:shadow-md transition-all duration-300 disabled:opacity-50 text-sm"
                                    >
                                        {sending ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
                                        Send Reply
                                    </button>
                                </div>
                            </div>
                        </div>
                    </>
                ) : (
                    <div className="flex-1 flex flex-col items-center justify-center text-slate-500 gap-4 bg-slate-50">
                        <div className="w-20 h-20 bg-white rounded-2xl flex items-center justify-center border border-slate-200 shadow-sm">
                            <MessageSquare className="w-10 h-10 text-slate-300" />
                        </div>
                        <p className="text-[11px] font-bold text-slate-400 uppercase tracking-widest">Select an inquiry to start help</p>
                    </div>
                )}
            </main>
        </div>
    );
}
