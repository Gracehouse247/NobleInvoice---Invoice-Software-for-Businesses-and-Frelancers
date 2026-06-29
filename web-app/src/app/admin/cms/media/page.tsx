'use client';

import React from 'react';
import MediaManager from '@/components/features/cms/MediaManager';
import { ImageIcon } from 'lucide-react';

export default function AdminMediaPage() {
    return (
        <div className="p-10 space-y-8 max-w-7xl mx-auto h-full flex flex-col">
            <header className="flex-shrink-0">
                <div className="flex items-center gap-3 mb-2">
                    <div className="p-2 bg-[#006970]/10 rounded-lg border border-[#006970]/20 text-[#006970]">
                        <ImageIcon className="w-5 h-5" />
                    </div>
                    <h1 className="text-3xl font-extrabold text-foreground  font-sans">Media Library</h1>
                </div>
                <p className="text-slate-600  font-medium">Manage images and assets for your blog and landing pages.</p>
            </header>

            <div className="flex-1 glass-card p-8 rounded-[40px] border border-black/5  shadow-2xl overflow-hidden">
                <MediaManager />
            </div>
        </div>
    );
}

