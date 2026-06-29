import React from 'react';
import { CardRendererProps } from '../types';
import { Phone, Mail, Globe, MapPin, Briefcase, Camera, Box, Leaf } from 'lucide-react';

export const AldenaireExecutiveCard: React.FC<CardRendererProps & { defaultColor?: string }> = (props) => {
  const { data, side, brandAccent, brandDark, brandLight, brandMid, ON_COLOR, ON_WHITE, fs, DraggableElement, renderAvatar, effectiveAccent } = props;
    const isFront = side === 'front';
    const darkBg = brandDark;
    const goldAccent = brandAccent;
    return (
        <div className={`relative w-full h-full flex ${isFront ? 'flex-row' : 'flex-col items-center justify-center'} z-20`}>
            {isFront ? (
                <>
                    <DraggableElement elementKey="logo" className="flex-[0.4] flex flex-col justify-center items-center p-12 text-center border-r-8" style={{ backgroundColor: darkBg, borderColor: goldAccent }}>
                        <div className="w-40 h-40 bg-white rounded-2xl flex items-center justify-center mb-6 shadow-xl">
                            <Briefcase size={80} style={{ color: darkBg }} />
                        </div>
                        <h2 className="font-black text-white uppercase tracking-tight leading-none" style={{ fontSize: fs(24) }}>
                            {data.companyName || 'ALDENAIRE'}
                        </h2>
                        <p className="font-bold tracking-[0.3em] mt-2" style={{ color: goldAccent, fontSize: fs(12) }}>CONSULTING</p>
                    </DraggableElement>
                    <DraggableElement elementKey="content" className="flex-[0.6] flex flex-col justify-between p-20 pl-24">
                        <div className="flex justify-between items-start w-full">
                            <div className="space-y-2">
                                <h1 className="font-black tracking-tighter uppercase leading-none" style={{ color: darkBg, fontSize: fs(52) }}>
                                    {data.fullName || 'RICHARD ALDEN'}
                                </h1>
                                <p className="font-medium tracking-[0.2em] uppercase" style={{ color: ON_WHITE, opacity: 0.5, fontSize: fs(20) }}>
                                    {data.jobTitle || 'Senior Partner'}
                                </p>
                            </div>
                            {renderAvatar(goldAccent, 110)}
                        </div>
                        <div className="space-y-6 mt-10">
                            {[
                                { icon: Phone, value: data.phone || '+123-456-7890' },
                                { icon: Mail, value: data.email || 'richard@aldenaire.com' },
                                { icon: MapPin, value: data.address || 'Financial District, NY' }
                            ].map((item, idx) => (
                                <div key={idx} className="flex items-center gap-6">
                                    <item.icon size={28} style={{ color: ON_WHITE }} />
                                    <span className="font-medium" style={{ color: ON_WHITE, fontSize: fs(16) }}>{item.value}</span>
                                </div>
                            ))}
                        </div>
                    </DraggableElement>
                </>
            ) : (
                /* Back side: full dark navy background (darkBg) — all text must be WHITE */
                <div className="text-center space-y-12">
                    <DraggableElement elementKey="logo">
                        <div className="flex flex-col items-center gap-6">
                            <div className="w-56 h-56 bg-white/10 rounded-3xl flex items-center justify-center shadow-2xl border border-white/20">
                                <Briefcase size={120} className="text-white" />
                            </div>
                            <h2 className="font-black text-white uppercase tracking-tighter" style={{ fontSize: fs(42) }}>
                                {data.companyName || 'ALDENAIRE'}
                            </h2>
                            <p className="font-bold tracking-[0.3em] uppercase" style={{ color: goldAccent, fontSize: fs(14) }}>CONSULTING</p>
                        </div>
                    </DraggableElement>
                    <DraggableElement elementKey="qr" className="flex flex-col items-center gap-4">
                        <div className="bg-white p-3 rounded-2xl shadow-xl border-4 border-white/30 inline-block">
                            <img 
                                src={`https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${encodeURIComponent(data.qrCodeUrl || 'https://nobleinvoice.ai')}&color=${darkBg.replace('#', '')}`} 
                                alt="QR" 
                                className="w-24 h-24"
                            />
                        </div>
                        <p className="text-white/50 font-bold tracking-[0.5em] uppercase" style={{ fontSize: fs(10) }}>Scan to Connect</p>
                    </DraggableElement>
                </div>
            )}
        </div>
    );
  };
