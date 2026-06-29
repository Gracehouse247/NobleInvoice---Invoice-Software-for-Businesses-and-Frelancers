// lib/core/services/pdf/templates/classic_pdf_templates.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Per-template colour map matching the UI layer
// ─────────────────────────────────────────────────────────────────────────────
const _colors = <int, int>{
  1:  0xFFF57C00, 2:  0xFF00897B, 3:  0xFFC62828, 4:  0xFF212121,
  5:  0xFF1A237E, 6:  0xFFB71C1C, 7:  0xFF1565C0, 8:  0xFF00695C,
  9:  0xFF546E7A, 10: 0xFF1E88E5, 11: 0xFFFFB300, 12: 0xFF3949AB,
  13: 0xFF2E7D32, 14: 0xFFE65100, 15: 0xFF1565C0, 16: 0xFF283593,
  17: 0xFFF9A825, 18: 0xFF3F51B5, 19: 0xFFFF8F00, 20: 0xFF1976D2,
  21: 0xFF1E88E5, 22: 0xFFFDD835, 23: 0xFF1565C0, 24: 0xFF1976D2,
  25: 0xFF1565C0, 26: 0xFF424242, 27: 0xFF455A64, 28: 0xFFFFCA28,
  29: 0xFFE65100, 30: 0xFF1565C0, 31: 0xFF424242, 32: 0xFFBF360C,
  33: 0xFF455A64, 34: 0xFF2E7D32,
};

// Which templates have a body diamond pattern
const _bodyDiamonds = {3};
// Which templates use dark pill total box
const _darkPillTotal = {30, 31};
// Which templates use no colour header block
const _headerless = {4, 22, 27, 28};
// Which templates use boldBadge layout
const _boldBadge = {29};
// Which templates use circle badge
const _circleBadge = {20};
// Which templates use sidebar layout
const _sidebarLayout = {33};
// Which templates use chevron header
const _chevron = {17, 19};

class ClassicPdfTemplates {
  static pw.Widget build(
    PdfTemplate template,
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor brandColor,
    Uint8List? logoBytes,
  ) {
    final idx = int.tryParse(template.name.replaceAll('classic', '')) ?? 1;
    final color = PdfColor.fromInt(_colors[idx] ?? 0xFF1565C0);
    const isDark = false;
    final darkPill = _darkPillTotal.contains(idx);
    final bodyDiamonds = _bodyDiamonds.contains(idx);

    if (_sidebarLayout.contains(idx)) {
      return _buildSidebarLayout(invoice, biz, font, bold, color, logoBytes);
    }

    if (_headerless.contains(idx)) {
      return _buildHeaderlessLayout(invoice, biz, font, bold, color, logoBytes,
          darkPill: darkPill);
    }

    return _buildStandardLayout(
      invoice, biz, font, bold, color, logoBytes,
      isDark: isDark,
      darkPill: darkPill,
      bodyDiamonds: bodyDiamonds,
      boldBadge: _boldBadge.contains(idx),
      circleBadge: _circleBadge.contains(idx),
      chevron: _chevron.contains(idx),
    );
  }

  // ── Standard layout ─────────────────────────────────────────────────
  static pw.Widget _buildStandardLayout(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    Uint8List? logoBytes, {
    bool isDark = false,
    bool darkPill = false,
    bool bodyDiamonds = false,
    bool boldBadge = false,
    bool circleBadge = false,
    bool chevron = false,
  }) {
    final bgColor = isDark ? PdfColor.fromHex('#212121') : PdfColors.white;
    final textColor = isDark ? PdfColors.white : PdfColors.black;

    return pw.Container(
      color: bgColor,
      child: pw.Column(
        children: [
          // Header
          _buildPdfHeader(invoice, biz, font, bold, color, logoBytes,
              boldBadge: boldBadge,
              circleBadge: circleBadge,
              chevron: chevron),
          // Body
          pw.Padding(
            padding: const pw.EdgeInsets.all(28),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoSection(invoice, biz, font, bold, color, textColor),
                pw.SizedBox(height: 24),
                PdfWidgets.itemsTable(invoice, font, bold, color),
                pw.SizedBox(height: 24),
                _totalsSection(invoice, biz, font, bold, color, textColor,
                    darkPill: darkPill),
                pw.SizedBox(height: 24),
                _signatureBlock(biz, font, bold, textColor),
              ],
            ),
          ),
          _termsFooter(invoice, font, color, isDark),
        ],
      ),
    );
  }

  // ── Headerless layout ───────────────────────────────────────────────
  static pw.Widget _buildHeaderlessLayout(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    Uint8List? logoBytes, {
    bool darkPill = false,
  }) {
    return pw.Container(
      color: PdfColors.white,
      child: pw.Column(
        children: [
          // Accent bar instead of full header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: pw.BoxDecoration(
              border: pw.Border(left: pw.BorderSide(color: color, width: 5)),
              color: PdfColor(color.red, color.green, color.blue, 0.06),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logoBytes != null)
                      pw.Image(pw.MemoryImage(logoBytes), height: 36),
                    pw.Text(biz.name.toUpperCase(),
                        style: pw.TextStyle(
                            font: bold, fontSize: 14, color: color)),
                    pw.Text(biz.businessEmail ?? '',
                        style: pw.TextStyle(
                            font: font, fontSize: 9, color: PdfColors.grey600)),
                  ],
                ),
                pw.Text('INVOICE',
                    style: pw.TextStyle(
                        font: bold, fontSize: 26, color: color, letterSpacing: 2)),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(28),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoSection(invoice, biz, font, bold, color, PdfColors.black),
                pw.SizedBox(height: 24),
                PdfWidgets.itemsTable(invoice, font, bold, color),
                pw.SizedBox(height: 24),
                _totalsSection(invoice, biz, font, bold, color, PdfColors.black,
                    darkPill: darkPill),
                pw.SizedBox(height: 24),
                _signatureBlock(biz, font, bold, PdfColors.black),
              ],
            ),
          ),
          _termsFooter(invoice, font, color, false),
        ],
      ),
    );
  }

  // ── Sidebar layout ──────────────────────────────────────────────────
  static pw.Widget _buildSidebarLayout(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    Uint8List? logoBytes,
  ) {
    return pw.Container(
      color: PdfColors.white,
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            color: PdfColor(color.red, color.green, color.blue, 0.08),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(biz.name.toUpperCase(),
                      style: pw.TextStyle(font: bold, fontSize: 14, color: color)),
                  pw.Text(biz.businessEmail ?? '',
                      style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                ]),
                pw.Text('INVOICE',
                    style: pw.TextStyle(font: bold, fontSize: 22, color: color)),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(28),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _infoSection(invoice, biz, font, bold, color, PdfColors.black),
                pw.SizedBox(height: 24),
                PdfWidgets.itemsTable(invoice, font, bold, color),
                pw.SizedBox(height: 24),
                _totalsSection(invoice, biz, font, bold, color, PdfColors.black),
                pw.SizedBox(height: 24),
                _signatureBlock(biz, font, bold, PdfColors.black),
              ],
            ),
          ),
          _termsFooter(invoice, font, color, false),
        ],
      ),
    );
  }

  // ── PDF header ──────────────────────────────────────────────────────
  static pw.Widget _buildPdfHeader(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    Uint8List? logoBytes, {
    bool boldBadge = false,
    bool circleBadge = false,
    bool chevron = false,
  }) {
    if (boldBadge) {
      return pw.Container(
        height: 140,
        width: double.infinity,
        color: color,
        child: pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(28, 32, 28, 0),
          child: pw.Row(
            children: [
              pw.Container(
                width: 52, height: 52,
                decoration: const pw.BoxDecoration(
                    color: PdfColors.white, shape: pw.BoxShape.circle),
                child: logoBytes != null
                    ? pw.ClipOval(child: pw.Image(pw.MemoryImage(logoBytes)))
                    : pw.Center(child: pw.Text('B',
                        style: pw.TextStyle(font: bold, color: color, fontSize: 24))),
              ),
              pw.SizedBox(width: 16),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('INVOICE',
                      style: pw.TextStyle(
                          font: bold, fontSize: 34, color: PdfColors.white,
                          letterSpacing: 2)),
                  pw.Text('#${invoice.id}',
                      style: pw.TextStyle(
                          font: font, fontSize: 11, color: PdfColor(1, 1, 1, 0.7))),
                ],
              ),
              pw.Spacer(),
              pw.Text(biz.name.toUpperCase(),
                  style: pw.TextStyle(
                      font: bold, fontSize: 12, color: PdfColors.white)),
            ],
          ),
        ),
      );
    }

    if (circleBadge) {
      return pw.Container(
        height: 140,
        width: double.infinity,
        color: color,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Container(
              width: 58, height: 58,
              decoration: const pw.BoxDecoration(
                  color: PdfColors.white, shape: pw.BoxShape.circle),
              child: logoBytes != null
                  ? pw.ClipOval(child: pw.Image(pw.MemoryImage(logoBytes)))
                  : pw.Center(child: pw.Text(biz.name.isNotEmpty ? biz.name[0] : 'B',
                      style: pw.TextStyle(font: bold, color: color, fontSize: 26))),
            ),
            pw.SizedBox(height: 8),
            pw.Text(biz.name.toUpperCase(),
                style: pw.TextStyle(font: bold, fontSize: 13, color: PdfColors.white)),
            pw.Text('INVOICE',
                style: pw.TextStyle(
                    font: font, fontSize: 10, color: PdfColor(1, 1, 1, 0.7),
                    letterSpacing: 3)),
          ],
        ),
      );
    }

    // Default header
    return pw.Container(
      height: 130,
      width: double.infinity,
      color: color,
      child: pw.Padding(
        padding: const pw.EdgeInsets.fromLTRB(28, 32, 28, 0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                if (logoBytes != null)
                  pw.Container(
                    width: 44, height: 44,
                    padding: const pw.EdgeInsets.all(3),
                    decoration: const pw.BoxDecoration(
                        color: PdfColors.white, shape: pw.BoxShape.circle),
                    child: pw.Image(pw.MemoryImage(logoBytes),
                        fit: pw.BoxFit.contain),
                  ),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(biz.name.toUpperCase(),
                        style: pw.TextStyle(
                            font: bold, fontSize: 14, color: PdfColors.white)),
                    pw.Text(biz.businessEmail ?? '',
                        style: pw.TextStyle(
                            font: font, fontSize: 9, color: PdfColor(1, 1, 1, 0.7))),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('INVOICE',
                    style: pw.TextStyle(
                        font: bold, fontSize: 28, color: PdfColors.white,
                        letterSpacing: 2)),
                pw.Text('#${invoice.id}',
                    style: pw.TextStyle(
                        font: font, fontSize: 10, color: PdfColor(1, 1, 1, 0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Info section (Bill To / From / Dates) ───────────────────────────
  static pw.Widget _infoSection(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    PdfColor textColor,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('INVOICE TO:',
              style: pw.TextStyle(font: bold, fontSize: 9, color: color)),
          pw.SizedBox(height: 4),
          pw.Text(invoice.client.name.toUpperCase(),
              style: pw.TextStyle(font: bold, fontSize: 13, color: textColor)),
          pw.Text(invoice.client.email,
              style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
          if (invoice.client.address != null)
            pw.Text(invoice.client.address!,
                style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('FROM:',
              style: pw.TextStyle(font: bold, fontSize: 9, color: color)),
          pw.SizedBox(height: 4),
          pw.Text(biz.name.toUpperCase(),
              style: pw.TextStyle(font: bold, fontSize: 11, color: textColor)),
          pw.Text(biz.businessEmail ?? '',
              style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
          pw.SizedBox(height: 8),
          pw.Text('DATE: ${_fmt(invoice.issueDate)}',
              style: pw.TextStyle(font: font, fontSize: 9, color: textColor)),
          pw.Text('DUE: ${_fmt(invoice.dueDate)}',
              style: pw.TextStyle(font: font, fontSize: 9, color: textColor)),
        ]),
      ],
    );
  }

  // ── Totals section ──────────────────────────────────────────────────
  static pw.Widget _totalsSection(
    Invoice invoice,
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor color,
    PdfColor textColor, {
    bool darkPill = false,
  }) {
    final totalBg = darkPill
        ? PdfColor.fromHex('#212121')
        : PdfColor(color.red, color.green, color.blue, 0.1);
    final totalFg = darkPill ? PdfColors.white : color;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Payment details
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('PAYMENT DETAILS:',
              style: pw.TextStyle(font: bold, fontSize: 9, color: color)),
          pw.SizedBox(height: 4),
          pw.Text(biz.bankName ?? 'Bank Name',
              style: pw.TextStyle(font: font, fontSize: 9, color: textColor)),
          pw.Text(biz.accountNumber ?? 'Account No.',
              style: pw.TextStyle(font: bold, fontSize: 9, color: textColor)),
          pw.Text(biz.accountName ?? 'Account Name',
              style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey600)),
        ]),
        // Totals
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          _pdfRow('SUBTOTAL', invoice.subtotal, font, bold, textColor),
          if (invoice.taxRate > 0)
            _pdfRow('TAX (${invoice.taxRate}%)', invoice.taxAmount, font, bold,
                textColor),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: pw.BoxDecoration(
              color: totalBg,
              borderRadius: pw.BorderRadius.circular(darkPill ? 20 : 6),
            ),
            child: _pdfRow(
                'TOTAL DUE', invoice.totalAmount, font, bold, totalFg,
                isBold: true, fontSize: 12),
          ),
        ]),
      ],
    );
  }

  static pw.Widget _pdfRow(
    String label,
    double amount,
    pw.Font font,
    pw.Font bold,
    PdfColor color, {
    bool isBold = false,
    double fontSize = 10,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
        pw.Text(label,
            style: pw.TextStyle(
                font: isBold ? bold : font, fontSize: fontSize, color: color)),
        pw.SizedBox(width: 24),
        pw.Text(amount.toStringAsFixed(2),
            style: pw.TextStyle(
                font: isBold ? bold : font, fontSize: fontSize, color: color)),
      ]),
    );
  }

  // ── Signature block — ALWAYS RENDERED ──────────────────────────────
  static pw.Widget _signatureBlock(
    BusinessInfo biz,
    pw.Font font,
    pw.Font bold,
    PdfColor textColor,
  ) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Placeholder space for signature (48pt tall)
          pw.SizedBox(height: 48, width: 140),
          pw.Container(width: 140, height: 0.8, color: PdfColors.grey400),
          pw.SizedBox(height: 4),
          pw.Text('AUTHORIZED SIGNATURE',
              style: pw.TextStyle(
                  font: bold, fontSize: 7, color: PdfColors.grey600,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ── Terms & Notes footer band ───────────────────────────────────────
  static pw.Widget _termsFooter(
    Invoice invoice,
    pw.Font font,
    PdfColor color,
    bool isDark,
  ) {
    final bgColor = isDark
        ? PdfColor.fromHex('#2C2C2C')
        : PdfColor(color.red, color.green, color.blue, 0.06);
    final labelColor = isDark ? PdfColor(1, 1, 1, 0.7) : color;
    final textColor = isDark ? PdfColor(1, 1, 1, 0.54) : PdfColors.grey600;
    final termsText =
        (invoice.notes != null && invoice.notes!.isNotEmpty)
            ? invoice.notes!
            : 'Thank you for your business. Please make payment within 15 days. '
                'Late payments may be subject to additional fees.';

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      color: bgColor,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Terms & Notes',
              style: pw.TextStyle(
                  font: pw.Font.helveticaBold(),
                  fontSize: 9,
                  color: labelColor)),
          pw.SizedBox(height: 4),
          pw.Text(termsText,
              style: pw.TextStyle(
                  font: font, fontSize: 8, color: textColor,
                  lineSpacing: 3)),
        ],
      ),
    );
  }

  static String _fmt(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}
