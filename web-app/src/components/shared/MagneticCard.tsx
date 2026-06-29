'use client';

import React, { useRef } from 'react';
import { motion, useSpring, useMotionValue, useTransform } from 'framer-motion';

interface MagneticCardProps {
    children: React.ReactNode;
    className?: string;
    strength?: number;
}

export default function MagneticCard({ children, className = "", strength = 20 }: MagneticCardProps) {
    const cardRef = useRef<HTMLDivElement>(null);

    // Motion values for normalized mouse position (-0.5 to 0.5)
    const x = useMotionValue(0);
    const y = useMotionValue(0);

    // Smooth springs for fluid motion
    const springConfig = { damping: 25, stiffness: 150 };
    const xSpring = useSpring(x, springConfig);
    const ySpring = useSpring(y, springConfig);

    // Transform spring values to rotation degrees
    const rotateX = useTransform(ySpring, [-0.5, 0.5], [`${strength}deg`, `-${strength}deg`]);
    const rotateY = useTransform(xSpring, [-0.5, 0.5], [`-${strength}deg`, `${strength}deg`]);

    const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
        if (!cardRef.current) return;

        const rect = cardRef.current.getBoundingClientRect();
        const mouseX = e.clientX - rect.left;
        const mouseY = e.clientY - rect.top;

        const xPct = (mouseX / rect.width) - 0.5;
        const yPct = (mouseY / rect.height) - 0.5;

        x.set(xPct);
        y.set(yPct);
    };

    const handleMouseLeave = () => {
        x.set(0);
        y.set(0);
    };

    return (
        <div 
            className={`perspective-1000 ${className}`}
            onMouseMove={handleMouseMove}
            onMouseLeave={handleMouseLeave}
        >
            <motion.div
                ref={cardRef}
                style={{
                    rotateX,
                    rotateY,
                    transformStyle: "preserve-3d",
                }}
                className="w-full h-full relative"
            >
                {/* Subtle Shine Overlay */}
                <motion.div 
                    style={{
                        background: useTransform(
                            [xSpring, ySpring],
                            ([latestX, latestY]) => `radial-gradient(circle at ${(latestX as number + 0.5) * 100}% ${(latestY as number + 0.5) * 100}%, rgba(255,255,255,0.15) 0%, transparent 70%)`
                        ),
                        transform: "translateZ(1px)"
                    }}
                    className="absolute inset-0 pointer-events-none rounded-[inherit] z-20"
                />
                
                {/* Content with Z-offset for parallax effect */}
                <div className="w-full h-full" style={{ transform: "translateZ(40px)", transformStyle: "preserve-3d" }}>
                    {children}
                </div>
            </motion.div>

            <style jsx>{`
                .perspective-1000 {
                    perspective: 1000px;
                }
            `}</style>
        </div>
    );
}
