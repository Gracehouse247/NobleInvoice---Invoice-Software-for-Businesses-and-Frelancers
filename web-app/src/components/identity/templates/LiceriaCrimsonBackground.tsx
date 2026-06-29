import React from 'react';

interface LiceriaCrimsonBackgroundProps {
  accentColor: string;
  side?: 'front' | 'back';
}

export const LiceriaCrimsonBackground: React.FC<LiceriaCrimsonBackgroundProps> = ({ 
  accentColor,
  side = 'front' 
}) => {
  const Charcoal = '#2D2D2D';

  const getLightAccent = (color: string) => {
    if (!color) return '#DC2626';
    const hex = color.replace('#', '');
    const r = parseInt(hex.substring(0, 2) || '0', 16);
    const g = parseInt(hex.substring(2, 4) || '0', 16);
    const b = parseInt(hex.substring(4, 6) || '0', 16);
    const rLight = Math.min(255, Math.round(r + (255 - r) * 0.3));
    const gLight = Math.min(255, Math.round(g + (255 - g) * 0.3));
    const bLight = Math.min(255, Math.round(b + (255 - b) * 0.3));
    return `#${rLight.toString(16).padStart(2, '0')}${gLight.toString(16).padStart(2, '0')}${bLight.toString(16).padStart(2, '0')}`;
  };

  const Crimson = accentColor || '#A00000';
  const CrimsonLight = accentColor ? getLightAccent(accentColor) : '#DC2626';

  return (
    <div className="absolute inset-0 w-full h-full" style={{ backgroundColor: Charcoal }}>
      {side === 'front' ? (
        <>
          {/* Main Crimson Arc */}
          <div 
            className="absolute top-[-20%] right-[-15%] w-[80%] h-[140%] shadow-[inset_0_0_100px_rgba(0,0,0,0.5)]"
            style={{ 
                background: `radial-gradient(circle at 70% 50%, ${CrimsonLight} 0%, ${Crimson} 100%)`,
                borderRadius: '50% 0 0 50%'
            }}
          />
          
          {/* Arc Shadow Effect */}
          <div 
            className="absolute top-[-20%] right-[60%] w-[10px] h-[140%] opacity-20"
            style={{ 
                background: `linear-gradient(to right, transparent, black)`,
                borderRadius: '50%'
            }}
          />

          {/* Subtle Texture Overlay */}
          <div className="absolute inset-0 opacity-[0.05] pointer-events-none" 
               style={{ backgroundImage: 'url("https://www.transparenttextures.com/patterns/carbon-fibre.png")' }} />
        </>
      ) : (
        <>
            {/* Left Tapered Shard */}
            <div 
                className="absolute left-0 top-[10%] bottom-[10%] w-12"
                style={{ 
                    background: `linear-gradient(to bottom, transparent, ${Crimson}, transparent)`,
                    clipPath: 'polygon(0 0, 100% 15%, 100% 85%, 0 100%)'
                }}
            />

            {/* Right Tapered Shard */}
            <div 
                className="absolute right-0 top-[10%] bottom-[10%] w-12"
                style={{ 
                    background: `linear-gradient(to bottom, transparent, ${Crimson}, transparent)`,
                    clipPath: 'polygon(0 15%, 100% 0, 100% 100%, 0 85%)'
                }}
            />

            {/* Center Focus Shadow */}
            <div className="absolute inset-0 opacity-20" style={{ background: 'radial-gradient(circle, transparent 30%, black 100%)' }} />
        </>
      )}
    </div>
  );
};
