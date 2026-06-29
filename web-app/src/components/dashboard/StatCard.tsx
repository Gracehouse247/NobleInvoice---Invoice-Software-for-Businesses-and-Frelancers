import React from 'react';
import { LucideIcon } from 'lucide-react';

interface StatCardProps {
    title: string;
    value: string;
    icon: LucideIcon;
    badgeText: string;
    badgeType: 'positive' | 'warning' | 'neutral';
    iconBgColor: string;
    iconColor: string;
    loading?: boolean;
}

export default function StatCard({ title, value, icon: Icon, badgeText, badgeType, iconBgColor, iconColor, loading = false }: StatCardProps) {
    const getBadgeStyle = () => {
        switch (badgeType) {
            case 'positive':
                return 'bg-green-50 text-green-600 border-green-100';
            case 'warning':
                return 'bg-orange-50 text-orange-500 border-orange-100';
            case 'neutral':
                return 'bg-slate-50 text-slate-500 border-slate-100';
            default:
                return 'bg-slate-50 text-slate-500 border-slate-100';
        }
    };

    return (
        <div className="bg-white/80 backdrop-blur-xl border border-white rounded-[24px] p-5 shadow-[0_8px_30px_rgb(0,0,0,0.04)] flex flex-col justify-between hover:shadow-[0_8px_30px_rgb(0,0,0,0.08)] transition-all">
            <div className="flex justify-between items-start mb-4">
                <div className={`w-12 h-12 rounded-2xl flex items-center justify-center ${iconBgColor}`}>
                    <Icon className={`w-5 h-5 ${iconColor}`} />
                </div>
                <div className={`px-3 py-1 rounded-full border text-xs font-medium ${getBadgeStyle()}`}>
                    {badgeText}
                </div>
            </div>
            <div>
                <h3 className="text-sm font-medium text-slate-500 mb-1">{title}</h3>
                {loading ? (
                    <div className="h-8 bg-slate-200 rounded animate-pulse w-24"></div>
                ) : (
                    <p className="text-2xl md:text-3xl font-bold text-slate-900">{value}</p>
                )}
            </div>
        </div>
    );
}
