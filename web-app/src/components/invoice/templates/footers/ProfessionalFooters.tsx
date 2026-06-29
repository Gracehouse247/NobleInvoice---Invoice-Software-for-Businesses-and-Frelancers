import React from 'react';
import { SharedEngineProps } from '../types';
import * as Group1 from './FooterDesignsGroup1';
import * as Group2 from './FooterDesignsGroup2';

const FOOTER_MAP: Record<string, React.FC<SharedEngineProps>> = {
  'prof-blue-horizon': Group1.BlueHorizonFooter,
  'prof-red-diamond': Group1.RedDiamondFooter,
  'prof-navy-geometric': Group1.NavyGeometricFooter,
  'prof-teal-geometric': Group1.TealGeometricFooter,
  'prof-orange-geometric': Group1.OrangeGeometricFooter,
  'prof-yellow-sharp': Group1.YellowSharpFooter,
  'prof-black-yellow-geo': Group1.BlackYellowGeoFooter,
  'prof-cyan-black-geo': Group1.CyanBlackGeoFooter,
  'prof-yellow-blue-pill': Group1.YellowBluePillFooter,
  'prof-yellow-minimal-geo': Group1.YellowMinimalGeoFooter,

  'prof-blue-wave-premium': Group2.BlueWavePremiumFooter,
  'prof-blue-curved-banner': Group2.BlueCurvedBannerFooter,
  'prof-carbon-fiber': Group2.CarbonFiberFooter,
  'prof-sage-minimal': Group2.SageMinimalFooter,
  'prof-crimson-ledger': Group2.CrimsonLedgerFooter,
  'prof-cobalt-split': Group2.CobaltSplitFooter,
  'prof-slate-grid': Group2.SlateGridFooter,
  'prof-forest-premium': Group2.ForestPremiumFooter,
  'prof-emerald-nexus': Group2.EmeraldNexusFooter,
  'prof-royal-purple': Group2.RoyalPurpleFooter,
  'prof-brick': Group2.BrickFooter,
  'prof-dark-gold': Group2.DarkGoldFooter,
  'prof-navy-ribbon': Group2.NavyRibbonFooter,
  'prof-slate-angle': Group2.SlateAngleFooter,
  'prof-construction': Group2.ConstructionFooter,
};

export const ProfessionalFooter: React.FC<SharedEngineProps> = (props) => {
  const FooterComponent = FOOTER_MAP[props.id];
  if (!FooterComponent) {
    return null;
  }
  return <FooterComponent {...props} />;
};
