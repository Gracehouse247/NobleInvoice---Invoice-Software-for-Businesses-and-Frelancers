import React from 'react';
import { Shield, Eye, Scale, Fingerprint } from 'lucide-react';
import Link from 'next/link';
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Global Compliance & Security Standards | NobleInvoice',
  description: 'NobleInvoice operates with PCI-DSS, GDPR, and SOC2 compliance standards. Learn about our anti-fraud controls, AML screening, and data protection protocols.',
  keywords: ['invoice software compliance', 'PCI-DSS invoicing', 'GDPR billing software', 'secure invoice generator'],
};

export default function CompliancePage() {
  return (
    <div className="min-h-screen bg-[#F8FAFC] pt-32 pb-24 px-6 relative overflow-hidden">
      {/* Background Ornaments */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[700px] h-[700px] bg-noble-blue/5 blur-[150px] rounded-full -mt-96" />

      <div className="max-w-[1000px] mx-auto relative z-10">
        {/* Header Block */}
        <div className="text-center max-w-2xl mx-auto mb-20 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-noble-blue/10 text-noble-blue font-bold text-[10px] uppercase tracking-widest border border-noble-blue/5">
            <span className="w-2 h-2 rounded-full bg-noble-blue animate-pulse" />
            Security & Governance
          </div>
          <h1 className="text-4xl md:text-5xl font-black text-slate-900 tracking-tight" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>
            Global Compliance
          </h1>
          <p className="text-slate-500 font-medium text-lg leading-relaxed">
            Operating with institutional-grade standards. We align our systems to global financial compliance frameworks.
          </p>
        </div>

        {/* Info Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-20">
          <div className="p-8 bg-white/70 backdrop-blur-md rounded-[32px] border border-slate-100 shadow-xl shadow-slate-100/50 space-y-4">
            <div className="w-12 h-12 rounded-xl bg-noble-blue/10 text-noble-blue flex items-center justify-center">
              <Shield className="w-5 h-5" />
            </div>
            <h3 className="text-xl font-black text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>PCI-DSS Certified</h3>
            <p className="text-slate-500 text-sm leading-relaxed">
              We process card data using PCI-DSS compliant infrastructure. Under the hood, payments are securely routed and processed through Flutterwave's audited networks.
            </p>
          </div>

          <div className="p-8 bg-white/70 backdrop-blur-md rounded-[32px] border border-slate-100 shadow-xl shadow-slate-100/50 space-y-4">
            <div className="w-12 h-12 rounded-xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center">
              <Eye className="w-5 h-5" />
            </div>
            <h3 className="text-xl font-black text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>AML & KYC Screening</h3>
            <p className="text-slate-500 text-sm leading-relaxed">
              Our automated ledger engine performs systematic Anti-Money Laundering checks. High-volume business nodes undergo rigorous Know Your Customer processing to ensure clean transacting pipelines.
            </p>
          </div>

          <div className="p-8 bg-white/70 backdrop-blur-md rounded-[32px] border border-slate-100 shadow-xl shadow-slate-100/50 space-y-4">
            <div className="w-12 h-12 rounded-xl bg-purple-500/10 text-purple-600 flex items-center justify-center">
              <Scale className="w-5 h-5" />
            </div>
            <h3 className="text-xl font-black text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Tax & Invoicing Auditing</h3>
            <p className="text-slate-500 text-sm leading-relaxed">
              Invoices generated on the platform match international specifications (VAT, sales tax rules, localized receipt details). Every entry leaves an immutable record for tax auditing.
            </p>
          </div>

          <div className="p-8 bg-white/70 backdrop-blur-md rounded-[32px] border border-slate-100 shadow-xl shadow-slate-100/50 space-y-4">
            <div className="w-12 h-12 rounded-xl bg-amber-500/10 text-amber-600 flex items-center justify-center">
              <Fingerprint className="w-5 h-5" />
            </div>
            <h3 className="text-xl font-black text-slate-900" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>GDPR & Data Transparency</h3>
            <p className="text-slate-500 text-sm leading-relaxed">
              We uphold strict data protection protocols. Clients possess absolute authority over their financial data profiles. Learn more about data routing in our Privacy policy.
            </p>
          </div>
        </div>

        {/* Central Compliance statement card */}
        <div className="p-8 md:p-10 bg-slate-900 text-white rounded-[32px] space-y-6 relative overflow-hidden">
          <div className="absolute top-0 right-0 w-[400px] h-[400px] bg-noble-blue/10 blur-[80px] rounded-full -mr-48 -mt-48" />
          <h3 className="text-2xl font-black relative z-10" style={{ fontFamily: 'Clash Display, Syne, Inter, sans-serif' }}>Our Commitment to Safety</h3>
          <p className="text-slate-400 text-sm leading-relaxed relative z-10">
            NobleInvoice represents a high-integrity ecosystem. We cooperate with leading compliance bodies and regional banks to guarantee that your business billing pathways remain completely legal, compliant, and optimized.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 pt-4 relative z-10">
            <Link href="/privacy" className="text-xs font-black uppercase tracking-wider text-noble-blue hover:text-blue-400 transition-colors">
              Privacy Framework &rarr;
            </Link>
            <Link href="/terms" className="text-xs font-black uppercase tracking-wider text-noble-blue hover:text-blue-400 transition-colors">
              Terms & Rules &rarr;
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
