// lib/core/services/pdf/templates/platinum_batch_4_a.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch4A {
  static pw.Widget platinumFaugetDarkTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final dark = PdfColor.fromHex('#1A1A1A');
    final boxGrey = PdfColor.fromHex('#333333');
    final whiteText = pw.TextStyle(font: font, fontSize: 10, color: PdfColors.white);

    return pw.Container(
      color: dark,
      padding: const pw.EdgeInsets.all(32),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 52, color: brandColor)),
             pw.Text('REF: #${invoice.id}', style: whiteText.copyWith(font: bold)),
             pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: whiteText),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 48),
        pw.Row(children: [
          pw.Expanded(child: _faugetBox('BILL TO', invoice.client.name, invoice.client.address ?? 'N/A', brandColor, boxGrey, font, bold)),
          pw.SizedBox(width: 16),
          pw.Expanded(child: _faugetBox('FROM', biz.name, biz.businessAddress ?? 'N/A', brandColor, boxGrey, font, bold)),
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

  static pw.Widget platinumWarnerSpencerBeigeTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final beige = PdfColor.fromHex('#F5F5DC');
    final darkText = PdfColor(brandColor.red * 0.4, brandColor.green * 0.4, brandColor.blue * 0.4);

    return pw.Container(
      color: beige,
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
           pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 48, color: darkText, letterSpacing: 2)),
             pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10, color: darkText)),
           ]),
           if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 60),
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
    );
  }

  static pw.Widget platinumBorcelleGoldTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 50, color: brandColor, letterSpacing: 4)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 60),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
             pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 9)),
          ]),
        ]),
        pw.SizedBox(height: 30),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 48),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, PdfColors.black),
        PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
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

  static pw.Widget _faugetBox(String title, String name, String addr, PdfColor brandColor, PdfColor grey, pw.Font font, pw.Font bold) {
    return pw.Container(
      color: grey,
      padding: const pw.EdgeInsets.all(24),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title, style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.white, letterSpacing: 1.2)),
        pw.SizedBox(height: 6),
        pw.Text(name, style: pw.TextStyle(font: bold, fontSize: 18, color: brandColor)),
        pw.Text(addr, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.white)),
      ]),
    );
  }
}
