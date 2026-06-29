'use client';

import React from 'react';
import { useInvoiceCreator } from './InvoiceCreatorContext';
import { TemplateEngine } from '@/components/invoice/TemplateEngine';
import { LayoutTemplate } from 'lucide-react';

export const InvoicePreviewPanel = () => {
    const { 
        selectedTemplate, customAccentColor, invoiceNumber, dueDate, 
        clients, selectedClientId, items, subtotal, taxTotal, discountTotal, total,
        currencySymbol, notes, bankName, accountName, accountNumber, signatureUrl, teamData, invoiceType
    } = useInvoiceCreator();

    return (
        <div className="h-full bg-[#F8FAFC] p-8 lg:p-12 flex flex-col justify-center items-center relative overflow-hidden">
            {/* Ambient Background Grid */}
            <div className="absolute inset-0 opacity-20 pointer-events-none" style={{ backgroundImage: 'radial-gradient(#166FBB 1px, transparent 1px)', backgroundSize: '32px 32px' }} />
            
            {/* Status Pill */}
            <div className="absolute top-8 right-8 z-30 flex items-center gap-2 px-4 py-2 bg-white/90 backdrop-blur-md rounded-full shadow-sm border border-slate-200">
                <div className="w-2 h-2 bg-[#166FBB] rounded-full animate-pulse" />
                <span className="text-[10px] font-black uppercase tracking-widest text-[#0F172A]">Live 3D Preview</span>
            </div>

            {/* Premium Preview Card */}
            <div className="w-full max-w-[850px] relative group perspective-[2000px]">
                {/* Scale Container to fit the 1100px invoice */}
                <div 
                    className="bg-white rounded-3xl shadow-[0_40px_100px_-20px_rgba(0,0,0,0.2)] overflow-hidden transition-all duration-700 ease-[cubic-bezier(0.23,1,0.32,1)] origin-center relative transform group-hover:scale-105"
                    style={{ aspectRatio: '8.5/11' }}
                >
                    <div className="w-full h-full relative" style={{ transform: 'scale(0.77)', transformOrigin: 'top left', width: '130%', height: '130%' }}>
                        <div id="invoice-preview-element" className="w-[1100px] h-[1424px] bg-white absolute top-0 left-0">
                            <TemplateEngine 
                                template={{
                                    ...selectedTemplate,
                                    accentColor: customAccentColor || selectedTemplate.accentColor
                                }} 
                                data={{
                                    invoiceNumber,
                                    date: new Date().toLocaleDateString(),
                                    dueDate: dueDate ? new Date(dueDate).toLocaleDateString() : 'Upon Receipt',
                                    client: clients.find(c => c.id === selectedClientId) || { name: 'Client Name', address: 'Client Address' },
                                    items: items.length > 0 ? items : [{ name: 'Sample Item', quantity: 1, price: 100 }],
                                    subtotal,
                                    taxTotal,
                                    discountTotal,
                                    total,
                                    currencySymbol,
                                    notes,
                                    bankDetails: {
                                        name: bankName,
                                        accountName,
                                        accountNumber
                                    },
                                    signatureUrl,
                                    sender: teamData
                                }} 
                            />
                        </div>
                    </div>
                </div>

                {/* Floating summary label */}
                <div className="absolute -bottom-6 left-1/2 -translate-x-1/2 px-6 py-4 bg-[#0F172A] text-white rounded-2xl shadow-2xl flex items-center gap-4 transition-transform group-hover:-translate-y-4">
                    <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center">
                        <LayoutTemplate className="w-5 h-5" />
                    </div>
                    <div>
                        <p className="text-[10px] font-black uppercase tracking-widest text-slate-300">{selectedTemplate.name}</p>
                        <p className="text-sm font-bold mt-1">{currencySymbol}{total.toLocaleString()}</p>
                    </div>
                </div>
            </div>
        </div>
    );
};
