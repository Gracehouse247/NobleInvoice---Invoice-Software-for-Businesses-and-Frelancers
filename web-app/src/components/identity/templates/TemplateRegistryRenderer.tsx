import React from 'react';
import * as Corporate from './CorporateBackgrounds';
import * as Tech from './TechBackgrounds';
import * as Geometric from './GeometricBackgrounds';
import * as Minimal from './MinimalBackgrounds';
import * as Creative from './CreativeBackgrounds';
import * as Premium from './PremiumExecutiveBackgrounds';
import { EliteChevronBackground } from './EliteChevronBackground';
import { RimberioBackground } from './RimberioBackground';
import { DynamicWaveBackground } from './DynamicWaveBackground';
import { IngoudeBackground } from './IngoudeBackground';
import { AdelineBackground } from './AdelineBackground';
import { KogaxBackground } from './KogaxBackground';
import { SalfordBackground } from './SalfordBackground';
import { LiceriaLiquidBackground } from './LiceriaLiquidBackground';
import { BorcelleBackground } from './BorcelleBackground';
import { AndradeBackground } from './AndradeBackground';
import { RosaCrystalBackground } from './RosaCrystalBackground';
import { RosaDynamicBackground } from './RosaDynamicBackground';
import { LiceriaCrimsonBackground } from './LiceriaCrimsonBackground';
import { GallegoDynamicBackground } from './GallegoDynamicBackground';
import { AveryExecutiveBackground } from './AveryExecutiveBackground';
import { ThynkAzureBackground } from './ThynkAzureBackground';
import { WilsonDynamicBackground } from './WilsonDynamicBackground';
import { AldenaireExecutiveBackground } from './AldenaireExecutiveBackground';
import { ChastainKineticBackground } from './ChastainKineticBackground';

export const renderTemplateBackground = (templateId: string, accentColor: string, side: 'front' | 'back' = 'front') => {
  // Mapping logic based on cluster prefixes
  if (templateId === 'id-elite-chevron') return <EliteChevronBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-rimberio-pro') return <RimberioBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-dynamic-wave-pro') return <DynamicWaveBackground side={side} />;
  if (templateId === 'id-ingoude-pro') return <IngoudeBackground side={side} />;
  if (templateId === 'id-adeline-pro') return <AdelineBackground side={side} />;
  if (templateId === 'id-kogax-pro') return <KogaxBackground side={side} />;
  if (templateId === 'id-salford-pro') return <SalfordBackground side={side} />;
  if (templateId === 'id-liceria-liquid') return <LiceriaLiquidBackground side={side} />;
  if (templateId === 'id-borcelle-pro') return <BorcelleBackground side={side} />;
  if (templateId === 'id-andrade-pro') return <AndradeBackground side={side} />;
  if (templateId === 'id-chastain-kinetic') return <ChastainKineticBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-aldenaire-executive') return <AldenaireExecutiveBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-wilson-dynamic') return <WilsonDynamicBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-thynk-azure') return <ThynkAzureBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-avery-executive') return <AveryExecutiveBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-gallego-dynamic') return <GallegoDynamicBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-liceria-crimson') return <LiceriaCrimsonBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-rosa-dynamic') return <RosaDynamicBackground accentColor={accentColor} side={side} />;
  if (templateId === 'id-rosa-crystal') return <RosaCrystalBackground side={side} />;
  if (templateId.startsWith('id-corp-')) {
    if (side === 'back') return <Premium.EliteNavyBackground accentColor={accentColor} />;
    if (templateId === 'id-corp-26' || templateId === 'id-obsidian') return <Premium.MillionDollarGoldBackground accentColor={accentColor} />;
    if (templateId === 'id-corp-27' || templateId === 'id-arctic') return <Premium.EliteNavyBackground accentColor={accentColor} />;
    if (templateId === 'id-corp-30' || templateId === 'id-vanguard') return <Premium.DiamondEdgeBackground accentColor={accentColor} />;
    if (templateId.includes('corp-42') || templateId.includes('corp-43')) return <Premium.CinematicWaveBackground accentColor={accentColor} />;
    return <Corporate.ExecutiveNavyBackground accentColor={accentColor} />;
  }
  
  if (templateId.startsWith('id-tech-')) {
    if (templateId === 'id-tech-11') return <Tech.CyberPulseBackground accentColor={accentColor} />;
    if (templateId === 'id-tech-15') return <Tech.NeuralFlowBackground accentColor={accentColor} />;
    return <Tech.DigitalPulseBackground accentColor={accentColor} />;
  }
  
  if (templateId.startsWith('id-geo-')) {
    if (templateId === 'id-geo-45' || templateId === 'id-geo-54') return <Geometric.SalfordRedBackground accentColor={accentColor} />;
    if (templateId === 'id-geo-50' || templateId === 'id-geo-63') return <Geometric.ArowwaiGreenBackground accentColor={accentColor} />;
    if (templateId.includes('Back')) return <Geometric.ModernGeometricBackground accentColor={accentColor} />;
    return <Geometric.SharpAngleBackground accentColor={accentColor} />;
  }
  
  if (templateId.startsWith('id-min-')) {
    if (templateId === 'id-min-01') return <Premium.ArchitectSlateBackground accentColor={accentColor} />;
    if (templateId === 'id-min-02') return <Premium.ObsidianMarbleBackground accentColor={accentColor} />;
    return <Minimal.SoftCharcoalBackground accentColor={accentColor} />;
  }
  
  if (templateId.startsWith('id-crea-')) {
    if (templateId === 'id-crea-36') return <Creative.FloralBloomBackground accentColor={accentColor} />;
    return <Creative.NatureFlowBackground accentColor={accentColor} />;
  }

  // Fallback for defaults
  return (
    <div className="absolute inset-0 bg-white overflow-hidden">
      <div className="absolute inset-0 opacity-[0.01]" style={{ backgroundImage: 'radial-gradient(circle, #000 1px, transparent 1px)', backgroundSize: '40px 40px' }} />
    </div>
  );
};
