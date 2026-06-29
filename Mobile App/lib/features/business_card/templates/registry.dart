import 'base_template.dart';
import 'elite_templates.dart';
import 'creative_templates.dart';
import 'tech_templates.dart';
import 'minimalist_templates.dart';
import 'professional_templates.dart';
import 'luxury_templates.dart';
import 'legacy_templates.dart';

class TemplateRegistry {
  static final Map<String, BusinessCardTemplate> templates = {
    // ── Elite Series ────────────────────────────────────────────────────────
    'ceo_elite':      CEOEliteTemplate(),
    'midnight_gold': MidnightGoldTemplate(),
    'presidential':   PresidentialTemplate(),
    
    // ── Creative Series ─────────────────────────────────────────────────────
    'glass_alpha':   GlassAlphaTemplate(),
    'organic_wave':  OrganicWaveTemplate(),
    'pop_art':       PopArtTemplate(),
    
    // ── Tech Series ─────────────────────────────────────────────────────────
    'circuit_board': CircuitBoardTemplate(),
    'blockchain':    BlockchainTemplate(),
    'digital_mesh':  DigitalMeshTemplate(),
    'quantum':       QuantumTemplate(),

    // ── Minimalist Series ───────────────────────────────────────────────────
    'pure_white':     PureWhiteTemplate(),
    'deep_noir':      DeepNoirTemplate(),
    'swiss_grid':     SwissGridTemplate(),
    
    // ── Professional Series ─────────────────────────────────────────────────
    'lawyer_pro':     LawyerTemplate(),
    'medical_card':   MedicalTemplate(),
    'real_estate':    RealEstateTemplate(),
    'consultant':     ConsultantTemplate(),
    
    // ── Modern Series ───────────────────────────────────────────────────────
    'gradient_flash': GradientFlashTemplate(),
    'glass_card_2':   GlassCard2Template(),
    'neon_border':    NeonBorderTemplate(),

    // ── Luxury Series ───────────────────────────────────────────────────────
    'platinum_velvet': PlatinumVelvetTemplate(),
    'emerald_silk':    EmeraldSilkTemplate(),
    'marble_royale':   MarbleRoyaleTemplate(),
    
    // ── Social Series ───────────────────────────────────────────────────────
    'influencer':      InfluencerTemplate(),
    'creator':         CreatorTemplate(),
    'portfolio':       PortfolioTemplate(),
    
    // ── Geometric Series ────────────────────────────────────────────────────
    'prism':           PrismTemplate(),
    'triangle_edge':   TriangleTemplate(),
    'hexagon_grid':    HexagonTemplate(),
    'stellar':         StellarTemplate(),

    // ── Original (Legacy) ───────────────────────────────────────────────────
    'modern_minimal': ModernMinimalTemplate(),
    'corporate_bold': CorporateBoldTemplate(),
  };

  static List<String> getAllIds() => templates.keys.toList();
}
