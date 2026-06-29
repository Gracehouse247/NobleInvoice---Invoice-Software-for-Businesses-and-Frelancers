// lib/core/services/pdf/templates/platinum_batch_5_a.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch5A {
  static pw.Widget platinumYellowLotusTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkText = PdfColor.fromHex('#1C1917');
    final accent = PdfColor(brandColor.red, (brandColor.green * 0.8).clamp(0, 1), (brandColor.blue * 0.8).clamp(0, 1));

    return pw.Stack(children: [
      pw.Positioned(top: -100, right: -100, child: pw.Container(width: 350, height: 350, decoration: pw.BoxDecoration(color: brandColor, shape: pw.BoxShape.circle))),
      pw.Padding(
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
               pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 64, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: -4)),
               pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 14, color: accent, letterSpacing: 4)),
               pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10, color: PdfWidgets.getContrastColor(brandColor))),
             ]),
             if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
          ]),
          pw.SizedBox(height: 60),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 60),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, brandColor),
          pw.SizedBox(height: 32),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
        ]),
      ),
    ]);
  }

  static pw.Widget platinumBlueSkylineTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(children: [
      pw.Container(
        height: 160, color: brandColor, width: double.infinity,
        padding: const pw.EdgeInsets.all(50),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 32, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: 6)),
            pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, color: PdfWidgets.getContrastColor(brandColor), fontSize: 12)),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
      ),
      pw.Expanded(child: pw.Padding(
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 48),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, brandColor),
          pw.SizedBox(height: 40),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
          pw.Container(height: 10, color: brandColor, width: double.infinity),
        ]),
      )),
    ]);
  }

  static pw.Widget platinumTealBlobsTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Stack(children: [
      pw.Positioned(top: -100, left: -100, child: pw.Container(width: 300, height: 300, decoration: pw.BoxDecoration(color: PdfWidgets.applyOpacity(brandColor, 0.1), shape: pw.BoxShape.circle))),
      pw.Padding(
        padding: const pw.EdgeInsets.all(60),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 44, color: brandColor, letterSpacing: -2)),
              pw.Text(biz.industry?.toUpperCase() ?? 'BUSINESS SOLUTIONS', style: pw.TextStyle(font: bold, fontSize: 10, color: brandColor, letterSpacing: 4)),
              pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
            ]),
            if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
          ]),
          pw.SizedBox(height: 60),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 60),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, brandColor),
          pw.SizedBox(height: 48),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
        ]),
      ),
    ]);
  }
}
