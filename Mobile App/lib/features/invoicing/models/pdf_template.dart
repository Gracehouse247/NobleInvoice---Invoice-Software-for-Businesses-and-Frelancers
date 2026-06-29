// lib/features/invoicing/models/pdf_template.dart
// Phase 5: Extended PDF Template Definitions with the 3 World-Class Aesthetic Themes

enum PdfTemplate {
  classic,  // Original — kept for backwards compat
  modern,   // Original — kept for backwards compat
  minimal,  // Original — kept for backwards compat
  bold,     // Original — kept for backwards compat
  minimalistAlpha,
  enterpriseStandard,
  creativeBold,
  modernCurve,      // New: Image 1 & 2 layout
  waveCorporate,    // New: Image 3 layout
  geometricBlue,    // New: Image 4 layout
  boldClassic,      // New: Image 5 layout
  platinumSky,      // Image 1 from Platinum Batch (Airplane Immersive Background)
  platinumRed,      // Image 2 from Platinum Batch (Red Clean Minimalist Wave)
  platinumBlue,     // Image 3 from Platinum Batch (Corporate Tabular Blue)
  platinumPurple,   // Image 4 from Platinum Batch (Sweeping Purple Gradient Vectors)
  platinumDark,     // Image 5 from Platinum Batch (High Contrast Block Headers)
  platinumNobleBlue, // Image 1 (Noble Blue Circular Header)
  platinumOrganicAmethyst, // Image 9 (Organic Purple Blobs)
  platinumSlateExecutive, // Image 10 (Slate Authority Bars)
  platinumScarletSwoosh, // Image 11 (Red Swoosh Footer)
  platinumGeometricAzure, // Image 20 (Angled Azure Stripes)
  platinumPaucek,          // Image 1: Centered Geometric (Paucek & Lage)
  platinumTimmerman,       // Image 2: Burgundy Serif (Timmerman Industries)
  platinumVerticalSidebar, // Image 3: Purple Sidebar (Avery Davis)
  platinumIngoude,         // Image 4: Navy/Gold Corporate (Ingoude Company)
  platinumAlves,           // Image 5: Minimalist Signature (Claudia Alves)
  platinumLaranaOrange,     // Screenshot 1: Larana Studio (Orange/Gold)
  platinumBorcelleBlue,      // Screenshot 2: Borcelle (Indigo/Blue)
  platinumSalfordTeal,       // Screenshot 3: Salford & Co (Teal)
  platinumFaugetDark,        // Screenshot 4: Fauget Agency (Dark/Yellow)
  platinumWarnerSpencerBeige, // Screenshot 5: Warner & Spencer (Beige/Elegant)
  platinumBorcelleGold,       // 31.png: Borcelle Industries (Gold Stripe)
  platinumFaugetSteak,        // 32.png: Fauget Steak House (Immersive Image)
  platinumShodweGreen,        // 33.png: Studio Shodwe (Green Curved)
  platinumLiceriaBlue,        // 34.png: Liceria & Co (Blue Angles)
  platinumBorcelleCircle,     // 35.png: Borcelle (Grey Circle Background)
  platinumMollyScript,        // 36.png: Molly's (Olive Green Script)
  platinumSalfordGeometric,   // 37.png: Salford & Co (Grey Geometrics)
  platinumFaugetRestaurant,   // 38.png: Fauget Restaurant (Watermark Sketch)
  platinumArowwaiNavy,        // 39.png: Arowwai & Co (Navy Header)
  platinumBoldDesign,         // 40.png: Bold Design Studio (Lime/Blue)
  platinumTSCompany,          // 41.png: TS Company (Grey/Indigo blocks)
  platinumChadGibbons,        // 42.png: Chad Gibbons (Teal Rounded Caps)
  platinumShodweWindow,       // 43.png: Studio Shodwe (Pink Window UI)
  platinumBorcelleFlower,      // 44.png: Borcelle (Gold Footer/Flower)
  platinumMauveMinimalist,    // 45.png: Mauve Minimalist (Rosy Circle)
  platinumYellowLotus,        // 46.png: Yellow Lotus (Yellow Curved)
  platinumBlueSkyline,        // 47.png: Blue Skyline (Blue Angled)
  platinumTealBlobs,          // 48.png: Teal Blobs (Teal/Pink lines)
  platinumWarnerCopper,       // 49.png: Warner & Spencer (Copper Immersive)
  platinumBorcelleModern,     // 50.png: Borcelle Modern (Blue Diagonal)
  platinumLaranaStudio,       // 51.png: Larana Studio (Orange Serif)
  platinumSalfordGreen,       // 52.png: Salford Green (Teal/Hexagon)
  platinumFaugetAgencyDark,   // 53.png: Fauget Agency (Dark/Yellow)
  
  // Premium Simple Batch
  simpleDiamond,     // Red/Black diamond pattern
  simpleBlobs,       // Organic blue/purple blobs
  simpleMetallic,    // Navy/Metallic curved header
  simpleGeometric,   // Yellow geometric arrow
  simpleAngled,      // Blue header with angled tab
  simpleWave,        // Orange/Dark Blue wave pattern
  simpleModern,      // Yellow triangle/diamond header
  simpleImmersive,   // Full background curve pattern
  simplePillTotal,
  simpleArrowLabel,
  simpleCleanGrid,
  simpleMinimalist,
  // ── Colorful Template Family ─────────────────────────────────────────────
  colorfulYellowBurst,
  colorfulNavyDiagonal,
  colorfulNavyHex,
  colorfulPinkMagenta,
  colorfulBlueCorporate,
  colorfulTealGreen,
  colorfulPurpleViolet,
  colorfulCleanMono,
  colorfulNavyBold,
  colorfulSkyWave,
  colorfulDarkIndigo,
  colorfulCharcoalBlock,
  colorfulOrangeBlob,
  colorfulSkyBlueSoft,
  colorfulFullOrange,
  colorfulBlueBanner,
  colorfulCleanLined,
  colorfulYellowBlueSplit,
  colorfulTealOlive,
  colorfulLightSlate,
  classic01, classic02, classic03, classic04, classic05, classic06, classic07, classic08, classic09, classic10,
  classic11, classic12, classic13, classic14, classic15, classic16, classic17, classic18, classic19, classic20,
  classic21, classic22, classic23, classic24, classic25, classic26, classic27, classic28, classic29, classic30,
  classic31, classic32, classic33, classic34,
  
  // ── Creative Immersive Family (New 27 Templates) ─────────────────────────
  creative01, creative02, creative03, creative04, creative05,
  creative06, creative07, creative08, creative09, creative10,
}

extension PdfTemplateExtension on PdfTemplate {
  String get label {
    switch (this) {
      case PdfTemplate.classic:             return 'Classic';
      case PdfTemplate.modern:              return 'Modern';
      case PdfTemplate.minimal:             return 'Minimal';
      case PdfTemplate.bold:               return 'Bold';
      case PdfTemplate.minimalistAlpha:    return '✦ Alpha';
      case PdfTemplate.enterpriseStandard: return '✦ Enterprise';
      case PdfTemplate.creativeBold:       return '✦ Creative';
      case PdfTemplate.modernCurve:        return '✦ Modern Curve';
      case PdfTemplate.waveCorporate:      return '✦ Wave Corporate';
      case PdfTemplate.geometricBlue:      return '✦ Geometric Blue';
      case PdfTemplate.boldClassic:        return '✦ Bold Classic';
      case PdfTemplate.platinumSky:        return '★ Premium Teal (Wardiere)';
      case PdfTemplate.platinumRed:        return '★ Premium Scarlet (Liceria)';
      case PdfTemplate.platinumBlue:       return '★ Premium Indigo (Austen)';
      case PdfTemplate.platinumPurple:     return '★ Premium Emerald (Arowwai)';
      case PdfTemplate.platinumDark:       return '★ Premium Slate (Salford)';
      case PdfTemplate.platinumNobleBlue:   return '★ Platinum Noble';
      case PdfTemplate.platinumOrganicAmethyst: return '★ Platinum Amethyst';
      case PdfTemplate.platinumSlateExecutive: return '★ Platinum Slate';
      case PdfTemplate.platinumScarletSwoosh: return '★ Platinum Scarlet';
      case PdfTemplate.platinumGeometricAzure: return '★ Platinum Azure';
      case PdfTemplate.platinumPaucek:      return '★ Professional Paucek';
      case PdfTemplate.platinumTimmerman:   return '★ Professional Timmerman';
      case PdfTemplate.platinumVerticalSidebar: return '★ Professional Avery';
      case PdfTemplate.platinumIngoude:     return '★ Professional Ingoude';
      case PdfTemplate.platinumAlves:       return '★ Professional Alves';
      case PdfTemplate.platinumLaranaOrange:    return '★ Platinum Larana';
      case PdfTemplate.platinumBorcelleBlue:     return '★ Platinum Borcelle';
      case PdfTemplate.platinumSalfordTeal:      return '★ Platinum Salford';
      case PdfTemplate.platinumFaugetDark:       return '★ Platinum Fauget Dark';
      case PdfTemplate.platinumWarnerSpencerBeige: return '★ Platinum Warner';
      case PdfTemplate.platinumBorcelleGold:     return '★ Platinum Borcelle Gold';
      case PdfTemplate.platinumFaugetSteak:      return '★ Platinum Fauget Steak';
      case PdfTemplate.platinumShodweGreen:      return '★ Platinum Shodwe Green';
      case PdfTemplate.platinumLiceriaBlue:      return '★ Platinum Liceria Blue';
      case PdfTemplate.platinumBorcelleCircle:    return '★ Platinum Borcelle Circle';
      case PdfTemplate.platinumMollyScript:       return '★ Platinum Molly Script';
      case PdfTemplate.platinumSalfordGeometric:  return '★ Platinum Salford Geometric';
      case PdfTemplate.platinumFaugetRestaurant:  return '★ Platinum Fauget Resto';
      case PdfTemplate.platinumArowwaiNavy:       return '★ Platinum Arowwai Navy';
      case PdfTemplate.platinumBoldDesign:        return '★ Platinum Bold Design';
      case PdfTemplate.platinumTSCompany:         return '★ Platinum TS Company';
      case PdfTemplate.platinumChadGibbons:       return '★ Platinum Chad Gibbons';
      case PdfTemplate.platinumShodweWindow:      return '★ Platinum Studio Shodwe';
      case PdfTemplate.platinumBorcelleFlower:     return '★ Platinum Borcelle Flower';
      case PdfTemplate.platinumMauveMinimalist:   return '★ Platinum Mauve Bliss';
      case PdfTemplate.platinumYellowLotus:       return '★ Platinum Yellow Lotus';
      case PdfTemplate.platinumBlueSkyline:       return '★ Platinum Blue Skyline';
      case PdfTemplate.platinumTealBlobs:         return '★ Platinum Teal Blobs';
      case PdfTemplate.platinumWarnerCopper:      return '★ Platinum Warner Copper';
      case PdfTemplate.platinumBorcelleModern:    return '★ Platinum Borcelle Modern';
      case PdfTemplate.platinumLaranaStudio:      return '★ Platinum Larana Studio';
      case PdfTemplate.platinumSalfordGreen:      return '★ Platinum Salford Green';
      case PdfTemplate.platinumFaugetAgencyDark:  return '★ Platinum Fauget Dark';
      
      case PdfTemplate.simpleDiamond:    return '✧ Diamond Edge';
      case PdfTemplate.simpleBlobs:      return '✧ Organic Blobs';
      case PdfTemplate.simpleMetallic:   return '✧ Metallic Curve';
      case PdfTemplate.simpleGeometric:  return '✧ Geometric Arrow';
      case PdfTemplate.simpleAngled:     return '✧ Angled Folder';
      case PdfTemplate.simpleWave:       return '✧ Energy Wave';
      case PdfTemplate.simpleModern:     return '✧ Modern Minimal';
      case PdfTemplate.simpleImmersive:  return '✧ Immersive Paper';
      case PdfTemplate.simplePillTotal:  return '✧ Pill Total';
      case PdfTemplate.simpleArrowLabel: return '✧ Arrow Label';
      case PdfTemplate.simpleCleanGrid:  return '✧ Clean Grid';
      case PdfTemplate.simpleMinimalist: return '✧ Charcoal Minimal';
      case PdfTemplate.colorfulYellowBurst:   return '◈ Yellow Burst';
      case PdfTemplate.colorfulNavyDiagonal:  return '◈ Navy Diagonal';
      case PdfTemplate.colorfulNavyHex:       return '◈ Navy Hex Grid';
      case PdfTemplate.colorfulPinkMagenta:   return '◈ Pink Magenta';
      case PdfTemplate.colorfulBlueCorporate: return '◈ Blue Corporate';
      case PdfTemplate.colorfulTealGreen:     return '◈ Teal Green';
      case PdfTemplate.colorfulPurpleViolet:  return '◈ Purple Violet';
      case PdfTemplate.colorfulCleanMono:     return '◈ Clean Mono';
      case PdfTemplate.colorfulNavyBold:      return '◈ Navy Bold';
      case PdfTemplate.colorfulSkyWave:       return '◈ Sky Wave';
      case PdfTemplate.colorfulDarkIndigo:    return '◈ Dark Indigo';
      case PdfTemplate.colorfulCharcoalBlock: return '◈ Charcoal Block';
      case PdfTemplate.colorfulOrangeBlob:    return '◈ Orange Blob';
      case PdfTemplate.colorfulSkyBlueSoft:   return '◈ Sky Blue Soft';
      case PdfTemplate.colorfulFullOrange:    return '◈ Full Orange';
      case PdfTemplate.colorfulBlueBanner:    return '◈ Blue Banner';
      case PdfTemplate.colorfulCleanLined:    return '◈ Clean Lined';
      case PdfTemplate.colorfulYellowBlueSplit: return '◈ Yellow Blue';
      case PdfTemplate.colorfulTealOlive:     return '◈ Teal Olive';
      case PdfTemplate.colorfulLightSlate:    return '◈ Light Slate';
      
      case PdfTemplate.classic01: return 'Classic Blue Horizon';
      case PdfTemplate.classic02: return 'Classic Emerald Curve';
      case PdfTemplate.classic03: return 'Classic Slate Grid';
      case PdfTemplate.classic04: return 'Classic Sunset Header';
      case PdfTemplate.classic05: return 'Classic Royal Banner';
      case PdfTemplate.classic06: return 'Classic Indigo Stripe';
      case PdfTemplate.classic07: return 'Classic Ruby Accent';
      case PdfTemplate.classic08: return 'Classic Teal Wave';
      case PdfTemplate.classic09: return 'Classic Onyx Executive';
      case PdfTemplate.classic10: return 'Classic Golden Edge';
      case PdfTemplate.classic11: return 'Classic Azure Flow';
      case PdfTemplate.classic12: return 'Classic Charcoal Block';
      case PdfTemplate.classic13: return 'Classic Violet Bloom';
      case PdfTemplate.classic14: return 'Classic Forest Modern';
      case PdfTemplate.classic15: return 'Classic Crimson Peak';
      case PdfTemplate.classic16: return 'Classic Navy Shield';
      case PdfTemplate.classic17: return 'Classic Amber Glow';
      case PdfTemplate.classic18: return 'Classic Silver Lining';
      case PdfTemplate.classic19: return 'Classic Bronze Authority';
      case PdfTemplate.classic20: return 'Classic Pearl Minimal';
      case PdfTemplate.classic21: return 'Classic Midnight Sky';
      case PdfTemplate.classic22: return 'Classic Rustik Copper';
      case PdfTemplate.classic23: return 'Classic Nordic White';
      case PdfTemplate.classic24: return 'Classic Tropical Palm';
      case PdfTemplate.classic25: return 'Classic Urban Loft';
      case PdfTemplate.classic26: return 'Classic Desert Sand';
      case PdfTemplate.classic27: return 'Classic Ocean Breeze';
      case PdfTemplate.classic28: return 'Classic Marble Stone';
      case PdfTemplate.classic29: return 'Classic Autumn Leaf';
      case PdfTemplate.classic30: return 'Classic Winter Frost';
      case PdfTemplate.classic31: return 'Classic Spring Bud';
      case PdfTemplate.classic32: return 'Classic Summer Flare';
      case PdfTemplate.classic33: return 'Classic Twilight Haze';
      case PdfTemplate.classic34: return 'Classic Morning Mist';
      
      case PdfTemplate.creative01: return 'Creative Teal Net';
      case PdfTemplate.creative02: return 'Creative Low-Poly';
      case PdfTemplate.creative03: return 'Creative Diamond';
      case PdfTemplate.creative04: return 'Creative Soft Gradient';
      case PdfTemplate.creative05: return 'Creative Architecture';
      case PdfTemplate.creative06: return 'Creative Gold Marble';
      case PdfTemplate.creative07: return 'Creative Glassmorphism';
      case PdfTemplate.creative08: return 'Creative Isometric';
      case PdfTemplate.creative09: return 'Creative Vintage';
      case PdfTemplate.creative10: return 'Creative Illustration';
      
      default: return 'Custom Template';
    }
  }

  String get description {
    switch (this) {
      case PdfTemplate.minimalistAlpha:    return 'Ultra-minimal. Refined whitespace. Premium agency look.';
      case PdfTemplate.enterpriseStandard: return 'Grid-based, info-dense. Built for corporate clients.';
      case PdfTemplate.creativeBold:       return 'Edge-to-edge color headers. Dynamic visual hierarchy.';
      case PdfTemplate.modernCurve:        return 'Premium swooping curves. A massive visual statement.';
      case PdfTemplate.waveCorporate:      return 'Organic wave headers. Professional and clean.';
      case PdfTemplate.geometricBlue:      return 'Dynamic angled stripes and vibrant borders.';
      case PdfTemplate.boldClassic:        return 'High contrast blocks. Bold numeric typography.';
      case PdfTemplate.platinumSky:        return 'Immersive gradient backdrop with floating typography.';
      case PdfTemplate.platinumRed:        return 'Sublime minimalism with sharp vector wave footer.';
      case PdfTemplate.platinumBlue:       return 'Sleek tabulated structures for ultimate corporate clarity.';
      case PdfTemplate.platinumPurple:     return 'Flowing elegant curves and centered symmetric spacing.';
      case PdfTemplate.platinumDark:       return 'Executive authority with ultra-heavy block hierarchy.';
      case PdfTemplate.platinumNobleBlue:   return 'Distinctive circular blue headers with floating typography.';
      case PdfTemplate.platinumOrganicAmethyst: return 'Creative organic blob patterns for high-end boutique brands.';
      case PdfTemplate.platinumSlateExecutive: return 'Powerful slate bars and a rigorous information grid.';
      case PdfTemplate.platinumScarletSwoosh: return 'Dynamic scarlet red swooshes and a clean minimalist body.';
      case PdfTemplate.platinumGeometricAzure: return 'Modern angled stripe patterns for a high-tech corporate look.';
      case PdfTemplate.platinumPaucek:      return 'Premium centered typography with minimalist geometric accents.';
      case PdfTemplate.platinumTimmerman:   return 'Elegant burgundy serif theme with high-end banded structures.';
      case PdfTemplate.platinumVerticalSidebar: return 'Modern breakout design with a vertical purple banner sidebar.';
      case PdfTemplate.platinumIngoude:     return 'Professional navy & gold corporate design for large enterprises.';
      case PdfTemplate.platinumAlves:       return 'High-end minimalist agency style with authoritative dark sidebars.';
      case PdfTemplate.platinumLaranaOrange:    return 'Elegant gold headers with organic corner curves and refined serif typography.';
      case PdfTemplate.platinumBorcelleBlue:     return 'Modern indigo design with geometric accents and clean sans-serif layouts.';
      case PdfTemplate.platinumSalfordTeal:      return 'Professional teal corporate theme with bold headers and signature lines.';
      case PdfTemplate.platinumFaugetDark:       return 'High-impact dark mode theme with vibrant yellow accents for modern brands.';
      case PdfTemplate.platinumWarnerSpencerBeige: return 'Sophisticated ivory/beige theme with elegant serifs and minimalist branding.';
      case PdfTemplate.platinumBorcelleGold:     return 'Modern gold stripe design with clean layout and professional typography.';
      case PdfTemplate.platinumFaugetSteak:      return 'Full-page immersive food backdrop with centered elegant typography.';
      case PdfTemplate.platinumShodweGreen:      return 'Organic green curved headers with a fresh, modern professional feel.';
      case PdfTemplate.platinumLiceriaBlue:      return 'Dynamic blue angled accents for a energetic corporate identity.';
      case PdfTemplate.platinumBorcelleCircle:    return 'Subtle grey circular geometry with refined minimalist information grid.';
      case PdfTemplate.platinumMollyScript:       return 'Artistic olive green script branding with a boutique feel.';
      case PdfTemplate.platinumSalfordGeometric:  return 'Professional grey geometric overlays with clean enterprise layout.';
      case PdfTemplate.platinumFaugetRestaurant:  return 'Creative restaurant sketch watermark with playful artisan typography.';
      case PdfTemplate.platinumArowwaiNavy:       return 'Authoritative navy header with geometric triangle branding.';
      case PdfTemplate.platinumBoldDesign:        return 'High-impact lime and blue geometric design for creative agencies.';
      case PdfTemplate.platinumTSCompany:         return 'Modern industrial grey and indigo blocks with strong typographic hierarchy.';
      case PdfTemplate.platinumChadGibbons:       return 'Friendly teal rounded layout with a focus on clear information grouping.';
      case PdfTemplate.platinumShodweWindow:      return 'Unique window-style UI design with playful pink accents and scrollbar motifs.';
      case PdfTemplate.platinumBorcelleFlower:     return 'Elegant gold-themed layout with organic flower branding and signature lines.';
      case PdfTemplate.platinumMauveMinimalist:   return 'Soft mauve tones with a minimalist circle-logo focus for boutique services.';
      case PdfTemplate.platinumYellowLotus:       return 'Vibrant yellow curves with a clean, energetic layout and high visibility.';
      case PdfTemplate.platinumBlueSkyline:       return 'Corporate blue angled gradients for a high-tech or financial industry look.';
      case PdfTemplate.platinumTealBlobs:         return 'Creative teal and pink organic shapes for a modern, artistic brand identity.';
      case PdfTemplate.platinumWarnerCopper:      return 'Luxurious copper-themed parchment style with high-end classic typography.';
      case PdfTemplate.platinumBorcelleModern:    return 'Sharp blue diagonal stripes with a modern, fast-paced corporate feel.';
      case PdfTemplate.platinumLaranaStudio:      return 'Warm orange serif-based design for a studio with a focus on craftsmanship.';
      case PdfTemplate.platinumSalfordGreen:      return 'Structured teal and green design with professional hexagon branding.';
      case PdfTemplate.platinumFaugetAgencyDark:  return 'Premiere dark mode agency template with high-contrast yellow typography.';
      
      case PdfTemplate.simpleDiamond:    return 'High-energy diamond pattern borders with high-contrast information grouping.';
      case PdfTemplate.simpleBlobs:      return 'Soft organic shapes and premium purple/blue gradients for a modern artistic look.';
      case PdfTemplate.simpleMetallic:   return 'Professional navy header with a sophisticated metallic curved overlay.';
      case PdfTemplate.simpleGeometric:  return 'Vibrant geometric arrow shapes and high-visibility yellow accents.';
      case PdfTemplate.simpleAngled:     return 'Sleek blue corporate header with a modern angled folder motif.';
      case PdfTemplate.simpleWave:       return 'Dynamic orange and navy wave patterns for a high-energy brand identity.';
      case PdfTemplate.simpleModern:     return 'Clean yellow and charcoal geometric header with a minimalist focus.';
      case PdfTemplate.simpleImmersive:  return 'Full-page subtle curve patterns for an ultra-premium, textured paper feel.';
      case PdfTemplate.simplePillTotal:  return 'High-impact design featuring a unique dark pill-shaped total summary block.';
      case PdfTemplate.simpleArrowLabel: return 'Modern corporate layout with a distinctive arrow-shaped badge for the invoice header.';
      case PdfTemplate.simpleCleanGrid:  return 'Professional, ultra-clean grid layout with sharp typography and ample white space.';
      case PdfTemplate.simpleMinimalist: return 'Elegant charcoal-toned minimalist layout with a focus on balanced information design.';
      case PdfTemplate.colorfulYellowBurst:   return 'High-energy amber burst design with bold orange accents and a striking circular decoration.';
      case PdfTemplate.colorfulNavyDiagonal:  return 'Sophisticated dark navy with a sharp diagonal split for a modern corporate identity.';
      case PdfTemplate.colorfulNavyHex:       return 'Deep navy header with a geometric hex-grid texture overlay for a high-tech look.';
      case PdfTemplate.colorfulPinkMagenta:   return 'Bold hot-pink magenta design for boutique brands that demand attention.';
      case PdfTemplate.colorfulBlueCorporate: return 'Full-width corporate blue header with white typography for a trusted enterprise look.';
      case PdfTemplate.colorfulTealGreen:     return 'Vibrant emerald-teal design blending professionalism with a fresh, energetic feel.';
      case PdfTemplate.colorfulPurpleViolet:  return 'Elegant violet-purple accents for creative studios and premium service brands.';
      case PdfTemplate.colorfulCleanMono:     return 'Crisp monochrome design with pure borders and no fills — universally professional.';
      case PdfTemplate.colorfulNavyBold:      return 'Bold solid navy authority header with high-contrast white text for ultimate trust.';
      case PdfTemplate.colorfulSkyWave:       return 'Soft sky-blue wave curved header for a calm yet structured corporate feel.';
      case PdfTemplate.colorfulDarkIndigo:    return 'Deep indigo premium dark template for luxury and executive-level invoices.';
      case PdfTemplate.colorfulCharcoalBlock: return 'Charcoal block header with high-contrast white text for strong executive authority.';
      case PdfTemplate.colorfulOrangeBlob:    return 'Organic orange circular blob decoration for a vibrant, modern creative brand.';
      case PdfTemplate.colorfulSkyBlueSoft:   return 'Gentle sky-blue soft header for a clean, accessible and friendly invoice design.';
      case PdfTemplate.colorfulFullOrange:    return 'Striking full-page orange background with white text — the most distinctive template.';
      case PdfTemplate.colorfulBlueBanner:    return 'Wide bold blue banner header with a logo circle for a powerful brand presence.';
      case PdfTemplate.colorfulCleanLined:    return 'Minimalist lined design with a single color accent stripe for elegant simplicity.';
      case PdfTemplate.colorfulYellowBlueSplit: return 'Full blue header meets bold yellow totals accent — a dynamic split-color design.';
      case PdfTemplate.colorfulTealOlive:     return 'Earthy olive-teal sidebar design for artisan, eco-friendly and nature-led brands.';
      case PdfTemplate.colorfulLightSlate:    return 'Cool light-slate professional design — subtle, refined and universally versatile.';
      case PdfTemplate.classic01: return 'Sophisticated blue header with a clean, horizontal focus.';
      case PdfTemplate.classic02: return 'Elegant green curves providing a professional yet modern feel.';
      case PdfTemplate.classic03: return 'Strict grid-based layout for ultimate corporate precision.';
      case PdfTemplate.classic04: return 'Warm sunset tones with a vibrant, high-visibility header.';
      case PdfTemplate.classic05: return 'Stately royal banner design for established luxury brands.';
      case PdfTemplate.classic06: return 'Bold indigo stripes for a confident and trustworthy look.';
      case PdfTemplate.classic07: return 'Refined ruby red accents on a crisp white background.';
      case PdfTemplate.classic08: return 'Refreshing teal waves for a modern and approachable brand.';
      case PdfTemplate.classic09: return 'Deep onyx black blocks for high-impact executive authority.';
      case PdfTemplate.classic10: return 'Subtle golden edges for a touch of premium sophistication.';
      case PdfTemplate.classic11: return 'Fluid azure designs for a tech-savvy and innovative brand.';
      case PdfTemplate.classic12: return 'Solid charcoal structures for a grounded and reliable feel.';
      case PdfTemplate.classic13: return 'Soft violet floral motifs for boutique and creative services.';
      case PdfTemplate.classic14: return 'Natural forest green tones with a clean modern layout.';
      case PdfTemplate.classic15: return 'Sharp crimson peaks for a high-energy and bold identity.';
      case PdfTemplate.classic16: return 'Traditional navy shields for a classic and secure look.';
      case PdfTemplate.classic17: return 'Warm amber glow for an inviting and friendly customer experience.';
      case PdfTemplate.classic18: return 'Sleek silver linings for a high-tech and futuristic look.';
      case PdfTemplate.classic19: return 'Rich bronze tones for a classic and authoritative feel.';
      case PdfTemplate.classic20: return 'Pure pearl white minimalism for ultra-clean brand identities.';
      case PdfTemplate.classic21: return 'Deep midnight blue backgrounds with high-contrast text.';
      case PdfTemplate.classic22: return 'Rustic copper accents for a grounded and artisan feel.';
      case PdfTemplate.classic23: return 'Nordic-inspired white and grey themes for clean simplicity.';
      case PdfTemplate.classic24: return 'Vibrant tropical colors for an energetic and fun brand.';
      case PdfTemplate.classic25: return 'Industrial urban loft style with raw and bold elements.';
      case PdfTemplate.classic26: return 'Soft desert sand tones for a calm and professional look.';
      case PdfTemplate.classic27: return 'Cool ocean blue gradients for a refreshing and calm feel.';
      case PdfTemplate.classic28: return 'Structured marble patterns for a solid and luxurious brand.';
      case PdfTemplate.classic29: return 'Rich autumn colors for a seasonal and warm brand identity.';
      case PdfTemplate.classic30: return 'Clean winter frost themes for a sharp and professional look.';
      case PdfTemplate.classic31: return 'Fresh spring bud greens for an energetic and growing brand.';
      case PdfTemplate.classic32: return 'Bright summer flare colors for high visibility and impact.';
      case PdfTemplate.classic33: return 'Mystical twilight hues for a creative and unique brand.';
      case PdfTemplate.classic34: return 'Soft morning mist tones for a gentle and professional look.';
      
      case PdfTemplate.creative01: return 'Glow net pattern with dark teal gradients and bold branding.';
      case PdfTemplate.creative02: return 'Sophisticated blue low-poly geometric header with steel blue accents.';
      case PdfTemplate.creative03: return 'Vibrant blue 3D diamond pattern header with professional clean layout.';
      case PdfTemplate.creative04: return 'Soft pink and sky blue fluid gradient with organic wavy shapes.';
      case PdfTemplate.creative05: return 'Dark architectural geometry with sleek charcoal and black tones.';
      case PdfTemplate.creative06: return 'Luxurious white marble with elegant gold veins for a high-end feel.';
      case PdfTemplate.creative07: return 'Modern glassmorphism effects with frosted panels over vibrant gradients.';
      case PdfTemplate.creative08: return 'Isometric 3D geometric illustrations for a tech-forward corporate look.';
      case PdfTemplate.creative09: return 'Premium vintage style with textured paper and classic typography.';
      case PdfTemplate.creative10: return 'Modern flat illustrations of financial growth and business partnership.';
      
      default: return '';
    }
  }

  bool get isPremium {
    return this == PdfTemplate.minimalistAlpha ||
           this == PdfTemplate.enterpriseStandard ||
           this == PdfTemplate.creativeBold ||
           this == PdfTemplate.modernCurve ||
           this == PdfTemplate.waveCorporate ||
           this == PdfTemplate.geometricBlue ||
           this == PdfTemplate.boldClassic ||
        this == PdfTemplate.simpleAngled ||
        this == PdfTemplate.simplePillTotal ||
           this == PdfTemplate.platinumSky ||
           this == PdfTemplate.platinumRed ||
           this == PdfTemplate.platinumBlue ||
           this == PdfTemplate.platinumPurple ||
           this == PdfTemplate.platinumDark ||
           this == PdfTemplate.platinumNobleBlue ||
           this == PdfTemplate.platinumOrganicAmethyst ||
           this == PdfTemplate.platinumSlateExecutive ||
           this == PdfTemplate.platinumScarletSwoosh ||
           this == PdfTemplate.platinumGeometricAzure ||
           this == PdfTemplate.platinumPaucek ||
           this == PdfTemplate.platinumTimmerman ||
           this == PdfTemplate.platinumVerticalSidebar ||
           this == PdfTemplate.platinumIngoude ||
           this == PdfTemplate.platinumAlves ||
           this == PdfTemplate.platinumLaranaOrange ||
           this == PdfTemplate.platinumBorcelleBlue ||
           this == PdfTemplate.platinumSalfordTeal ||
           this == PdfTemplate.platinumFaugetDark ||
           this == PdfTemplate.platinumWarnerSpencerBeige ||
           this == PdfTemplate.platinumBorcelleGold ||
           this == PdfTemplate.platinumFaugetSteak ||
           this == PdfTemplate.platinumShodweGreen ||
           this == PdfTemplate.platinumLiceriaBlue ||
           this == PdfTemplate.platinumBorcelleCircle ||
           this == PdfTemplate.platinumMollyScript ||
           this == PdfTemplate.platinumSalfordGeometric ||
           this == PdfTemplate.platinumFaugetRestaurant ||
           this == PdfTemplate.platinumArowwaiNavy ||
           this == PdfTemplate.platinumBoldDesign ||
           this == PdfTemplate.platinumTSCompany ||
           this == PdfTemplate.platinumChadGibbons ||
           this == PdfTemplate.platinumShodweWindow ||
           this == PdfTemplate.platinumBorcelleFlower ||
           this == PdfTemplate.platinumMauveMinimalist ||
           this == PdfTemplate.platinumYellowLotus ||
           this == PdfTemplate.platinumBlueSkyline ||
           this == PdfTemplate.platinumTealBlobs ||
           this == PdfTemplate.platinumWarnerCopper ||
           this == PdfTemplate.platinumBorcelleModern ||
           this == PdfTemplate.platinumLaranaStudio ||
           this == PdfTemplate.platinumSalfordGreen ||
           this == PdfTemplate.platinumFaugetAgencyDark ||
           this == PdfTemplate.simpleDiamond || 
           this == PdfTemplate.simpleWave ||
           this == PdfTemplate.simpleBlobs ||
           this == PdfTemplate.simpleMetallic ||
           this == PdfTemplate.simpleGeometric || 
           this == PdfTemplate.simpleModern ||
           this == PdfTemplate.simpleArrowLabel ||
           this == PdfTemplate.simpleAngled ||
           this == PdfTemplate.simplePillTotal ||
           this == PdfTemplate.simpleImmersive ||
           this == PdfTemplate.simpleCleanGrid ||
           this == PdfTemplate.simpleMinimalist ||
           this.name.startsWith('classic') ||
           (this.name.startsWith('colorful') && 
             this != PdfTemplate.colorfulCleanMono && 
             this != PdfTemplate.colorfulSkyBlueSoft && 
             this != PdfTemplate.colorfulCleanLined && 
             this != PdfTemplate.colorfulLightSlate) ||
           this.name.startsWith('creative');
  }

  String get category {
    if (this == PdfTemplate.simpleCleanGrid || this == PdfTemplate.simpleMinimalist ||
        this == PdfTemplate.colorfulCleanMono || this == PdfTemplate.colorfulSkyBlueSoft ||
        this == PdfTemplate.colorfulCleanLined || this == PdfTemplate.colorfulLightSlate) return 'Essentials';
    if (!isPremium) return 'Essentials';
    
    // Creative Immersive Family
    if (this.name.startsWith('creative') && this != PdfTemplate.creativeBold) return 'Creative';

    // Geometric: Modern structure, sharp lines
    if (this == PdfTemplate.simpleGeometric || 
        this == PdfTemplate.simpleModern ||
        this == PdfTemplate.simpleArrowLabel || 
        this == PdfTemplate.geometricBlue ||
        this == PdfTemplate.platinumGeometricAzure ||
        this == PdfTemplate.platinumSalfordGeometric ||
        this == PdfTemplate.platinumBorcelleModern ||
        this == PdfTemplate.platinumLiceriaBlue ||
        this == PdfTemplate.colorfulNavyDiagonal ||
        this == PdfTemplate.colorfulNavyHex ||
        this == PdfTemplate.colorfulSkyWave) {
      return 'Geometric';
    }

    // Professional: Trust and Authority, B2B focused (formerly Business)
    if (this == PdfTemplate.minimalistAlpha ||
        this == PdfTemplate.enterpriseStandard ||
        this == PdfTemplate.modernCurve ||
        this == PdfTemplate.waveCorporate ||
        this == PdfTemplate.boldClassic ||
        this == PdfTemplate.simpleAngled ||
        this == PdfTemplate.simplePillTotal ||
        this == PdfTemplate.platinumPaucek ||
        this == PdfTemplate.platinumTimmerman ||
        this == PdfTemplate.platinumIngoude ||
        this == PdfTemplate.platinumSlateExecutive ||
        this == PdfTemplate.platinumWarnerSpencerBeige ||
        this == PdfTemplate.platinumTSCompany ||
        this == PdfTemplate.platinumSalfordGreen ||
        this == PdfTemplate.colorfulNavyBold ||
        this == PdfTemplate.colorfulBlueBanner ||
        this == PdfTemplate.colorfulTealGreen ||
        this == PdfTemplate.colorfulYellowBlueSplit) {
      return 'Professional';
    }

    if (this == PdfTemplate.simpleImmersive ||
        this == PdfTemplate.simpleMetallic ||
        this == PdfTemplate.simpleBlobs ||
        this == PdfTemplate.creativeBold || // Moved to Platinum
        this == PdfTemplate.platinumOrganicAmethyst ||
        this == PdfTemplate.platinumMollyScript ||
        this == PdfTemplate.platinumFaugetRestaurant ||
        this == PdfTemplate.platinumBoldDesign ||
        this == PdfTemplate.platinumTealBlobs ||
        this == PdfTemplate.platinumShodweWindow ||
        this == PdfTemplate.colorfulPinkMagenta ||
        this == PdfTemplate.colorfulPurpleViolet ||
        this == PdfTemplate.colorfulOrangeBlob ||
        this == PdfTemplate.colorfulTealOlive ||
        this == PdfTemplate.colorfulDarkIndigo ||
        this == PdfTemplate.colorfulCharcoalBlock) {
      return 'Platinum';
    }

    // Geometric: 02, 08, 14, 20, 26, 32
    if (this == PdfTemplate.classic02 || this == PdfTemplate.classic08 || this == PdfTemplate.classic14 || 
        this == PdfTemplate.classic20 || this == PdfTemplate.classic26 || this == PdfTemplate.classic32) return 'Geometric';
    
    // Professional: 03, 09, 15, 21, 27, 33
    if (this == PdfTemplate.classic03 || this == PdfTemplate.classic09 || this == PdfTemplate.classic15 || 
        this == PdfTemplate.classic21 || this == PdfTemplate.classic27 || this == PdfTemplate.classic33) return 'Professional';
    
    // Platinum: 04, 10, 16, 22, 28, 34
    if (this == PdfTemplate.classic04 || this == PdfTemplate.classic10 || this == PdfTemplate.classic16 || 
        this == PdfTemplate.classic22 || this == PdfTemplate.classic28 || this == PdfTemplate.classic34) return 'Platinum';
    
    // Essentials: 05, 11, 17, 23, 29
    if (this == PdfTemplate.classic05 || this == PdfTemplate.classic11 || this == PdfTemplate.classic17 || 
        this == PdfTemplate.classic23 || this == PdfTemplate.classic29) return 'Essentials';

    // Recommended: 06, 12, 18, 24, 30
    if (this == PdfTemplate.classic06 || this == PdfTemplate.classic12 || this == PdfTemplate.classic18 || 
        this == PdfTemplate.classic24 || this == PdfTemplate.classic30) return 'Recommended';

    return 'Platinum';
  }

  bool get isRecommended {
    // Specifically curated list of world-class templates for the "Recommended" tab
    return this == PdfTemplate.simpleDiamond ||
        this == PdfTemplate.simpleBlobs ||
        this == PdfTemplate.modernCurve ||
        this == PdfTemplate.platinumNobleBlue ||
        this == PdfTemplate.platinumGeometricAzure ||
        this == PdfTemplate.platinumScarletSwoosh ||
        this == PdfTemplate.creative01 ||
        this == PdfTemplate.creative02 ||
        this == PdfTemplate.creative03 ||
        this == PdfTemplate.creative04 ||
        this == PdfTemplate.creative05 ||
        this == PdfTemplate.classic06 ||
        this == PdfTemplate.classic12 ||
        this == PdfTemplate.classic18 ||
        this == PdfTemplate.classic24 ||
        this == PdfTemplate.classic30 ||
        this == PdfTemplate.colorfulYellowBurst ||
        this == PdfTemplate.colorfulBlueCorporate ||
        this == PdfTemplate.colorfulFullOrange;
  }
}

