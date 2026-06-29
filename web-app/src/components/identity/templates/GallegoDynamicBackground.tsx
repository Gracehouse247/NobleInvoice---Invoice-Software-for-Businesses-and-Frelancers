import React from 'react';

interface GallegoDynamicBackgroundProps {
  accentColor: string;
  side?: 'front' | 'back';
}

export const GallegoDynamicBackground: React.FC<GallegoDynamicBackgroundProps> = ({ 
  accentColor,
  side = 'front' 
}) => {
  const Charcoal = '#22242C';
  const Emerald = '#10B981';
  const LightGreen = '#34D399';

  return (
    <div className="absolute inset-0 w-full h-full" style={{ backgroundColor: Charcoal }}>
      {/* Sweeping Kinetic Lines (Present on both sides) */}
      <div className="absolute top-0 right-0 w-[60%] h-[60%] overflow-hidden">
        <svg viewBox="0 0 400 400" className="w-full h-full transform translate-x-20 -translate-y-20">
          <path 
            d="M0,0 Q200,50 400,400" 
            fill="none" 
            stroke={Emerald} 
            strokeWidth="40" 
            className="opacity-20"
          />
          <path 
            d="M50,0 Q250,100 400,350" 
            fill="none" 
            stroke={LightGreen} 
            strokeWidth="20" 
            className="opacity-30"
          />
          <path 
            d="M100,0 Q300,150 400,300" 
            fill="none" 
            stroke={Emerald} 
            strokeWidth="10" 
            className="opacity-50"
          />
          
          {/* Detailed Fine Lines */}
          {[...Array(8)].map((_, i) => (
            <path 
              key={i}
              d={`M${150 + i*10},0 Q${320 + i*5},${180 + i*10} 400,${250 + i*15}`} 
              fill="none" 
              stroke={LightGreen} 
              strokeWidth="1" 
              className="opacity-40"
            />
          ))}
        </svg>
      </div>

      {side === 'front' ? (
        <>
          {/* Subtle Bottom Accent */}
          <div className="absolute bottom-0 left-0 w-full h-1 opacity-10" 
               style={{ background: `linear-gradient(to right, ${Emerald}, transparent)` }} />
        </>
      ) : (
        <>
          {/* Center-Right Focus Overlay */}
          <div className="absolute inset-0 opacity-[0.03] pointer-events-none" 
               style={{ backgroundImage: 'radial-gradient(circle, #fff 1px, transparent 1px)', backgroundSize: '30px 30px' }} />
        </>
      )}
    </div>
  );
};
