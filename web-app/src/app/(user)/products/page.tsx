'use client';

import React from 'react';
import Link from 'next/link';
import { 
    Plus, Search, Filter, Layers, 
    MoreHorizontal, Tag, DollarSign, Package,
    Loader2, Trash2
} from 'lucide-react';
import { useAuth } from '@/context/AuthContext';
import { productService, teamService } from '@/lib/services/supabaseService';
import { toast } from 'react-hot-toast';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import NobleEmptyState from '@/components/shared/NobleEmptyState';
import { Sparkles } from 'lucide-react';

const TABS = ['All Items', 'Products', 'Services'];

export default function ProductsPage() {
    const { user } = useAuth();
    const router = useRouter();
    const [activeTab, setActiveTab] = React.useState('All Items');
    const [products, setProducts] = React.useState<any[]>([]);
    const [loading, setLoading] = React.useState(true);
    const [searchQuery, setSearchQuery] = React.useState('');

    React.useEffect(() => {
        if (!user) return;
        
        const fetchProducts = async () => {
            try {
                const tData = await teamService.getTeamByUserId(user.id);
                const teamId = tData?.id || user.id;
                const data = await productService.getProducts(teamId);
                setProducts(data || []);
            } catch (err) {
                console.error('Error fetching products:', err);
                toast.error('Failed to load catalog');
            } finally {
                setLoading(false);
            }
        };

        fetchProducts();
    }, [user]);

    const handleDeleteProduct = async (id: string) => {
        if (!confirm('Are you sure you want to delete this item?')) return;
        try {
            await productService.deleteProduct(id);
            setProducts(prev => prev.filter(p => p.id !== id));
            toast.success('Item deleted successfully');
        } catch (err) {
            console.error('Failed to delete product:', err);
            toast.error('Failed to delete item');
        }
    };

    const formatCurrency = (amount: number) => {
        return `₦${amount.toLocaleString(undefined, { minimumFractionDigits: 2 })}`;
    };

    const filteredProducts = React.useMemo(() => {
        return products.filter(product => {
            const matchesSearch = 
                product.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                product.description?.toLowerCase().includes(searchQuery.toLowerCase());
            
            if (!matchesSearch) return false;

            if (activeTab === 'All Items') return true;
            // Handle if type column is null or matches casing
            const pType = (product.type || 'product').toLowerCase();
            if (activeTab === 'Products') return pType === 'product';
            if (activeTab === 'Services') return pType === 'service';
            return true;
        });
    }, [products, searchQuery, activeTab]);

    return (
        <div className="min-h-screen bg-[#F0F4F8] text-slate-900 pb-32 font-inter relative overflow-hidden selection:bg-noble-blue/20">
            {/* Ambient Background Mesh Gradients */}
            <div className="fixed top-[-20%] left-[-10%] w-[800px] h-[800px] bg-noble-blue/10 blur-[150px] rounded-full pointer-events-none z-0" />
            <div className="fixed bottom-[-20%] right-[-10%] w-[600px] h-[600px] bg-electric-cyan/10 blur-[150px] rounded-full pointer-events-none z-0" />

            {/* Header Area */}
            <header className="relative z-50 bg-white/40 backdrop-blur-3xl border-b border-white/60 px-8 py-8 shadow-[0_20px_40px_rgba(0,0,0,0.02)]">
                <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="flex items-center gap-4">
                        <div className="w-12 h-12 rounded-[20px] bg-gradient-to-br from-noble-blue/20 to-transparent flex items-center justify-center text-noble-blue border border-white/50 shadow-inner">
                            <Layers className="w-6 h-6 fill-current opacity-80" />
                        </div>
                        <div>
                            <h1 className="text-2xl md:text-3xl font-semibold text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
                                Products & <span className="text-noble-blue">Services</span>
                            </h1>
                            <p className="text-slate-500 font-bold text-[10px] mt-1">Manage your inventory and reusable services for faster invoicing.</p>
                        </div>
                    </div>
                    <motion.div whileTap={{ scale: 0.95 }} className="inline-flex">
                        <Link 
                            href="/products/new"
                            className="group relative overflow-hidden flex items-center gap-2 px-8 py-4 bg-white/60 backdrop-blur-md border border-white hover:border-noble-blue/30 text-slate-900 font-black text-[11px] uppercase tracking-[0.2em] rounded-2xl hover:bg-white transition-all shadow-[0_10px_20px_rgba(0,0,0,0.02)] hover:shadow-[0_15px_30px_rgba(22,111,187,0.1)] whitespace-nowrap"
                        >
                            <div className="w-6 h-6 rounded-full bg-noble-blue flex items-center justify-center group-hover:scale-110 transition-transform shadow-inner">
                                <Plus className="w-3.5 h-3.5 text-white" />
                            </div>
                            <span>Add Item</span>
                        </Link>
                    </motion.div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-8 mt-12 relative z-10">
                {/* Filters & Search */}
                <div className="bg-white/40 backdrop-blur-2xl p-4 rounded-[32px] border border-white/60 shadow-[0_20px_40px_rgba(0,0,0,0.03)] mb-8 flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden">
                    <div className="absolute top-[-20%] right-[-10%] w-[300px] h-[300px] bg-noble-blue/5 blur-[80px] rounded-full pointer-events-none z-0" />
                    
                    <div className="flex items-center overflow-x-auto w-full md:w-auto hide-scrollbar gap-2 p-1 relative z-10">
                        {TABS.map((tab) => (
                            <motion.button
                                whileTap={{ scale: 0.95 }}
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`relative px-8 py-4 rounded-2xl text-[10px] font-black uppercase tracking-[0.2em] transition-all whitespace-nowrap ${
                                    activeTab === tab 
                                    ? 'text-noble-blue bg-white shadow-sm' 
                                    : 'text-slate-400 hover:text-slate-700 hover:bg-white/50'
                                }`}
                            >
                                <span className="relative z-10">{tab}</span>
                            </motion.button>
                        ))}
                    </div>
                    
                    <div className="flex items-center gap-4 w-full md:w-auto px-2 md:px-0 relative z-10">
                        <div className="relative w-full md:w-80">
                            <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 z-10" />
                            <input 
                                type="text"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                placeholder="Search items..."
                                className="w-full pl-12 pr-6 py-4 bg-white/60 backdrop-blur-md border border-white/60 rounded-2xl text-xs font-bold text-slate-900 placeholder:text-slate-400 focus:outline-none focus:border-noble-blue/40 focus:ring-4 focus:ring-noble-blue/10 transition-all shadow-inner"
                            />
                        </div>
                        <motion.button whileTap={{ scale: 0.95 }} className="p-4 bg-white/60 backdrop-blur-md border border-white/60 text-slate-500 rounded-2xl hover:border-noble-blue/30 hover:bg-white transition-all shadow-sm">
                            <Filter className="w-[18px] h-[18px]" />
                        </motion.button>
                    </div>
                </div>

                {/* Items Table Area */}
                <div className="bg-white/40 backdrop-blur-2xl rounded-[40px] border border-white/60 shadow-[0_40px_80px_rgba(0,0,0,0.03)] overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="border-b border-white/60 bg-white/20">
                                    <th className="px-8 py-6 text-[10px] font-black text-slate-500 uppercase tracking-[0.2em]">Item Name</th>
                                    <th className="px-8 py-6 text-[10px] font-black text-slate-500 uppercase tracking-[0.2em]">Type</th>
                                    <th className="px-8 py-6 text-[10px] font-black text-slate-500 uppercase tracking-[0.2em]">Price</th>
                                    <th className="px-8 py-6 text-[10px] font-black text-slate-500 uppercase tracking-[0.2em]">Tax Rate</th>
                                    <th className="px-8 py-6 text-[10px] font-black text-slate-500 uppercase tracking-[0.2em] text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-32 text-center">
                                            <div className="flex flex-col items-center justify-center gap-4">
                                                <Loader2 className="w-10 h-10 text-noble-blue animate-spin" />
                                                <p className="text-slate-500 text-xs font-bold uppercase tracking-widest">Decrypting item records...</p>
                                            </div>
                                        </td>
                                    </tr>
                                ) : filteredProducts.length === 0 ? (
                                    <tr>
                                        <td colSpan={5} className="px-8 py-16">
                                            <NobleEmptyState
                                                icon={Layers}
                                                accentIcon={Sparkles}
                                                title="No items found"
                                                description="You haven't added any products or services. Add your first item to speed up invoice creation."
                                                actions={[
                                                    { label: '+ Add Item', onClick: () => router.push('/products/new') }
                                                ]}
                                            />
                                        </td>
                                    </tr>
                                ) : (
                                    filteredProducts.map((product, i) => (
                                        <tr 
                                            key={product.id}
                                            className="border-b border-white/60 hover:bg-white/40 transition-colors group"
                                        >
                                            <td className="px-8 py-6">
                                                <div className="flex flex-col">
                                                    <span className="font-bold text-slate-800 text-sm">{product.name}</span>
                                                    {product.description && (
                                                        <span className="text-xs text-slate-400 font-semibold max-w-xs truncate mt-0.5">{product.description}</span>
                                                    )}
                                                </div>
                                            </td>
                                            <td className="px-8 py-6">
                                                <span className={`px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider ${
                                                    (product.type || 'product').toLowerCase() === 'service' 
                                                    ? 'bg-purple-100 text-purple-800 border border-purple-200' 
                                                    : 'bg-sky-100 text-sky-800 border border-sky-200'
                                                }`}>
                                                    {product.type || 'Product'}
                                                </span>
                                            </td>
                                            <td className="px-8 py-6 font-black text-slate-900 text-sm">
                                                {formatCurrency(product.unit_price || 0)}
                                            </td>
                                            <td className="px-8 py-6 text-slate-600 font-bold text-xs">
                                                {product.tax_rate ? `${product.tax_rate}%` : '0%'}
                                            </td>
                                            <td className="px-8 py-6 text-right">
                                                <div className="flex items-center justify-end gap-2">
                                                    <motion.button
                                                        whileTap={{ scale: 0.95 }}
                                                        onClick={() => handleDeleteProduct(product.id)}
                                                        className="p-2 rounded-xl bg-rose-50 text-rose-600 hover:bg-rose-600 hover:text-white border border-rose-100 transition-all"
                                                        title="Delete Item"
                                                    >
                                                        <Trash2 className="w-4 h-4" />
                                                    </motion.button>
                                                </div>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    );
}
