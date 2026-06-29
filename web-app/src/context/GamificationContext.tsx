'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { useAuth } from './AuthContext';
import { GamificationModel } from '@/types';
import { gamificationService } from '@/lib/services/gamificationService';

interface GamificationContextType {
    gamificationData: GamificationModel | null;
    loading: boolean;
}

const GamificationContext = createContext<GamificationContextType>({
    gamificationData: null,
    loading: true,
});

export const GamificationProvider = ({ children }: { children: React.ReactNode }) => {
    const { user } = useAuth();
    const [gamificationData, setGamificationData] = useState<GamificationModel | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!user) {
            setGamificationData(null);
            setLoading(false);
            return;
        }

        gamificationService.initIfNeeded(user.id).catch(console.error);

        const unsubscribe = gamificationService.subscribeToGamification(user.id, (data) => {
            setGamificationData(data);
            setLoading(false);
        });

        return () => unsubscribe();
    }, [user]);

    return (
        <GamificationContext.Provider value={{ gamificationData, loading }}>
            {children}
        </GamificationContext.Provider>
    );
};

export const useGamification = () => useContext(GamificationContext);

