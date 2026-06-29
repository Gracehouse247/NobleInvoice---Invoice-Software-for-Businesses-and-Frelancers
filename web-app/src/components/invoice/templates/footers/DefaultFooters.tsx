import React from 'react';
import { SharedEngineProps } from '../types';
import { Mail, Phone, Globe, MapPin, User, Calendar, FileText, Diamond, Building2, CheckCircle2, Star, ShieldCheck, Signature } from 'lucide-react';

export const DefaultFooter = (props: SharedEngineProps) => {
  const { id, data, brand, containerRounding, isSerif, fontClass, renderLogo } = props;
  const { sender, client } = data;

  const footerStyle = data.template?.settings?.footerStyle || 'default';

  const accentColor = brand?.primary_color || brand?.brand_color || '#166FBB';

  switch (footerStyle) {
      case 'wave':
        return (
          <div className="mt-auto relative h-64 overflow-hidden bg-slate-50">
            <svg className="absolute bottom-0 left-0 w-full h-full" preserveAspectRatio="none" viewBox="0 0 1440 320">
              <path fill={accentColor} fillOpacity="1" d="M0,256L48,229.3C96,203,192,149,288,154.7C384,160,480,224,576,218.7C672,213,768,139,864,128C960,117,1056,171,1152,197.3C1248,224,1344,224,1392,224L1440,224L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path>
            </svg>
            <div className="absolute bottom-12 left-16 text-white font-black uppercase tracking-[1em] text-[10px] opacity-30">
              Noble Enterprise Global Network
            </div>
          </div>
        );
      case 'block':
        return (
          <div className="mt-auto flex h-56 text-white" style={{ backgroundColor: accentColor }}>
            <div className="w-[50%] p-16 flex flex-col justify-center border-r border-white/10 bg-black/5">
              <p className="text-[10px] font-black uppercase tracking-widest mb-4 opacity-50">Compliance Notice</p>
              <p className="text-base font-black leading-tight italic">All transactions are final upon receipt. Late payments incur standard processing fees.</p>
            </div>
            <div className="w-[50%] p-16 flex flex-col items-center justify-center text-center">
              <h2 className="text-6xl font-black uppercase italic tracking-tighter leading-none mb-3">THANK YOU</h2>
              <p className="text-[9px] font-black uppercase tracking-[0.5em] opacity-40">Business Partnership Excellence</p>
            </div>
          </div>
        );
      default:
        return (
          <div className="mt-auto p-16 border-t-4 border-slate-50 flex flex-col items-center bg-slate-50/30">
             <div className="w-16 h-1 bg-slate-200 mb-8 rounded-full" />
             <p className="text-[9px] font-black text-slate-400 uppercase tracking-[0.6em]">Authorized Transaction Document</p>
          </div>
        );
    }
  
  return null; // Fallback if no specific ID matched in this group
};
