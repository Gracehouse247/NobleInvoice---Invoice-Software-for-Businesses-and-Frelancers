'use client';

import React, { useState, useMemo } from 'react';
import { INVOICE_TEMPLATE_CATEGORIES, INVOICE_TEMPLATES, TemplateCategory, TemplateDefinition } from '@/lib/templates/templateRegistry';
import { Star, Layout, Briefcase, Palette, Box, Diamond, Search, Check } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { TemplateEngine } from '@/components/invoice/TemplateEngine';
import Image from 'next/image';

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
  currencySymbol: "₦",
  currencyCode: "NGN",
  currencySymbolOverride: null as string | null
};

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

export default function EmbedTemplateGallery() {
  const [activeCategory, setActiveCategory] = useState<TemplateCategory>('recommended');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedTemplateId, setSelectedTemplateId] = useState<string | null>(null);

  const filteredTemplates = useMemo(() => {
    return INVOICE_TEMPLATES.filter(t => {
      const matchesCategory = t.category.includes(activeCategory);
      const matchesSearch = t.name.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    });
  }, [activeCategory, searchQuery]);

  const handleSelect = (template: TemplateDefinition) => {
    setSelectedTemplateId(template.id);
    
    // Send message back to Flutter
    if (typeof window !== 'undefined' && (window as any).NobleBridge) {
      (window as any).NobleBridge.postMessage(JSON.stringify({
        type: 'TEMPLATE_SELECTED',
        payload: template.id
      }));
    }
  };

  return (
    <div className="flex flex-col h-screen bg-[#F8FAFC] overflow-hidden select-none">
      {/* Header */}
      <div className="shrink-0 p-4 bg-white border-b border-slate-100 flex flex-col gap-4">
        <div>
          <h2 className="text-xl font-black text-[#0F172A] tracking-tight">Choose Template</h2>
          <p className="text-slate-500 font-medium text-xs">Select a professional design</p>
        </div>
        
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input 
            type="text"
            placeholder="Search templates..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full h-10 pl-10 pr-4 bg-slate-50 border border-slate-100 rounded-xl font-bold text-sm text-slate-700 placeholder:text-slate-400 focus:outline-none focus:border-[#166FBB]/30 focus:bg-white"
          />
        </div>
      </div>

      {/* Categories */}
      <div className="shrink-0 bg-white border-b border-slate-100 overflow-x-auto no-scrollbar">
        <div className="flex px-4">
          {INVOICE_TEMPLATE_CATEGORIES.map((category) => (
            <button
              key={category.id}
              onClick={() => setActiveCategory(category.id)}
              className={`relative py-4 px-4 flex items-center gap-2 whitespace-nowrap transition-colors ${
                activeCategory === category.id 
                  ? 'text-[#0F172A]' 
                  : 'text-slate-400'
              }`}
            >
              <div className={activeCategory === category.id ? 'text-[#166FBB]' : 'text-slate-300'}>
                <CategoryIcon id={category.id} />
              </div>
              <span className={`text-[11px] uppercase tracking-[0.1em] ${activeCategory === category.id ? 'font-black' : 'font-bold'}`}>
                {category.label}
              </span>
              
              {activeCategory === category.id && (
                <motion.div 
                  layoutId="activeTabUnderlineMobile"
                  className="absolute bottom-0 left-0 right-0 h-0.5 bg-[#166FBB] rounded-t-full"
                />
              )}
            </button>
          ))}
        </div>
      </div>

      {/* Grid */}
      <div className="flex-1 overflow-y-auto p-4 custom-scrollbar">
        <div className="grid grid-cols-2 gap-4">
          <AnimatePresence>
            {filteredTemplates.map((template) => (
              <motion.div
                key={template.id}
                layout
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95 }}
                onClick={() => handleSelect(template)}
                className={`relative aspect-[1/1.414] bg-white rounded-2xl overflow-hidden shadow-sm border-2 transition-all ${
                  selectedTemplateId === template.id 
                    ? 'border-[#166FBB]' 
                    : 'border-slate-100 active:scale-95'
                }`}
              >
                <div className="absolute inset-0 pointer-events-none">
                  {template.thumbnail === '/placeholder.png' ? (
                    <div className="absolute top-0 left-0 w-[1000px] h-[1414px] origin-top-left scale-[0.15]">
                      <TemplateEngine template={template} data={MOCK_DATA} />
                    </div>
                  ) : (
                    <Image 
                      src={template.thumbnail || '/placeholder.png'} 
                      alt={template.name}
                      fill
                      className="object-cover"
                    />
                  )}
                </div>

                {selectedTemplateId === template.id && (
                  <div className="absolute top-3 right-3 w-6 h-6 bg-[#166FBB] rounded-full flex items-center justify-center text-white shadow-md z-10">
                    <Check className="w-3.5 h-3.5" strokeWidth={3} />
                  </div>
                )}
              </motion.div>
            ))}
          </AnimatePresence>
        </div>

        {filteredTemplates.length === 0 && (
          <div className="py-12 flex flex-col items-center text-center opacity-50">
            <Search className="w-8 h-8 text-slate-400 mb-3" />
            <p className="font-bold text-slate-600">No templates found</p>
          </div>
        )}
        
        {/* Padding for bottom safe area */}
        <div className="h-12" />
      </div>
    </div>
  );
}
