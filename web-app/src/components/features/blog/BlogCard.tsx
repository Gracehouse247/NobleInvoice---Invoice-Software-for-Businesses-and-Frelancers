'use client';

import React from 'react';
import { motion } from 'framer-motion';
import Link from 'next/link';
// import { Badge } from '@/components/ui/Badge'; // Removed as it was a placeholder
import { Calendar, Clock, ChevronRight } from 'lucide-react';

interface BlogCardProps {
    post: {
        id: number;
        title: string;
        slug: string;
        excerpt: string;
        cover_image: string;
        published_at: string;
        reading_time_minutes: number;
        tags: string[];
    };
}

export default function BlogCard({ post }: BlogCardProps) {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            whileHover={{ y: -5 }}
            className="group glass-card rounded-3xl overflow-hidden flex flex-col h-full hover:border-[#006970]/30 transition-all"
        >
            {/* Image Wrapper */}
            <div className="relative aspect-[16/9] overflow-hidden">
                <img
                    src={post.cover_image || '/images/blog-placeholder.jpg'}
                    alt={post.title}
                    className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-[#020617] via-transparent to-transparent opacity-60" />
                <div className="absolute bottom-4 left-4 flex gap-2">
                    {post.tags?.slice(0, 2).map(tag => (
                        <span key={tag} className="px-2.5 py-1 bg-black/10  backdrop-blur-md border border-black/10  rounded-full text-[10px] font-bold text-foreground  uppercase tracking-wider">
                            {tag}
                        </span>
                    ))}
                </div>
            </div>

            {/* Content */}
            <div className="p-6 flex-1 flex flex-col">
                <div className="flex items-center gap-4 mb-4">
                    <div className="flex items-center gap-1.5 text-slate-500 text-xs font-medium">
                        <Calendar className="w-3.5 h-3.5" />
                        {new Date(post.published_at).toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' })}
                    </div>
                    <div className="flex items-center gap-1.5 text-slate-500 text-xs font-medium">
                        <Clock className="w-3.5 h-3.5" />
                        {post.reading_time_minutes} min read
                    </div>
                </div>

                <h3 className="text-xl font-bold text-foreground  font-sans mb-3 group-hover:text-[#006970] transition-colors line-clamp-2 leading-snug">
                    <Link href={`/blog/${post.slug}`}>
                        {post.title}
                    </Link>
                </h3>

                <p className="text-sm text-slate-600  line-clamp-3 mb-6 leading-relaxed">
                    {post.excerpt}
                </p>

                <div className="mt-auto">
                    <Link href={`/blog/${post.slug}`} className="inline-flex items-center gap-2 text-[#006970] font-bold text-sm group/link">
                        Read Full Story
                        <ChevronRight className="w-4 h-4 transition-transform group-hover/link:translate-x-1" />
                    </Link>
                </div>
            </div>
        </motion.div>
    );
}

