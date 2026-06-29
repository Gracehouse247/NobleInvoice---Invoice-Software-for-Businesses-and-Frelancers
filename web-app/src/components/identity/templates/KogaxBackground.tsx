import React from 'react';

const TextureOverlay = () => (
    <div 
        className="absolute inset-0 opacity-[0.05] pointer-events-none" 
        style={{ 
            backgroundImage: `repeating-linear-gradient(45deg, #000, #000 1px, transparent 1px, transparent 10px)` 
        }} 
    />
);

export const KogaxBackground: React.FC<{ side: 'front' | 'back' }> = ({ side }) => {
    const Lime = "#A4D955";
    const Charcoal = "#2D2D2D";

    return (
        <div className="absolute inset-0 bg-[#2D2D2D] overflow-hidden">
            <TextureOverlay />

            {/* Thick Diagonal Lime Stripe */}
            <div 
                className="absolute inset-0"
                style={{ 
                    backgroundColor: Lime,
                    clipPath: side === 'front' 
                        ? 'polygon(60% 0, 100% 0, 40% 100%, 0 100%)' 
                        : 'polygon(0 0, 40% 0, 100% 100%, 60% 100%)',
                    opacity: 0.9
                }}
            />

            {/* The Hexagonal Portal Frame (Stroke) */}
            <div 
                className="absolute top-1/2 -translate-y-1/2 w-[450px] h-[450px] z-10"
                style={{ 
                    left: side === 'front' ? 'auto' : '50px',
                    right: side === 'front' ? '50px' : 'auto',
                    backgroundColor: Lime,
                    clipPath: 'polygon(25% 5%, 75% 5%, 100% 50%, 75% 95%, 25% 95%, 0% 50%)'
                }}
            />

            {/* The Hexagonal Inner Mask (Where Photo goes) */}
            <div 
                className="absolute top-1/2 -translate-y-1/2 w-[420px] h-[420px] z-20 bg-slate-100"
                style={{ 
                    left: side === 'front' ? 'auto' : '65px',
                    right: side === 'front' ? '65px' : 'auto',
                    clipPath: 'polygon(25% 5%, 75% 5%, 100% 50%, 75% 95%, 25% 95%, 0% 50%)'
                }}
            />
        </div>
    );
};
