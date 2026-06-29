import { CanvasTemplate } from '../../types/canvas';

export const STUDIO_TEMPLATES: CanvasTemplate[] = [
  {
    id: 'luxury-dark-01',
    name: 'Luxury Dark Real Estate',
    width: 1050,
    height: 600,
    background: '#0c0f1d',
    elements: [
      { id: 't1', type: 'text', text: 'OLIVIA WILSON', x: 80, y: 150, fontSize: 52, fill: '#ffffff', fontFamily: 'Playfair Display', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'CEO & Founder', x: 80, y: 220, fontSize: 24, fill: '#d4af37', fontFamily: 'Outfit', letterSpacing: 2, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 234 567 8900', x: 80, y: 400, fontSize: 18, fill: '#ffffff', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'olivia@estate.com', x: 80, y: 440, fontSize: 18, fill: '#ffffff', fontFamily: 'Inter', rotation: 0 },
      { id: 's1', type: 'shape', x: 80, y: 500, width: 400, height: 4, fill: '#d4af37', rotation: 0 }
    ]
  },
  {
    id: 'minimal-light-01',
    name: 'Minimal Clean Architecture',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 't1', type: 'text', text: 'MARCUS AURELIUS', x: 100, y: 200, fontSize: 48, fill: '#1a1a1a', fontFamily: 'Space Grotesk', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Lead Architect', x: 100, y: 260, fontSize: 20, fill: '#666666', fontFamily: 'Inter', letterSpacing: 4, rotation: 0 },
      { id: 's1', type: 'shape', x: 100, y: 320, width: 60, height: 4, fill: '#ff4400', rotation: 0 },
      { id: 't3', type: 'text', text: 'www.aurelius.arc', x: 650, y: 450, fontSize: 16, fill: '#1a1a1a', fontFamily: 'Space Mono', rotation: 0 }
    ]
  },
  {
    id: 'creative-gradient-01',
    name: 'Creative Tech Dynamic',
    width: 1050,
    height: 600,
    background: '#0f172a',
    elements: [
      { id: 't1', type: 'text', text: 'SARAH CHEN', x: 80, y: 150, fontSize: 64, fill: '#38bdf8', fontFamily: 'Syne', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Full Stack Engineer', x: 80, y: 230, fontSize: 22, fill: '#94a3b8', fontFamily: 'Space Grotesk', letterSpacing: 2, rotation: 0 },
      { id: 't3', type: 'text', text: 'GITHUB: @sarahc', x: 80, y: 480, fontSize: 16, fill: '#38bdf8', fontFamily: 'JetBrains Mono', rotation: 0 },
      { id: 's1', type: 'shape', x: 800, y: 0, width: 250, height: 600, fill: '#38bdf8', rotation: 0 },
      { id: 't4', type: 'text', text: 'SC', x: 860, y: 250, fontSize: 80, fill: '#0f172a', fontFamily: 'Syne', fontWeight: 'bold', rotation: 0 }
    ]
  },
  {
    id: 'id-claudia-alves',
    name: 'Claudia Bakery Artisanal',
    width: 1050,
    height: 600,
    background: '#fdfbf7',
    elements: [
      { id: 't1', type: 'text', text: 'CLAUDIA ALVES', x: 100, y: 150, fontSize: 44, fill: '#E69138', fontFamily: 'Cormorant Garamond', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'ARTISANAL BAKERY', x: 100, y: 210, fontSize: 16, fill: '#7f6000', fontFamily: 'Inter', letterSpacing: 4, rotation: 0 },
      { id: 's1', type: 'shape', x: 100, y: 250, width: 280, height: 2, fill: '#E69138', rotation: 0 },
      { id: 't3', type: 'text', text: '+123-456-7890', x: 100, y: 380, fontSize: 16, fill: '#333333', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'hello@bakery.com', x: 100, y: 420, fontSize: 16, fill: '#333333', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.bakery.com', x: 100, y: 460, fontSize: 16, fill: '#333333', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-larana-inc',
    name: 'Larana Vertex Executive',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 40, height: 600, fill: '#D35400', rotation: 0 },
      { id: 't1', type: 'text', text: 'AVERY DAVIS', x: 100, y: 150, fontSize: 48, fill: '#1a1a1a', fontFamily: 'Playfair Display', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'CREATIVE DIRECTOR', x: 100, y: 210, fontSize: 16, fill: '#666666', fontFamily: 'Outfit', letterSpacing: 5, rotation: 0 },
      { id: 's2', type: 'shape', x: 100, y: 250, width: 80, height: 4, fill: '#D35400', rotation: 0 },
      { id: 't3', type: 'text', text: '+1 234 567 8900', x: 100, y: 400, fontSize: 18, fill: '#1a1a1a', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'hello@larana.com', x: 100, y: 440, fontSize: 18, fill: '#1a1a1a', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.larana.com', x: 100, y: 480, fontSize: 18, fill: '#1a1a1a', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-chastain-kinetic',
    name: 'Chastain Navy Kinetic',
    width: 1050,
    height: 600,
    background: '#0B2447',
    elements: [
      { id: 's1', type: 'shape', x: 600, y: 0, width: 450, height: 600, fill: '#19376D', rotation: 0 },
      { id: 't1', type: 'text', text: 'CHASTAIN KINETIC', x: 80, y: 140, fontSize: 48, fill: '#ffffff', fontFamily: 'Space Grotesk', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'KINETIC CONSULTING', x: 80, y: 200, fontSize: 18, fill: '#00F0FF', fontFamily: 'Space Mono', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 019 2831', x: 80, y: 380, fontSize: 18, fill: '#ffffff', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'chastain@kinetic.io', x: 80, y: 420, fontSize: 18, fill: '#ffffff', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.kinetic.io', x: 80, y: 460, fontSize: 18, fill: '#00F0FF', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-aldenaire-executive',
    name: 'Aldenaire Navy Executive',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 380, height: 600, fill: '#0B3D66', rotation: 0 },
      { id: 't1', type: 'text', text: 'ALDENAIRE', x: 60, y: 200, fontSize: 40, fill: '#ffffff', fontFamily: 'Cinzel', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'EXECUTIVE GROUP', x: 60, y: 250, fontSize: 12, fill: '#e2e8f0', fontFamily: 'Outfit', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: 'ARTHUR PENDELTON', x: 440, y: 180, fontSize: 48, fill: '#0B3D66', fontFamily: 'EB Garamond', fontWeight: 'bold', rotation: 0 },
      { id: 't4', type: 'text', text: 'Managing Partner', x: 440, y: 240, fontSize: 20, fill: '#64748b', fontFamily: 'Lora', rotation: 0 },
      { id: 's2', type: 'shape', x: 440, y: 290, width: 500, height: 2, fill: '#D4AF37', rotation: 0 },
      { id: 't5', type: 'text', text: '+1 (800) 555-0199', x: 440, y: 400, fontSize: 18, fill: '#334155', fontFamily: 'Inter', rotation: 0 },
      { id: 't6', type: 'text', text: 'arthur@aldenaire.com', x: 440, y: 440, fontSize: 18, fill: '#334155', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-wilson-dynamic',
    name: 'Wilson Dynamic Azure',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 1050, height: 120, fill: '#00B4DB', rotation: 0 },
      { id: 't1', type: 'text', text: 'WILSON PARTNERS', x: 80, y: 180, fontSize: 44, fill: '#00B4DB', fontFamily: 'Montserrat', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Corporate Advisors', x: 80, y: 235, fontSize: 18, fill: '#64748b', fontFamily: 'Outfit', letterSpacing: 2, rotation: 0 },
      { id: 's2', type: 'shape', x: 80, y: 280, width: 200, height: 4, fill: '#00B4DB', rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 432 9988', x: 80, y: 390, fontSize: 16, fill: '#0f172a', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'contact@wilsoncorp.com', x: 80, y: 430, fontSize: 16, fill: '#0f172a', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.wilsoncorp.com', x: 80, y: 470, fontSize: 16, fill: '#00B4DB', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-thynk-azure',
    name: 'Thynk Azure Dynamic',
    width: 1050,
    height: 600,
    background: '#f8fafc',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 80, height: 600, fill: '#0055A4', rotation: 0 },
      { id: 't1', type: 'text', text: 'THYNK AZURE', x: 140, y: 150, fontSize: 48, fill: '#0055A4', fontFamily: 'Cabinet Grotesk', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Global Innovation', x: 140, y: 210, fontSize: 18, fill: '#64748b', fontFamily: 'Outfit', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 888 THYNK AZ', x: 140, y: 380, fontSize: 18, fill: '#0f172a', fontFamily: 'Space Mono', rotation: 0 },
      { id: 't4', type: 'text', text: 'innovate@thynk.azure', x: 140, y: 420, fontSize: 18, fill: '#0f172a', fontFamily: 'Space Mono', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.thynk.azure', x: 140, y: 460, fontSize: 18, fill: '#0055A4', fontFamily: 'Space Mono', rotation: 0 }
    ]
  },
  {
    id: 'id-avery-executive',
    name: 'Avery Executive Portal',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 25, height: 600, fill: '#DC2626', rotation: 0 },
      { id: 't1', type: 'text', text: 'AVERY PORTAL', x: 80, y: 140, fontSize: 48, fill: '#111827', fontFamily: 'Outfit', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Enterprise Architecture', x: 80, y: 200, fontSize: 18, fill: '#6b7280', fontFamily: 'Inter', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 901 2893', x: 80, y: 380, fontSize: 18, fill: '#111827', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'avery@portal.io', x: 80, y: 420, fontSize: 18, fill: '#111827', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.portal.io', x: 80, y: 460, fontSize: 18, fill: '#DC2626', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-gallego-dynamic',
    name: 'Gallego Dynamic Kinetic',
    width: 1050,
    height: 600,
    background: '#0f172a',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 580, width: 1050, height: 20, fill: '#10B981', rotation: 0 },
      { id: 't1', type: 'text', text: 'GALLEGO', x: 100, y: 150, fontSize: 56, fill: '#ffffff', fontFamily: 'Syne', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Kinetic Ventures', x: 100, y: 215, fontSize: 20, fill: '#10B981', fontFamily: 'Space Grotesk', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 777 8899', x: 100, y: 380, fontSize: 18, fill: '#e2e8f0', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'gallego@ventures.io', x: 100, y: 420, fontSize: 18, fill: '#e2e8f0', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-liceria-crimson',
    name: 'Liceria Crimson Elite',
    width: 1050,
    height: 600,
    background: '#110000',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 120, height: 600, fill: '#A00000', rotation: 0 },
      { id: 't1', type: 'text', text: 'LICERIA ELITE', x: 180, y: 150, fontSize: 52, fill: '#ffffff', fontFamily: 'Cinzel', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Crimson Prestige Club', x: 180, y: 210, fontSize: 18, fill: '#A00000', fontFamily: 'Outfit', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 800 CRIMSON', x: 180, y: 390, fontSize: 18, fill: '#f8fafc', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'reservations@liceria.com', x: 180, y: 430, fontSize: 18, fill: '#f8fafc', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-rosa-dynamic',
    name: 'Rosa Maria Dynamic',
    width: 1050,
    height: 600,
    background: '#fdfcfb',
    elements: [
      { id: 's1', type: 'shape', x: 350, y: 100, width: 4, height: 400, fill: '#FF4B6B', rotation: 0 },
      { id: 't1', type: 'text', text: 'ROSA MARIA', x: 80, y: 220, fontSize: 44, fill: '#111827', fontFamily: 'Cormorant Garamond', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Dynamic Artistry', x: 80, y: 280, fontSize: 16, fill: '#FF4B6B', fontFamily: 'Outfit', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 990 0112', x: 400, y: 210, fontSize: 18, fill: '#374151', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'hello@rosamaria.com', x: 400, y: 260, fontSize: 18, fill: '#374151', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: 'www.rosamaria.com', x: 400, y: 310, fontSize: 18, fill: '#374151', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-rosa-crystal',
    name: 'Rosa Crystal Dynamic',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 750, y: 0, width: 300, height: 600, fill: '#E8F5E9', rotation: 0 },
      { id: 't1', type: 'text', text: 'ROSA CRYSTAL', x: 80, y: 160, fontSize: 48, fill: '#2E7D32', fontFamily: 'Outfit', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Crystal Therapies', x: 80, y: 220, fontSize: 18, fill: '#64748b', fontFamily: 'Inter', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 019 2831', x: 80, y: 390, fontSize: 16, fill: '#2E7D32', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'crystal@rosa.com', x: 80, y: 430, fontSize: 16, fill: '#334155', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-andrade-pro',
    name: 'Andrade Creative',
    width: 1050,
    height: 600,
    background: '#0e1726',
    elements: [
      { id: 's1', type: 'shape', x: 50, y: 50, width: 4, height: 500, fill: '#D4AF37', rotation: 0 },
      { id: 't1', type: 'text', text: 'ANDRADE', x: 100, y: 150, fontSize: 52, fill: '#ffffff', fontFamily: 'Cinzel', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Creative Architect', x: 100, y: 210, fontSize: 16, fill: '#D4AF37', fontFamily: 'Space Grotesk', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 019 9931', x: 100, y: 380, fontSize: 18, fill: '#94a3b8', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'studio@andrade.co', x: 100, y: 420, fontSize: 18, fill: '#94a3b8', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-borcelle-pro',
    name: 'Borcelle Executive',
    width: 1050,
    height: 600,
    background: '#faf8f5',
    elements: [
      { id: 's1', type: 'shape', x: 700, y: 0, width: 350, height: 600, fill: '#800020', rotation: 0 },
      { id: 't1', type: 'text', text: 'BORCELLE', x: 80, y: 150, fontSize: 44, fill: '#800020', fontFamily: 'Fraunces', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Executive Advisory', x: 80, y: 205, fontSize: 16, fill: '#64748b', fontFamily: 'Inter', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 019 4432', x: 80, y: 380, fontSize: 18, fill: '#334155', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'advisory@borcelle.com', x: 80, y: 420, fontSize: 18, fill: '#334155', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-liceria-liquid',
    name: 'Liceria Liquid',
    width: 1050,
    height: 600,
    background: '#0c0f1d',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 20, height: 600, fill: '#0061FF', rotation: 0 },
      { id: 't1', type: 'text', text: 'LICERIA LIQUID', x: 80, y: 140, fontSize: 48, fill: '#ffffff', fontFamily: 'Syne', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Dynamic Tech Incubator', x: 80, y: 200, fontSize: 18, fill: '#0061FF', fontFamily: 'Space Grotesk', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 888 LIQ TECH', x: 80, y: 380, fontSize: 18, fill: '#e2e8f0', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'incubate@liceria.com', x: 80, y: 420, fontSize: 18, fill: '#e2e8f0', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-salford-pro',
    name: 'Salford Dynamic',
    width: 1050,
    height: 600,
    background: '#111827',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 15, height: 600, fill: '#EAB308', rotation: 0 },
      { id: 't1', type: 'text', text: 'SALFORD GROUP', x: 80, y: 150, fontSize: 48, fill: '#ffffff', fontFamily: 'Montserrat', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Strategic Development', x: 80, y: 210, fontSize: 18, fill: '#EAB308', fontFamily: 'Inter', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 901 0293', x: 80, y: 390, fontSize: 18, fill: '#f3f4f6', fontFamily: 'Space Mono', rotation: 0 },
      { id: 't4', type: 'text', text: 'salford@strategic.com', x: 80, y: 430, fontSize: 18, fill: '#f3f4f6', fontFamily: 'Space Mono', rotation: 0 }
    ]
  },
  {
    id: 'id-kogax-pro',
    name: 'Kogax Creative',
    width: 1050,
    height: 600,
    background: '#0d0d0d',
    elements: [
      { id: 's1', type: 'shape', x: 50, y: 50, width: 950, height: 500, fill: 'transparent', stroke: '#A4D955', strokeWidth: 2, rotation: 0 },
      { id: 't1', type: 'text', text: 'KOGAX STUDIO', x: 100, y: 150, fontSize: 52, fill: '#ffffff', fontFamily: 'Space Grotesk', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Creative Cybernetics', x: 100, y: 210, fontSize: 16, fill: '#A4D955', fontFamily: 'Space Mono', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 992 0192', x: 100, y: 380, fontSize: 16, fill: '#94a3b8', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'connect@kogax.cyber', x: 100, y: 420, fontSize: 16, fill: '#94a3b8', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-adeline-pro',
    name: 'Adeline Executive',
    width: 1050,
    height: 600,
    background: '#1e1e24',
    elements: [
      { id: 's1', type: 'shape', x: 950, y: 0, width: 100, height: 600, fill: '#EAB308', rotation: 0 },
      { id: 't1', type: 'text', text: 'ADELINE ELITE', x: 80, y: 160, fontSize: 44, fill: '#ffffff', fontFamily: 'Cormorant Garamond', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Executive Boardroom', x: 80, y: 215, fontSize: 16, fill: '#EAB308', fontFamily: 'Inter', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 901 2893', x: 80, y: 390, fontSize: 18, fill: '#e5e7eb', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'boardroom@adeline.com', x: 80, y: 430, fontSize: 18, fill: '#e5e7eb', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-ingoude-pro',
    name: 'Ingoude Executive',
    width: 1050,
    height: 600,
    background: '#252220',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 300, height: 600, fill: '#9B846F', rotation: 0 },
      { id: 't1', type: 'text', text: 'INGOUDE', x: 50, y: 220, fontSize: 40, fill: '#ffffff', fontFamily: 'Cinzel', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'EXECUTIVE', x: 50, y: 270, fontSize: 12, fill: '#f5f5f5', fontFamily: 'Inter', letterSpacing: 5, rotation: 0 },
      { id: 't3', type: 'text', text: 'VICTORIA STERLING', x: 360, y: 160, fontSize: 48, fill: '#9B846F', fontFamily: 'Playfair Display', fontWeight: 'bold', rotation: 0 },
      { id: 't4', type: 'text', text: 'Managing Partner', x: 360, y: 220, fontSize: 18, fill: '#a3a3a3', fontFamily: 'Inter', rotation: 0 },
      { id: 't5', type: 'text', text: '+1 555 0199', x: 360, y: 380, fontSize: 18, fill: '#e5e5e5', fontFamily: 'Inter', rotation: 0 },
      { id: 't6', type: 'text', text: 'sterling@ingoude.com', x: 360, y: 420, fontSize: 18, fill: '#e5e5e5', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-dynamic-wave-pro',
    name: 'Dynamic Wave',
    width: 1050,
    height: 600,
    background: '#f8f9fc',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 560, width: 1050, height: 40, fill: '#FF4B6B', rotation: 0 },
      { id: 't1', type: 'text', text: 'DYNAMIC WAVE', x: 80, y: 160, fontSize: 44, fill: '#FF4B6B', fontFamily: 'Syne', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Digital Solutions', x: 80, y: 220, fontSize: 16, fill: '#64748b', fontFamily: 'Inter', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 432 9988', x: 80, y: 390, fontSize: 16, fill: '#334155', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'wave@dynamicsolutions.io', x: 80, y: 430, fontSize: 16, fill: '#334155', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-rimberio-pro',
    name: 'Rimberio Elite',
    width: 1050,
    height: 600,
    background: '#110002',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 140, height: 600, fill: '#E31E24', rotation: 0 },
      { id: 't1', type: 'text', text: 'RIMBERIO ELITE', x: 200, y: 150, fontSize: 52, fill: '#ffffff', fontFamily: 'Cinzel', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Global Hospitality & Estates', x: 200, y: 210, fontSize: 16, fill: '#E31E24', fontFamily: 'Inter', letterSpacing: 3, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 (800) RIMBERIO', x: 200, y: 380, fontSize: 18, fill: '#f9fafb', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'concierge@rimberio.com', x: 200, y: 420, fontSize: 18, fill: '#f9fafb', fontFamily: 'Inter', rotation: 0 }
    ]
  },
  {
    id: 'id-elite-chevron',
    name: 'Elite Chevron',
    width: 1050,
    height: 600,
    background: '#ffffff',
    elements: [
      { id: 's1', type: 'shape', x: 0, y: 0, width: 1050, height: 25, fill: '#FCB221', rotation: 0 },
      { id: 't1', type: 'text', text: 'ELITE CHEVRON', x: 80, y: 150, fontSize: 44, fill: '#1e293b', fontFamily: 'Outfit', fontWeight: 'bold', rotation: 0 },
      { id: 't2', type: 'text', text: 'Corporate Operations', x: 80, y: 205, fontSize: 16, fill: '#FCB221', fontFamily: 'Inter', letterSpacing: 4, rotation: 0 },
      { id: 't3', type: 'text', text: '+1 555 901 0293', x: 80, y: 380, fontSize: 16, fill: '#334155', fontFamily: 'Inter', rotation: 0 },
      { id: 't4', type: 'text', text: 'operations@elitechevron.com', x: 80, y: 420, fontSize: 16, fill: '#334155', fontFamily: 'Inter', rotation: 0 }
    ]
  }
];
