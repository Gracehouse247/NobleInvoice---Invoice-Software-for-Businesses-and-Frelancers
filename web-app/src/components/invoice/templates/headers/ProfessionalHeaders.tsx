import React from 'react';
import { SharedEngineProps } from '../types';
import * as Group1 from './HeaderDesignsGroup1';
import * as Group2 from './HeaderDesignsGroup2';
import * as Group3 from './HeaderDesignsGroup3';

const HEADER_MAP: Record<string, React.FC<SharedEngineProps>> = {
  'prof-blue-horizon': Group1.BlueHorizonHeader,
  'prof-red-diamond': Group1.RedDiamondHeader,
  'prof-navy-geometric': Group1.NavyGeometricHeader,
  'prof-teal-geometric': Group1.TealGeometricHeader,
  'prof-orange-geometric': Group1.OrangeGeometricHeader,
  'prof-yellow-sharp': Group1.YellowSharpHeader,
  'prof-black-yellow-geo': Group1.BlackYellowGeoHeader,
  'prof-cyan-black-geo': Group1.CyanBlackGeoHeader,
  'prof-yellow-blue-pill': Group1.YellowBluePillHeader,
  'prof-yellow-minimal-geo': Group1.YellowMinimalGeoHeader,

  'prof-blue-wave-premium': Group2.BlueWavePremiumHeader,
  'prof-blue-curved-banner': Group2.BlueCurvedBannerHeader,
  'prof-carbon-fiber': Group2.CarbonFiberHeader,
  'prof-sage-minimal': Group2.SageMinimalHeader,
  'prof-crimson-ledger': Group2.CrimsonLedgerHeader,
  'prof-cobalt-split': Group2.CobaltSplitHeader,
  'prof-slate-grid': Group2.SlateGridHeader,
  'prof-forest-premium': Group2.ForestPremiumHeader,
  'prof-emerald-nexus': Group2.EmeraldNexusHeader,
  'prof-royal-purple': Group2.RoyalPurpleHeader,

  'prof-modern-minimal': Group3.ModernMinimalHeader,
  'prof-pastel-bloom': Group3.PastelBloomHeader,
  'prof-blue-precision': Group3.BluePrecisionHeader,
  'prof-orange-orbit': Group3.OrangeOrbitHeader,
  'prof-oceanic-wave': Group3.OceanicWaveHeader,
  'prof-brick': Group3.BrickHeader,
  'prof-dark-gold': Group3.DarkGoldHeader,
  'prof-navy-ribbon': Group3.NavyRibbonHeader,
  'prof-slate-angle': Group3.SlateAngleHeader,
  'prof-construction': Group3.ConstructionHeader,
};

export const ProfessionalHeader: React.FC<SharedEngineProps> = (props) => {
  const HeaderComponent = HEADER_MAP[props.id];
  if (!HeaderComponent) {
    return null;
  }
  return <HeaderComponent {...props} />;
};
