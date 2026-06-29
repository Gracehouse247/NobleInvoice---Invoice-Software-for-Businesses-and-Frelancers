'use client';

import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface NeuralWaveformProps {
  isListening: boolean;
  color?: string;
}

export default function NeuralWaveform({ isListening, color = '#1E2A78' }: NeuralWaveformProps) {
  const bars = Array.from({ length: 15 });

  return (
    <div className="flex items-center justify-center gap-1.5 h-16 w-full max-w-[200px]">
      {bars.map((_, i) => (
        <motion.div
          key={i}
          animate={
            isListening
              ? {
                  height: [
                    Math.random() * 20 + 10,
                    Math.random() * 40 + 20,
                    Math.random() * 20 + 10,
                  ],
                  opacity: [0.4, 0.8, 0.4],
                }
              : { height: 8, opacity: 0.2 }
          }
          transition={{
            duration: 0.6,
            repeat: Infinity,
            delay: i * 0.05,
            ease: "easeInOut",
          }}
          className="w-1.5 rounded-full"
          style={{ backgroundColor: color }}
        />
      ))}
      
      {/* Decorative center pulse */}
      <AnimatePresence>
        {isListening && (
          <motion.div
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 3, opacity: 0 }}
            exit={{ scale: 0, opacity: 0 }}
            transition={{ duration: 1.5, repeat: Infinity, ease: "easeOut" }}
            className="absolute w-20 h-20 rounded-full border-2"
            style={{ borderColor: color }}
          />
        )}
      </AnimatePresence>
    </div>
  );
}
