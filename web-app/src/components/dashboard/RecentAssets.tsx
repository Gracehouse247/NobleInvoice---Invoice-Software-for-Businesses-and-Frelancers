import React from 'react';
import { FileText, MoreHorizontal } from 'lucide-react';
import { currencyService } from '@/lib/services/currencyService';
import Link from 'next/link';

interface RecentAssetsProps {
    invoices: any[];
    currencyCode: string;
}

export default function RecentAssets({ invoices = [], currencyCode = 'NGN' }: RecentAssetsProps) {
    const recentInvoices = invoices.slice(0, 5).map(inv => {
        let type = 'neutral';
        if (inv.status === 'paid') type = 'positive';
        else if (inv.status === 'overdue') type = 'negative';
        else if (inv.status === 'pending' || inv.status === 'sent' || inv.status === 'unpaid') type = 'warning';

        return {
            id: inv.id,
            invoiceNumber: inv.invoice_number,
            client: inv.clients?.name || 'Unknown Client',
            amount: currencyService.format(inv.total_amount, inv.currency_code || currencyCode, { decimals: 0 }),
            status: inv.status,
            type
        };
    });

    const getStatusStyle = (type: string) => {
        if (type === 'positive') return 'bg-emerald-50 text-emerald-600 border-emerald-100';
        if (type === 'warning') return 'bg-amber-50 text-amber-600 border-amber-100';
        if (type === 'negative') return 'bg-red-50 text-red-600 border-red-100';
        return 'bg-slate-50 text-slate-600 border-slate-100';
    };

    return (
        <div className="bg-white/80 backdrop-blur-xl border border-white rounded-[32px] p-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)] h-full flex flex-col">
            <div className="flex justify-between items-center mb-6">
                <h3 className="text-base font-bold text-slate-900">Recent Activities</h3>
                <div className="w-8 h-8 rounded-full border border-slate-200 flex items-center justify-center text-slate-400 hover:bg-slate-50 cursor-pointer">
                    <MoreHorizontal className="w-4 h-4" />
                </div>
            </div>

            <div className="flex-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
                {recentInvoices.length > 0 ? recentInvoices.map((asset) => (
                    <Link href={`/invoices`} key={asset.id} className="flex items-center justify-between p-4 rounded-[20px] hover:bg-slate-50 transition-colors group cursor-pointer border border-transparent hover:border-slate-100">
                        <div className="flex items-center gap-4">
                            <div className="w-12 h-12 rounded-2xl border border-slate-200 bg-white shadow-sm flex items-center justify-center group-hover:scale-105 transition-transform">
                                <FileText className="w-5 h-5 text-noble-blue" />
                            </div>
                            <div>
                                <p className="font-medium text-slate-900 mb-0.5 text-xs">{asset.invoiceNumber}</p>
                                <p className="text-[10px] text-slate-500 uppercase">{asset.client}</p>
                            </div>
                        </div>
                        <div className="text-right">
                            <p className="font-semibold text-slate-900 text-sm mb-0.5">{asset.amount}</p>
                            <span className={`px-2 py-0.5 border rounded text-[9px] font-medium uppercase ${getStatusStyle(asset.type)}`}>
                                {asset.status}
                            </span>
                        </div>
                    </Link>
                )) : (
                    <div className="flex items-center justify-center h-full text-sm text-slate-400">
                        No recent invoices found.
                    </div>
                )}
            </div>

            <Link href="/invoices" className="w-full mt-6 py-4 rounded-xl border border-slate-200 bg-white text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors shadow-sm text-center block">
                View Transaction History
            </Link>
        </div>
    );
}
