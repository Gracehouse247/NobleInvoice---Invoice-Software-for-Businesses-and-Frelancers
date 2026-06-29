'use client';

import React, { useState } from 'react';
import { useInvoiceCreator } from './InvoiceCreatorContext';
import { InvoiceWizardForm } from './InvoiceWizardForm';
import { InvoicePreviewPanel } from './InvoicePreviewPanel';
import { ChevronLeft, FileText, Truck, BarChart, RefreshCw, CheckCircle, ArrowDownCircle, ArrowUpCircle, ArrowLeftRight, Calculator, Share2, FileDown, Download, Home, Plus } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { downloadAsImage, downloadAsPDF, shareInvoice } from '@/lib/exportUtils';
import { ChooseTemplateDialog } from '@/components/invoice/ChooseTemplateDialog';
import { motion } from 'framer-motion';

const INVOICE_TYPES = [
    { id: 'standard', title: 'Standard Invoice', desc: 'A standard bill for completed goods or services.', icon: FileText, color: 'text-blue-600', bg: 'bg-blue-600/10' },
    { id: 'proforma', title: 'Proforma Invoice', desc: 'A preliminary quote before final billing. Not a legal doc.', icon: FileText, color: 'text-purple-600', bg: 'bg-purple-600/10' },
    { id: 'commercial', title: 'Commercial Invoice', desc: 'Used for international trade and customs clearance.', icon: Truck, color: 'text-teal-600', bg: 'bg-teal-600/10' },
    { id: 'progress', title: 'Progress Invoice', desc: 'Bill for a portion of a larger project at a milestone.', icon: BarChart, color: 'text-[#006970]', bg: 'bg-[#006970]/10' },
    { id: 'recurring', title: 'Recurring Invoice', desc: 'Automatically re-issues on a set schedule.', icon: RefreshCw, color: 'text-green-600', bg: 'bg-green-600/10' },
    { id: 'final', title: 'Final Invoice', desc: 'The last invoice for a project, closing all outstanding amounts.', icon: CheckCircle, color: 'text-blue-700', bg: 'bg-blue-700/10' },
    { id: 'credit_memo', title: 'Credit Memo', desc: "Issue a credit to reduce a client's outstanding balance.", icon: ArrowDownCircle, color: 'text-orange-600', bg: 'bg-orange-600/10' },
    { id: 'debit_memo', title: 'Debit Memo', desc: 'Increase the amount a client owes for additional charges.', icon: ArrowUpCircle, color: 'text-red-600', bg: 'bg-red-600/10' },
    { id: 'mixed', title: 'Mixed Invoice', desc: 'Combine credit and debit charges on a single invoice layout.', icon: ArrowLeftRight, color: 'text-amber-600', bg: 'bg-amber-600/10' },
    { id: 'estimate', title: 'Estimate', desc: 'A detailed list of costs for a project. Not a bill.', icon: Calculator, color: 'text-slate-600', bg: 'bg-slate-600/10' },
    { id: 'quote', title: 'Quote', desc: 'A fixed price offer that can be accepted by the client.', icon: CheckCircle, color: 'text-emerald-600', bg: 'bg-emerald-600/10' },
];

export const InvoiceCreatorLayout = () => {
    const { 
        step, setStep, setInvoiceType, 
        loading, invoiceNumber, dueDate, selectedClientId, 
        clients, total, currencySymbol,
        selectedTemplate, setSelectedTemplate, currencyCode
    } = useInvoiceCreator();
    
    const router = useRouter();
    // Only mount the template dialog when explicitly opened — prevents the crash
    // caused by rendering 40+ scaled TemplateEngine instances simultaneously
    const [isTemplateDialogOpen, setIsTemplateDialogOpen] = useState(false);

    // Navigation guard prompt to prevent loss of unsaved invoice changes
    React.useEffect(() => {
        if (step !== 'form') return;
        const handleBeforeUnload = (e: BeforeUnloadEvent) => {
            e.preventDefault();
            e.returnValue = 'You have unsaved changes. Are you sure you want to discard your draft?';
            return e.returnValue;
        };
        window.addEventListener('beforeunload', handleBeforeUnload);
        return () => window.removeEventListener('beforeunload', handleBeforeUnload);
    }, [step]);

    if (loading) return (
        <div className="h-screen flex items-center justify-center bg-[#F8FAFC]">
            <div className="w-10 h-10 border-4 border-[#166FBB] border-t-transparent rounded-full animate-spin" />
        </div>
    );

    if (step === 'select-type') {
        return (
            <div className="min-h-screen bg-[#F8FAFC] py-6 px-4 md:px-8 flex flex-col justify-center">
                <div className="max-w-7xl mx-auto w-full">
                    <button 
                        onClick={() => router.back()}
                        className="flex items-center gap-2 text-slate-500 hover:text-[#166FBB] transition-colors font-black text-[10px] uppercase tracking-widest mb-6"
                    >
                        <ChevronLeft className="w-4 h-4" /> Back to List
                    </button>
                    
                    <div className="bg-white rounded-[32px] p-6 lg:p-8 border border-[#E2E8F0] shadow-sm mb-8">
                        <h1 className="text-2xl lg:text-3xl font-black text-[#0F172A] tracking-tight mb-2">Select Invoice Type</h1>
                        <p className="text-[#64748B] text-sm font-medium">Choose from our specialized invoice formats to perfectly match your billing operation.</p>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-5">
                        {INVOICE_TYPES.map((type) => {
                            const Icon = type.icon;
                            return (
                                <button
                                    key={type.id}
                                    onClick={() => { setInvoiceType(type.id); setStep('form'); }}
                                    className="bg-white border border-[#E2E8F0] rounded-[24px] p-5 text-left hover:border-[#166FBB] hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group flex flex-col items-center justify-center overflow-hidden"
                                >
                                    <div className={`w-12 h-12 rounded-2xl ${type.bg} flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300`}>
                                        <Icon className={`w-5 h-5 ${type.color}`} />
                                    </div>
                                    <h3 className="text-sm font-semibold text-[#0F172A] mb-2 text-center leading-tight">{type.title}</h3>
                                    <p className="text-[11px] text-[#64748B] font-medium text-center leading-relaxed line-clamp-2">{type.desc}</p>
                                </button>
                            );
                        })}
                    </div>
                </div>
            </div>
        );
    }

    if (step === 'success') {
        return (
            <div className="min-h-screen bg-[#F8FAFC] py-12 px-4 md:px-8">
                <div className="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                    <div className="lg:col-span-5 space-y-8">
                        <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} className="w-20 h-20 bg-green-500 rounded-[28px] flex items-center justify-center text-white shadow-2xl shadow-green-500/30">
                            <CheckCircle className="w-10 h-10 stroke-[3]" />
                        </motion.div>
                        <div>
                            <h1 className="text-4xl font-black text-[#0F172A] tracking-tight">Invoice Issued!</h1>
                            <p className="text-lg font-medium text-[#64748B] mt-2">Your invoice <span className="text-[#0F172A] font-bold">#{invoiceNumber}</span> has been finalized.</p>
                        </div>
                        <div className="bg-white p-8 rounded-[32px] border border-[#E2E8F0] shadow-sm space-y-6">
                            <p className="text-[11px] font-black text-[#64748B] uppercase tracking-[0.2em] pb-6 border-b border-[#F1F5F9]">Summary</p>
                            <div className="space-y-4">
                                <div className="flex justify-between"><span className="text-sm font-medium text-[#64748B]">Client</span><span className="text-sm font-bold text-[#0F172A]">{clients.find(c => c.id === selectedClientId)?.name}</span></div>
                                <div className="flex justify-between"><span className="text-sm font-medium text-[#64748B]">Due Date</span><span className="text-sm font-bold text-[#0F172A]">{dueDate || 'Upon Receipt'}</span></div>
                                <div className="pt-4 flex justify-between border-t border-[#F1F5F9]">
                                    <span className="text-base font-black text-[#0F172A] uppercase tracking-wider">Total Amount</span>
                                    <span className="text-2xl font-black text-[#166FBB]">{currencySymbol}{total.toLocaleString()}</span>
                                </div>
                            </div>
                        </div>
                        <div className="grid grid-cols-1 gap-4">
                            <button onClick={() => shareInvoice('invoice-preview-element', `Invoice_${invoiceNumber}`, `Invoice ${invoiceNumber}`)} className="h-16 bg-[#0F172A] text-white rounded-[20px] font-black text-[11px] uppercase tracking-[0.2em] shadow-xl hover:scale-[1.02] active:scale-95 transition-all flex items-center justify-center gap-3">
                                <Share2 className="w-5 h-5" /> Share Invoice Link
                            </button>
                            <div className="grid grid-cols-2 gap-4">
                                <button onClick={() => downloadAsPDF('invoice-preview-element', `Invoice_${invoiceNumber}`)} className="h-16 bg-white border border-[#E2E8F0] text-[#0F172A] rounded-[20px] font-black text-[11px] uppercase tracking-[0.2em] shadow-sm hover:border-[#166FBB] hover:text-[#166FBB] transition-all flex items-center justify-center gap-3">
                                    <FileDown className="w-5 h-5" /> Download PDF
                                </button>
                                <button onClick={() => downloadAsImage('invoice-preview-element', `Invoice_${invoiceNumber}`)} className="h-16 bg-white border border-[#E2E8F0] text-[#0F172A] rounded-[20px] font-black text-[11px] uppercase tracking-[0.2em] shadow-sm hover:border-[#166FBB] hover:text-[#166FBB] transition-all flex items-center justify-center gap-3">
                                    <Download className="w-5 h-5" /> Save Image
                                </button>
                            </div>
                        </div>
                        <div className="flex items-center gap-4 pt-4">
                            <button onClick={() => window.location.reload()} className="flex-1 h-14 bg-slate-100 text-[#0F172A] rounded-2xl font-black text-[10px] uppercase tracking-widest hover:bg-slate-200 transition-all flex items-center justify-center gap-2">
                                <Plus className="w-4 h-4" /> Create Another
                            </button>
                            <button onClick={() => router.push('/dashboard')} className="flex-1 h-14 bg-slate-100 text-[#0F172A] rounded-2xl font-black text-[10px] uppercase tracking-widest hover:bg-slate-200 transition-all flex items-center justify-center gap-2">
                                <Home className="w-4 h-4" /> Dashboard
                            </button>
                        </div>
                    </div>
                    <div className="lg:col-span-7"><InvoicePreviewPanel /></div>
                </div>
            </div>
        );
    }

    return (
        <div className="h-screen w-full flex flex-col md:flex-row overflow-hidden bg-white">
            <div className="w-full md:w-5/12 lg:w-[45%] h-full shrink-0 overflow-hidden">
                <InvoiceWizardForm />
            </div>

            <div className="hidden md:block flex-1 h-full relative border-l border-slate-200">
                <button 
                    onClick={() => setIsTemplateDialogOpen(true)}
                    className="absolute top-8 left-8 z-40 bg-white/90 backdrop-blur-md border border-slate-200 shadow-lg h-10 px-4 rounded-xl flex items-center gap-2 font-black text-[10px] uppercase tracking-widest text-[#0F172A] hover:bg-white hover:scale-105 transition-all"
                >
                    🎨 Change Design
                </button>
                <InvoicePreviewPanel />
            </div>

            {/* Lazy-mounted: only renders when open, preventing the 40+ TemplateEngine crash */}
            {isTemplateDialogOpen && (
                <ChooseTemplateDialog 
                    isOpen={isTemplateDialogOpen}
                    onClose={() => setIsTemplateDialogOpen(false)}
                    onSelect={(template) => {
                        setSelectedTemplate(template);
                        setIsTemplateDialogOpen(false);
                    }}
                    selectedTemplateId={selectedTemplate?.id}
                    currencySymbol={currencySymbol}
                    currencyCode={currencyCode}
                />
            )}
        </div>
    );
};
