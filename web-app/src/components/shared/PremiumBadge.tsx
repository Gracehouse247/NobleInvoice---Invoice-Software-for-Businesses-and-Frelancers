import React from 'react';

interface PremiumBadgeProps {
  className?: string;
  size?: 'sm' | 'md';
}

export default function PremiumBadge({ className = '', size = 'md' }: PremiumBadgeProps) {
  const sizeClasses = size === 'sm' ? 'w-5 h-5' : 'w-7 h-7';
  const iconSize = size === 'sm' ? 'text-[12px]' : 'text-[16px]';
  
  return (
    <div className={`inline-flex items-center justify-center rounded-full bg-gradient-to-r from-yellow-400 via-amber-500 to-yellow-600 text-white shadow-lg shadow-amber-500/20 ${sizeClasses} ${className}`}>
      <span className={`material-symbols-outlined ${iconSize}`}>diamond</span>
    </div>
  );
}
