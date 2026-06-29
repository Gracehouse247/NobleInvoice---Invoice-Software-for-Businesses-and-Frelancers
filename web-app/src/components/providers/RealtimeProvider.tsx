'use client';

import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/context/AuthContext';
import { teamService } from '@/lib/services/supabaseService';

interface RealtimeContextType {
    lastSyncTime: number;
}

const RealtimeContext = createContext<RealtimeContextType>({ lastSyncTime: Date.now() });

export const useRealtime = () => useContext(RealtimeContext);

export default function RealtimeProvider({ children }: { children: React.ReactNode }) {
    const { user } = useAuth();
    const [lastSyncTime, setLastSyncTime] = useState(Date.now());
    // Track the active channel ref so we can safely remove it even if setup is async
    const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);

    useEffect(() => {
        if (!user) return;

        // Guard against React StrictMode double-invocation / fast-refresh races
        let cancelled = false;

        const setupRealtime = async () => {
            // Get active team ID just like the mobile app
            const tData = await teamService.getTeamByUserId(user.id);

            // If the effect already cleaned up while we were awaiting, bail out
            if (cancelled) return;

            const teamId = tData?.id || user.id;
            const channelName = `public:sync:${teamId}`;

            // If a channel with this name is already open (e.g. StrictMode second call),
            // remove it first so we start fresh and never call .on() after .subscribe()
            if (channelRef.current) {
                await supabase.removeChannel(channelRef.current);
                channelRef.current = null;
            }

            if (cancelled) return;

            const bump = () => setLastSyncTime(Date.now());

            // Build all listeners BEFORE subscribe — Supabase requires this order
            const channel = supabase
                .channel(channelName)
                .on('postgres_changes', { event: '*', schema: 'public', table: 'invoices' }, bump)
                .on('postgres_changes', { event: '*', schema: 'public', table: 'clients' }, bump)
                .on('postgres_changes', { event: '*', schema: 'public', table: 'expenses' }, bump)
                .on('postgres_changes', { event: '*', schema: 'public', table: 'identities' }, bump)
                .subscribe((status) => {
                    if (status === 'SUBSCRIBED') {
                        console.log(`[RealtimeProvider] Sync active for team: ${teamId}`);
                    }
                });

            channelRef.current = channel;
        };

        setupRealtime().catch((err) => {
            console.warn('[RealtimeProvider] setup error:', err);
        });

        return () => {
            // Signal the async function to abort if still in-flight
            cancelled = true;
            // Remove the channel if it was already created
            if (channelRef.current) {
                supabase.removeChannel(channelRef.current);
                channelRef.current = null;
            }
        };
    }, [user]);

    return (
        <RealtimeContext.Provider value={{ lastSyncTime }}>
            {children}
        </RealtimeContext.Provider>
    );
}
