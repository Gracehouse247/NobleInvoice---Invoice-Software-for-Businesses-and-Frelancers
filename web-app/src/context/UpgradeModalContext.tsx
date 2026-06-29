'use client';

import React, { createContext, useContext, useState, ReactNode } from 'react';

export interface UpgradeModalOptions {
    featureName: string;
    requiredPlan: 'pro' | 'elite';
}

interface UpgradeModalContextType {
    isOpen: boolean;
    options: UpgradeModalOptions | null;
    openUpgradeModal: (options: UpgradeModalOptions) => void;
    closeUpgradeModal: () => void;
}

const UpgradeModalContext = createContext<UpgradeModalContextType>({
    isOpen: false,
    options: null,
    openUpgradeModal: () => {},
    closeUpgradeModal: () => {},
});

export const useUpgradeModal = () => useContext(UpgradeModalContext);

export const UpgradeModalProvider = ({ children }: { children: ReactNode }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [options, setOptions] = useState<UpgradeModalOptions | null>(null);

    const openUpgradeModal = (newOptions: UpgradeModalOptions) => {
        setOptions(newOptions);
        setIsOpen(true);
    };

    const closeUpgradeModal = () => {
        setIsOpen(false);
        setTimeout(() => setOptions(null), 300); // Clear after animation
    };

    return (
        <UpgradeModalContext.Provider value={{ isOpen, options, openUpgradeModal, closeUpgradeModal }}>
            {children}
        </UpgradeModalContext.Provider>
    );
};
