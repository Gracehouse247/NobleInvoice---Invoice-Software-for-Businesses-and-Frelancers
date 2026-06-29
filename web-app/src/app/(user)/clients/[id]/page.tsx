'use client';

import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { 
    ChevronLeft, Mail, Phone, MapPin, 
    Briefcase, Edit3, Trash2,
    FileText, MessageSquare, PhoneCall,
    Calendar, FolderOpen, Heart, TrendingUp, Download, X, Plus, Zap
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { clientService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

export default function ClientProfilePage({ params }: { params: { id: string } }) {
    const { user } = useAuth();
    const router = useRouter();
    const [client, setClient] = useState<any>(null);
    const [notes, setNotes] = useState<any[]>([]);
    const [documents, setDocuments] = useState<any[]>([]);
    const [logs, setLogs] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState('Overview');

    const [isAddingNote, setIsAddingNote] = useState(false);
    const [newNote, setNewNote] = useState({ content: '', sentiment: 'neutral' });

    const [isAddingDoc, setIsAddingDoc] = useState(false);
    const [newDoc, setNewDoc] = useState({ title: '', url: '' });

    const [isLoggingActivity, setIsLoggingActivity] = useState(false);
    const [newActivity, setNewActivity] = useState({ type: 'call', description: '', duration: 15 });

    useEffect(() => {
        if (!user || !params.id) return;
        
        Promise.all([
            clientService.getClient(params.id),
            clientService.getClientNotes(params.id).catch(() => []),
            clientService.getClientDocuments(params.id).catch(() => []),
            clientService.getCommunicationLogs(params.id).catch(() => [])
        ]).then(([clientData, notesData, docsData, logsData]) => {
            setClient(clientData);
            setNotes(notesData || []);
            setDocuments(docsData || []);
            setLogs(logsData || []);
            setLoading(false);
        }).catch(err => {
            console.error('Error fetching client details:', err);
            toast.error('Failed to load client details');
            setLoading(false);
        });
    }, [user, params.id]);

    if (loading) {
        return (
            <div className="h-screen flex items-center justify-center bg-[#F8FAFC]">
                <div className="w-10 h-10 border-4 border-[#166FBB] border-t-transparent rounded-full animate-spin" />
            </div>
        );
    }

    if (!client) {
        return (
            <div className="min-h-screen bg-[#F8FAFC] flex flex-col items-center justify-center">
                <h1 className="text-2xl font-black text-[#0F172A]">Client not found</h1>
                <button onClick={() => router.push('/clients')} className="mt-4 text-[#166FBB] font-bold">Return to CRM</button>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-[#F8FAFC] pb-24">
            {/* Header Profile Card */}
            <div className="bg-white border-b border-[#E2E8F0]">
                <div className="max-w-5xl mx-auto px-8 pt-8 pb-6">
                    <button 
                        onClick={() => router.push('/clients')}
                        className="flex items-center gap-2 text-slate-500 hover:text-[#166FBB] transition-colors font-black text-[10px] uppercase tracking-widest mb-6"
                    >
                        <ChevronLeft className="w-4 h-4" />
                        Back to CRM
                    </button>

                    <div className="flex flex-col md:flex-row md:items-start justify-between gap-6">
                        <div className="flex items-start gap-6">
                            <div className="w-24 h-24 rounded-3xl bg-gradient-to-br from-[#166FBB] to-[#125A96] flex items-center justify-center text-white text-3xl font-black shadow-lg shadow-[#166FBB]/20">
                                {client.name?.charAt(0).toUpperCase()}
                            </div>
                            <div>
                                <h1 className="text-3xl font-black text-[#0F172A] tracking-tight">{client.name}</h1>
                                <div className="flex items-center gap-2 mt-2">
                                    {client.company && (
                                        <span className="flex items-center gap-1.5 text-sm font-bold text-[#64748B]">
                                            <Briefcase className="w-4 h-4 text-[#94A3B8]" />
                                            {client.company}
                                        </span>
                                    )}
                                    {client.position && (
                                        <span className="px-2 py-0.5 bg-slate-100 text-slate-600 rounded text-xs font-bold uppercase tracking-wider">
                                            {client.position}
                                        </span>
                                    )}
                                </div>
                                <div className="flex flex-wrap gap-2 mt-4">
                                    <span className={`inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-black uppercase tracking-wider ${
                                        client.lead_status === 'vip' ? 'bg-amber-100 text-amber-700' :
                                        client.lead_status === 'lead' ? 'bg-[#e0f5f5] text-[#005a60]' :
                                        client.lead_status === 'churned' ? 'bg-slate-100 text-slate-600' :
                                        'bg-emerald-100 text-emerald-700'
                                    }`}>
                                        <Zap className="w-3.5 h-3.5" /> 
                                        {client.lead_status || 'Active'}
                                    </span>
                                    {client.tags?.map((tag: string, i: number) => (
                                        <span key={i} className="px-3 py-1 bg-[#F8FAFC] border border-[#E2E8F0] text-[#64748B] rounded-full text-xs font-bold">
                                            #{tag}
                                        </span>
                                    ))}
                                </div>
                            </div>
                        </div>
                        <div className="flex items-center gap-3">
                            <button className="h-10 px-4 bg-[#F8FAFC] border border-[#E2E8F0] text-[#64748B] rounded-xl hover:bg-white transition-all font-bold text-sm flex items-center gap-2">
                                <Edit3 className="w-4 h-4" /> Edit
                            </button>
                            <button className="h-10 w-10 bg-red-50 text-red-600 rounded-xl hover:bg-red-100 transition-all flex items-center justify-center">
                                <Trash2 className="w-4 h-4" />
                            </button>
                        </div>
                    </div>
                </div>

                {/* Tabs */}
                <div className="max-w-5xl mx-auto px-8 flex overflow-x-auto hide-scrollbar border-t border-[#E2E8F0]">
                    {['Overview', 'Notes & Sentiment', 'Documents', 'Communication Log'].map(tab => (
                        <button
                            key={tab}
                            onClick={() => setActiveTab(tab)}
                            className={`px-6 py-4 text-sm font-bold whitespace-nowrap border-b-2 transition-all ${
                                activeTab === tab 
                                ? 'border-[#166FBB] text-[#166FBB]' 
                                : 'border-transparent text-[#64748B] hover:text-[#0F172A]'
                            }`}
                        >
                            {tab}
                        </button>
                    ))}
                </div>
            </div>

            {/* Content Area */}
            <div className="max-w-5xl mx-auto px-8 mt-8">
                {activeTab === 'Overview' && (
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div className="md:col-span-2 space-y-6">
                            <div className="bg-white p-6 rounded-3xl border border-[#E2E8F0] shadow-sm">
                                <h3 className="text-sm font-black text-[#0F172A] uppercase tracking-widest mb-4">Contact Information</h3>
                                <div className="space-y-4">
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center border border-slate-100">
                                            <Mail className="w-4 h-4 text-slate-400" />
                                        </div>
                                        <div>
                                            <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Email Address</div>
                                            <div className="text-sm font-bold text-[#0F172A]">{client.email}</div>
                                        </div>
                                    </div>
                                    {client.phone && (
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center border border-slate-100">
                                                <Phone className="w-4 h-4 text-slate-400" />
                                            </div>
                                            <div>
                                                <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Phone Number</div>
                                                <div className="text-sm font-bold text-[#0F172A]">{client.country_code} {client.phone}</div>
                                            </div>
                                        </div>
                                    )}
                                    {client.address && (
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center border border-slate-100">
                                                <MapPin className="w-4 h-4 text-slate-400" />
                                            </div>
                                            <div>
                                                <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Address</div>
                                                <div className="text-sm font-bold text-[#0F172A]">{client.address} {client.country ? `, ${client.country}` : ''}</div>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                        <div className="space-y-6">
                            <div className="bg-white p-6 rounded-3xl border border-[#E2E8F0] shadow-sm">
                                <h3 className="text-sm font-black text-[#0F172A] uppercase tracking-widest mb-4 flex items-center gap-2">
                                    <TrendingUp className="w-4 h-4 text-[#166FBB]" /> Financial Summary
                                </h3>
                                <div className="space-y-4">
                                    <div className="p-4 bg-[#F8FAFC] rounded-2xl border border-[#E2E8F0]">
                                        <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Total Lifetime Value</div>
                                        <div className="text-2xl font-black text-[#166FBB]">₦0.00</div>
                                    </div>
                                    <div className="p-4 bg-orange-50 rounded-2xl border border-orange-100">
                                        <div className="text-[10px] font-bold text-orange-400 uppercase tracking-wider mb-1">Outstanding Balance</div>
                                        <div className="text-xl font-black text-orange-600">₦0.00</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                )}

                {activeTab === 'Notes & Sentiment' && (
                    <div className="bg-white p-6 rounded-3xl border border-[#E2E8F0] shadow-sm">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-sm font-black text-[#0F172A] uppercase tracking-widest flex items-center gap-2">
                                <Heart className="w-4 h-4 text-rose-500" /> AI Sentiment Tracking
                            </h3>
                            {!isAddingNote && (
                                <button onClick={() => setIsAddingNote(true)} className="text-sm font-bold text-[#166FBB] hover:underline flex items-center gap-1">
                                    <Plus className="w-4 h-4" /> Add Note
                                </button>
                            )}
                        </div>

                        {isAddingNote && (
                            <div className="mb-6 p-4 bg-[#F8FAFC] border border-[#E2E8F0] rounded-2xl">
                                <div className="flex items-center justify-between mb-2">
                                    <h4 className="text-xs font-black text-[#0F172A] uppercase tracking-widest">New Note</h4>
                                    <button onClick={() => setIsAddingNote(false)} className="text-[#64748B] hover:text-[#0F172A]">
                                        <X className="w-4 h-4" />
                                    </button>
                                </div>
                                <textarea 
                                    className="w-full p-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB] min-h-[100px] mb-3"
                                    placeholder="Write your note here..."
                                    value={newNote.content}
                                    onChange={(e) => setNewNote({...newNote, content: e.target.value})}
                                />
                                <div className="flex items-center justify-between">
                                    <div className="flex gap-2">
                                        <select 
                                            className="px-3 py-2 text-xs font-bold rounded-lg border border-[#E2E8F0] bg-white outline-none"
                                            value={newNote.sentiment}
                                            onChange={(e) => setNewNote({...newNote, sentiment: e.target.value})}
                                        >
                                            <option value="positive">🟢 Positive Sentiment</option>
                                            <option value="neutral">⚪ Neutral Sentiment</option>
                                            <option value="negative">🔴 Negative Sentiment</option>
                                        </select>
                                    </div>
                                    <button 
                                        className="px-6 py-2 bg-[#166FBB] text-white text-xs font-bold rounded-lg hover:bg-[#125A96]"
                                        onClick={() => {
                                            const noteObj = { id: Date.now(), ...newNote, created_at: new Date().toISOString() };
                                            setNotes([noteObj, ...notes]);
                                            setIsAddingNote(false);
                                            setNewNote({ content: '', sentiment: 'neutral' });
                                        }}
                                    >
                                        Save Note
                                    </button>
                                </div>
                            </div>
                        )}

                        {notes.length === 0 && !isAddingNote ? (
                            <div className="text-center py-12">
                                <FileText className="w-12 h-12 text-slate-200 mx-auto mb-3" />
                                <h4 className="font-bold text-slate-700">No notes yet</h4>
                                <p className="text-sm text-slate-500 mt-1">Add notes from meetings or calls to track client sentiment over time.</p>
                            </div>
                        ) : (
                            <div className="space-y-4">
                                {notes.map(note => (
                                    <div key={note.id} className="p-4 border border-[#E2E8F0] rounded-2xl bg-white">
                                        <div className="flex justify-between items-start mb-2">
                                            <span className={`px-2 py-0.5 rounded text-[10px] font-black uppercase tracking-wider ${
                                                note.sentiment === 'positive' ? 'bg-emerald-100 text-emerald-700' :
                                                note.sentiment === 'negative' ? 'bg-rose-100 text-rose-700' :
                                                'bg-slate-100 text-slate-700'
                                            }`}>
                                                {note.sentiment} Sentiment
                                            </span>
                                            <span className="text-xs text-[#94A3B8] font-medium">{new Date(note.created_at).toLocaleDateString()}</span>
                                        </div>
                                        <p className="text-sm text-[#0F172A] whitespace-pre-wrap">{note.content}</p>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                )}

                {activeTab === 'Documents' && (
                    <div className="bg-white p-6 rounded-3xl border border-[#E2E8F0] shadow-sm">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-sm font-black text-[#0F172A] uppercase tracking-widest flex items-center gap-2">
                                <FolderOpen className="w-4 h-4 text-[#166FBB]" /> Client Files
                            </h3>
                            {!isAddingDoc && (
                                <button onClick={() => setIsAddingDoc(true)} className="text-sm font-bold text-[#166FBB] hover:underline flex items-center gap-1">
                                    <Plus className="w-4 h-4" /> Upload File
                                </button>
                            )}
                        </div>

                        {isAddingDoc && (
                            <div className="mb-6 p-4 bg-[#F8FAFC] border border-[#E2E8F0] rounded-2xl">
                                <div className="flex items-center justify-between mb-4">
                                    <h4 className="text-xs font-black text-[#0F172A] uppercase tracking-widest">New Document</h4>
                                    <button onClick={() => setIsAddingDoc(false)} className="text-[#64748B] hover:text-[#0F172A]">
                                        <X className="w-4 h-4" />
                                    </button>
                                </div>
                                <div className="space-y-3">
                                    <input 
                                        type="text"
                                        placeholder="Document Title (e.g. Q3 Contract)"
                                        className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB]"
                                        value={newDoc.title}
                                        onChange={e => setNewDoc({...newDoc, title: e.target.value})}
                                    />
                                    <div className="flex gap-2">
                                        <input 
                                            type="url"
                                            placeholder="Paste secure URL here..."
                                            className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB]"
                                            value={newDoc.url}
                                            onChange={e => setNewDoc({...newDoc, url: e.target.value})}
                                        />
                                        <button 
                                            className="px-6 py-2 bg-[#166FBB] text-white text-xs font-bold rounded-xl hover:bg-[#125A96] whitespace-nowrap"
                                            onClick={() => {
                                                if(!newDoc.title || !newDoc.url) return;
                                                const docObj = { id: Date.now(), ...newDoc, created_at: new Date().toISOString() };
                                                setDocuments([docObj, ...documents]);
                                                setIsAddingDoc(false);
                                                setNewDoc({ title: '', url: '' });
                                            }}
                                        >
                                            Save Link
                                        </button>
                                    </div>
                                </div>
                            </div>
                        )}

                        {documents.length === 0 && !isAddingDoc ? (
                            <div className="text-center py-12">
                                <FolderOpen className="w-12 h-12 text-slate-200 mx-auto mb-3" />
                                <h4 className="font-bold text-slate-700">No documents</h4>
                                <p className="text-sm text-slate-500 mt-1">Upload contracts, NDAs, or project scopes here.</p>
                            </div>
                        ) : (
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                {documents.map(doc => (
                                    <div key={doc.id} className="p-4 border border-[#E2E8F0] rounded-2xl flex items-center justify-between hover:border-[#166FBB] transition-colors group">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center text-[#166FBB]">
                                                <FileText className="w-5 h-5" />
                                            </div>
                                            <div>
                                                <h4 className="text-sm font-bold text-[#0F172A]">{doc.title}</h4>
                                                <span className="text-xs text-[#64748B]">{new Date(doc.created_at).toLocaleDateString()}</span>
                                            </div>
                                        </div>
                                        <a href={doc.url} target="_blank" rel="noopener noreferrer" className="p-2 text-[#94A3B8] hover:text-[#166FBB] hover:bg-blue-50 rounded-lg opacity-0 group-hover:opacity-100 transition-all">
                                            <Download className="w-4 h-4" />
                                        </a>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                )}

                {activeTab === 'Communication Log' && (
                    <div className="bg-white p-6 rounded-3xl border border-[#E2E8F0] shadow-sm">
                        <div className="flex items-center justify-between mb-6">
                            <h3 className="text-sm font-black text-[#0F172A] uppercase tracking-widest flex items-center gap-2">
                                <PhoneCall className="w-4 h-4 text-[#166FBB]" /> Activity Timeline
                            </h3>
                            {!isLoggingActivity && (
                                <button onClick={() => setIsLoggingActivity(true)} className="text-sm font-bold text-[#166FBB] hover:underline flex items-center gap-1">
                                    <Plus className="w-4 h-4" /> Log Activity
                                </button>
                            )}
                        </div>

                        {isLoggingActivity && (
                            <div className="mb-6 p-4 bg-[#F8FAFC] border border-[#E2E8F0] rounded-2xl">
                                <div className="flex items-center justify-between mb-4">
                                    <h4 className="text-xs font-black text-[#0F172A] uppercase tracking-widest">Record Interaction</h4>
                                    <button onClick={() => setIsLoggingActivity(false)} className="text-[#64748B] hover:text-[#0F172A]">
                                        <X className="w-4 h-4" />
                                    </button>
                                </div>
                                <div className="space-y-3">
                                    <div className="flex gap-2">
                                        <select 
                                            className="px-4 py-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB] bg-white w-1/3"
                                            value={newActivity.type}
                                            onChange={e => setNewActivity({...newActivity, type: e.target.value})}
                                        >
                                            <option value="call">📞 Phone Call</option>
                                            <option value="email">✉️ Email</option>
                                            <option value="meeting">🤝 Meeting</option>
                                        </select>
                                        <input 
                                            type="number"
                                            placeholder="Duration (mins)"
                                            className="w-1/3 px-4 py-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB]"
                                            value={newActivity.duration}
                                            onChange={e => setNewActivity({...newActivity, duration: parseInt(e.target.value) || 0})}
                                        />
                                    </div>
                                    <input 
                                        type="text"
                                        placeholder="Brief description (e.g. Discussed Q3 roadmap)"
                                        className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] text-sm focus:outline-none focus:border-[#166FBB]"
                                        value={newActivity.description}
                                        onChange={e => setNewActivity({...newActivity, description: e.target.value})}
                                    />
                                    <div className="flex justify-end pt-2">
                                        <button 
                                            className="px-6 py-2 bg-[#166FBB] text-white text-xs font-bold rounded-xl hover:bg-[#125A96]"
                                            onClick={() => {
                                                if(!newActivity.description) return;
                                                const logObj = { id: Date.now(), ...newActivity, logged_at: new Date().toISOString() };
                                                setLogs([logObj, ...logs]);
                                                setIsLoggingActivity(false);
                                                setNewActivity({ type: 'call', description: '', duration: 15 });
                                            }}
                                        >
                                            Save Log
                                        </button>
                                    </div>
                                </div>
                            </div>
                        )}

                        {logs.length === 0 && !isLoggingActivity ? (
                            <div className="text-center py-12">
                                <Calendar className="w-12 h-12 text-slate-200 mx-auto mb-3" />
                                <h4 className="font-bold text-slate-700">No activity recorded</h4>
                                <p className="text-sm text-slate-500 mt-1">Log phone calls, emails, and meetings to keep track of interactions.</p>
                            </div>
                        ) : (
                            <div className="space-y-4">
                                {logs.map(log => (
                                    <div key={log.id} className="p-4 border border-[#E2E8F0] rounded-2xl bg-white flex items-start gap-4">
                                        <div className="w-10 h-10 rounded-full bg-slate-50 border border-[#E2E8F0] flex items-center justify-center shrink-0">
                                            {log.type === 'call' ? <PhoneCall className="w-4 h-4 text-emerald-500" /> :
                                             log.type === 'email' ? <Mail className="w-4 h-4 text-blue-500" /> :
                                             <MessageSquare className="w-4 h-4 text-purple-500" />}
                                        </div>
                                        <div className="flex-1">
                                            <div className="flex items-center justify-between mb-1">
                                                <h4 className="text-sm font-bold text-[#0F172A] capitalize">{log.type}</h4>
                                                <span className="text-xs text-[#94A3B8] font-medium">
                                                    {new Date(log.logged_at).toLocaleDateString()}
                                                </span>
                                            </div>
                                            <p className="text-sm text-[#64748B] mb-2">{log.description}</p>
                                            {log.duration > 0 && (
                                                <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-[10px] font-bold bg-slate-100 text-slate-500">
                                                    ⏱ {log.duration} mins
                                                </span>
                                            )}
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}
