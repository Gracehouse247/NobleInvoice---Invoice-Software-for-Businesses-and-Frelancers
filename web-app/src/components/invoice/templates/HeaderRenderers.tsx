import React, { Suspense } from 'react';
import { SharedEngineProps } from './types';

const renderers = {
  plat: React.lazy(() => import('./headers/PlatinumHeaders').then(m => ({ default: m.PlatinumHeader }))),
  prof: React.lazy(() => import('./headers/ProfessionalHeaders').then(m => ({ default: m.ProfessionalHeader }))),
  ess: React.lazy(() => import('./headers/EssentialHeaders').then(m => ({ default: m.EssentialHeader }))),
  geo: React.lazy(() => import('./headers/GeometricHeaders').then(m => ({ default: m.GeometricHeader }))),
  creative: React.lazy(() => import('./headers/CreativeHeaders').then(m => ({ default: m.CreativeHeader }))),
  default: React.lazy(() => import('./headers/DefaultHeaders').then(m => ({ default: m.DefaultHeader }))),
};

export const renderHeaderExt = (props: SharedEngineProps) => {
  let prefix = props.id.split('-')[0];
  if (!renderers[prefix as keyof typeof renderers]) {
    prefix = 'default';
  }
  
  const Renderer = renderers[prefix as keyof typeof renderers];

  return (
    <Suspense fallback={<div className="animate-pulse h-64 bg-slate-100 rounded-xl mb-12 w-full flex items-center justify-center text-slate-300 font-bold uppercase tracking-widest text-xs">Loading Template...</div>}>
      <Renderer {...props} />
    </Suspense>
  );
};
