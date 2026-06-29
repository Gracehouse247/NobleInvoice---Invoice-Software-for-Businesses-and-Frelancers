import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PremiumSimpleBatch {
  static pw.Widget build(PdfTemplate template, Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    switch (template) {
      case PdfTemplate.simpleDiamond:
        return _simpleDiamond(invoice, biz, font, bold, const PdfColor.fromInt(0xFF59C2BC), logoBytes);
      case PdfTemplate.simpleBlobs:
        return _simpleBlobs(invoice, biz, font, bold, const PdfColor.fromInt(0xFF7C4DFF), logoBytes);
      case PdfTemplate.simpleMetallic:
        return _simpleMetallic(invoice, biz, font, bold, const PdfColor.fromInt(0xFF1A237E), logoBytes);
      case PdfTemplate.simpleGeometric:
        return _simpleGeometric(invoice, biz, font, bold, const PdfColor.fromInt(0xFFFFD600), logoBytes);
      case PdfTemplate.simpleAngled:
        return _simpleAngled(invoice, biz, font, bold, const PdfColor.fromInt(0xFF00C853), logoBytes);
      case PdfTemplate.simpleWave:
        return _simpleWave(invoice, biz, font, bold, const PdfColor.fromInt(0xFFFF6D00), logoBytes);
      case PdfTemplate.simpleModern:
        return _simpleModern(invoice, biz, font, bold, const PdfColor.fromInt(0xFF2962FF), logoBytes);
      case PdfTemplate.simpleImmersive:
        return _simpleImmersive(invoice, biz, font, bold, const PdfColor.fromInt(0xFFD500F9), logoBytes);
      case PdfTemplate.simplePillTotal:
        return _simplePillTotal(invoice, biz, font, bold, const PdfColor.fromInt(0xFFFFAB00), logoBytes);
      case PdfTemplate.simpleArrowLabel:
        return _simpleArrowLabel(invoice, biz, font, bold, const PdfColor.fromInt(0xFF00B8D4), logoBytes);
      case PdfTemplate.simpleCleanGrid:
        return _simpleCleanGrid(invoice, biz, font, bold, const PdfColor.fromInt(0xFF6200EA), logoBytes);
      case PdfTemplate.simpleMinimalist:
        return _simpleMinimalist(invoice, biz, font, bold, const PdfColor.fromInt(0xFF37474F), logoBytes);
      default:
        return _simpleDiamond(invoice, biz, font, bold, brandColor, logoBytes);
    }
  }

  static pw.Widget _simpleDiamond(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          height: 120,
          decoration: pw.BoxDecoration(color: themeColor),
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoBytes != null)
                  pw.Image(pw.MemoryImage(logoBytes), width: 60)
                else
                  pw.Text(biz.name, style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 24)),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('INVOICE', style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 32)),
                    pw.Text('#${invoice.id}', style: pw.TextStyle(font: font, color: PdfColors.white, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('BILL TO:', style: pw.TextStyle(font: bold, fontSize: 10, color: PdfColors.grey700)),
                  pw.Text(invoice.client.name, style: pw.TextStyle(font: bold, fontSize: 14)),
                  pw.Text(invoice.client.address ?? '', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('DATE: ${invoice.issueDate.toString().split(' ')[0]}', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text('DUE DATE: ${invoice.dueDate.toString().split(' ')[0]}', style: pw.TextStyle(font: font, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 32),
          child: PdfWidgets.itemsTable(invoice, font, bold, themeColor),
        ),

        pw.Spacer(),
        pw.Container(
          height: 40,
          color: PdfColors.grey200,
          child: pw.Center(
            child: pw.Text('Thank you for your business!', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
          ),
        ),
      ],
    );
  }

  static pw.Widget _simpleBlobs(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return pw.Column(
      children: [
        pw.Container(
          height: 150,
          padding: const pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            color: themeColor,
            borderRadius: const pw.BorderRadius.only(bottomLeft: pw.Radius.circular(60)),
          ),
          child: pw.Row(
            children: [
              if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
              pw.SizedBox(width: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(biz.name, style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 20)),
                  pw.Text(biz.businessEmail ?? '', style: pw.TextStyle(font: font, color: PdfColors.white, fontSize: 10)),
                ],
              ),
              pw.Spacer(),
              pw.Text('INVOICE', style: pw.TextStyle(font: bold, color: PdfColor(1, 1, 1, 0.2), fontSize: 40)),
            ],
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('INVOICE TO', style: pw.TextStyle(font: bold, fontSize: 12, color: themeColor)),
              pw.Text(invoice.client.name, style: pw.TextStyle(font: bold, fontSize: 18)),
              pw.SizedBox(height: 20),
              PdfWidgets.itemsTable(invoice, font, bold, themeColor),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('TOTAL', style: pw.TextStyle(font: bold, fontSize: 14, color: themeColor)),
                      pw.Text('${invoice.currencyCode} ${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(font: bold, fontSize: 24)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _simpleMetallic(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return pw.Stack(
      children: [
        pw.Column(
          children: [
             pw.Container(
              height: 200,
              decoration: pw.BoxDecoration(color: themeColor),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                         pw.Text('INVOICE', style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 40)),
                         pw.Text('#${invoice.id}', style: pw.TextStyle(font: font, color: PdfColors.white, fontSize: 16)),
                      ],
                    ),
                    if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 100),
                  ],
                ),
              ),
            ),
            pw.Expanded(child: pw.Container(color: PdfColors.white)),
          ],
        ),
        pw.Positioned(
          top: 150,
          left: 40,
          right: 40,
          bottom: 40,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(30),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('SENDER', style: pw.TextStyle(font: bold, fontSize: 10, color: PdfColors.grey)),
                        pw.Text(biz.name, style: pw.TextStyle(font: bold)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('RECEIVER', style: pw.TextStyle(font: bold, fontSize: 10, color: PdfColors.grey)),
                        pw.Text(invoice.client.name, style: pw.TextStyle(font: bold)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                PdfWidgets.itemsTable(invoice, font, bold, themeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _simpleGeometric(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Container(
              width: 100,
              height: 100,
              color: themeColor,
              child: pw.Center(child: pw.Text('G', style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 50))),
            ),
            pw.Expanded(
              child: pw.Container(
                height: 100,
                color: PdfColors.grey800,
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(biz.name, style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 18)),
                    pw.Text('INVOICE', style: pw.TextStyle(font: bold, color: themeColor, fontSize: 24)),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('BILL TO', style: pw.TextStyle(font: bold, fontSize: 12)),
                      pw.Text(invoice.client.name),
                    ],
                  ),
                   pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('DATE: ${invoice.issueDate.toString().split(' ')[0]}'),
                      pw.Text('DUE: ${invoice.dueDate.toString().split(' ')[0]}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              PdfWidgets.itemsTable(invoice, font, bold, themeColor),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _simpleAngled(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleDiamond(invoice, biz, font, bold, themeColor, logoBytes); // Re-use Diamond layout with different color
  }

  static pw.Widget _simpleWave(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleBlobs(invoice, biz, font, bold, themeColor, logoBytes); // Re-use Blobs layout with different color
  }

  static pw.Widget _simpleModern(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleDiamond(invoice, biz, font, bold, themeColor, logoBytes);
  }

  static pw.Widget _simpleImmersive(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleMetallic(invoice, biz, font, bold, themeColor, logoBytes);
  }

  static pw.Widget _simplePillTotal(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleDiamond(invoice, biz, font, bold, themeColor, logoBytes);
  }

  static pw.Widget _simpleArrowLabel(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleGeometric(invoice, biz, font, bold, themeColor, logoBytes);
  }

  static pw.Widget _simpleCleanGrid(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleDiamond(invoice, biz, font, bold, themeColor, logoBytes);
  }

  static pw.Widget _simpleMinimalist(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor themeColor, Uint8List? logoBytes) {
    return _simpleDiamond(invoice, biz, font, bold, themeColor, logoBytes);
  }
}
