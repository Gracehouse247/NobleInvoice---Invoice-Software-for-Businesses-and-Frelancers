'use client';

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useSearchParams } from 'next/navigation';
import { useAuth } from '@/context/AuthContext';
import { invoiceService, clientService, productService, teamService, storageService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import { removeImageBackground } from '@/lib/utils/image-processing';
import { TEMPLATES, TemplateDefinition } from '@/lib/templates/templateRegistry';

interface InvoiceItem {
    id: number;
    name: string;
    quantity: number;
    price: number;
}

interface InvoiceCreatorState {
    step: 'select-type' | 'form' | 'success';
    setStep: (step: 'select-type' | 'form' | 'success') => void;
    currentWizardStep: number;
    setCurrentWizardStep: (step: number) => void;
    
    invoiceType: string;
    setInvoiceType: (type: string) => void;
    
    selectedTemplate: TemplateDefinition;
    setSelectedTemplate: (t: TemplateDefinition) => void;
    customAccentColor: string | null;
    setCustomAccentColor: (c: string | null) => void;
    
    clients: any[];
    products: any[];
    teamData: any;
    loading: boolean;
    
    // Form Data
    selectedClientId: string;
    setSelectedClientId: (id: string) => void;
    invoiceNumber: string;
    setInvoiceNumber: (num: string) => void;
    dueDate: string;
    setDueDate: (date: string) => void;
    items: InvoiceItem[];
    setItems: (items: InvoiceItem[]) => void;
    taxRate: number;
    setTaxRate: (rate: number) => void;
    taxType: 'exclusive' | 'inclusive';
    setTaxType: (type: 'exclusive' | 'inclusive') => void;
    discountType: 'none' | 'flat' | 'percentage';
    setDiscountType: (type: 'none' | 'flat' | 'percentage') => void;
    discountValue: number;
    setDiscountValue: (val: number) => void;
    currencyCode: string;
    setCurrencyCode: (code: string) => void;
    notes: string;
    setNotes: (notes: string) => void;
    
    bankName: string;
    setBankName: (name: string) => void;
    accountName: string;
    setAccountName: (name: string) => void;
    accountNumber: string;
    setAccountNumber: (num: string) => void;
    acceptOnlinePayments: boolean;
    setAcceptOnlinePayments: (accept: boolean) => void;
    
    signatureUrl: string | null;
    setSignatureUrl: (url: string | null) => void;
    
    // Derived Financials
    subtotal: number;
    taxTotal: number;
    discountTotal: number;
    total: number;
    currencySymbol: string;
    
    // Actions
    handleSave: (status?: 'draft' | 'pending') => Promise<void>;
    addItem: () => void;
    removeItem: (id: number) => void;
    updateItem: (id: number, field: keyof InvoiceItem, value: any) => void;
    createAndSelectClient: (clientData: { name: string; email: string; company?: string; phone?: string; address?: string }) => Promise<void>;
    issuedInvoiceData: any;
    setClients: React.Dispatch<React.SetStateAction<any[]>>;
}

const InvoiceCreatorContext = createContext<InvoiceCreatorState | undefined>(undefined);

export const InvoiceCreatorProvider = ({ children }: { children: ReactNode }) => {
    const { user } = useAuth();
    const searchParams = useSearchParams();
    
    const [step, setStep] = useState<'select-type' | 'form' | 'success'>('select-type');
    const [currentWizardStep, setCurrentWizardStep] = useState(0);
    const [invoiceType, setInvoiceType] = useState('standard');
    
    const [selectedTemplate, setSelectedTemplate] = useState<TemplateDefinition>(TEMPLATES[0]);
    const [customAccentColor, setCustomAccentColor] = useState<string | null>(null);
    const [issuedInvoiceData, setIssuedInvoiceData] = useState<any>(null);

    const [clients, setClients] = useState<any[]>([]);
    const [products, setProducts] = useState<any[]>([]);
    const [teamData, setTeamData] = useState<any>(null);
    const [loading, setLoading] = useState(true);

    const [selectedClientId, setSelectedClientId] = useState('');
    const [invoiceNumber, setInvoiceNumber] = useState(`INV-${new Date().toISOString().slice(0, 10).replace(/-/g, '')}-${Math.floor(1000 + Math.random() * 9000)}`);
    const [dueDate, setDueDate] = useState('');
    const [items, setItems] = useState<InvoiceItem[]>([{ id: Date.now(), name: '', quantity: 1, price: 0 }]);
    const [taxRate, setTaxRate] = useState(0);
    const [taxType, setTaxType] = useState<'exclusive' | 'inclusive'>('exclusive');
    const [discountType, setDiscountType] = useState<'none' | 'flat' | 'percentage'>('none');
    const [discountValue, setDiscountValue] = useState(0);
    const [currencyCode, setCurrencyCode] = useState('NGN');
    const [notes, setNotes] = useState('');
    
    const [bankName, setBankName] = useState('');
    const [accountName, setAccountName] = useState('');
    const [accountNumber, setAccountNumber] = useState('');
    const [acceptOnlinePayments, setAcceptOnlinePayments] = useState(false);
    const [signatureUrl, setSignatureUrl] = useState<string | null>(null);

    // Handle return from clients/new page — auto-select new client and jump to form
    useEffect(() => {
        const newClientId = searchParams?.get('newClientId');
        if (newClientId) {
            setSelectedClientId(newClientId);
            setStep('form');
            setCurrentWizardStep(0); // Stay on client step so user sees selection
        }
    }, [searchParams]);

    const getCurrencySymbol = (code: string) => {
        try {
            return new Intl.NumberFormat('en-US', { style: 'currency', currency: code }).formatToParts(0).find(x => x.type === 'currency')?.value || code;
        } catch {
            return code === 'NGN' ? '₦' : code;
        }
    };
    const currencySymbol = getCurrencySymbol(currencyCode);

    const draftId = searchParams?.get('draftId');

    useEffect(() => {
        if (!user) {
            setLoading(false);
            return;
        }

        const fetchData = async () => {
            try {
                // Step 1: Get team/profile using the Supabase ID (owner_id)
                const tData = await teamService.getTeamByUserId(user.id);
                if (tData) {
                    const td = tData as any;
                    setTeamData(tData);
                    setCurrencyCode(td.preferred_currency || 'NGN');
                    setBankName(td.bank_name || '');
                    setAccountName(td.account_name || '');
                    setAccountNumber(td.account_number || '');
                    setSignatureUrl(td.brand_signature_url || null);

                    // Step 2: Use the team id for subsequent team-scoped queries.
                    //         If tData has its own `id` that differs from user.id, use it;
                    //         otherwise fall back to user.id.
                    const teamId = tData.id || user.id;

                    const [clientsData, productsData] = await Promise.all([
                        clientService.getClients(teamId).catch(() => []),
                        productService.getProducts(teamId).catch(() => []),
                    ]);
                    setClients(clientsData || []);
                    setProducts(productsData || []);
                }

                // Step 3: If draftId is present, load the existing draft details
                if (draftId) {
                    try {
                        const existingInvoice = await invoiceService.getInvoiceById(draftId);
                        if (existingInvoice) {
                            if (existingInvoice.invoice_type) setInvoiceType(existingInvoice.invoice_type);
                            if (existingInvoice.client_id) setSelectedClientId(String(existingInvoice.client_id));
                            if (existingInvoice.invoice_number) setInvoiceNumber(existingInvoice.invoice_number);
                            if (existingInvoice.due_date) setDueDate(existingInvoice.due_date);
                            if (existingInvoice.currency_code) setCurrencyCode(existingInvoice.currency_code);
                            if (existingInvoice.tax_rate !== undefined && existingInvoice.tax_rate !== null) setTaxRate(Number(existingInvoice.tax_rate));
                            if (existingInvoice.tax_type) setTaxType(existingInvoice.tax_type as 'exclusive' | 'inclusive');
                            if (existingInvoice.discount_type) setDiscountType(existingInvoice.discount_type as 'none' | 'flat' | 'percentage');
                            if (existingInvoice.discount_value !== undefined && existingInvoice.discount_value !== null) setDiscountValue(Number(existingInvoice.discount_value));
                            if (existingInvoice.notes) setNotes(existingInvoice.notes);
                            
                            if (existingInvoice.metadata) {
                                if (existingInvoice.metadata.bank_name) setBankName(existingInvoice.metadata.bank_name);
                                if (existingInvoice.metadata.account_name) setAccountName(existingInvoice.metadata.account_name);
                                if (existingInvoice.metadata.account_number) setAccountNumber(existingInvoice.metadata.account_number);
                                if (existingInvoice.metadata.signature_url) setSignatureUrl(existingInvoice.metadata.signature_url);
                            }

                            if (existingInvoice.invoice_items && existingInvoice.invoice_items.length > 0) {
                                const loadedItems = existingInvoice.invoice_items.map((item: any) => ({
                                    id: item.id || Date.now() + Math.random(),
                                    name: item.description || '',
                                    quantity: parseInt(item.quantity) || 1,
                                    price: parseFloat(item.unit_price) || 0,
                                    product_id: item.product_id || null
                                }));
                                setItems(loadedItems);
                            } else {
                                setItems([{ id: Date.now(), name: '', quantity: 1, price: 0 }]);
                            }

                            setStep('form');
                            setCurrentWizardStep(0);
                        }
                    } catch (draftErr: any) {
                        console.error('Failed to load draft invoice:', draftErr);
                        toast.error('Failed to load draft details');
                    }
                }
            } catch (err: any) {
                // Log the full error so we can see actual Supabase messages
                console.error('Data fetch failed:', err?.message || err?.code || JSON.stringify(err), err);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, [user]); // Removed draftId from dependencies to prevent double-fetching on navigation/searchparam changes

    // Handle AI prompt draft loading
    useEffect(() => {
        if (loading) return; // Wait until initial data load completes!
        const source = searchParams?.get('source');
        if (source === 'ai') {
            try {
                const rawDraft = localStorage.getItem('noble_ai_draft_invoice');
                if (rawDraft) {
                    const parsed = JSON.parse(rawDraft);
                    const client = parsed.client || {};
                    const invoice = parsed.invoice || {};
                    const itemsData = invoice.items || [];

                    // 1. Currency
                    if (invoice.currency_code) setCurrencyCode(invoice.currency_code);

                    // 2. Invoice Type
                    if (parsed.invoice_type) {
                        setInvoiceType(parsed.invoice_type);
                    } else if (invoice.invoice_type) {
                        setInvoiceType(invoice.invoice_type);
                    }

                    // 3. Notes
                    if (invoice.notes) setNotes(invoice.notes);
                    if (parsed.notes) setNotes(parsed.notes);

                    // 4. Line Items
                    if (itemsData.length > 0) {
                        setItems(itemsData.map((it: any) => ({
                            id: Date.now() + Math.random(),
                            name: it.description || '',
                            quantity: it.quantity || 1,                            price: it.unit_price || 0
                        })));
                    }

                    // Go to wizard form view
                    setStep('form');
                    setCurrentWizardStep(0);
                    
                    // Cleanup localStorage so reloading doesn't repeat
                    localStorage.removeItem('noble_ai_draft_invoice');
                    toast.success("AI invoice draft loaded successfully!");
                }
            } catch (err) {
                console.error("Failed to load AI draft:", err);
            }
        }
    }, [searchParams, loading, clients]);

    const addItem = () => setItems([...items, { id: Date.now(), name: '', quantity: 1, price: 0 }]);
    const removeItem = (id: number) => items.length > 1 && setItems(items.filter(i => i.id !== id));
    const updateItem = (id: number, field: keyof InvoiceItem, value: any) => setItems(items.map(item => item.id === id ? { ...item, [field]: value } : item));

    const createAndSelectClient = async (clientData: { name: string; email: string; company?: string; phone?: string; address?: string }) => {
        if (!user) return;
        const teamId = teamData?.id || user.id;
        const newClient = await clientService.createClient({ ...clientData, team_id: teamId, user_id: user.id, lead_status: 'active' });
        if (newClient) {
            setClients(prev => [...prev, newClient]);
            setSelectedClientId(String(newClient.id));
        }
    };

    const subtotal = Number(items.reduce((acc, item) => acc + (item.quantity * item.price), 0).toFixed(2));
    const discountAmount = Number((discountType === 'flat' ? discountValue : discountType === 'percentage' ? subtotal * (discountValue / 100) : 0).toFixed(2));
    const taxableAmount = Math.max(0, subtotal - discountAmount);
    const taxTotal = Number((taxType === 'exclusive' ? taxableAmount * (taxRate / 100) : taxableAmount - (taxableAmount / (1 + taxRate / 100))).toFixed(2));
    const total = Number((taxType === 'exclusive' ? taxableAmount + taxTotal : taxableAmount).toFixed(2));
    const discountTotal = discountAmount;

    const handleSave = async (status: 'draft' | 'pending' = 'pending') => {
        if (!selectedClientId) {
            toast.error('Please select a client');
            return;
        }
        if (items.some(item => !item.name?.trim() || item.price < 0 || item.quantity <= 0)) {
            toast.error('Please complete all line items with valid quantities and prices');
            return;
        }
        if (dueDate) {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const due = new Date(dueDate);
            if (due < today) {
                toast.error('Due date cannot be in the past');
                return;
            }
        }
        try {
            toast.loading(draftId ? 'Updating draft invoice...' : 'Generating invoice...', { id: 'save-inv' });
            const invoiceData = {
                team_id: teamData?.id || user?.id,
                user_id: user?.id,
                client_id: selectedClientId,
                invoice_number: invoiceNumber,
                invoice_type: invoiceType,
                due_date: dueDate || new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
                items: items,
                subtotal: subtotal,
                discount_type: discountType,
                discount_value: discountValue,
                discount_amount: discountAmount,
                tax_type: taxType,
                tax_rate: taxRate,
                tax_total: taxTotal,
                total_amount: total,
                currency_code: currencyCode,
                status: status,
                notes: notes,
                bank_name: bankName,
                account_name: accountName,
                account_number: accountNumber,
                signature_url: signatureUrl
            };

            let savedInvoice;
            if (draftId) {
                savedInvoice = await invoiceService.updateInvoice(draftId, invoiceData);
                toast.success('Invoice updated successfully!', { id: 'save-inv' });
            } else {
                savedInvoice = await invoiceService.createInvoice(invoiceData);
                toast.success('Invoice created successfully!', { id: 'save-inv' });
            }

            setIssuedInvoiceData(savedInvoice);
            setStep('success');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        } catch (error) {
            console.error('Error saving invoice:', error);
            toast.error(draftId ? 'Failed to update invoice' : 'Failed to create invoice', { id: 'save-inv' });
        }
    };

    return (
        <InvoiceCreatorContext.Provider value={{
            step, setStep, currentWizardStep, setCurrentWizardStep, invoiceType, setInvoiceType,
            selectedTemplate, setSelectedTemplate, customAccentColor, setCustomAccentColor,
            clients, products, teamData, loading, selectedClientId, setSelectedClientId,
            invoiceNumber, setInvoiceNumber, dueDate, setDueDate, items, setItems,
            taxRate, setTaxRate, taxType, setTaxType, discountType, setDiscountType,
            discountValue, setDiscountValue, currencyCode, setCurrencyCode, notes, setNotes,
            bankName, setBankName, accountName, setAccountName, accountNumber, setAccountNumber,
            acceptOnlinePayments, setAcceptOnlinePayments, signatureUrl, setSignatureUrl,
            subtotal, taxTotal, discountTotal, total, currencySymbol, handleSave, addItem,
            removeItem, updateItem, issuedInvoiceData, createAndSelectClient, setClients
        }}>
            {children}
        </InvoiceCreatorContext.Provider>
    );
};

export const useInvoiceCreator = () => {
    const context = useContext(InvoiceCreatorContext);
    if (context === undefined) throw new Error('useInvoiceCreator must be used within InvoiceCreatorProvider');
    return context;
};
