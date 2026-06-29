import React, { useState, useMemo } from 'react';
import { X, Check, Lock, Star, Layout, Briefcase, Palette, Box, Diamond, Search, Eye, ArrowRight, Sparkles } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { INVOICE_TEMPLATE_CATEGORIES, INVOICE_TEMPLATES, TemplateCategory, TemplateDefinition } from '@/lib/templates/templateRegistry';
import Image from 'next/image';
import { TemplateEngine } from './TemplateEngine';
import { useAuth } from '@/context/AuthContext';
import { pricingService } from '@/lib/services/supabaseService';
import PremiumBadge from '../shared/PremiumBadge';
import PaygUnlockModal, { usePaygBundle } from '../features/billing/PaygUnlockModal';

const MOCK_DATA = {
  invoiceNumber: "INV-2026-001",
  date: "24 Aug 2026",
  dueDate: "07 Sep 2026",
  sender: {
    full_name: "Noble Studio",
    address: "100 Innovation Drive\nTech District, NY 10001",
    email: "billing@noblestudio.com",
    phone_number: "+1 (555) 123-4567"
  },
  client: {
    name: "Acme Corp",
    address: "400 Business Pkwy\nSuite 200, CA 94016",
    email: "accounts@acme.corp"
  },
  items: [
    { name: "Premium Design Services", quantity: 1, price: 4005.00 }
  ],
  subtotal: 4005.00,
  taxTotal: 0,
  discountTotal: 150,
  total: 3855.00,
  currencySymbol: "",
  currencyCode: "",
  currencySymbolOverride: null as string | null
};

interface ChooseTemplateDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (template: TemplateDefinition) => void;
  selectedTemplateId?: string;
  currencySymbol?: string;
  currencyCode?: string;
}

const CategoryIcon = ({ id }: { id: string }) => {
  switch (id) {
    case 'recommended': return <Star className="w-4 h-4" />;
    case 'essentials': return <Layout className="w-4 h-4" />;
    case 'professional': return <Briefcase className="w-4 h-4" />;
    case 'creative': return <Palette className="w-4 h-4" />;
    case 'geometric': return <Box className="w-4 h-4" />;
    case 'platinum': return <Diamond className="w-4 h-4" />;
    default: return <Layout className="w-4 h-4" />;
  }
};

export const ChooseTemplateDialog: React.FC<ChooseTemplateDialogProps> = ({ 
  isOpen, 
  onClose, 
  onSelect, 
  selectedTemplateId,
  currencySymbol = "₦",
  currencyCode = "NGN"
}) => {
  const { user, userData } = useAuth();
  const [activeCategory, setActiveCategory] = useState<TemplateCategory>('recommended');
  const [searchQuery, setSearchQuery] = useState('');
  const [unitPrice, setUnitPrice] = useState<number | null>(null);
  const [unlockTemplate, setUnlockTemplate] = useState<TemplateDefinition | null>(null);

  const isFreeUser = userData?.plan === 'explorer' || !userData;
  const paygBundle = usePaygBundle(user?.id);

  React.useEffect(() => {
    pricingService.getTemplatePrice().then(setUnitPrice);
  }, []);

  const mockDataWithCurrency = useMemo(() => ({
    ...MOCK_DATA,
    currencySymbol,
    sender: {
      ...MOCK_DATA.sender,
      preferred_currency: currencyCode
    }
  }), [currencySymbol, currencyCode]);

  const filteredTemplates = useMemo(() => {
    return INVOICE_TEMPLATES.filter(t => {
      const matchesCategory = t.category.includes(activeCategory);
      const matchesSearch = t.name.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    });
  }, [activeCategory, searchQuery]);

  const handleTemplateClick = (template: TemplateDefinition) => {
    if (template.isPremium && isFreeUser) {
      if (user) {
        // Check if already unlocked permanently
        if (paygBundle.hasAccess('invoice', template.id)) {
          onSelect(template);
          return;
        }
        
        // If not unlocked but we have a credit, redeem it silently!
        if (paygBundle.state.credits.invoiceTemplates > 0) {
          if (paygBundle.redeemCredit('invoice', template.id)) {
             onSelect(template);
             return;
          }
        }
      }
      setUnlockTemplate(template);
    } else {
      onSelect(template);
    }
  };

  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 md:p-6 lg:p-8">
        <motion.div 
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="absolute inset-0 bg-[#0F172A]/90 backdrop-blur-xl" 
          onClick={onClose} 
        />
        
        <motion.div 
          initial={{ opacity: 0, scale: 0.95, y: 20 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          exit={{ opacity: 0, scale: 0.95, y: 20 }}
          transition={{ type: 'spring', damping: 25, stiffness: 300 }}
          className="relative w-full max-w-7xl bg-[#F8FAFC] rounded-[24px] shadow-[0_32px_128px_-16px_rgba(0,0,0,0.5)] overflow-hidden flex flex-col max-h-[95vh] border border-white/10"
        >
          
          {/* Header Area - Tightened Spacing */}
          <div className="relative p-6 lg:px-10 lg:py-6 bg-white overflow-hidden shrink-0">
            {/* Abstract Background Element */}
            <div className="absolute top-0 right-0 w-96 h-96 bg-gradient-to-br from-[#166FBB]/5 to-transparent rounded-full -mr-48 -mt-48 blur-3xl" />
            
            <div className="relative flex flex-col lg:flex-row lg:items-center justify-between gap-6">
              <div className="space-y-1">
                <h2 className="text-xl lg:text-2xl font-black text-[#0F172A] tracking-tight leading-tight">
                  Choose Your Invoice
                </h2>
                <p className="text-slate-500 font-medium text-[13px] lg:text-sm opacity-80">
                  Select from 180+ world-class invoice designs.
                </p>
              </div>

              <div className="flex flex-col md:flex-row items-center gap-4">
                {/* Search Bar - More Compact */}
                <div className="relative group w-full lg:w-72">
                  <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-300 group-focus-within:text-[#166FBB] transition-colors" />
                  <input 
                    type="text"
                    placeholder="Search designs..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full h-11 pl-11 pr-6 bg-slate-50 border border-slate-100 rounded-xl font-bold text-[13px] text-slate-700 placeholder:text-slate-400 focus:outline-none focus:border-[#166FBB]/30 focus:bg-white transition-all shadow-sm"
                  />
                </div>
                
                <button 
                  onClick={onClose}
                  className="hidden lg:flex w-10 h-10 rounded-full bg-slate-50 hover:bg-white hover:shadow-xl items-center justify-center text-slate-300 hover:text-[#0F172A] transition-all border border-slate-100"
                >
                  <X className="w-5 h-5" strokeWidth={2.5} />
                </button>
              </div>
            </div>
          </div>

          {/* Categories Navigation - Larger Font for Desktop */}
          <div className="px-8 lg:px-10 py-0.5 bg-white border-y border-slate-50 flex items-center gap-8 overflow-x-auto no-scrollbar scroll-smooth shrink-0">
            {INVOICE_TEMPLATE_CATEGORIES.map((category) => (
              <button
                key={category.id}
                onClick={() => setActiveCategory(category.id)}
                className={`relative py-3 px-1 flex items-center gap-2 transition-all duration-300 whitespace-nowrap ${
                  activeCategory === category.id 
                    ? 'text-[#0F172A]' 
                    : 'text-slate-400 hover:text-slate-600'
                }`}
              >
                <div className={`${activeCategory === category.id ? 'text-[#166FBB]' : 'text-slate-300'} transition-colors`}>
                  <CategoryIcon id={category.id} />
                </div>
                <span className={`text-[11px] lg:text-[13px] uppercase tracking-[0.1em] ${activeCategory === category.id ? 'font-black' : 'font-bold'}`}>
                  {category.label}
                </span>
                
                {activeCategory === category.id && (
                  <motion.div 
                    layoutId="activeTabUnderline"
                    className="absolute bottom-0 left-0 right-0 h-0.5 bg-[#166FBB] rounded-full"
                  />
                )}
              </button>
            ))}
          </div>

          {/* Main Grid Area - Significantly smaller cards for maximum density */}
          <div className="flex-1 overflow-y-auto p-4 lg:p-8 no-scrollbar bg-white">
            <motion.div 
              layout
              className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-7 xl:grid-cols-9 2xl:grid-cols-10 gap-4 lg:gap-6"
            >
              <AnimatePresence mode="popLayout">
                {filteredTemplates.map((template, index) => (
                  <motion.div
                    key={template.id}
                    layout
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, scale: 0.95 }}
                    transition={{ delay: index * 0.02 }}
                    onClick={() => handleTemplateClick(template)}
                    className={`group relative aspect-[1/1.414] bg-[#F8FAFC] rounded-[16px] overflow-hidden transition-all duration-500 cursor-pointer border-2 ${
                      selectedTemplateId === template.id 
                        ? 'border-[#166FBB]' 
                        : 'border-transparent hover:border-slate-100 hover:shadow-2xl'
                    }`}
                  >
                    {/* Thumbnail - Full Card */}
                    <div className="absolute inset-0">
                      {template.thumbnail === '/placeholder.png' ? (
                        <div className="absolute inset-0 bg-white group-hover:scale-105 transition-transform duration-700 ease-out origin-top">
                          <div className="absolute top-0 left-0 w-[1000px] h-[1414px] origin-top-left scale-[0.15] md:scale-[0.16] lg:scale-[0.13] xl:scale-[0.15] 2xl:scale-[0.18]">
                            <TemplateEngine template={template} data={mockDataWithCurrency} />
                          </div>
                        </div>
                      ) : (
                        <Image 
                          src={template.thumbnail || '/placeholder.png'} 
                          alt={template.name}
                          fill
                          className="object-cover group-hover:scale-105 transition-transform duration-700 ease-out"
                        />
                      )}
                      
                      {/* Premium Badge - Minimal - Top Right */}
                      {template.isPremium && (
                        <div className="absolute top-4 right-4 flex flex-col gap-2 items-end z-10">
                          <PremiumBadge size="sm" />
                          {template.id.startsWith('prof-') && (
                            <div className="px-2 py-0.5 bg-emerald-500 text-white rounded-md shadow-lg border border-emerald-400 animate-pulse">
                               <p className="text-[8px] font-black uppercase tracking-widest">NEW</p>
                            </div>
                          )}
                          {isFreeUser && unitPrice !== null && (
                            <div className="px-2 py-1 bg-white/90 backdrop-blur-md rounded-lg shadow-sm border border-amber-200">
                                <p className="text-[9px] font-black text-amber-700">${unitPrice.toFixed(2)}</p>
                            </div>
                          )}
                        </div>
                      )}

                      {/* Selected Overlay */}
                      {selectedTemplateId === template.id && (
                        <div className="absolute inset-0 bg-[#166FBB]/10 backdrop-blur-[1px] flex items-center justify-center z-10">
                          <div className="w-12 h-12 bg-[#166FBB] rounded-full flex items-center justify-center text-white shadow-2xl scale-110">
                            <Check className="w-6 h-6" strokeWidth={3.5} />
                          </div>
                        </div>
                      )}

                      {/* Hover Actions - More Minimal */}
                      <div className="absolute inset-0 bg-[#0F172A]/40 opacity-0 group-hover:opacity-100 transition-all duration-300 flex flex-col items-center justify-center gap-3 p-4 backdrop-blur-[1px] z-20">
                        <button className="px-5 h-9 bg-[#166FBB] text-white rounded-xl font-black text-[9px] uppercase tracking-widest shadow-xl transform translate-y-2 group-hover:translate-y-0 transition-all duration-500">
                          {template.isPremium && isFreeUser ? `Unlock for $${unitPrice?.toFixed(2)}` : 'Select Template'}
                        </button>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </AnimatePresence>
            </motion.div>

            {filteredTemplates.length === 0 && (
              <div className="flex flex-col items-center justify-center py-24 text-center">
                <div className="w-20 h-20 bg-slate-50 rounded-[28px] flex items-center justify-center mb-6 border border-slate-100">
                  <Search className="w-8 h-8 text-slate-200" />
                </div>
                <h4 className="text-xl font-black text-[#0F172A] mb-1">No designs found</h4>
                <p className="text-slate-400 font-medium text-sm">
                  Try a different search term.
                </p>
              </div>
            )}
          </div>

          {/* Minimal Footer */}
          <div className="px-12 py-8 bg-white border-t border-slate-50 flex flex-col md:flex-row justify-between items-center gap-6 shrink-0">
             <div className="flex items-center gap-5">
                <div className="flex -space-x-3">
                  {[1,2,3].map(i => (
                    <div key={i} className="w-10 h-10 rounded-xl border-2 border-white bg-slate-100 overflow-hidden">
                      <Image src={`https://i.pravatar.cc/150?u=noble${i}`} alt="user" width={40} height={40} />
                    </div>
                  ))}
                </div>
                <div>
                  <p className="text-[10px] font-black text-[#0F172A] uppercase tracking-widest">Global Community</p>
                  <p className="text-xs text-slate-400 font-medium">Join growing businesses using Noble templates.</p>
                </div>
             </div>
             
             <div className="flex items-center gap-6">
               <button 
                 onClick={onClose}
                 className="px-10 h-13 bg-[#166FBB] text-white rounded-[20px] font-black text-[12px] uppercase tracking-[0.15em] hover:shadow-[0_12px_24px_-8px_rgba(22,111,187,0.4)] hover:-translate-y-0.5 active:translate-y-0 transition-all flex items-center gap-3"
               >
                 Continue to Editor <ArrowRight className="w-4 h-4" />
               </button>
             </div>
          </div>
        </motion.div>
        
        {unlockTemplate && (
          <PaygUnlockModal
            isOpen={!!unlockTemplate}
            onClose={() => setUnlockTemplate(null)}
            triggerCategory="invoice"
            templateId={unlockTemplate.id}
            templateName={unlockTemplate.name}
            onUnlocked={() => {
              onSelect(unlockTemplate);
              setUnlockTemplate(null);
            }}
          />
        )}
      </div>
    </AnimatePresence>
  );
};
