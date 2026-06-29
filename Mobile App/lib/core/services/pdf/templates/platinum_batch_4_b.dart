// lib/core/services/pdf/templates/platinum_batch_4_b.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch4B {
  static pw.Widget platinumFaugetSteakTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkBrown = PdfColor.fromHex('#2F1B12');

    return pw.Container(
      color: darkBrown,
      padding: const pw.EdgeInsets.all(32),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 24, color: brandColor, letterSpacing: 4)),
              pw.Container(height: 1, width: 200, color: brandColor, margin: const pw.EdgeInsets.symmetric(vertical: 4)),
              pw.Text(biz.industry?.toUpperCase() ?? 'PREMIUM BUSINESS EXPERIENCE', style: pw.TextStyle(font: font, fontSize: 8, color: brandColor, letterSpacing: 2)),
           ]),
           if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 60),
        ]),
        pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 10)),
              pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: const pw.TextStyle(color: PdfColors.grey400, fontSize: 9)),
           ]),
        ]),
        pw.SizedBox(height: 30),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 48),
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
    );
  }

  static pw.Widget platinumShodweGreenTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkAccent = PdfColor(brandColor.red * 0.6, brandColor.green * 0.6, brandColor.blue * 0.6);

    return pw.Container(
      color: brandColor,
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 40, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: 2)),
            pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, color: PdfWidgets.getContrastColor(brandColor), fontSize: 10)),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: PdfWidgets.getContrastColor(brandColor))),
          pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: PdfWidgets.getContrastColor(brandColor))),
        ]),
        pw.SizedBox(height: 60),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, PdfWidgets.getContrastColor(brandColor)),
        PdfWidgets.itemsTable(invoice, font, bold, PdfWidgets.getContrastColor(brandColor)),
        pw.SizedBox(height: 32),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, darkAccent)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, darkAccent),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
        pw.SizedBox(height: 20),
        PdfWidgets.buildFooter(invoice, biz, font, bold),
      ]),
    );
  }

  static pw.Widget platinumLiceriaBlueTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(children: [
      pw.Container(
        color: brandColor,
        height: 150,
        padding: const pw.EdgeInsets.all(50),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 48, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: 2)),
            pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, color: PdfWidgets.getContrastColor(brandColor), fontSize: 10)),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 48),
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

  static pw.Widget platinumBorcelleCircleTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Container(width: 40, height: 40, decoration: pw.BoxDecoration(color: brandColor, shape: pw.BoxShape.circle)),
             pw.SizedBox(height: 12),
             pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 18)),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
             pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 40, color: brandColor, letterSpacing: 2)),
             pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
             pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: const pw.TextStyle(fontSize: 9)),
          ]),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 40),
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
    );
  }
}
