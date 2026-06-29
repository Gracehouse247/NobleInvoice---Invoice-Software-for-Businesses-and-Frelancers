'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { UserData } from '@/types';
import { User } from '@supabase/supabase-js';

export interface UserLimits {
    max_invoices_per_month: number;
    max_clients: number;
    has_advanced_editing: boolean;
    allowed_templates: string[];
    dpp_image_limit: number;
}

export interface UserFeatures {
    recurring_invoices: boolean;
    inventory_management: boolean;
    analytics_and_reports: boolean;
    multi_user: boolean;
    contracts: boolean;
    dpp_enabled: boolean;
    ai_voice_assistant: boolean;
    wallet_payments: boolean;
    marketing_networking: boolean;
    [key: string]: boolean;
}

export interface ProfileRow {
    display_name?: string;
    business_name?: string;
    brand_logo_url?: string;
    subscription_tier?: string;
    onboarding_completed?: boolean;
}

interface AuthContextType {
    user: User | null;
    userData: UserData | null;
    limits: UserLimits | null;
    features: UserFeatures | null;
    loading: boolean;
    logout: () => Promise<void>;
    refreshUserData: () => Promise<void>;
    hasFeature: (featureId: string) => boolean;
}

const AuthContext = createContext<AuthContextType>({
    user: null,
    userData: null,
    limits: null,
    features: null,
    loading: true,
    logout: async () => {},
    refreshUserData: async () => {},
    hasFeature: () => false,
});

export const useAuth = () => useContext(AuthContext);

export const useFeatureGate = () => {
    const { limits, features, hasFeature } = useAuth();
    return { limits, features, hasFeature };
};

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
    const [user, setUser] = useState<User | null>(null);
    const [userData, setUserData] = useState<UserData | null>(null);
    const [limits, setLimits] = useState<UserLimits | null>(null);
    const [features, setFeatures] = useState<UserFeatures | null>(null);
    const [loading, setLoading] = useState(true);

    const fetchUserProfile = async (currentUser: User) => {
        try {
            // Fetch profile first
            const profileResult = await supabase
                .from('profiles')
                .select('display_name, business_name, brand_logo_url, subscription_tier, onboarding_completed')
                .eq('id', currentUser.id)
                .single();

            const profile = profileResult.data as ProfileRow;
            if (profileResult.error && profileResult.error.code !== 'PGRST116') {
                console.error('Error fetching Supabase profile:', profileResult.error);
            }

            // Try fetching limits via RPC, fall back to defaults if function doesn't exist
            let limitsWereSet = false;
            const limitsResult = await supabase.rpc('resolve_user_limits', { p_user_id: currentUser.id });
            if (limitsResult.data && !limitsResult.error) {
                setLimits(limitsResult.data.limits);
                setFeatures(limitsResult.data.features);
                limitsWereSet = true;
            }

            // Apply free-tier defaults based on subscription_tier if limits weren't set
            const tier = profile?.subscription_tier || 'explorer';
            if (!limitsWereSet) {
                setLimits({
                    max_invoices_per_month: tier === 'explorer' ? 10 : tier === 'pulse' ? 100 : 999,
                    max_clients: tier === 'explorer' ? 5 : tier === 'pulse' ? 50 : 999,
                    has_advanced_editing: tier !== 'explorer',
                    allowed_templates: tier === 'explorer' ? ['classic', 'modern'] : ['classic', 'modern', 'premium', 'platinum'],
                    dpp_image_limit: tier === 'explorer' ? 3 : 20,
                });
                setFeatures({
                    recurring_invoices: tier !== 'explorer',
                    inventory_management: tier !== 'explorer',
                    analytics_and_reports: tier !== 'explorer',
                    multi_user: tier === 'elite',
                    contracts: tier !== 'explorer',
                    dpp_enabled: tier !== 'explorer',
                    ai_voice_assistant: tier !== 'explorer',
                    wallet_payments: tier !== 'explorer',
                    marketing_networking: true,
                });
            }

            // Map only the fields we need — never spread the entire profile row
            // to avoid accidentally exposing sensitive columns (e.g. bank_account_number)
            setUserData({
                uid: currentUser.id,
                email: currentUser.email || '',
                name: profile?.display_name || profile?.business_name || 'Noble User',
                photoUrl: profile?.brand_logo_url || undefined,
                subscriptionStatus: profile?.subscription_tier ? 'active' : 'cancelled',
                // Cast to the allowed plan union — the DB may have tiers not yet in the type;
                // unknown tiers fall back to 'explorer' so the feature-gate always has a safe default.
                plan: (['explorer', 'pulse', 'elite', 'admin'].includes(profile?.subscription_tier || '')
                    ? profile!.subscription_tier
                    : 'explorer') as 'explorer' | 'pulse' | 'elite' | 'admin',
                // Explicit profile fields used by UI
                display_name: profile?.display_name,
                business_name: profile?.business_name,
                brand_logo_url: profile?.brand_logo_url,
                onboarding_completed: profile?.onboarding_completed,
            });
        } catch (error) {
            console.error('Error in fetchUserProfile:', error);
        }
    };

    useEffect(() => {
        // Skip AuthContext processing on admin routes — the admin layout
        // handles its own auth check independently. This prevents the race
        // condition where onAuthStateChange fires during admin OTP login
        // and triggers user dashboard redirects.
        const isAdminRoute = typeof window !== 'undefined' && window.location.pathname.startsWith('/admin');
        if (isAdminRoute) {
            setLoading(false);
            return;
        }

        // Safety timeout — if auth hasn't resolved in 6s, unblock the UI
        const timeout = setTimeout(() => {
            setLoading(false);
        }, 6000);

        // 1. Check active session initially
        supabase.auth.getSession().then(async ({ data: { session } }) => {
            clearTimeout(timeout);
            const currentUser = session?.user || null;

            setUser(currentUser);
            if (currentUser) {
                await fetchUserProfile(currentUser);
                setLoading(false);
            } else {
                setUserData(null);
                setLimits(null);
                setFeatures(null);
                setLoading(false);
            }
        }).catch((err) => {
            clearTimeout(timeout);
            console.error('Session fetch error:', err);
            setLoading(false);
        });

        // 2. Listen for auth changes
        const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, session) => {
            // Double-check we're still not on admin routes (user may have navigated)
            if (typeof window !== 'undefined' && window.location.pathname.startsWith('/admin')) {
                return;
            }

            const currentUser = session?.user || null;
            setUser(currentUser);
            
            if (currentUser) {
                await fetchUserProfile(currentUser);
            } else {
                setUserData(null);
                setLimits(null);
                setFeatures(null);
            }
            setLoading(false);
        });

        return () => {
            clearTimeout(timeout);
            subscription.unsubscribe();
        };
    }, []);

    const hasFeature = (featureId: string): boolean => {
        if (!features) return false;
        
        const plan = userData?.plan || 'explorer';
        if (plan === 'admin') return true;

        return !!features[featureId];
    };

    const refreshUserData = async () => {
        if (!user) return;
        await fetchUserProfile(user);
    };

    const logout = async () => {
        try {
            await supabase.auth.signOut();
        } catch (err) {
            console.error('Logout error:', err);
        } finally {
            // Clear state only after signOut resolves (success or error)
            setUser(null);
            setUserData(null);
            setLimits(null);
            setFeatures(null);
            if (typeof window !== 'undefined') {
                window.location.href = '/login';
            }
        }
    };

    return (
        <AuthContext.Provider value={{ user, userData, limits, features, loading, logout, refreshUserData, hasFeature }}>
            {children}
        </AuthContext.Provider>
    );
};
