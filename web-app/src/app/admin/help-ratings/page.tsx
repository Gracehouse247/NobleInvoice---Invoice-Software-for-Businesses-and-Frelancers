'use client';

import React, { useState, useEffect } from 'react';
import { Star, ThumbsUp, ThumbsDown, Loader2, RefreshCw } from 'lucide-react';
import { supabase } from '@/lib/supabase';

interface Rating {
    id: string;
    article_slug: string;
    category_slug: string;
    helpful: boolean;
    created_at: string;
}

export default function HelpRatingsPage() {
    const [ratings, setRatings] = useState<Rating[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchRatings = async () => {
        setLoading(true);
        try {
            const { data, error } = await supabase
                .from('help_center_ratings')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) {
                console.error('Error fetching ratings:', error);
                return;
            }
            setRatings(data || []);
        } catch (err) {
            console.error('Failed to fetch ratings:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchRatings();
    }, []);

    const totalHelpful = ratings.filter(r => r.helpful).length;
    const totalNotHelpful = ratings.filter(r => !r.helpful).length;
    const helpfulPercentage = ratings.length > 0 
        ? Math.round((totalHelpful / ratings.length) * 100) 
        : 0;

    return (
        <div className="space-y-6">
            <header className="flex justify-between items-end">
                <div>
                    <h1 className="text-3xl font-bold tracking-tight text-slate-900 mb-2">Help Center Ratings</h1>
                    <p className="text-slate-500 font-medium">View feedback and usefulness ratings from your Help Center articles.</p>
                </div>
                <button 
                    onClick={fetchRatings} 
                    className="flex items-center gap-2 bg-white border border-slate-200 hover:bg-slate-50 text-slate-700 px-4 py-2 rounded-xl text-sm font-bold shadow-sm transition-all"
                >
                    <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin text-[#006970]' : ''}`} />
                    Refresh
                </button>
            </header>

            {/* Stats Grid */}
            <div className="grid md:grid-cols-3 gap-6">
                <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
                    <div className="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center border border-blue-100">
                        <Star className="w-6 h-6" />
                    </div>
                    <div>
                        <p className="text-sm font-bold text-slate-400 uppercase tracking-wider mb-1">Total Ratings</p>
                        <p className="text-2xl font-black text-slate-900">{ratings.length}</p>
                    </div>
                </div>
                <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
                    <div className="w-12 h-12 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center border border-emerald-100">
                        <ThumbsUp className="w-6 h-6" />
                    </div>
                    <div>
                        <p className="text-sm font-bold text-slate-400 uppercase tracking-wider mb-1">Helpful</p>
                        <div className="flex items-end gap-2">
                            <p className="text-2xl font-black text-slate-900">{totalHelpful}</p>
                            <span className="text-emerald-600 font-bold text-sm mb-1">({helpfulPercentage}%)</span>
                        </div>
                    </div>
                </div>
                <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm flex items-center gap-4">
                    <div className="w-12 h-12 rounded-xl bg-red-50 text-red-600 flex items-center justify-center border border-red-100">
                        <ThumbsDown className="w-6 h-6" />
                    </div>
                    <div>
                        <p className="text-sm font-bold text-slate-400 uppercase tracking-wider mb-1">Not Helpful</p>
                        <p className="text-2xl font-black text-slate-900">{totalNotHelpful}</p>
                    </div>
                </div>
            </div>

            {/* Ratings Table */}
            <div className="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full text-left">
                        <thead className="bg-slate-50 border-b border-slate-200">
                            <tr>
                                <th className="px-6 py-4 text-xs font-black uppercase tracking-widest text-slate-500">Date</th>
                                <th className="px-6 py-4 text-xs font-black uppercase tracking-widest text-slate-500">Article</th>
                                <th className="px-6 py-4 text-xs font-black uppercase tracking-widest text-slate-500">Category</th>
                                <th className="px-6 py-4 text-xs font-black uppercase tracking-widest text-slate-500">Rating</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-100">
                            {loading && ratings.length === 0 ? (
                                <tr>
                                    <td colSpan={4} className="px-6 py-12 text-center text-slate-500">
                                        <Loader2 className="w-6 h-6 animate-spin mx-auto mb-3 text-[#006970]" />
                                        <p className="font-medium">Loading ratings...</p>
                                    </td>
                                </tr>
                            ) : ratings.length === 0 ? (
                                <tr>
                                    <td colSpan={4} className="px-6 py-12 text-center text-slate-500">
                                        <Star className="w-10 h-10 mx-auto mb-3 text-slate-300" />
                                        <p className="font-medium text-slate-600">No ratings found yet.</p>
                                    </td>
                                </tr>
                            ) : (
                                ratings.map((rating) => (
                                    <tr key={rating.id} className="hover:bg-slate-50 transition-colors">
                                        <td className="px-6 py-4 text-sm text-slate-500 font-medium">
                                            {new Date(rating.created_at).toLocaleString()}
                                        </td>
                                        <td className="px-6 py-4 text-sm font-bold text-slate-900 truncate max-w-[200px]">
                                            {rating.article_slug.replace(/-/g, ' ')}
                                        </td>
                                        <td className="px-6 py-4 text-sm text-slate-600 capitalize truncate max-w-[150px]">
                                            {rating.category_slug.replace(/-/g, ' ')}
                                        </td>
                                        <td className="px-6 py-4">
                                            {rating.helpful ? (
                                                <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-emerald-50 text-emerald-700 border border-emerald-100 text-xs font-bold">
                                                    <ThumbsUp className="w-3.5 h-3.5" />
                                                    Helpful
                                                </div>
                                            ) : (
                                                <div className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md bg-red-50 text-red-700 border border-red-100 text-xs font-bold">
                                                    <ThumbsDown className="w-3.5 h-3.5" />
                                                    Not Helpful
                                                </div>
                                            )}
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
