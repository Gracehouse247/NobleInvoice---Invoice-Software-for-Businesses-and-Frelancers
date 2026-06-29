'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { 
    Plus, Search, Filter, Layers, 
    MoreHorizontal, Tag, Package, History, ArrowRightLeft, AlertCircle,
    Loader2, X, Check, Eye
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { productService, teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';

const TABS = ['All Stock', 'Low Stock', 'Out of Stock'];

export default function InventoryPage() {
    const { user, userData } = useAuth();
    const [activeTab, setActiveTab] = useState('All Stock');

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
    const [products, setProducts] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [showAdjustModal, setShowAdjustModal] = useState(false);
    const [selectedProduct, setSelectedProduct] = useState<any>(null);
    const [adjustQty, setAdjustQty] = useState('');
    const [adjustType, setAdjustType] = useState<'add' | 'set'>('add');
    const [adjusting, setAdjusting] = useState(false);

    const fetchInventory = async () => {
        if (!user) return;
        setLoading(true);
        try {
            const tData = await teamService.getTeamByUserId(user.id);
            const teamId = tData?.id || user.id;
            const data = await productService.getProducts(teamId);
            setProducts(data || []);
        } catch (error) {
            console.error('Failed to load inventory:', error);
            toast.error('Failed to load inventory');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchInventory();
    }, [user]);

    const handleOpenAdjustment = (product: any) => {
        setSelectedProduct(product);
        setAdjustQty('');
        setAdjustType('add');
        setShowAdjustModal(true);
    };

    const handleSaveAdjustment = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!selectedProduct) return;
        
        const qtyNum = parseInt(adjustQty);
        if (isNaN(qtyNum)) {
            toast.error('Please enter a valid quantity');
            return;
        }

        let newStock = 0;
        if (adjustType === 'add') {
            newStock = (selectedProduct.stock_quantity || 0) + qtyNum;
        } else {
            newStock = qtyNum;
        }

        if (newStock < 0) {
            toast.error('Stock quantity cannot be negative');
            return;
        }

        setAdjusting(true);
        try {
            await productService.updateProduct(selectedProduct.id, {
                stock_quantity: newStock,
                track_inventory: true // ensure tracking is on
            });
            toast.success(`Inventory updated for ${selectedProduct.name}`);
            setShowAdjustModal(false);
            fetchInventory();
        } catch (err) {
            console.error('Error adjusting stock:', err);
            toast.error('Failed to adjust stock');
        } finally {
            setAdjusting(false);
        }
    };

    // Derived statistics
    const totalItems = products.length;
    const lowStockAlerts = products.filter(p => p.stock_quantity !== null && p.stock_quantity <= (p.min_stock_level || 5) && p.stock_quantity > 0).length;
    const valueInStock = products.reduce((acc, p) => acc + (parseFloat(p.unit_price || '0') * (p.stock_quantity || 0)), 0);

    // Filter products
    const filteredProducts = products.filter(p => {
        const matchesSearch = p.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
                            (p.sku && p.sku.toLowerCase().includes(searchTerm.toLowerCase()));
        if (!matchesSearch) return false;
        
        if (activeTab === 'Low Stock') {
            return p.stock_quantity !== null && p.stock_quantity <= (p.min_stock_level || 5) && p.stock_quantity > 0;
        }
        if (activeTab === 'Out of Stock') {
            return p.stock_quantity === 0 || p.stock_quantity === null;
        }
        return true;
    });

    return (
        <div className="min-h-screen bg-[#F0F4F8] selection:bg-noble-blue/20 relative overflow-hidden pb-24 font-inter">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header Area */}
            <div className="bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 relative z-10 shadow-[0_20px_40px_rgba(0,0,0,0.01)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="space-y-1">
                        <div className="flex items-center gap-2">
                            <span className="text-[10px] font-black text-noble-blue uppercase tracking-[0.2em]">Real-time Asset Stream</span>
                        </div>
                        <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                            Inventory <span className="text-noble-blue">Ledger</span>
                        </h1>
                        <p className="text-slate-500 text-[10px] font-bold">Track stock levels, monitor inventory history, and adjust quantities.</p>
                    </div>
                    <div className="flex items-center gap-3">
                        <Link href="/products" className="flex items-center gap-2 px-5 py-4 bg-white/60 border border-white/60 text-slate-700 font-black text-[10px] uppercase tracking-[0.15em] rounded-xl hover:bg-white hover:text-noble-blue transition-all active:scale-95 shadow-sm">
                            <Eye className="w-4 h-4 text-slate-500" />
                            Product Catalog
                        </Link>
                        <Link href="/products/new" className="flex items-center gap-2 px-6 py-4 bg-noble-blue text-white font-black text-[10px] uppercase tracking-[0.2em] rounded-xl hover:bg-blue-600 transition-all shadow-[0_10px_20px_rgba(22,111,187,0.15)] active:scale-95 whitespace-nowrap">
                            <Plus className="w-4 h-4" />
                            Add Product
                        </Link>
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-8 mt-10 relative z-10">
                {/* Metrics Summary */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div className="bg-white/40 backdrop-blur-2xl p-6 rounded-3xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="w-12 h-12 bg-noble-blue/10 rounded-xl flex items-center justify-center border border-white/60">
                            <Package className="w-6 h-6 text-noble-blue" />
                        </div>
                        <div>
                            <p className="text-[9px] font-black text-slate-500 uppercase tracking-widest">Tracked Items</p>
                            <h3 className="text-2xl font-black text-slate-900 mt-1">{totalItems}</h3>
                        </div>
                    </div>
                    <div className="bg-white/40 backdrop-blur-2xl p-6 rounded-3xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="w-12 h-12 bg-amber-500/10 rounded-xl flex items-center justify-center border border-white/60">
                            <AlertCircle className="w-6 h-6 text-amber-600" />
                        </div>
                        <div>
                            <p className="text-[9px] font-black text-slate-500 uppercase tracking-widest">Low Stock Alerts</p>
                            <h3 className="text-2xl font-black text-slate-900 mt-1">{lowStockAlerts}</h3>
                        </div>
                    </div>
                    <div className="bg-white/40 backdrop-blur-2xl p-6 rounded-3xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="w-12 h-12 bg-emerald-500/10 rounded-xl flex items-center justify-center border border-white/60">
                            <Tag className="w-6 h-6 text-emerald-600" />
                        </div>
                        <div>
                            <p className="text-[9px] font-black text-slate-500 uppercase tracking-widest">Value in Stock</p>
                            <h3 className="text-2xl font-black text-slate-900 mt-1">
                                {symbol}{valueInStock.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                            </h3>
                        </div>
                    </div>
                </div>

                {/* Filters & Search */}
                <div className="bg-white/40 backdrop-blur-2xl p-2.5 rounded-3xl border border-white/60 shadow-[0_15px_30px_rgba(0,0,0,0.01)] mb-8 flex flex-col md:flex-row items-center justify-between gap-4">
                    <div className="flex items-center overflow-x-auto w-full md:w-auto pb-2 md:pb-0 no-scrollbar">
                        {TABS.map((tab) => (
                            <button
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-wider transition-all whitespace-nowrap ${
                                    activeTab === tab 
                                    ? 'bg-white/80 border-white text-noble-blue shadow-[0_10px_20px_rgba(22,111,187,0.05)]' 
                                    : 'text-slate-500 hover:text-slate-900 hover:bg-white/40'
                                    }`}
                            >
                                {tab}
                            </button>
                        ))}
                    </div>
                    
                    <div className="flex items-center gap-3 w-full md:w-auto px-2 md:px-0">
                        <div className="relative w-full md:w-64">
                            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                            <input 
                                type="text"
                                placeholder="Search inventory..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-full bg-white/60 border border-white/60 text-slate-800 text-xs font-semibold rounded-2xl pl-11 pr-4 py-3.5 outline-none focus:border-noble-blue transition-colors placeholder:text-slate-400"
                            />
                        </div>
                    </div>
                </div>

                {/* Items Table Area */}
                <div className="bg-white/40 backdrop-blur-2xl rounded-[35px] border border-white/60 shadow-[0_30px_60px_rgba(0,0,0,0.02)] overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-white/60 bg-white/40">
                                    <th className="px-8 py-5 text-[9px] font-black text-slate-500 uppercase tracking-[0.2em]">Product Name</th>
                                    <th className="px-8 py-5 text-[9px] font-black text-slate-500 uppercase tracking-[0.2em]">SKU</th>
                                    <th className="px-8 py-5 text-[9px] font-black text-slate-500 uppercase tracking-[0.2em]">Stock Level</th>
                                    <th className="px-8 py-5 text-[9px] font-black text-slate-500 uppercase tracking-[0.2em]">Status</th>
                                    <th className="px-8 py-5 text-[9px] font-black text-slate-500 uppercase tracking-[0.2em] text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-16 text-center">
                                            <div className="flex flex-col items-center justify-center gap-3">
                                                <Loader2 className="w-8 h-8 text-noble-blue animate-spin" />
                                                <span className="text-xs font-bold text-slate-500 uppercase tracking-widest">Loading ledger...</span>
                                            </div>
                                        </td>
                                    </tr>
                                ) : filteredProducts.length === 0 ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-24 text-center">
                                            <div className="flex flex-col items-center justify-center gap-6">
                                                <div className="w-24 h-24 bg-white/60 rounded-full flex items-center justify-center border border-white/60 shadow-inner">
                                                    <Package className="w-10 h-10 text-slate-400" />
                                                </div>
                                                <div className="space-y-1">
                                                    <h3 className="text-lg font-black text-slate-900 uppercase tracking-tight">No inventory records</h3>
                                                    <p className="text-[10px] text-slate-500 font-bold uppercase tracking-wider max-w-sm mx-auto leading-relaxed">
                                                        {searchTerm ? 'No products match your search query.' : 'You haven\'t tracked any physical stock yet.'}
                                                    </p>
                                                </div>
                                                {!searchTerm && (
                                                    <Link 
                                                        href="/products/new"
                                                        className="mt-2 px-8 py-3.5 bg-white/80 border border-white hover:border-noble-blue hover:text-noble-blue text-slate-700 font-black text-[10px] uppercase tracking-[0.15em] rounded-xl hover:shadow-sm transition-all active:scale-95"
                                                    >
                                                        Create Product
                                                    </Link>
                                                )}
                                            </div>
                                        </td>
                                    </tr>
                                ) : (
                                    filteredProducts.map((product) => {
                                        const isLow = product.stock_quantity !== null && product.stock_quantity <= (product.min_stock_level || 5) && product.stock_quantity > 0;
                                        const isOut = product.stock_quantity === 0 || product.stock_quantity === null;
                                        
                                        return (
                                            <tr key={product.id} className="border-b border-white/40 hover:bg-white/30 transition-colors">
                                                <td className="px-8 py-5">
                                                    <div className="font-black text-slate-900 text-sm">{product.name}</div>
                                                    <div className="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-1">
                                                        Price: {symbol}{parseFloat(product.unit_price || '0').toFixed(2)}
                                                    </div>
                                                </td>
                                                <td className="px-8 py-5 font-mono text-xs text-slate-600">
                                                    {product.sku || 'N/A'}
                                                </td>
                                                <td className="px-8 py-5">
                                                    <span className="font-black text-slate-900">{product.stock_quantity ?? 0}</span>
                                                    <span className="text-xs text-slate-400 font-medium ml-1">units</span>
                                                </td>
                                                <td className="px-8 py-5">
                                                    {isOut ? (
                                                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-100 text-[8px] font-black text-red-600 uppercase tracking-wider">
                                                            Out of Stock
                                                        </span>
                                                    ) : isLow ? (
                                                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 border border-amber-100 text-[8px] font-black text-amber-600 uppercase tracking-wider animate-pulse">
                                                            Low Stock
                                                        </span>
                                                    ) : (
                                                        <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-50 border border-emerald-100 text-[8px] font-black text-emerald-600 uppercase tracking-wider">
                                                            In Stock
                                                        </span>
                                                    )}
                                                </td>
                                                <td className="px-8 py-5 text-right">
                                                    <button 
                                                        onClick={() => handleOpenAdjustment(product)}
                                                        className="px-4 py-2 bg-white hover:bg-noble-blue hover:text-white border border-slate-200 hover:border-noble-blue text-slate-700 font-black text-[9px] uppercase tracking-wider rounded-xl transition-all shadow-sm active:scale-95"
                                                    >
                                                        Adjust
                                                    </button>
                                                </td>
                                            </tr>
                                        );
                                    })
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            {/* Adjust Stock Modal */}
            {showAdjustModal && selectedProduct && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
                    <div className="bg-white rounded-[32px] w-full max-w-md overflow-hidden shadow-2xl border border-slate-100 animate-in fade-in zoom-in duration-200">
                        {/* Modal Header */}
                        <div className="flex items-center justify-between p-6 border-b border-slate-100 bg-[#F8FAFC]">
                            <div>
                                <span className="text-[9px] font-black text-noble-blue uppercase tracking-widest">Inventory Action</span>
                                <h3 className="text-lg font-black text-slate-900 tracking-tight mt-0.5">Adjust Stock Levels</h3>
                            </div>
                            <button 
                                onClick={() => setShowAdjustModal(false)}
                                className="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-xl transition-all"
                            >
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        {/* Modal Body */}
                        <form onSubmit={handleSaveAdjustment} className="p-6 space-y-6">
                            <div>
                                <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Product Name</div>
                                <div className="text-base font-black text-slate-900 mt-1">{selectedProduct.name}</div>
                                <div className="text-xs text-slate-500 font-semibold mt-1">
                                    Current stock: <span className="font-bold text-slate-800">{selectedProduct.stock_quantity ?? 0}</span> units
                                </div>
                            </div>

                            {/* Adjustment Type */}
                            <div className="space-y-2">
                                <label className="text-[10px] font-black text-slate-500 uppercase tracking-wider">Adjustment Type</label>
                                <div className="grid grid-cols-2 gap-3">
                                    <button
                                        type="button"
                                        onClick={() => setAdjustType('add')}
                                        className={`py-3 px-4 rounded-xl text-xs font-black uppercase tracking-wider border transition-all ${
                                            adjustType === 'add'
                                            ? 'bg-noble-blue/10 border-noble-blue text-noble-blue shadow-sm'
                                            : 'bg-slate-50 border-slate-200 text-slate-600 hover:bg-slate-100'
                                        }`}
                                    >
                                        Add/Remove (+/-)
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setAdjustType('set')}
                                        className={`py-3 px-4 rounded-xl text-xs font-black uppercase tracking-wider border transition-all ${
                                            adjustType === 'set'
                                            ? 'bg-noble-blue/10 border-noble-blue text-noble-blue shadow-sm'
                                            : 'bg-slate-50 border-slate-200 text-slate-600 hover:bg-slate-100'
                                        }`}
                                    >
                                        Set New Total
                                    </button>
                                </div>
                            </div>

                            {/* Quantity Input */}
                            <div className="space-y-2">
                                <label className="text-[10px] font-black text-slate-500 uppercase tracking-wider">
                                    {adjustType === 'add' ? 'Quantity to add/subtract' : 'New Stock Quantity'}
                                </label>
                                <div className="relative">
                                    <input 
                                        type="number"
                                        required
                                        value={adjustQty}
                                        onChange={(e) => setAdjustQty(e.target.value)}
                                        placeholder={adjustType === 'add' ? 'e.g. 10 or -5' : 'e.g. 50'}
                                        className="w-full bg-slate-50 border border-slate-200 focus:border-noble-blue rounded-xl py-3 px-4 text-sm font-bold text-slate-900 outline-none transition-colors"
                                    />
                                </div>
                                <p className="text-[10px] text-slate-400 font-semibold leading-relaxed">
                                    {adjustType === 'add' 
                                        ? 'Enter a positive number to add stock, or a negative number (e.g., -10) to reduce stock.' 
                                        : 'Sets the total stock quantity level directly.'}
                                </p>
                            </div>

                            {/* Action Buttons */}
                            <div className="flex gap-3 pt-2">
                                <button
                                    type="button"
                                    onClick={() => setShowAdjustModal(false)}
                                    className="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-black text-xs uppercase tracking-wider rounded-xl transition-all"
                                >
                                    Cancel
                                </button>
                                <button
                                    type="submit"
                                    disabled={adjusting}
                                    className="flex-1 py-3 bg-noble-blue hover:bg-blue-600 text-white font-black text-xs uppercase tracking-wider rounded-xl transition-all shadow-md shadow-noble-blue/10 disabled:opacity-50 flex items-center justify-center gap-2"
                                >
                                    {adjusting ? (
                                        <>
                                            <Loader2 className="w-4 h-4 animate-spin" />
                                            Saving...
                                        </>
                                    ) : (
                                        <>
                                            <Check className="w-4 h-4" />
                                            Apply
                                        </>
                                    )}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}
