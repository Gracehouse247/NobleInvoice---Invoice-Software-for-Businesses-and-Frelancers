import React from 'react';
import { currencyService } from '@/lib/services/currencyService';

interface AccountsReceivableProps {
    invoices: any[];
    currencyCode: string;
}

export default function AccountsReceivable({ invoices = [], currencyCode = 'NGN' }: AccountsReceivableProps) {
    const now = new Date();
    
    let current = 0;
    let days1_30 = 0;
    let days31_60 = 0;
    let days60plus = 0;
    let totalOverdue = 0;

    invoices.forEach(inv => {
        if (inv.status === 'paid' || inv.status === 'draft') return;
        
        const amount = Number(inv.total_amount) || 0;
        const dueDate = inv.due_date ? new Date(inv.due_date) : new Date(inv.created_at);
        
        if (dueDate >= now) {
            current += amount;
        } else {
            totalOverdue += amount;
            const diffDays = Math.floor((now.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24));
            if (diffDays <= 30) days1_30 += amount;
            else if (diffDays <= 60) days31_60 += amount;
            else days60plus += amount;
        }
    });

    const total = current + totalOverdue;
    const format = (amt: number) => currencyService.format(amt, currencyCode, { decimals: 0 });

    const getPercent = (amt: number) => total > 0 ? `${(amt / total) * 100}%` : '0%';

    return (
        <div className="bg-white/80 backdrop-blur-xl border border-white rounded-[24px] p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] h-full flex flex-col justify-between">
            <div className="flex justify-between items-start mb-6">
                <div>
                    <h3 className="text-base font-bold text-slate-900 mb-1">Accounts Receivable</h3>
                    <p className="text-sm text-slate-500">AGING & OVERDUE ANALYSIS</p>
                </div>
                <div className="px-3 py-1 rounded-full border border-red-100 bg-red-50 flex items-center gap-2">
                    <span className="text-xs font-medium uppercase text-red-600">OVERDUE</span>
                    <span className="text-sm font-semibold text-red-600">{format(totalOverdue)}</span>
                </div>
            </div>

            <div>
                <div className="grid grid-cols-4 gap-4 mb-4">
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase mb-1">CURRENT</p>
                        <p className="text-xl font-bold text-green-500">{format(current)}</p>
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase mb-1">1-30 DAYS</p>
                        <p className="text-xl font-bold text-orange-400">{format(days1_30)}</p>
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase mb-1">31-60 DAYS</p>
                        <p className="text-xl font-bold text-orange-500">{format(days31_60)}</p>
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase mb-1">60+ DAYS</p>
                        <p className="text-xl font-bold text-red-500">{format(days60plus)}</p>
                    </div>
                </div>
                
                {/* Visual Progress Bar */}
                <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden flex mt-4">
                    {total > 0 ? (
                        <>
                            <div className="h-full bg-green-500 transition-all" style={{ width: getPercent(current) }}></div>
                            <div className="h-full bg-orange-400 transition-all" style={{ width: getPercent(days1_30) }}></div>
                            <div className="h-full bg-orange-500 transition-all" style={{ width: getPercent(days31_60) }}></div>
                            <div className="h-full bg-red-500 transition-all" style={{ width: getPercent(days60plus) }}></div>
                        </>
                    ) : (
                        <div className="h-full bg-slate-200 w-full"></div>
                    )}
                </div>
            </div>
        </div>
    );
}
