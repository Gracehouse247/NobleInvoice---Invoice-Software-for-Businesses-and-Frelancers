import React from 'react';
import Link from 'next/link';
import { ArrowLeft, Scale } from 'lucide-react';
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Terms of Service — NobleInvoice Usage Agreement',
  description: 'NobleInvoice terms of service. Understand your rights, billing terms, acceptable use policies, and our commitment to your business growth.',
  keywords: ['terms of service', 'usage agreement', 'invoice software rules', 'SaaS billing terms'],
};

export default function TermsPage() {
    return (
        <div className="min-h-screen bg-slate-50 text-slate-900 pt-32 pb-24 px-6 overflow-hidden relative">
            {/* Background elements */}
            <div className="absolute top-0 left-1/4 w-[600px] h-[600px] bg-blue-100 blur-[150px] rounded-full -z-10" />
            <div className="absolute top-40 right-1/4 w-[500px] h-[500px] bg-indigo-50 blur-[120px] rounded-full -z-10" />

            <div className="max-w-4xl mx-auto space-y-12">
                <Link href="/" className="inline-flex items-center gap-2 text-sm font-bold text-slate-500 hover:text-blue-600 transition-colors uppercase tracking-widest">
                    <ArrowLeft className="w-4 h-4" />
                    Back to Home
                </Link>

                <header className="space-y-6">
                    <div className="w-16 h-16 rounded-[24px] bg-blue-100 flex items-center justify-center border border-blue-200 shadow-sm">
                        <Scale className="w-8 h-8 text-blue-600" />
                    </div>
                    <div>
                        <h1 className="text-4xl sm:text-5xl font-black tracking-tight text-slate-900">Terms of Service</h1>
                        <p className="text-slate-500 mt-4 font-medium max-w-2xl text-lg">
                            Effective upon user acceptance. Last Updated: June 15, 2026.
                        </p>
                    </div>
                </header>

                <div className="bg-white p-8 md:p-12 rounded-[3rem] shadow-xl shadow-slate-200/50 border border-slate-100 space-y-10">
                    <p className="text-lg text-slate-600 leading-relaxed font-medium">
                        Welcome to NobleInvoice. These Terms of Service constitute a legally binding agreement between you ("User", "Business") and NobleInvoice regarding your use of our invoicing, CRM, and digital business platform.
                    </p>

                    <section className="space-y-4 group">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4 transition-colors">01. ACCEPTANCE OF TERMS</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            By creating an account, generating an invoice, or accessing the Service, you confirm that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. If you do not agree, you must cease use of the Service immediately.
                        </p>
                    </section>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">02. ELIGIBILITY & SECURITY</h2>
                        <div className="bg-slate-50 p-6 rounded-2xl border border-slate-100 space-y-4 mt-4">
                            <p className="text-slate-600 text-sm leading-relaxed"><strong className="text-slate-900">Age & Authority:</strong> You must be at least 18 years of age and possess the legal authority to bind your business entity to these Terms.</p>
                            <p className="text-slate-600 text-sm leading-relaxed"><strong className="text-slate-900">Account Integrity:</strong> You are strictly responsible for maintaining the confidentiality of your login credentials and all activities that occur under your NobleInvoice workspace.</p>
                        </div>
                    </section>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">03. ACCEPTABLE USE & PROHIBITED ACTIVITIES</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            NobleInvoice is a tool for legitimate business operations. You agree not to use the Service to:
                        </p>
                        <ul className="space-y-3 pt-2">
                            <li className="flex items-start gap-3 text-slate-600">
                                <span className="text-blue-600 font-bold mt-1">→</span>
                                <span>Generate fraudulent, deceptive, or legally invalid invoices.</span>
                            </li>
                            <li className="flex items-start gap-3 text-slate-600">
                                <span className="text-blue-600 font-bold mt-1">→</span>
                                <span>Process payments for illegal goods, services, or activities prohibited by our payment partners.</span>
                            </li>
                            <li className="flex items-start gap-3 text-slate-600">
                                <span className="text-blue-600 font-bold mt-1">→</span>
                                <span>Upload malicious code, attempt to bypass security protocols, or reverse-engineer our platform.</span>
                            </li>
                        </ul>
                    </section>

                    <section className="p-8 bg-gradient-to-br from-slate-50 to-white rounded-[24px] border border-slate-200 shadow-sm space-y-8">
                        <h2 className="text-2xl font-bold text-slate-900">04. FINANCIAL DISCLAIMERS & LIABILITY</h2>
                        <div>
                            <h3 className="text-sm font-bold uppercase tracking-widest text-blue-600 mb-2">Software, Not a Bank</h3>
                            <p className="text-slate-600 text-sm italic border-l-2 border-blue-600 pl-4 py-1">
                                LEGAL NOTICE: NobleInvoice provides software tools for invoicing and CRM. We are not a bank, financial institution, or payment processor. All payment routing and wallet functionalities are facilitated by third-party gateways (e.g., Stripe, Flutterwave).
                            </p>
                        </div>
                        <div>
                            <h3 className="text-sm font-bold uppercase tracking-widest text-blue-600 mb-2">Unpaid Invoices & Disputes</h3>
                            <p className="text-slate-600 text-sm italic border-l-2 border-slate-300 pl-4 py-1">
                                NobleInvoice assumes no liability for unpaid invoices, chargebacks, delayed payouts, or disputes between you and your clients. We merely provide the medium for transaction requests.
                            </p>
                        </div>
                    </section>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">05. SUBSCRIPTIONS, BILLING & REFUNDS</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            While NobleInvoice offers a robust free tier, premium features (Pro/Enterprise) require a subscription. Fees are billed in advance on a recurring cycle. You may cancel your subscription at any time; however, all payments are non-refundable unless legally required by your jurisdiction. Upon cancellation, you will retain access to premium features until the end of your billing cycle.
                        </p>
                    </section>

                    <section className="space-y-4">
                        <h2 className="text-2xl font-bold text-slate-900 border-b border-slate-100 pb-4">06. DATA OWNERSHIP & INTELLECTUAL PROPERTY</h2>
                        <p className="text-slate-600 leading-relaxed pt-2">
                            You retain full ownership of all business data, client lists, and content you upload. By using the Service, you grant NobleInvoice a worldwide, royalty-free license to host, copy, and process your data strictly to deliver the service. NobleInvoice retains all intellectual property rights to the platform, including its code, design, gamification mechanics, and AI algorithms.
                        </p>
                    </section>
                </div>

                <footer className="pt-8 text-center border-t border-slate-200">
                    <p className="text-slate-900 font-bold mb-2">Legal Department</p>
                    <a href="mailto:legal@noblesworld.com.ng" className="text-blue-600 font-bold hover:text-blue-800 decoration-2 underline-offset-4 transition-all tracking-tight">legal@noblesworld.com.ng</a>
                    <div className="mt-8 flex justify-center gap-6">
                        <span className="text-[10px] font-bold uppercase tracking-widest text-slate-400">Copyright © 2026 NobleInvoice</span>
                    </div>
                </footer>
            </div>
        </div>
    );
}
