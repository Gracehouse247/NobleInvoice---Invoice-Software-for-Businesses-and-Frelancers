import React, { Suspense } from 'react';
import { SharedEngineProps } from './types';

const renderers = {
  plat: React.lazy(() => import('./backgrounds/PlatinumBackgrounds').then(m => ({ default: m.PlatinumBackground }))),
  prof: React.lazy(() => import('./backgrounds/ProfessionalBackgrounds').then(m => ({ default: m.ProfessionalBackground }))),
  ess: React.lazy(() => import('./backgrounds/EssentialBackgrounds').then(m => ({ default: m.EssentialBackground }))),
  geo: React.lazy(() => import('./backgrounds/GeometricBackgrounds').then(m => ({ default: m.GeometricBackground }))),
  creative: React.lazy(() => import('./backgrounds/CreativeBackgrounds').then(m => ({ default: m.CreativeBackground }))),
  default: React.lazy(() => import('./backgrounds/DefaultBackgrounds').then(m => ({ default: m.DefaultBackground }))),
};

export const renderBackgroundExt = (props: SharedEngineProps) => {
  let prefix = props.id.split('-')[0];
  if (!renderers[prefix as keyof typeof renderers]) {
    prefix = 'default';
  }
  
  const Renderer = renderers[prefix as keyof typeof renderers];

  return (
    <Suspense fallback={null}>
      <Renderer {...props} />
    </Suspense>
  );
};
