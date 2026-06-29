'use client';

import React, { useEffect, useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { clientService } from '@/lib/services/supabaseService';
import { ArrowLeft, Download, Building, CheckCircle2, Clock, AlertCircle } from 'lucide-react';
import { motion } from 'framer-motion';

import { currencyService } from '@/lib/services/currencyService';

export default function PortalInvoiceView() {
    const params = useParams();
    const router = useRouter();
    const token = params?.token as string;
    const invoiceId = params?.id as string;
    
    const [invoice, setInvoice] = useState<any>(null);
    const [client, setClient] = useState<any>(null);

    useEffect(() => {
        if (!token || !invoiceId) return;
        clientService.getPortalData(token).then(res => {
            if (res) {
                setClient(res.client);
                const inv = res.invoices?.find((i: any) => String(i.id) === String(invoiceId));
                setInvoice(inv || null);
            }
        }).catch(console.error);
    }, [token, invoiceId]);

    if (!invoice || !client) return null;

    const formatCurrency = (amount: number) => {
        return currencyService.format(amount, invoice.currency_code || 'NGN', { decimals: 2 });
    };

    const getStatusConfig = (status: string) => {
        switch (status) {
            case 'paid': return { color: 'text-emerald-500', bg: 'bg-emerald-50', border: 'border-emerald-200', icon: CheckCircle2, label: 'PAID IN FULL' };
            case 'pending': return { color: 'text-amber-500', bg: 'bg-amber-50', border: 'border-amber-200', icon: Clock, label: 'PAYMENT PENDING' };
            case 'overdue': return { color: 'text-rose-500', bg: 'bg-rose-50', border: 'border-rose-200', icon: AlertCircle, label: 'OVERDUE' };
            default: return { color: 'text-slate-500', bg: 'bg-slate-50', border: 'border-slate-200', icon: Clock, label: status.toUpperCase() };
        }
    };

    const StatusIcon = getStatusConfig(invoice.status).icon;
    const statusConfig = getStatusConfig(invoice.status);

    return (
        <div className="max-w-4xl mx-auto px-4 md:px-8 py-12">
            <button 
                onClick={() => router.push(`/portal/${token}`)}
                className="flex items-center gap-2 text-sm font-bold text-slate-500 hover:text-noble-blue transition-colors mb-8"
            >
                <ArrowLeft size={16} /> Back to Dashboard
            </button>

            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="bg-white rounded-[40px] shadow-[0_40px_80px_rgba(0,0,0,0.04)] border border-slate-100 overflow-hidden">
                {/* Header Section */}
                <div className="p-10 md:p-16 border-b border-slate-100 relative overflow-hidden">
                    <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-noble-blue/5 rounded-full blur-[80px] -translate-y-1/2 translate-x-1/4 pointer-events-none" />
                    
                    <div className="flex flex-col md:flex-row md:items-end justify-between gap-8 relative z-10">
                        <div>
                            <div className="w-16 h-16 bg-slate-50 border border-slate-100 rounded-2xl flex items-center justify-center text-slate-400 mb-6">
                                <Building size={32} />
                            </div>
                            <h1 className="text-4xl font-black text-slate-900 tracking-tighter mb-2">Invoice {invoice.invoice_number}</h1>
                            <div className="text-slate-500 font-medium">Billed to: <span className="font-bold text-slate-700">{client.name}</span></div>
                        </div>
                        <div className="text-left md:text-right">
                            <div className={`inline-flex items-center gap-2 px-4 py-2 rounded-xl border ${statusConfig.bg} ${statusConfig.border} ${statusConfig.color} font-black text-xs uppercase tracking-widest mb-6`}>
                                <StatusIcon size={14} /> {statusConfig.label}
                            </div>
                            <div className="grid grid-cols-2 gap-x-8 gap-y-2 text-sm">
                                <div className="text-slate-500 font-bold">Issue Date</div>
                                <div className="text-slate-900 font-black">{invoice.issue_date}</div>
                                <div className="text-slate-500 font-bold">Due Date</div>
                                <div className="text-slate-900 font-black">{invoice.due_date}</div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Summary Section (Alternative to line items) */}
                <div className="p-10 md:p-16 bg-slate-50/50">
                    <h3 className="text-lg font-black text-slate-900 tracking-tight mb-6">Financial Summary</h3>
                    
                    <div className="space-y-4">
                        <div className="flex items-center justify-between py-4 border-b border-slate-100">
                            <span className="text-slate-600 font-medium">Subtotal</span>
                            <span className="text-slate-900 font-bold">{formatCurrency(invoice.subtotal || 0)}</span>
                        </div>
                        <div className="flex items-center justify-between py-4 border-b border-slate-100">
                            <span className="text-slate-600 font-medium">Tax ({invoice.tax_rate}%)</span>
                            <span className="text-slate-900 font-bold">{formatCurrency(invoice.tax_amount || 0)}</span>
                        </div>
                        {invoice.discount_amount > 0 && (
                            <div className="flex items-center justify-between py-4 border-b border-slate-100 text-emerald-600">
                                <span className="font-medium">Discount</span>
                                <span className="font-bold">-{formatCurrency(invoice.discount_amount)}</span>
                            </div>
                        )}
                        <div className="flex items-center justify-between py-6">
                            <span className="text-xl font-black text-slate-900 uppercase tracking-tight">Total Amount</span>
                            <span className="text-3xl font-black text-noble-blue tracking-tighter">{formatCurrency(invoice.total_amount)}</span>
                        </div>
                    </div>
                </div>

                {/* Payment Information */}
                {invoice.metadata?.bank_name && (
                    <div className="p-10 md:p-16 border-t border-slate-100 bg-white">
                        <h3 className="text-sm font-black text-slate-400 uppercase tracking-widest mb-4">Payment Instructions</h3>
                        <div className="bg-slate-50 p-6 rounded-2xl border border-slate-100 max-w-md">
                            <div className="space-y-2 text-sm">
                                <div className="flex justify-between"><span className="text-slate-500">Bank</span><span className="font-bold text-slate-900">{invoice.metadata.bank_name}</span></div>
                                <div className="flex justify-between"><span className="text-slate-500">Account Name</span><span className="font-bold text-slate-900">{invoice.metadata.account_name}</span></div>
                                <div className="flex justify-between"><span className="text-slate-500">Account No.</span><span className="font-black text-noble-blue tracking-wider">{invoice.metadata.account_number}</span></div>
                            </div>
                        </div>
                    </div>
                )}
            </motion.div>
        </div>
    );
}
