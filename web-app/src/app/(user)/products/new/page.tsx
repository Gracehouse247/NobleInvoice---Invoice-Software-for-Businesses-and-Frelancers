'use client';

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { 
    ChevronLeft, Package, Tag, DollarSign, 
    Layers, Save, FileText, BarChart3
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { productService, teamService, productPassportService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import { Globe, ShieldCheck } from 'lucide-react';

export default function NewProductPage() {
    const { user, userData } = useAuth();
    const router = useRouter();
    const [loading, setLoading] = useState(false);

    const currency = (userData as any)?.preferred_currency || 'NGN';
    const currencySymbol: Record<string, string> = {
        'USD': '$',
        'EUR': '€',
        'GBP': '£',
        'CAD': '$',
        'AUD': '$',
        'NGN': '₦',
        'GHS': '₵',
        'KES': 'KSh',
        'ZAR': 'R'
    };
    const symbol = currencySymbol[currency] || '₦';

    const [formData, setFormData] = useState({
        name: '',
        description: '',
        price: '',
        category: '',
        type: 'product', // product or service
        sku: ''
    });

    const [enablePassport, setEnablePassport] = useState(false);
    const [passportData, setPassportData] = useState({
        hsCode: '',
        countryOfOrigin: '',
        batchNumber: '',
        publicStatus: 'published'
    });

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!user) return;
        
        setLoading(true);
        try {
            // 1. Fetch team ID
            const tData = await teamService.getTeamByUserId(user.id);
            const teamId = tData?.id || user.id;

            // 2. Resolve category string to category_id
            let categoryId = null;
            if (formData.category) {
                categoryId = await productService.resolveCategory(teamId, formData.category);
            }

            // 3. Map values to table structure and create product
            const newProduct = await productService.createProduct({
                name: formData.name,
                description: formData.description || null,
                unit_price: parseFloat(formData.price) || 0,
                sku: formData.sku || null,
                category_id: categoryId,
                team_id: teamId,
                user_id: user.id
            });

            // 4. Create Product Passport if enabled
            if (enablePassport && newProduct) {
                await productPassportService.upsertPassport({
                    product_id: newProduct.id,
                    team_id: teamId,
                    hs_code: passportData.hsCode || null,
                    country_of_origin: passportData.countryOfOrigin || null,
                    batch_number: passportData.batchNumber || null,
                    brand_name: user.user_metadata?.business_name || null,
                    public_status: passportData.publicStatus,
                    seo_title: `${formData.name} - Official Product Passport`,
                    seo_description: `Digital product passport and traceability information for ${formData.name}.`
                });
            }
            toast.success('Item added to catalog');
            router.push('/products');
        } catch (error) {
            console.error('Error adding product:', error);
            toast.error('Failed to add item');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="p-4 md:p-8 max-w-5xl mx-auto space-y-5 pb-32">
            <button 
                onClick={() => router.back()}
                className="flex items-center gap-2 text-slate-500 hover:text-primary transition-colors font-black text-[10px] uppercase tracking-widest"
            >
                <ChevronLeft className="w-4 h-4" />
                Back to Catalog
            </button>

            <div className="space-y-2">
                <h1 className="text-3xl font-extrabold text-foreground font-manrope tracking-tight">Add New Item</h1>
                <p className="text-slate-500 font-medium">Define a new product or service for your invoicing inventory.</p>
            </div>

            <form onSubmit={handleSubmit} className="glass-card p-8 rounded-[32px] border-card-border">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-10">
                    {/* Left Column - Core Details */}
                    <div className="lg:col-span-7 space-y-8">
                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Item Name</label>
                            <div className="relative">
                                <Package className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                <input 
                                    required
                                    type="text"
                                    className="w-full bg-black/5 border border-card-border rounded-xl pl-11 pr-4 py-3 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                    placeholder="e.g. Web Design Package"
                                    value={formData.name}
                                    onChange={(e) => setFormData({...formData, name: e.target.value})}
                                />
                            </div>
                        </div>

                        <div className="space-y-1.5">
                            <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Description</label>
                            <div className="relative">
                                <FileText className="absolute left-4 top-4 w-4 h-4 text-slate-400" />
                                <textarea 
                                    className="w-full bg-black/5 border border-card-border rounded-xl pl-11 pr-4 py-3 font-bold text-sm focus:outline-none focus:border-primary transition-all min-h-[120px]"
                                    placeholder="Detailed description for the invoice..."
                                    value={formData.description}
                                    onChange={(e) => setFormData({...formData, description: e.target.value})}
                                />
                            </div>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Unit Price ({symbol})</label>
                                <div className="relative">
                                    <span className="absolute left-4 top-1/2 -translate-y-1/2 font-bold text-slate-400">{symbol}</span>
                                    <input 
                                        required
                                        type="number"
                                        step="0.01"
                                        className="w-full bg-black/5 border border-card-border rounded-xl pl-11 pr-4 py-3 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                        placeholder="0.00"
                                        value={formData.price}
                                        onChange={(e) => setFormData({...formData, price: e.target.value})}
                                    />
                                </div>
                            </div>
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">SKU / Item Code</label>
                                <div className="relative">
                                    <BarChart3 className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                    <input 
                                        type="text"
                                        className="w-full bg-black/5 border border-card-border rounded-xl pl-11 pr-4 py-3 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                        placeholder="INV-001"
                                        value={formData.sku}
                                        onChange={(e) => setFormData({...formData, sku: e.target.value})}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Right Column - Categorization & Passport */}
                    <div className="lg:col-span-5 space-y-8 lg:border-l lg:border-card-border lg:pl-10">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Category</label>
                                <div className="relative">
                                    <Tag className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                    <input 
                                        type="text"
                                        className="w-full bg-black/5 border border-card-border rounded-xl pl-11 pr-4 py-3 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                        placeholder="e.g. Services"
                                        value={formData.category}
                                        onChange={(e) => setFormData({...formData, category: e.target.value})}
                                    />
                                </div>
                            </div>
                            <div className="space-y-1.5">
                                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Type</label>
                                <select 
                                    className="w-full h-[46px] bg-black/5 border border-card-border rounded-xl px-4 font-bold text-sm focus:outline-none focus:border-primary transition-all cursor-pointer"
                                    value={formData.type}
                                    onChange={(e) => setFormData({...formData, type: e.target.value})}
                                >
                                    <option value="product">Physical Product</option>
                                    <option value="service">Professional Service</option>
                                </select>
                            </div>
                        </div>

                        {/* Digital Product Passport Section */}
                        <div className="pt-6 border-t border-card-border space-y-6">
                            <div className="flex items-start justify-between gap-4">
                                <div>
                                    <h3 className="text-sm font-black text-foreground flex items-center gap-2">
                                        <Globe className="w-4 h-4 text-primary" />
                                        Digital Passport
                                    </h3>
                                    <p className="text-slate-500 text-[10px] font-bold uppercase tracking-wider mt-1.5 leading-relaxed">
                                        SEO-optimized public landing page for EU compliance.
                                    </p>
                                </div>
                                <label className="relative inline-flex items-center cursor-pointer shrink-0 mt-1">
                                    <input type="checkbox" className="sr-only peer" checked={enablePassport} onChange={(e) => setEnablePassport(e.target.checked)} />
                                    <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                                </label>
                            </div>

                            {enablePassport && (
                                <div className="space-y-4 bg-black/5 p-5 rounded-[20px] border border-card-border">
                                    <div className="space-y-1.5">
                                        <label className="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">HS Code</label>
                                        <div className="relative">
                                            <ShieldCheck className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                            <input 
                                                type="text"
                                                className="w-full bg-white border border-card-border rounded-xl pl-11 pr-4 py-2.5 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                                placeholder="e.g. 6109.10.00"
                                                value={passportData.hsCode}
                                                onChange={(e) => setPassportData({...passportData, hsCode: e.target.value})}
                                            />
                                        </div>
                                    </div>
                                    <div className="space-y-1.5">
                                        <label className="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Country of Origin</label>
                                        <input 
                                            type="text"
                                            className="w-full bg-white border border-card-border rounded-xl px-4 py-2.5 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                            placeholder="e.g. United Kingdom"
                                            value={passportData.countryOfOrigin}
                                            onChange={(e) => setPassportData({...passportData, countryOfOrigin: e.target.value})}
                                        />
                                    </div>
                                    <div className="space-y-1.5">
                                        <label className="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Batch / Lot Number</label>
                                        <input 
                                            type="text"
                                            className="w-full bg-white border border-card-border rounded-xl px-4 py-2.5 font-bold text-sm focus:outline-none focus:border-primary transition-all"
                                            placeholder="e.g. BATCH-2024-X"
                                            value={passportData.batchNumber}
                                            onChange={(e) => setPassportData({...passportData, batchNumber: e.target.value})}
                                        />
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                <div className="flex justify-end gap-3 pt-6 mt-8 border-t border-card-border">
                    <button 
                        type="button"
                        onClick={() => router.back()}
                        className="h-12 px-8 rounded-2xl border border-card-border font-black text-[10px] uppercase tracking-widest hover:bg-black/5 transition-all"
                    >
                        Cancel
                    </button>
                    <button 
                        disabled={loading}
                        type="submit"
                        className="bg-noble-blue text-white h-12 px-10 rounded-2xl flex items-center gap-2 font-black text-[10px] uppercase tracking-widest shadow-lg shadow-noble-blue/20 hover:scale-[1.02] active:scale-95 transition-all disabled:opacity-50"
                    >
                        {loading ? 'Adding...' : <><Save className="w-4 h-4" /> Add to Catalog</>}
                    </button>
                </div>
            </form>
        </div>
    );
}
