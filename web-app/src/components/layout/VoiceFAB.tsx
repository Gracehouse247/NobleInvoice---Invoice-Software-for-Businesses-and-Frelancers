'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { Mic } from 'lucide-react';

interface VoiceFABProps {
    onClick: () => void;
}

export default function VoiceFAB({ onClick }: VoiceFABProps) {
    return (
        <motion.button 
            initial={{ scale: 0, y: 100 }}
            animate={{ scale: 1, y: 0 }}
            whileHover={{ scale: 1.1, rotate: 5 }}
            whileTap={{ scale: 0.9 }}
            onClick={onClick}
            className="fixed bottom-24 right-6 md:bottom-10 md:right-10 w-16 h-16 bg-primary text-secondary rounded-[24px] shadow-2xl shadow-primary/40 flex items-center justify-center z-40 group border-4 border-white #050B1A]"
        >
            <div className="absolute inset-0 bg-primary rounded-[20px] animate-ping opacity-20 group-hover:opacity-40" />
            <Mic className="w-7 h-7 relative z-10" />
            
            {/* Visual feedback tooltips could go here */}
            <div className="absolute right-full mr-4 px-4 py-2 bg-secondary text-white text-[10px] font-black uppercase tracking-widest rounded-xl opacity-0 group-hover:opacity-100 transition-all pointer-events-none whitespace-nowrap">
                Voice Assistant
            </div>
        </motion.button>
    );
}

