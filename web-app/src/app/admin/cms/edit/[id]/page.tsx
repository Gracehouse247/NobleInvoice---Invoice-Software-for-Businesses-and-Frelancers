'use client';

import React, { useEffect, useState } from 'react';
import PostEditor from '@/components/features/cms/PostEditor';
import { useRouter, useParams } from 'next/navigation';
import { cmsApi } from '@/lib/cmsApi';
import { Loader2, AlertCircle } from 'lucide-react';

export default function EditPostPage() {
    const router = useRouter();
    const params = useParams();
    const id = params.id as string;
    
    const [post, setPost] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchPost = async () => {
            try {
                // Fetch using the new Supabase-powered API
                const { data } = await cmsApi.getPostById(id);
                
                if (!data) {
                    setError('Post not found.');
                } else {
                    setPost(data);
                }
            } catch (err: any) {
                console.error(err);
                setError(err.message || 'Failed to load post.');
            } finally {
                setLoading(false);
            }
        };

        if (id) fetchPost();
    }, [id]);

    if (loading) {
        return (
            <div className="flex h-64 items-center justify-center">
                <div className="flex flex-col items-center gap-4">
                    <Loader2 className="w-8 h-8 text-[#006970] animate-spin" />
                    <p className="text-slate-500 font-semibold text-sm">Loading post data...</p>
                </div>
            </div>
        );
    }

    if (error || !post) {
        return (
            <div className="flex h-64 items-center justify-center p-8">
                <div className="bg-white p-10 rounded-2xl shadow-sm border border-slate-100 max-w-md w-full text-center space-y-6">
                    <div className="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center mx-auto border border-red-100">
                        <AlertCircle className="w-8 h-8 text-red-500" />
                    </div>
                    <h2 className="text-xl font-bold text-slate-900">Oops! Something went wrong.</h2>
                    <p className="text-slate-500 text-sm">{error || 'Post not found.'}</p>
                    <button 
                        onClick={() => router.push('/admin/cms')} 
                        className="w-full py-2.5 rounded-lg bg-slate-100 text-slate-700 font-bold hover:bg-slate-200 transition-all text-sm"
                    >
                        Back to CMS
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="space-y-6 pb-10">
            <header className="flex justify-between items-center">
                <div>
                    <h1 className="text-2xl font-semibold text-slate-900">Edit Blog Post</h1>
                    <p className="mt-1 text-sm text-slate-500">
                        Updating: <span className="font-medium text-[#006970]">{post.title}</span>
                    </p>
                </div>
                <button 
                    onClick={() => router.back()} 
                    className="px-4 py-2 bg-white border border-slate-200 rounded-md text-sm font-medium text-slate-700 hover:bg-slate-50 shadow-sm transition-colors"
                >
                    ← Back to CMS
                </button>
            </header>
            <div className="bg-white border border-slate-200 rounded-lg shadow-sm overflow-hidden min-h-[600px]">
                <PostEditor initialData={post} onSaved={() => router.push('/admin/cms')} />
            </div>
        </div>
    );
}
