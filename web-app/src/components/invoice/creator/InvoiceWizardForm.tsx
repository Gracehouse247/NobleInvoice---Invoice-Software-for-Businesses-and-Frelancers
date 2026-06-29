'use client';

import React, { useState, useRef } from 'react';
import { useInvoiceCreator } from './InvoiceCreatorContext';
import { ChevronRight, ChevronLeft, User, Package, Calculator, CreditCard, Send, Trash2, Plus, Search, X, Upload, Check, ExternalLink } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { toast } from 'react-hot-toast';
import { useRouter } from 'next/navigation';

const CURRENCIES = [
    { code: 'NGN', symbol: '₦', label: 'Nigerian Naira' },
    { code: 'USD', symbol: '$', label: 'US Dollar' },
    { code: 'GBP', symbol: '£', label: 'British Pound' },
    { code: 'EUR', symbol: '€', label: 'Euro' },
    { code: 'GHS', symbol: 'GH₵', label: 'Ghanaian Cedi' },
    { code: 'KES', symbol: 'KSh', label: 'Kenyan Shilling' },
    { code: 'ZAR', symbol: 'R', label: 'South African Rand' },
    { code: 'CAD', symbol: 'CA$', label: 'Canadian Dollar' },
    { code: 'AUD', symbol: 'A$', label: 'Australian Dollar' },
];

const inputClass = "w-full h-12 px-4 rounded-xl bg-white border border-[#E2E8F0] text-[#0F172A] font-bold text-sm focus:outline-none focus:border-[#166FBB] focus:ring-2 focus:ring-[#166FBB]/10 transition-all";
const labelClass = "text-[10px] font-black text-[#64748B] uppercase tracking-wider mb-1.5 block";

// ── Step 0: CRM Client Picker ─────────────────────────────────────────────────
const ClientStep = () => {
    const { clients, selectedClientId, setSelectedClientId } = useInvoiceCreator();
    const router = useRouter();
    const [search, setSearch] = useState('');

    const filtered = clients.filter(c =>
        c.name?.toLowerCase().includes(search.toLowerCase()) ||
        c.email?.toLowerCase().includes(search.toLowerCase()) ||
        c.company?.toLowerCase().includes(search.toLowerCase())
    );

    const selectedClient = clients.find(c => String(c.id) === selectedClientId);

    return (
        <div className="space-y-5 max-w-lg">
            {/* Selected Client Card */}
            {selectedClient && (
                <div className="flex items-center gap-3 p-4 bg-[#EEF6FF] border-2 border-[#166FBB] rounded-2xl">
                    <div className="w-10 h-10 rounded-xl bg-[#166FBB] text-white flex items-center justify-center font-black text-sm shrink-0">
                        {selectedClient.name?.charAt(0).toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                        <p className="font-black text-[#0F172A] text-sm truncate">{selectedClient.name}</p>
                        <p className="text-xs text-[#64748B] font-medium truncate">{selectedClient.company || selectedClient.email}</p>
                    </div>
                    <button onClick={() => setSelectedClientId('')} className="w-7 h-7 rounded-lg bg-white/80 flex items-center justify-center text-slate-400 hover:text-red-500 transition-colors shrink-0">
                        <X className="w-3.5 h-3.5" />
                    </button>
                </div>
            )}

            {/* Search */}
            <div className="relative">
                <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-300" />
                <input
                    type="text"
                    placeholder="Search by name, email, or company..."
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                    className="w-full h-12 pl-10 pr-4 rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] font-bold text-sm text-[#0F172A] focus:outline-none focus:border-[#166FBB] transition-all"
                />
            </div>

            {/* Client List */}
            <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
                {clients.length === 0 && (
                    <div className="text-center py-8 space-y-2">
                        <p className="text-[#64748B] text-sm font-medium">No clients yet</p>
                        <p className="text-[#94A3B8] text-xs">Create your first client below</p>
                    </div>
                )}
                {filtered.length === 0 && clients.length > 0 && (
                    <p className="text-center text-[#64748B] text-sm font-medium py-6">No clients match your search</p>
                )}
                {filtered.map(client => (
                    <button
                        key={client.id}
                        onClick={() => setSelectedClientId(String(client.id))}
                        className={`w-full flex items-center gap-3 p-3.5 rounded-xl border-2 transition-all text-left ${selectedClientId === String(client.id) ? 'border-[#166FBB] bg-[#EEF6FF]' : 'border-[#E2E8F0] bg-white hover:border-slate-300'}`}
                    >
                        <div className={`w-9 h-9 rounded-xl flex items-center justify-center font-black text-sm shrink-0 ${selectedClientId === String(client.id) ? 'bg-[#166FBB] text-white' : 'bg-slate-100 text-slate-500'}`}>
                            {client.name?.charAt(0).toUpperCase()}
                        </div>
                        <div className="flex-1 min-w-0">
                            <p className="font-black text-[#0F172A] text-sm truncate">{client.name}</p>
                            <p className="text-[11px] text-[#64748B] font-medium truncate">{client.company || client.email}</p>
                        </div>
                        {selectedClientId === String(client.id) && <Check className="w-4 h-4 text-[#166FBB] shrink-0" />}
                    </button>
                ))}
            </div>

            {/* Create New Client — navigates to full CRM form, returns with newClientId */}
            <button
                onClick={() => router.push('/clients/new?from=invoice')}
                className="w-full h-12 border-2 border-dashed border-[#E2E8F0] hover:border-[#166FBB] hover:text-[#166FBB] rounded-xl flex items-center justify-center gap-2 text-slate-400 font-black text-[11px] uppercase tracking-wider transition-all group"
            >
                <Plus className="w-4 h-4 group-hover:scale-110 transition-transform" />
                Create New Client
                <ExternalLink className="w-3.5 h-3.5 opacity-60" />
            </button>
        </div>
    );
};

// ── Step 1: Invoice Details ───────────────────────────────────────────────────
const DetailsStep = () => {
    const { invoiceNumber, setInvoiceNumber, dueDate, setDueDate, currencyCode, setCurrencyCode } = useInvoiceCreator();
    return (
        <div className="space-y-5 max-w-lg">
            <div><label className={labelClass}>Invoice Number</label><input type="text" value={invoiceNumber} onChange={e => setInvoiceNumber(e.target.value)} className={inputClass} /></div>
            <div><label className={labelClass}>Due Date</label><input type="date" min={new Date().toISOString().split('T')[0]} value={dueDate} onChange={e => setDueDate(e.target.value)} className={inputClass} /></div>
            <div>
                <label className={labelClass}>Currency</label>
                <select value={currencyCode} onChange={e => setCurrencyCode(e.target.value)} className={inputClass + ' cursor-pointer'}>
                    {CURRENCIES.map(c => <option key={c.code} value={c.code}>{c.symbol} — {c.label}</option>)}
                </select>
            </div>
        </div>
    );
};

// ── Step 2: Line Items ────────────────────────────────────────────────────────
const ItemsStep = () => {
    const { items, addItem, removeItem, updateItem, currencySymbol } = useInvoiceCreator();
    return (
        <div className="space-y-3">
            {items.map((item) => (
                <div key={item.id} className="p-4 rounded-2xl bg-[#F8FAFC] border border-[#E2E8F0] space-y-3 hover:border-[#166FBB]/40 transition-all">
                    <div className="flex items-center gap-2">
                        <input type="text" placeholder="Item description" value={item.name} onChange={e => updateItem(item.id, 'name', e.target.value)} className="flex-1 h-10 px-3 rounded-xl bg-white border border-[#E2E8F0] font-bold text-sm focus:outline-none focus:border-[#166FBB] text-[#0F172A]" />
                        {items.length > 1 && (
                            <button onClick={() => removeItem(item.id)} className="w-10 h-10 rounded-xl bg-red-50 hover:bg-red-100 flex items-center justify-center text-red-400 hover:text-red-600 transition-all shrink-0">
                                <Trash2 className="w-3.5 h-3.5" />
                            </button>
                        )}
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                        <div>
                            <label className={labelClass}>Qty</label>
                            <input type="number" min="0" value={item.quantity} onChange={e => updateItem(item.id, 'quantity', parseFloat(e.target.value) || 0)} className="w-full h-10 px-3 rounded-xl bg-white border border-[#E2E8F0] font-bold text-sm focus:outline-none focus:border-[#166FBB] text-[#0F172A]" />
                        </div>
                        <div>
                            <label className={labelClass}>Unit Price</label>
                            <div className="relative">
                                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-[#64748B] font-bold text-xs">{currencySymbol}</span>
                                <input type="number" min="0" value={item.price} onChange={e => updateItem(item.id, 'price', parseFloat(e.target.value) || 0)} className="w-full h-10 pl-7 pr-3 rounded-xl bg-white border border-[#E2E8F0] font-bold text-sm focus:outline-none focus:border-[#166FBB] text-[#0F172A]" />
                            </div>
                        </div>
                    </div>
                    <div className="flex justify-end">
                        <span className="text-xs font-black text-[#166FBB]">= {currencySymbol}{((item.quantity || 0) * (item.price || 0)).toLocaleString()}</span>
                    </div>
                </div>
            ))}
            <button onClick={addItem} className="w-full h-12 border-2 border-dashed border-[#E2E8F0] hover:border-[#166FBB] hover:text-[#166FBB] rounded-xl flex items-center justify-center gap-2 text-slate-400 font-black text-[11px] uppercase tracking-wider transition-all">
                <Plus className="w-4 h-4" /> Add Line Item
            </button>
        </div>
    );
};

// ── Step 3: Financials ────────────────────────────────────────────────────────
const FinancialsStep = () => {
    const { discountType, setDiscountType, discountValue, setDiscountValue, taxType, setTaxType, taxRate, setTaxRate, notes, setNotes, currencySymbol, subtotal, discountTotal, taxTotal, total } = useInvoiceCreator();
    return (
        <div className="space-y-6 max-w-lg">
            <div className="grid grid-cols-2 gap-4">
                <div>
                    <label className={labelClass}>Discount Type</label>
                    <select value={discountType} onChange={e => setDiscountType(e.target.value as any)} className={inputClass + ' cursor-pointer'}>
                        <option value="none">No Discount</option>
                        <option value="percentage">Percentage (%)</option>
                        <option value="flat">Flat Amount</option>
                    </select>
                </div>
                <div>
                    <label className={labelClass}>{discountType === 'flat' ? `Amount (${currencySymbol})` : 'Discount (%)'}</label>
                    <input type="number" min="0" value={discountValue} onChange={e => setDiscountValue(parseFloat(e.target.value) || 0)} disabled={discountType === 'none'} className={inputClass + ' disabled:opacity-40 disabled:cursor-not-allowed'} />
                </div>
                <div>
                    <label className={labelClass}>Tax Type</label>
                    <select value={taxType} onChange={e => setTaxType(e.target.value as any)} className={inputClass + ' cursor-pointer'}>
                        <option value="exclusive">Exclusive (added on top)</option>
                        <option value="inclusive">Inclusive (already included)</option>
                    </select>
                </div>
                <div>
                    <label className={labelClass}>Tax Rate (%)</label>
                    <input type="number" min="0" value={taxRate} onChange={e => setTaxRate(parseFloat(e.target.value) || 0)} className={inputClass} />
                </div>
            </div>
            {/* Live Summary */}
            <div className="p-4 bg-[#F8FAFC] rounded-2xl border border-[#E2E8F0] space-y-2 text-sm">
                <div className="flex justify-between text-[#64748B] font-medium"><span>Subtotal</span><span className="font-bold text-[#0F172A]">{currencySymbol}{subtotal.toLocaleString()}</span></div>
                {discountTotal > 0 && <div className="flex justify-between text-orange-600 font-medium"><span>Discount</span><span>-{currencySymbol}{discountTotal.toLocaleString()}</span></div>}
                {taxTotal > 0 && <div className="flex justify-between text-[#64748B] font-medium"><span>Tax</span><span>{currencySymbol}{taxTotal.toFixed(2)}</span></div>}
                <div className="flex justify-between font-black text-[#0F172A] pt-2 border-t border-[#E2E8F0] text-base"><span>Total</span><span className="text-[#166FBB]">{currencySymbol}{total.toLocaleString()}</span></div>
            </div>
            <div>
                <label className={labelClass}>Notes / Terms</label>
                <textarea value={notes} onChange={e => setNotes(e.target.value)} placeholder="e.g. Thank you for your business. Payment due within 30 days." className="w-full p-4 rounded-xl bg-white border border-[#E2E8F0] font-bold text-sm focus:outline-none focus:border-[#166FBB] resize-none h-28 text-[#0F172A] transition-all" />
            </div>
        </div>
    );
};

// ── Step 4: Payment & Signature ───────────────────────────────────────────────
const PaymentStep = () => {
    const { bankName, setBankName, accountName, setAccountName, accountNumber, setAccountNumber, acceptOnlinePayments, setAcceptOnlinePayments, signatureUrl, setSignatureUrl } = useInvoiceCreator();
    const sigRef = useRef<HTMLInputElement>(null);

    const handleSigUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = ev => setSignatureUrl(ev.target?.result as string);
        reader.readAsDataURL(file);
    };

    return (
        <div className="space-y-5 max-w-lg">
            <div><label className={labelClass}>Bank Name</label><input type="text" value={bankName} onChange={e => setBankName(e.target.value)} placeholder="e.g. First Bank Nigeria" className={inputClass} /></div>
            <div><label className={labelClass}>Account Name</label><input type="text" value={accountName} onChange={e => setAccountName(e.target.value)} placeholder="e.g. Noble World Ltd." className={inputClass} /></div>
            <div><label className={labelClass}>Account Number</label><input type="text" value={accountNumber} onChange={e => setAccountNumber(e.target.value)} placeholder="e.g. 0123456789" className={inputClass} /></div>

            <label className="flex items-center gap-3 p-4 bg-[#F8FAFC] rounded-xl border border-[#E2E8F0] cursor-pointer hover:border-[#166FBB] transition-all">
                <div className={`w-5 h-5 rounded-md border-2 flex items-center justify-center transition-all ${acceptOnlinePayments ? 'bg-[#166FBB] border-[#166FBB]' : 'border-slate-300'}`} onClick={() => setAcceptOnlinePayments(!acceptOnlinePayments)}>
                    {acceptOnlinePayments && <Check className="w-3 h-3 text-white" />}
                </div>
                <div>
                    <p className="text-sm font-black text-[#0F172A]">Accept Online Payments</p>
                    <p className="text-[11px] text-[#64748B] font-medium">Show payment link on invoice</p>
                </div>
            </label>

            {/* Signature */}
            <div className="space-y-2">
                <label className={labelClass}>Authorized Signature</label>
                {signatureUrl ? (
                    <div className="relative h-24 bg-white border-2 border-[#166FBB]/40 rounded-2xl overflow-hidden flex items-center justify-center group">
                        <img src={signatureUrl} alt="Signature" className="max-h-20 max-w-full object-contain" />
                        <button onClick={() => setSignatureUrl(null)} className="absolute top-2 right-2 w-7 h-7 bg-white rounded-lg shadow border border-slate-200 flex items-center justify-center text-red-400 hover:text-red-600 opacity-0 group-hover:opacity-100 transition-all">
                            <X className="w-3.5 h-3.5" />
                        </button>
                    </div>
                ) : (
                    <button onClick={() => sigRef.current?.click()} className="w-full h-24 border-2 border-dashed border-[#E2E8F0] hover:border-[#166FBB] rounded-2xl flex flex-col items-center justify-center gap-2 text-slate-400 hover:text-[#166FBB] transition-all group">
                        <Upload className="w-5 h-5 group-hover:scale-110 transition-transform" />
                        <span className="text-[11px] font-black uppercase tracking-wider">Upload Signature</span>
                        <span className="text-[10px] font-medium text-slate-300">PNG or JPG, transparent background recommended</span>
                    </button>
                )}
                <input ref={sigRef} type="file" accept="image/*" onChange={handleSigUpload} className="hidden" />
            </div>
        </div>
    );
};

// ── Main Wizard Shell ─────────────────────────────────────────────────────────
export const InvoiceWizardForm = () => {
    const { currentWizardStep, setCurrentWizardStep, handleSave, selectedClientId } = useInvoiceCreator();

    const steps = [
        { id: 0, title: 'Select Client', sub: 'Choose from your CRM', icon: User },
        { id: 1, title: 'Invoice Details', sub: 'Number, date, currency', icon: Package },
        { id: 2, title: 'Line Items', sub: 'Products & services', icon: Package },
        { id: 3, title: 'Financials', sub: 'Tax, discount, notes', icon: Calculator },
        { id: 4, title: 'Payment & Sign', sub: 'Bank details, signature', icon: CreditCard },
    ];

    const handleNext = () => {
        if (currentWizardStep === 0 && !selectedClientId) { toast.error('Please select or create a client first'); return; }
        if (currentWizardStep < steps.length - 1) setCurrentWizardStep(currentWizardStep + 1);
    };

    const handleBack = () => { if (currentWizardStep > 0) setCurrentWizardStep(currentWizardStep - 1); };

    const stepContent = [<ClientStep />, <DetailsStep />, <ItemsStep />, <FinancialsStep />, <PaymentStep />];

    return (
        <div className="flex flex-col h-full bg-white border-r border-[#E2E8F0]">
            {/* Header */}
            <div className="px-8 pt-8 pb-6 border-b border-[#E2E8F0]">
                <div className="flex items-center justify-between mb-4">
                    <div>
                        <h2 className="text-xl font-semibold text-[#0F172A] tracking-tight">{steps[currentWizardStep].title}</h2>
                        <p className="text-[10px] font-medium text-slate-400 mt-0.5">{steps[currentWizardStep].sub}</p>
                    </div>
                    <span className="text-[10px] font-black text-[#64748B] uppercase tracking-widest">{currentWizardStep + 1} / {steps.length}</span>
                </div>
                {/* Progress pills */}
                <div className="flex gap-1.5">
                    {steps.map(s => (
                        <button key={s.id} onClick={() => s.id < currentWizardStep && setCurrentWizardStep(s.id)}
                            className={`h-1.5 rounded-full transition-all duration-300 ${s.id === currentWizardStep ? 'flex-[3] bg-[#166FBB]' : s.id < currentWizardStep ? 'flex-1 bg-[#166FBB]/40 cursor-pointer' : 'flex-1 bg-slate-200'}`} />
                    ))}
                </div>
            </div>

            {/* Body */}
            <div className="flex-1 overflow-y-auto px-8 py-6">
                <AnimatePresence mode="wait">
                    <motion.div
                        key={currentWizardStep}
                        initial={{ opacity: 0, x: 16 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -16 }}
                        transition={{ duration: 0.25, ease: 'easeInOut' }}
                    >
                        {stepContent[currentWizardStep]}
                    </motion.div>
                </AnimatePresence>
            </div>

            {/* Footer */}
            <div className="px-8 py-5 border-t border-[#E2E8F0] bg-slate-50 flex items-center justify-between gap-4">
                {currentWizardStep > 0 ? (
                    <button onClick={handleBack} className="h-11 px-5 rounded-xl bg-white border border-[#E2E8F0] text-[#0F172A] font-black text-[10px] uppercase tracking-widest hover:bg-slate-100 transition-all flex items-center gap-2 shadow-sm">
                        <ChevronLeft className="w-4 h-4" /> Back
                    </button>
                ) : <div />}

                {currentWizardStep < steps.length - 1 ? (
                    <button onClick={handleNext} className="h-11 px-7 rounded-xl bg-[#0F172A] text-white font-black text-[10px] uppercase tracking-widest hover:bg-black transition-all flex items-center gap-2 shadow-xl hover:scale-105 active:scale-95">
                        Continue <ChevronRight className="w-4 h-4" />
                    </button>
                ) : (
                    <div className="flex items-center gap-3">
                        <button onClick={() => handleSave('draft')} className="h-11 px-5 rounded-xl bg-white border border-[#E2E8F0] text-[#0F172A] font-black text-[10px] uppercase tracking-widest hover:bg-slate-100 transition-all shadow-sm">
                            Save Draft
                        </button>
                        <button onClick={() => handleSave('pending')} className="h-11 px-7 rounded-xl bg-[#166FBB] text-white font-black text-[10px] uppercase tracking-widest transition-all flex items-center gap-2 shadow-xl shadow-[#166FBB]/20 hover:scale-105 active:scale-95">
                            <Send className="w-4 h-4" /> Finalize & Send
                        </button>
                    </div>
                )}
            </div>
        </div>
    );
};
