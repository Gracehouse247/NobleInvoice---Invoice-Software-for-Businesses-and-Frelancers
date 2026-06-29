'use client';

import React from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { 
    Globe, Wifi, Contact, Briefcase, Utensils, Share2, 
    Mail, MessageSquare, Smartphone, MapPin, AlignLeft, 
    FileText, Image as ImageIcon, Video, Calendar, 
    Bitcoin, MessageCircle, Ticket, Music, PhoneCall,
    FolderOpen, MoreVertical, Plus, QrCode, Package
} from 'lucide-react';

const QR_TYPES = [
    { id: 'product', name: 'Product Passport', icon: Package },
    { id: 'website', name: 'Website', icon: Globe },
    { id: 'wifi', name: 'WiFi', icon: Wifi },
    { id: 'vcard', name: 'vCard', icon: Contact },
    { id: 'business', name: 'Business', icon: Briefcase },
    { id: 'menu', name: 'Menu', icon: Utensils },
    { id: 'social', name: 'Social Media', icon: Share2 },
    { id: 'email', name: 'Email', icon: Mail },
    { id: 'sms', name: 'SMS', icon: MessageSquare },
    { id: 'appstore', name: 'App Store', icon: Smartphone },
    { id: 'location', name: 'Location', icon: MapPin },
    { id: 'text', name: 'Text', icon: AlignLeft },
    { id: 'pdf', name: 'PDF', icon: FileText },
    { id: 'image', name: 'Image', icon: ImageIcon },
    { id: 'video', name: 'Video', icon: Video },
    { id: 'event', name: 'Event', icon: Calendar },
    { id: 'bitcoin', name: 'Bitcoin', icon: Bitcoin },
    { id: 'whatsapp', name: 'WhatsApp', icon: MessageCircle },
    { id: 'coupon', name: 'Coupon', icon: Ticket },
    { id: 'mp3', name: 'MP3', icon: Music },
    { id: 'call', name: 'Call', icon: PhoneCall },
];

export default function QrGeneratorDashboard() {
    const router = useRouter();

    const handleTypeSelect = (typeId: string) => {
        router.push(`/qr-generator/create?type=${typeId}`);
    };

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Dynamic Header */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-10 shadow-[0_20px_40px_rgba(0,0,0,0.02)] mb-12">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6 relative">
                    <div className="flex items-center gap-5">
                        <div className="w-14 h-14 rounded-[20px] bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center text-noble-blue border border-white/50 shadow-inner">
                            <QrCode className="w-7 h-7 fill-current opacity-80" />
                        </div>
                        <div>
                            <div className="inline-flex items-center gap-2 px-3 py-1 bg-noble-blue/10 border border-noble-blue/20 rounded-xl mb-2 shadow-sm">
                                <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                                <span className="text-[9px] font-black tracking-[0.2em] text-noble-blue uppercase">20 Engine Types Active</span>
                            </div>
                            <h1 className="text-xl md:text-2xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                QR <span className="text-noble-blue">Generator</span>
                            </h1>
                        </div>
                    </div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 relative z-20">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
                    
                    {/* Main Types Grid */}
                    <div className="lg:col-span-8 bg-white/40 backdrop-blur-2xl rounded-[40px] p-10 border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] relative overflow-hidden">
                        <div className="absolute top-[-20%] right-[-10%] w-[400px] h-[400px] bg-electric-cyan/5 blur-[80px] rounded-full pointer-events-none" />
                        
                        <h3 className="text-xl md:text-2xl font-semibold text-slate-900 mb-8 flex items-center gap-3 tracking-tight relative z-10" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            <div className="p-2 bg-white/60 rounded-xl shadow-sm border border-white">
                                <QrCode className="w-5 h-5 text-noble-blue" />
                            </div>
                            Select QR Type
                        </h3>
                        
                        <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-5 relative z-10">
                            {QR_TYPES.map((type) => (
                                <button 
                                    key={type.id}
                                    onClick={() => handleTypeSelect(type.id)}
                                    className="flex flex-col items-center justify-center p-5 rounded-[24px] bg-white/60 backdrop-blur-md border border-white/60 hover:border-noble-blue/40 hover:bg-white hover:shadow-[0_20px_40px_rgba(22,111,187,0.1)] hover:-translate-y-1.5 transition-all duration-300 group"
                                >
                                    <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-slate-100 to-white flex items-center justify-center shadow-inner border border-white text-slate-500 mb-4 group-hover:bg-gradient-to-br group-hover:from-noble-blue group-hover:to-blue-600 group-hover:text-white transition-all duration-300">
                                        <type.icon className="w-6 h-6" />
                                    </div>
                                    <span className="text-[10px] font-bold text-slate-700 uppercase tracking-widest text-center leading-tight group-hover:text-noble-blue transition-colors">
                                        {type.name}
                                    </span>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Sidebar: Folders & Activity */}
                    <div className="lg:col-span-4 space-y-8">
                        {/* Folders */}
                        <div className="bg-white/40 backdrop-blur-2xl rounded-[32px] p-8 border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.02)] relative overflow-hidden">
                            <div className="absolute top-[-20%] left-[-20%] w-[200px] h-[200px] bg-amber-400/5 blur-[50px] rounded-full pointer-events-none" />
                            
                            <div className="flex items-center justify-between mb-6 relative z-10">
                                <h3 className="text-[11px] font-black text-slate-500 uppercase tracking-[0.2em] flex items-center gap-2">
                                    <FolderOpen className="w-4 h-4 text-noble-blue" />
                                    Folders
                                </h3>
                                <button className="w-10 h-10 rounded-[14px] bg-white/80 border border-white shadow-sm flex items-center justify-center text-noble-blue hover:bg-noble-blue hover:text-white hover:shadow-md transition-all">
                                    <Plus className="w-4 h-4" />
                                </button>
                            </div>
                            <div className="space-y-3 relative z-10">
                                {/* Sample Folders */}
                                <div className="flex items-center justify-between p-4 rounded-2xl bg-white/60 backdrop-blur-md border border-white/60 hover:border-noble-blue/30 hover:bg-white hover:shadow-[0_10px_20px_rgba(22,111,187,0.05)] transition-all cursor-pointer group">
                                    <div className="flex items-center gap-4">
                                        <div className="w-10 h-10 rounded-[14px] bg-amber-50 border border-amber-100 shadow-inner flex items-center justify-center text-amber-500">
                                            <Briefcase className="w-5 h-5" />
                                        </div>
                                        <span className="text-sm font-black text-slate-900 group-hover:text-noble-blue transition-colors" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Marketing Q1</span>
                                    </div>
                                    <span className="text-[10px] font-black text-slate-400 bg-white px-2 py-1 rounded-lg border border-slate-100 shadow-sm">12</span>
                                </div>
                                <div className="flex items-center justify-between p-4 rounded-2xl bg-white/60 backdrop-blur-md border border-white/60 hover:border-noble-blue/30 hover:bg-white hover:shadow-[0_10px_20px_rgba(22,111,187,0.05)] transition-all cursor-pointer group">
                                    <div className="flex items-center gap-4">
                                        <div className="w-10 h-10 rounded-[14px] bg-emerald-50 border border-emerald-100 shadow-inner flex items-center justify-center text-emerald-500">
                                            <Smartphone className="w-5 h-5" />
                                        </div>
                                        <span className="text-sm font-black text-slate-900 group-hover:text-noble-blue transition-colors" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>App Downloads</span>
                                    </div>
                                    <span className="text-[10px] font-black text-slate-400 bg-white px-2 py-1 rounded-lg border border-slate-100 shadow-sm">4</span>
                                </div>
                            </div>
                        </div>

                        {/* Recent Activity */}
                        <div className="bg-white/40 backdrop-blur-2xl rounded-[32px] p-8 border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.02)] relative overflow-hidden">
                            <div className="flex items-center justify-between mb-6 relative z-10">
                                <h3 className="text-[11px] font-black text-slate-500 uppercase tracking-[0.2em] flex items-center gap-2">
                                    <QrCode className="w-4 h-4 text-noble-blue" />
                                    Recent Activity
                                </h3>
                                <Link href="#" className="text-[9px] font-black uppercase tracking-[0.2em] text-noble-blue hover:text-blue-700 bg-white/50 px-3 py-1.5 rounded-lg border border-white">View All</Link>
                            </div>
                            <div className="space-y-4 relative z-10">
                                {/* Sample Activity Item */}
                                <div className="flex items-start justify-between p-4 rounded-2xl bg-white/60 backdrop-blur-md border border-white/60 hover:border-noble-blue/30 hover:bg-white shadow-sm transition-all">
                                    <div className="flex gap-4">
                                        <div className="w-12 h-12 rounded-[16px] bg-white border border-white/60 flex items-center justify-center flex-shrink-0 shadow-inner">
                                            <QrCode className="w-6 h-6 text-slate-400" />
                                        </div>
                                        <div className="pt-1">
                                            <p className="text-sm font-black text-slate-900 leading-tight mb-1.5" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Summer Menu 2024</p>
                                            <p className="text-[9px] font-bold text-slate-400 uppercase tracking-[0.2em]">PDF • 2d ago</p>
                                        </div>
                                    </div>
                                    <button className="text-slate-400 hover:text-noble-blue p-2 bg-white/50 rounded-xl border border-transparent hover:border-noble-blue/20 hover:shadow-sm transition-all mt-1">
                                        <MoreVertical className="w-4 h-4" />
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    );
}
