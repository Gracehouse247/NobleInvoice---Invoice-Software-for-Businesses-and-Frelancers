import React from 'react';

const DotGrid = ({ className }: { className?: string }) => (
    <svg className={className} width="100" height="100" viewBox="0 0 100 100" fill="none">
        {[...Array(6)].map((_, i) => (
            [...Array(6)].map((_, j) => (
                <circle key={`${i}-${j}`} cx={10 + i * 16} cy={10 + j * 16} r="2" fill="currentColor" opacity="0.3" />
            ))
        ))}
    </svg>
);

export const SalfordBackground: React.FC<{ side: 'front' | 'back' }> = ({ side }) => {
    const Coffee = "#2B1B17";
    const Ochre = "#EAB308";
    const Tan = "#C0A58A";

    return (
        <div className="absolute inset-0 bg-[#2B1B17] overflow-hidden font-serif">
            {/* Top Right Shards */}
            <div className="absolute top-0 right-0 w-[400px] h-[300px] pointer-events-none">
                <div 
                    className="absolute top-0 right-0 w-full h-full transform translate-x-20 -translate-y-20 rotate-45"
                    style={{ backgroundColor: Tan, opacity: 0.8 }}
                />
                <div 
                    className="absolute top-0 right-0 w-[80%] h-[80%] transform translate-x-32 -translate-y-32 rotate-45 border-[20px] border-[#3d2721]"
                />
                <div 
                    className="absolute top-0 right-0 w-[60%] h-[60%] transform translate-x-40 -translate-y-40 rotate-45"
                    style={{ backgroundColor: Ochre }}
                />
            </div>

            {/* Bottom Left Shards */}
            <div className="absolute bottom-0 left-0 w-[300px] h-[400px] pointer-events-none">
                <div 
                    className="absolute bottom-0 left-0 w-full h-full transform -translate-x-20 translate-y-20 rotate-45"
                    style={{ backgroundColor: Ochre, opacity: 0.9 }}
                />
                <div 
                    className="absolute bottom-0 left-0 w-[80%] h-[80%] transform -translate-x-32 translate-y-32 rotate-45 border-[15px] border-white/10"
                />
                <div 
                    className="absolute bottom-0 left-0 w-[60%] h-[60%] transform -translate-x-40 translate-y-40 rotate-45"
                    style={{ backgroundColor: Tan }}
                />
            </div>

            {/* Dot Grids */}
            <DotGrid className="absolute top-10 left-10 text-white" />
            <DotGrid className="absolute bottom-10 right-10 text-white" />

            {/* Footer Bar (Front Side) */}
            {side === 'front' && (
                <div 
                    className="absolute bottom-0 left-0 w-full h-[60px]"
                    style={{ backgroundColor: Ochre }}
                />
            )}

            <div className="absolute inset-0 opacity-[0.03] pointer-events-none" style={{ backgroundImage: 'radial-gradient(circle, #fff 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
        </div>
    );
};
