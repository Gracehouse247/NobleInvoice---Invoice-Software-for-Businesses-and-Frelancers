// lib/features/invoicing/widgets/classic_template_ui.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart' as ctrl;
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';

// ── Shape enum ────────────────────────────────────────────────────────────────
enum ClassicHeaderShape {
  rect, angled, curved, wave, pill, stripes, diamonds, bubbles,
  modern, goldEdge, azure, bloom, peaks, shield, dots, gradient,
  headerless,    // No top color block — INVOICE word in body
  chevron,       // Color header + white chevron accent bottom-right
  circleBadge,   // Color header + centered circular logo container
  boldBadge,     // Full header + INVOICE left-aligned LARGE + circle badge
  darkPill,      // White body + dark #212121 pill-shaped total box
  sidebarLayout, // No top header — 2-column: bill-to left, business right
}

// ── Per-template config ───────────────────────────────────────────────────────
class _TemplateConfig {
  final ClassicHeaderShape shape;
  final Color color;
  final bool isDark;
  final bool bodyDiamonds;
  final bool darkPillTotal;
  const _TemplateConfig(this.shape, this.color,
      {this.isDark = false, this.bodyDiamonds = false, this.darkPillTotal = false});
}

const _configs = <int, _TemplateConfig>{
  1:  _TemplateConfig(ClassicHeaderShape.angled,       Color(0xFFF57C00)),
  2:  _TemplateConfig(ClassicHeaderShape.angled,       Color(0xFF00897B)),
  3:  _TemplateConfig(ClassicHeaderShape.angled,       Color(0xFFC62828), bodyDiamonds: true),
  4:  _TemplateConfig(ClassicHeaderShape.headerless,   Color(0xFF212121)),
  5:  _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF1A237E)),
  6:  _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFFB71C1C)),
  7:  _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF1565C0)),
  8:  _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF00695C)),
  9:  _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFF546E7A)),
  10: _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFF1E88E5)),
  11: _TemplateConfig(ClassicHeaderShape.wave,         Color(0xFFFFB300)),
  12: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF3949AB)),
  13: _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFF2E7D32)),
  14: _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFFE65100)),
  15: _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFF1565C0)),
  16: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF283593)),
  17: _TemplateConfig(ClassicHeaderShape.chevron,      Color(0xFFF9A825)),
  18: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF3F51B5)),
  19: _TemplateConfig(ClassicHeaderShape.chevron,      Color(0xFFFF8F00)),
  20: _TemplateConfig(ClassicHeaderShape.circleBadge,  Color(0xFF1976D2)),
  21: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF1E88E5)),
  22: _TemplateConfig(ClassicHeaderShape.headerless,   Color(0xFFFDD835)),
  23: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF1565C0)),
  24: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF1976D2)),
  25: _TemplateConfig(ClassicHeaderShape.angled,       Color(0xFF1565C0)),
  26: _TemplateConfig(ClassicHeaderShape.rect,         Color(0xFF424242)),
  27: _TemplateConfig(ClassicHeaderShape.headerless,   Color(0xFF455A64)),
  28: _TemplateConfig(ClassicHeaderShape.headerless,   Color(0xFFFFCA28)),
  29: _TemplateConfig(ClassicHeaderShape.boldBadge,    Color(0xFFE65100)),
  30: _TemplateConfig(ClassicHeaderShape.darkPill,     Color(0xFF1565C0), darkPillTotal: true),
  31: _TemplateConfig(ClassicHeaderShape.darkPill,     Color(0xFF424242), darkPillTotal: true),
  32: _TemplateConfig(ClassicHeaderShape.angled,       Color(0xFFBF360C)),
  33: _TemplateConfig(ClassicHeaderShape.sidebarLayout,Color(0xFF455A64)),
  34: _TemplateConfig(ClassicHeaderShape.curved,       Color(0xFF2E7D32)),
};

// ── Public entry point ────────────────────────────────────────────────────────
class ClassicTemplateUI {
  static Widget build(PdfTemplate template, ctrl.InvoiceDetails invoice,
      BusinessInfo business, Color brandColor) {
    final idx = int.tryParse(template.name.replaceAll('classic', '')) ?? 1;
    final cfg = _configs[idx] ?? const _TemplateConfig(ClassicHeaderShape.rect, Color(0xFF1565C0));
    return _ClassicBaseTemplate(
      invoice: invoice,
      business: business,
      brandColor: cfg.color,
      headerShape: cfg.shape,
      isDark: cfg.isDark,
      bodyDiamonds: cfg.bodyDiamonds,
      darkPillTotal: cfg.darkPillTotal,
    );
  }
}

// ── Base template widget ───────────────────────────────────────────────────────
class _ClassicBaseTemplate extends StatelessWidget {
  final ctrl.InvoiceDetails invoice;
  final BusinessInfo business;
  final Color brandColor;
  final ClassicHeaderShape headerShape;
  final bool isDark;
  final bool bodyDiamonds;
  final bool darkPillTotal;

  const _ClassicBaseTemplate({
    required this.invoice,
    required this.business,
    required this.brandColor,
    required this.headerShape,
    this.isDark = false,
    this.bodyDiamonds = false,
    this.darkPillTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark
        ? const Color(0xFF212121)
        : (headerShape == ClassicHeaderShape.darkPill
            ? Colors.white
            : Colors.white);

    // Sidebar layout has no top header — different structure
    if (headerShape == ClassicHeaderShape.sidebarLayout) {
      return _SidebarLayout(
          invoice: invoice, business: business, brandColor: brandColor);
    }

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          if (bodyDiamonds)
            Positioned.fill(child: _DiamondsBg(color: brandColor.withOpacity(0.06))),
          Column(
            children: [
              if (headerShape != ClassicHeaderShape.headerless &&
                  headerShape != ClassicHeaderShape.darkPill)
                _buildHeader()
              else
                _buildHeaderlessBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: InvoiceTemplateComponents.buildBody(
                    context, invoice, business, brandColor,
                    isDark: isDark,
                    darkPillTotal: darkPillTotal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Full colour header ──────────────────────────────────────────────
  Widget _buildHeader() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderPainter(shape: headerShape, color: brandColor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 44, 24, 0),
          child: _headerContent(),
        ),
      ),
    );
  }

  Widget _headerContent() {
    if (headerShape == ClassicHeaderShape.boldBadge) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circle badge logo
          Container(
            width: 56, height: 56,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: business.logoUrl != null
                ? ClipOval(child: Image.network(business.logoUrl!, fit: BoxFit.cover))
                : const Icon(Icons.business, color: Color(0xFF455A64), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('INVOICE',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2)),
                Text('#${invoice.invoiceNumber}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(business.name.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    }

    if (headerShape == ClassicHeaderShape.circleBadge) {
      return Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: business.logoUrl != null
                ? ClipOval(child: Image.network(business.logoUrl!, fit: BoxFit.cover))
                : const Icon(Icons.business, color: Color(0xFF455A64), size: 30),
          ),
          const SizedBox(height: 6),
          Text(business.name.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
          Text('INVOICE',
              style: const TextStyle(
                  color: Colors.white70, fontSize: 10, letterSpacing: 3)),
        ],
      );
    }

    // Default header content (logo-left, INVOICE-right)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (business.logoUrl != null)
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(business.logoUrl!, fit: BoxFit.contain),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(business.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Text(business.businessEmail ?? '',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 9)),
                    Text(business.businessPhone ?? '',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('INVOICE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: headerShape == ClassicHeaderShape.wave ? 30 : 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)),
            Text('#${invoice.invoiceNumber}',
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  // ── Headerless bar (just a thin accent) ────────────────────────────
  Widget _buildHeaderlessBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: brandColor, width: 5)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (business.logoUrl != null)
                Image.network(business.logoUrl!, height: 36, fit: BoxFit.contain),
              Text(business.name.toUpperCase(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: brandColor)),
              Text(business.businessEmail ?? '',
                  style: const TextStyle(fontSize: 9, color: Colors.black54)),
            ],
          ),
          Text('INVOICE',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: brandColor,
                  letterSpacing: 2)),
        ],
      ),
    );
  }
}

// ── Sidebar layout ────────────────────────────────────────────────────────────
class _SidebarLayout extends StatelessWidget {
  final ctrl.InvoiceDetails invoice;
  final BusinessInfo business;
  final Color brandColor;
  const _SidebarLayout(
      {required this.invoice,
      required this.business,
      required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Business info strip at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: brandColor.withOpacity(0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(business.name.toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: brandColor)),
                  Text(business.businessEmail ?? '',
                      style:
                          const TextStyle(fontSize: 9, color: Colors.black54)),
                ]),
                Text('INVOICE',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: brandColor)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: InvoiceTemplateComponents.buildBody(
                  context, invoice, business, brandColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header CustomPainter ──────────────────────────────────────────────────────
class _HeaderPainter extends CustomPainter {
  final ClassicHeaderShape shape;
  final Color color;
  _HeaderPainter({required this.shape, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();

    switch (shape) {
      case ClassicHeaderShape.angled:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 50);
        path.lineTo(0, size.height);
        path.close();
        break;
      case ClassicHeaderShape.curved:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 30);
        path.quadraticBezierTo(
            size.width * 0.5, size.height, 0, size.height - 30);
        path.close();
        break;
      case ClassicHeaderShape.wave:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 20);
        path.cubicTo(
            size.width * 0.75, size.height - 50,
            size.width * 0.25, size.height + 10,
            0, size.height - 20);
        path.close();
        break;
      case ClassicHeaderShape.chevron:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 40);
        path.lineTo(size.width * 0.85, size.height);
        path.lineTo(0, size.height - 40);
        path.close();
        break;
      case ClassicHeaderShape.circleBadge:
      case ClassicHeaderShape.boldBadge:
      case ClassicHeaderShape.rect:
      case ClassicHeaderShape.stripes:
      case ClassicHeaderShape.bubbles:
      case ClassicHeaderShape.dots:
        path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
        break;
      case ClassicHeaderShape.pill:
        path.addRRect(RRect.fromLTRBAndCorners(
          0, 0, size.width, size.height,
          bottomRight: const Radius.circular(80),
        ));
        break;
      case ClassicHeaderShape.diamonds:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 50);
        path.lineTo(size.width * 0.5, size.height);
        path.lineTo(0, size.height - 50);
        path.close();
        break;
      case ClassicHeaderShape.modern:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width * 0.3, size.height - 30);
        path.lineTo(0, size.height);
        path.close();
        break;
      case ClassicHeaderShape.peaks:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 30);
        path.lineTo(size.width * 0.75, size.height);
        path.lineTo(size.width * 0.5, size.height - 40);
        path.lineTo(size.width * 0.25, size.height);
        path.lineTo(0, size.height - 30);
        path.close();
        break;
      case ClassicHeaderShape.shield:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 40);
        path.lineTo(size.width * 0.5, size.height);
        path.lineTo(0, size.height - 40);
        path.close();
        break;
      case ClassicHeaderShape.azure:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height - 20);
        path.quadraticBezierTo(
            size.width * 0.8, size.height + 30, size.width * 0.5, size.height - 10);
        path.quadraticBezierTo(
            size.width * 0.2, size.height - 50, 0, size.height);
        path.close();
        break;
      case ClassicHeaderShape.bloom:
        path.addRect(Rect.fromLTWH(0, 0, size.width, size.height - 40));
        canvas.drawPath(path, paint);
        final bloom = Paint()..color = color.withOpacity(0.3);
        canvas.drawCircle(Offset(size.width, 0), 100, bloom);
        canvas.drawCircle(Offset(0, size.height - 40), 50, bloom);
        return;
      case ClassicHeaderShape.goldEdge:
        path.addRect(Rect.fromLTWH(0, 0, size.width, size.height - 30));
        canvas.drawPath(path, paint);
        final accent = Paint()
          ..color = const Color(0xFFFFC107)
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
            Offset(0, size.height - 30),
            Offset(size.width, size.height - 30),
            accent);
        return;
      case ClassicHeaderShape.gradient:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        paint.shader = LinearGradient(
          colors: [color, color.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect);
        path.addRect(rect);
        break;
      case ClassicHeaderShape.headerless:
      case ClassicHeaderShape.darkPill:
      case ClassicHeaderShape.sidebarLayout:
        return; // No header painting
    }

    canvas.drawPath(path, paint);

    // Chevron extra white triangle
    if (shape == ClassicHeaderShape.chevron) {
      final whitePaint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      final chevPath = Path();
      chevPath.moveTo(size.width * 0.6, 0);
      chevPath.lineTo(size.width, 0);
      chevPath.lineTo(size.width, size.height - 40);
      chevPath.lineTo(size.width * 0.85, size.height);
      chevPath.lineTo(size.width * 0.6, size.height - 40);
      chevPath.close();
      canvas.drawPath(chevPath, whitePaint);
    }

    // Dots in header for dot-style
    if (shape == ClassicHeaderShape.dots) {
      final dotPaint = Paint()..color = Colors.white.withOpacity(0.12);
      for (double x = 20; x < size.width; x += 28) {
        for (double y = 20; y < size.height; y += 28) {
          canvas.drawCircle(Offset(x, y), 2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Body diamond background ───────────────────────────────────────────────────
class _DiamondsBg extends StatelessWidget {
  final Color color;
  const _DiamondsBg({required this.color});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _DiamondsPainter(color: color));
}

class _DiamondsPainter extends CustomPainter {
  final Color color;
  _DiamondsPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 36.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        final path = Path()
          ..moveTo(x + step / 2, y)
          ..lineTo(x + step, y + step / 2)
          ..lineTo(x + step / 2, y + step)
          ..lineTo(x, y + step / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
