import axios from 'axios';
import { supabase } from './supabase';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080/api';

const api = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

// Attach Supabase Session Token to every request
api.interceptors.request.use(async (config) => {
    const { data: { session } } = await supabase.auth.getSession();
    if (session) {
        config.headers.Authorization = `Bearer ${session.access_token}`;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

export const authApi = {
    sendOtp: (email: string) => api.post('/auth/send-otp', { email }),
    verifyOtp: (email: string, otp: string) => api.post('/auth/verify-otp', { email, otp }),
};

export const identityApi = {
    getStyleSuggestions: (businessType: string, currentData?: any) => 
        api.post('/ai/identity-style-suggestions', { businessType, currentData }),
    generateProfileCopy: (data: any) => 
        api.post('/ai/identity-copywriting', { data }),
};

export default api;

