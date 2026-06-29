'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface StepIndicatorProps {
  currentStep: number;
  totalSteps: number;
}

export function StepIndicator({ currentStep, totalSteps }: StepIndicatorProps) {
  return (
    <div className="flex items-center space-x-2">
      {Array.from({ length: totalSteps }).map((_, index) => {
        const isActive = index <= currentStep;
        return (
          <div key={index} className="flex-1 h-2 relative rounded-full bg-slate-100 overflow-hidden">
            <motion.div
              initial={false}
              animate={{ width: isActive ? '100%' : '0%' }}
              transition={{ duration: 0.5, ease: 'easeInOut' }}
              className="absolute inset-0 bg-blue-600 rounded-full"
            />
          </div>
        );
      })}
    </div>
  );
}
