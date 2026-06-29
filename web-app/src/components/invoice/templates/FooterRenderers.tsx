import React, { Suspense } from 'react';
import { SharedEngineProps } from './types';

const renderers = {
  plat: React.lazy(() => import('./footers/PlatinumFooters').then(m => ({ default: m.PlatinumFooter }))),
  prof: React.lazy(() => import('./footers/ProfessionalFooters').then(m => ({ default: m.ProfessionalFooter }))),
  ess: React.lazy(() => import('./footers/EssentialFooters').then(m => ({ default: m.EssentialFooter }))),
  geo: React.lazy(() => import('./footers/GeometricFooters').then(m => ({ default: m.GeometricFooter }))),
  creative: React.lazy(() => import('./footers/CreativeFooters').then(m => ({ default: m.CreativeFooter }))),
  default: React.lazy(() => import('./footers/DefaultFooters').then(m => ({ default: m.DefaultFooter }))),
};

export const renderFooterExt = (props: SharedEngineProps) => {
  let prefix = props.id.split('-')[0];
  if (!renderers[prefix as keyof typeof renderers]) {
    prefix = 'default';
  }
  
  const Renderer = renderers[prefix as keyof typeof renderers];

  return (
    <Suspense fallback={<div className="animate-pulse h-32 bg-slate-100 rounded-xl mt-12 w-full flex items-center justify-center text-slate-300 font-bold uppercase tracking-widest text-xs">Loading Template...</div>}>
      <Renderer {...props} />
    </Suspense>
  );
};
