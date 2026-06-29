import { IdentityData } from '@/types';
import React from 'react';

export interface CardRendererProps {
  data: IdentityData;
  side: 'front' | 'back';
  brandAccent: string;
  brandDark: string;
  brandLight: string;
  brandMid: string;
  ON_COLOR: string;
  ON_WHITE: string;
  effectiveAccent: string;
  fs: (baseSize: number) => string;
  DraggableElement: React.FC<{ elementKey: any, children: React.ReactNode, className?: string, style?: any }>;
  renderAvatar: (borderColor?: string, size?: number) => React.ReactNode;
}
