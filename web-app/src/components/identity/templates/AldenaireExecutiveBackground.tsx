import React from 'react';

interface AldenaireExecutiveBackgroundProps {
  accentColor: string;
  side?: 'front' | 'back';
}

export const AldenaireExecutiveBackground: React.FC<AldenaireExecutiveBackgroundProps> = ({ 
  accentColor,
  side = 'front' 
}) => {
  const getDarkColor = (color: string) => {
    if (!color) return '#0B3D66';
    const hex = color.replace('#', '');
    const r = parseInt(hex.substring(0, 2) || '0', 16);
    const g = parseInt(hex.substring(2, 4) || '0', 16);
    const b = parseInt(hex.substring(4, 6) || '0', 16);
    const rDark = Math.max(12, Math.round(r * 0.15));
    const gDark = Math.max(18, Math.round(g * 0.15));
    const bDark = Math.max(35, Math.round(b * 0.18));
    return `#${rDark.toString(16).padStart(2, '0')}${gDark.toString(16).padStart(2, '0')}${bDark.toString(16).padStart(2, '0')}`;
  };

  const Navy = accentColor ? getDarkColor(accentColor) : '#0B3D66';

  return (
    <div className="absolute inset-0 w-full h-full overflow-hidden" style={{ backgroundColor: side === 'front' ? '#ffffff' : Navy }}>
      {/* Textured Silk Background Overlay (Front Only) */}
      {side === 'front' && (
        <div className="absolute inset-0 opacity-[0.1]" style={{ backgroundImage: 'repeating-linear-gradient(45deg, #ccc 0, #ccc 1px, transparent 0, transparent 50%)', backgroundSize: '10px 10px' }} />
      )}
      
      {side === 'front' ? (
        <>
          {/* Rounded Pill Header Block */}
          <div 
            className="absolute top-[8%] left-0 w-[55%] h-[180px] z-10 shadow-xl"
            style={{ 
                backgroundColor: Navy,
                borderRadius: '0 100px 100px 0'
            }}
          />
          
          {/* Massive Navy Arc (Right Anchor) */}
          <div 
            className="absolute top-1/2 -translate-y-1/2 right-[-25%] w-[850px] h-[850px] rounded-full z-0"
            style={{ backgroundColor: Navy }}
          />

          {/* Large White Monogram Overlay (Front) */}
          <div className="absolute top-1/2 -translate-y-1/2 right-[5%] z-10 opacity-100 pointer-events-none">
            <svg viewBox="0 0 100 100" className="w-56 h-56 fill-white">
                <path d="M 20,80 L 50,40 L 80,80 L 95,70 L 50,10 L 5,70 Z" />
                <path d="M 35,90 L 50,70 L 65,90 L 80,80 L 50,40 L 20,80 Z" />
            </svg>
          </div>
        </>
      ) : (
        <>
          {/* Back Face Massive Ghost Monogram Overlay */}
          <div 
            className="absolute top-[-15%] right-[-15%] w-[850px] h-[850px] opacity-[0.04] z-0 pointer-events-none transform rotate-12"
          >
             <svg viewBox="0 0 100 100" className="w-full h-full fill-white">
                <path d="M 20,80 L 50,40 L 80,80 L 95,70 L 50,10 L 5,70 Z" />
                <path d="M 35,90 L 50,70 L 65,90 L 80,80 L 50,40 L 20,80 Z" />
             </svg>
          </div>

          {/* Secondary Ghost Accent (Bottom Left) */}
          <div 
            className="absolute bottom-[-10%] left-[-10%] w-[300px] h-[300px] opacity-[0.02] z-0 pointer-events-none transform -rotate-12"
          >
             <svg viewBox="0 0 100 100" className="w-full h-full fill-white">
                <path d="M 20,80 L 50,40 L 80,80 L 95,70 L 50,10 L 5,70 Z" />
                <path d="M 35,90 L 50,70 L 65,90 L 80,80 L 50,40 L 20,80 Z" />
             </svg>
          </div>
        </>
      )}
    </div>
  );
};
