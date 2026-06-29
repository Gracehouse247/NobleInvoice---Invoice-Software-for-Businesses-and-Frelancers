import React from 'react';

interface LaranaIncBackgroundProps {
  side?: 'front' | 'back';
}

export const LaranaIncBackground: React.FC<LaranaIncBackgroundProps> = ({ side = 'front' }) => {
  const brown = "#4E3B31";
  const orange = "#D35400";
  const white = "#FFFFFF";

  if (side === 'back') {
    return (
      <svg viewBox="0 0 1050 600" className="absolute inset-0 w-full h-full" preserveAspectRatio="none">
        <rect width="1050" height="600" fill={brown} />
        {/* Top Accent */}
        <path d="M 0,0 L 1050,0 L 1050,400 L 525,480 L 0,400 Z" fill={brown} />
        {/* Bottom Tiered Vertex */}
        <path d="M 0,600 L 525,500 L 1050,600 Z" fill={white} />
        <path d="M 0,600 L 525,520 L 1050,600 Z" fill={orange} />
        <path d="M 0,600 L 525,550 L 1050,600 Z" fill={orange} opacity="0.6" />
      </svg>
    );
  }

  return (
    <svg viewBox="0 0 1050 600" className="absolute inset-0 w-full h-full" preserveAspectRatio="none">
      <rect width="1050" height="600" fill={white} />
      
      {/* Background Tiered Vertex (Orange Wings - Curved) */}
      <path 
        d="M 1050,0 
           L 580,0 
           Q 430,0 350,300 
           Q 430,600 580,600 
           L 1050,600 
           Z" 
        fill={orange} 
      />
      
      {/* Main Brown Vertex Body (Curved) */}
      <path 
        d="M 1050,0 
           L 620,0 
           Q 480,0 400,300 
           Q 480,600 620,600 
           L 1050,600 
           Z" 
        fill={brown} 
      />

      {/* Top/Bottom Sharp Accents (The entry points) */}
      <path d="M 620,0 L 550,0 L 580,60 Z" fill={orange} />
      <path d="M 620,600 L 550,600 L 580,540 Z" fill={orange} />

      {/* Subtle White Border for extra crispness at the vertex */}
      <path 
        d="M 620,0 Q 480,0 400,300 Q 480,600 620,600" 
        fill="none" 
        stroke={white} 
        strokeWidth="1.5" 
        opacity="0.1"
      />
    </svg>
  );
};
