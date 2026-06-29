// lib/core/services/pdf/templates/foundation_batch_2.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class FoundationBatch2 {
  static pw.Widget boldTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Container(
        color: brandColor,
        padding: const pw.EdgeInsets.all(24),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 26, color: PdfWidgets.getContrastColor(brandColor))),
            pw.Text(biz.name, style: pw.TextStyle(font: font, fontSize: 12, color: PdfWidgets.applyOpacity(PdfWidgets.getContrastColor(brandColor), 0.7))),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('No. ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 14, color: PdfWidgets.getContrastColor(brandColor))),
            pw.Text(PdfWidgets.fmt(invoice.issueDate), style: pw.TextStyle(color: PdfWidgets.getContrastColor(brandColor))),
          ]),
        ]),
      ),
      pw.SizedBox(height: 24),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, brandColor),
      pw.SizedBox(height: 20),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }

  static pw.Widget minimalistAlphaTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(biz.name, style: pw.TextStyle(font: bold, fontSize: 24, color: brandColor)),
        pw.Text('No. ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 12)),
      ]),
      pw.SizedBox(height: 60),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
      pw.SizedBox(height: 40),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }

  static pw.Widget enterpriseStandardTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkAccent = PdfColor(brandColor.red * 0.4, brandColor.green * 0.4, brandColor.blue * 0.4);
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Container(color: darkAccent, padding: const pw.EdgeInsets.all(16), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, color: PdfWidgets.getContrastColor(darkAccent))),
        pw.Text('INVOICE NO. ${invoice.id}', style: pw.TextStyle(color: PdfWidgets.getContrastColor(darkAccent))),
      ])),
      pw.SizedBox(height: 24),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, brandColor),
      pw.SizedBox(height: 24),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, darkAccent)),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }

  static pw.Widget geometricBlueTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('Invoice', style: pw.TextStyle(font: bold, fontSize: 60, color: brandColor))),
      pw.SizedBox(height: 40),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, brandColor),
      pw.SizedBox(height: 40),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }

  static pw.Widget boldClassicTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Container(width: 40, height: 40, decoration: pw.BoxDecoration(color: brandColor, shape: pw.BoxShape.circle)),
        pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, color: brandColor)),
      ]),
      pw.SizedBox(height: 24),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, brandColor),
      pw.SizedBox(height: 24),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }
}
