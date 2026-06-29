import React from 'react';
import Link from 'next/link';
import { ArrowLeft, ShieldCheck } from 'lucide-react';
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Privacy Policy — How NobleInvoice Protects Your Data',
  description: 'Read the NobleInvoice privacy policy. We protect your B2B invoicing and payment data with banking-grade encryption. Full transparency on how your information is handled.',
  keywords: ['privacy policy', 'data protection', 'secure invoicing', 'GDPR billing compliance', 'B2B SaaS privacy'],
};

export default function PrivacyPage() {
    return (
        <div className="min-h-screen bg-slate-50 text-slate-900 pt-32 pb-24 px-6 overflow-hidden relative">
            {/* Decorative Light Mode Background */}
            <div className="absolute top-0 right-1/4 w-[600px] h-[600px] bg-blue-100 blur-[150px] rounded-full -z-10" />
            <div className="absolute bottom-40 left-1/4 w-[500px] h-[500px] bg-indigo-50 blur-[120px] rounded-full -z-10" />

            <div className="max-w-4xl mx-auto space-y-12">
                <Link href="/" className="inline-flex items-center gap-2 text-sm font-bold text-slate-500 hover:text-blue-600 transition-colors uppercase tracking-widest">
                    <ArrowLeft className="w-4 h-4" />
                    Back to Home
                </Link>

                <header className="space-y-6">
                    <div className="w-16 h-16 rounded-[24px] bg-blue-100 flex items-center justify-center border border-blue-200 shadow-sm">
                        <ShieldCheck className="w-8 h-8 text-blue-600" />
                    </div>
                    <div>
                        <h1 className="text-4xl sm:text-5xl font-black tracking-tight text-slate-900">Privacy Policy</h1>
                        <p className="text-slate-500 mt-4 font-medium max-w-2xl text-lg">
                            Effective Date: June 15, 2026. Last Updated: June 15, 2026.
                        </p>
                    </div>
                </header>

                <div className="bg-white p-8 md:p-12 rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-100 space-y-12">
                    <div className="bg-blue-50/50 border-l-4 border-blue-600 p-6 rounded-r-2xl text-slate-700 leading-relaxed font-medium">
                        "At NobleInvoice, we recognize that your financial and client data is the lifeblood of your business. Our commitment to privacy is absolute. This policy outlines how we collect, process, and safeguard your information to provide our premium B2B invoicing, CRM, and payment ecosystem."
                    </div>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">01. Data Controller & Global Compliance</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            NobleInvoice acts as the Data Processor for your client information and the Data Controller for your account information. We adhere strictly to global data protection standards, including:
                        </p>
                        <ul className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4">
                            {['GDPR (EU/UK)', 'CCPA/CPRA (California)', 'PIPEDA (Canada)', 'NDPR (Nigeria)'].map((law) => (
                                <li key={law} className="bg-slate-50 border border-slate-100 p-4 rounded-2xl text-sm font-bold text-slate-700 flex items-center gap-3">
                                    <div className="w-2 h-2 rounded-full bg-blue-600" /> {law}
                                </li>
                            ))}
                        </ul>
                    </section>

                    <section className="space-y-6">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">02. Information We Collect</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            To provide our comprehensive suite of business tools, we collect the following categories of data:
                        </p>
                        <div className="space-y-6 pl-4 border-l-2 border-slate-200 pt-2">
                            <div>
                                <h3 className="text-lg font-bold text-slate-800 mb-2">A. Business Identity Data</h3>
                                <ul className="text-slate-600 space-y-2 list-disc pl-5">
                                    <li><strong className="text-slate-800">Account Information:</strong> Your name, business name, industry, country, and login credentials.</li>
                                    <li><strong className="text-slate-800">Brand Settings:</strong> Your logo, brand colors, and brand voice preferences.</li>
                                </ul>
                            </div>
                            <div>
                                <h3 className="text-lg font-bold text-slate-800 mb-2">B. Financial & CRM Data</h3>
                                <ul className="text-slate-600 space-y-2 list-disc pl-5">
                                    <li><strong className="text-slate-800">Invoicing Data:</strong> Invoice amounts, line items, taxes, discounts, and payment status.</li>
                                    <li><strong className="text-slate-800">Client Information (CRM):</strong> Your clients' names, emails, addresses, and transaction histories.</li>
                                    <li><strong className="text-slate-800">Wallet & Payments:</strong> Bank account details for payouts, transaction records, and preferred currencies. Note: We do not store full credit card numbers; these are handled securely by our payment partners (e.g., Stripe, Flutterwave).</li>
                                </ul>
                            </div>
                            <div>
                                <h3 className="text-lg font-bold text-slate-800 mb-2">C. Usage & Engagement Data</h3>
                                <ul className="text-slate-600 space-y-2 list-disc pl-5">
                                    <li><strong className="text-slate-800">Platform Analytics:</strong> Device IP, browser type, and interactions with features like QR code generation or Business Cards.</li>
                                    <li><strong className="text-slate-800">Gamification:</strong> Your earned XP, levels, and badges within the NobleInvoice ecosystem.</li>
                                </ul>
                            </div>
                        </div>
                    </section>

                    <section className="space-y-6">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">03. How We Use Your Data</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            We use your data solely to operate, improve, and protect the NobleInvoice platform:
                        </p>
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                            <div className="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                                <span className="text-xs font-bold text-blue-600 uppercase tracking-widest">Core Service</span>
                                <h4 className="font-bold text-slate-900 mt-2">Invoicing & Payments</h4>
                                <p className="text-sm text-slate-600 mt-2 leading-relaxed">Generating professional invoices, sending automated reminders, and routing payments to your connected Wallet.</p>
                            </div>
                            <div className="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                                <span className="text-xs font-bold text-blue-600 uppercase tracking-widest">AI Enhancements</span>
                                <h4 className="font-bold text-slate-900 mt-2">Smart CRM & Insights</h4>
                                <p className="text-sm text-slate-600 mt-2 leading-relaxed">Using anonymized data to provide cash flow predictions, client intelligence, and gamified business goals.</p>
                            </div>
                        </div>
                    </section>
                    
                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">04. Data Sharing & Third Parties</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            We <strong className="text-slate-900">do not sell</strong> your personal or business data. We only share information with trusted infrastructure and payment partners necessary to deliver our services (e.g., Supabase for secure database hosting, and payment gateways for processing transactions). All partners are bound by strict SOC2 and GDPR-compliant confidentiality agreements.
                        </p>
                    </section>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">05. Your Rights & Data Retention</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            You own your data. You have the right to access, rectify, export, or delete your data at any time via your Account Settings. We retain your data only for as long as your account is active, or as required to comply with our legal and financial auditing obligations.
                        </p>
                    </section>
                </div>

                <footer className="pt-8 text-center border-t border-slate-200">
                    <p className="text-slate-900 font-bold mb-2">Data Protection Officer</p>
                    <a href="mailto:privacy@noblesworld.com.ng" className="text-blue-600 font-bold hover:text-blue-800 decoration-2 underline-offset-4 transition-all tracking-tight">privacy@noblesworld.com.ng</a>
                    <p className="mt-8 text-xs text-slate-400 max-w-md mx-auto">This policy is governed by applicable international data protection laws.</p>
                </footer>
            </div>
        </div>
    );
}
