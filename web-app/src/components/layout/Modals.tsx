'use client';

import React from 'react';
import { AnimatePresence } from 'framer-motion';
import CommandPalette from '@/components/shared/CommandPalette';
import UpgradePromptModal from '@/components/shared/UpgradePromptModal';

interface ModalsProps {
    isSearchOpen: boolean;
    setIsSearchOpen: (val: boolean) => void;
    isProfileModalOpen: boolean;
    setIsProfileModalOpen: (val: boolean) => void;
}

export default function Modals({
    isSearchOpen,
    setIsSearchOpen,
    isProfileModalOpen,
    setIsProfileModalOpen
}: ModalsProps) {
    return (
        <>
            {/* Global Overlays */}
            <AnimatePresence>
                {isSearchOpen && (
                    <CommandPalette 
                        isOpen={isSearchOpen}
                        onClose={() => setIsSearchOpen(false)}
                    />
                )}
            </AnimatePresence>
            <UpgradePromptModal />
        </>
    );
}

