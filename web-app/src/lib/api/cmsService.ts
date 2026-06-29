import apiClient from './apiClient';

export interface BlogPost {
    id: number;
    title: string;
    slug: string;
    content: string;
    summary: string;
    featuredImage?: string;
    author: string;
    category: string;
    status: 'draft' | 'published';
    publishedAt: string | null;
    createdAt: string;
    updatedAt: string;
}

export const cmsService = {
    getPublishedPosts: async (): Promise<BlogPost[]> => {
        const response = await apiClient.get('/cms/posts');
        return response.data;
    },

    getPostBySlug: async (slug: string): Promise<BlogPost> => {
        const response = await apiClient.get(`/cms/posts/${slug}`);
        return response.data;
    }
};

