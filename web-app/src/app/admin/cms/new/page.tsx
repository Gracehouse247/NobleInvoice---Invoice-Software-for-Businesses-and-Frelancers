'use client';

import PostEditor from '@/components/features/cms/PostEditor';
import { useRouter } from 'next/navigation';

export default function NewPostPage() {
    const router = useRouter();
    return (
        <div className="space-y-6 pb-10">
            <header className="flex justify-between items-center">
                <div>
                    <h1 className="text-2xl font-semibold text-slate-900">New Blog Post</h1>
                    <p className="mt-1 text-sm text-slate-500">Write, optimize, and publish your content.</p>
                </div>
                <button 
                    onClick={() => router.back()} 
                    className="px-4 py-2 bg-white border border-slate-200 rounded-md text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition-colors"
                >
                    ← Back to CMS
                </button>
            </header>
            <div className="bg-white border border-slate-200 rounded-lg shadow-sm overflow-hidden min-h-[600px]">
                <PostEditor onSaved={() => router.push('/admin/cms')} />
            </div>
        </div>
    );
}
