import React from 'react';
import { TrendingUp, ChevronRight, AlertCircle } from 'lucide-react';
import { Invoice } from '@/types';
import { currencyService } from '@/lib/services/currencyService';

export default function PredictiveHub({ invoices = [], currencyCode = 'USD' }: { invoices?: Invoice[], currencyCode?: string }) {
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    
    const projectedRevenue = invoices.filter(inv => {
        if (inv.status === 'paid') return false;
        if (!inv.due_date) return false;
        const dueDate = new Date(inv.due_date);
        return dueDate.getMonth() === nextMonth.getMonth() && dueDate.getFullYear() === nextMonth.getFullYear();
    }).reduce((sum, inv) => sum + (inv.total_amount || 0), 0);

    const hasData = projectedRevenue > 0;
    return (
        <div className="flex flex-col gap-4">
            <div className="flex items-center gap-2 mb-2">
                <div className="w-6 h-6 rounded bg-noble-blue/10 flex items-center justify-center">
                    <TrendingUp className="w-3 h-3 text-noble-blue" />
                </div>
                <h3 className="text-sm font-semibold text-slate-500 uppercase">PREDICTIVE HUB</h3>
            </div>
            
            <button className="bg-white/90 backdrop-blur-xl border border-white rounded-[24px] p-5 shadow-[0_8px_30px_rgb(0,0,0,0.04)] flex items-center justify-between hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)] hover:scale-[1.02] transition-all group w-full text-left h-full">
                <div className="flex items-center gap-5">
                    <div className="w-12 h-12 rounded-2xl bg-cyan-50 flex items-center justify-center">
                        <TrendingUp className="w-5 h-5 text-cyan-500" />
                    </div>
                    <div>
                        <h4 className="font-bold text-slate-900 mb-1">Revenue Forecast</h4>
                        {hasData ? (
                            <>
                                <p className="text-xl font-black text-slate-900 mb-1">{currencyService.format(projectedRevenue, currencyCode)}</p>
                                <p className="text-xs text-slate-500 max-w-[150px] leading-relaxed">
                                    PROJECTED INCOME FOR NEXT MONTH.
                                </p>
                            </>
                        ) : (
                            <div className="flex items-start gap-2 mt-2">
                                <AlertCircle className="w-4 h-4 text-slate-400 shrink-0 mt-0.5" />
                                <p className="text-xs text-slate-400 max-w-[150px] leading-relaxed">
                                    Not enough data. Send invoices due next month to see your forecast.
                                </p>
                            </div>
                        )}
                    </div>
                </div>
                <div className="w-8 h-8 rounded-full border border-slate-100 flex items-center justify-center text-slate-400 group-hover:bg-slate-50 group-hover:text-noble-blue transition-colors">
                    <ChevronRight className="w-4 h-4" />
                </div>
            </button>
        </div>
    );
}
