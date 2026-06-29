// lib/core/services/pdf/templates/platinum_batch_1.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch1 {
  static pw.Widget platinumSkyTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final lightColor = PdfColor(brandColor.red, brandColor.green, brandColor.blue, 0.2);
    return pw.Stack(children: [
      pw.Positioned(top: -10, left: 0, right: 0, child: pw.Container(height: 40, color: lightColor)),
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 50, color: brandColor, letterSpacing: 2)),
            if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
          ]),
          pw.SizedBox(height: 30),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
            pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 30),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, brandColor),
          pw.SizedBox(height: 24),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.SizedBox(height: 12),
          PdfWidgets.buildPaymentDetails(biz, font, bold, color: brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
        ]),
      ),
    ]);
  }

  static pw.Widget platinumRedTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 100),
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 40, color: brandColor)),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold)),
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold)),
        ]),
        pw.SizedBox(height: 40),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
        pw.SizedBox(height: 24),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, brandColor),
        pw.SizedBox(height: 12),
        PdfWidgets.buildPaymentDetails(biz, font, bold),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
        pw.SizedBox(height: 20),
        PdfWidgets.buildFooter(invoice, biz, font, bold),
      ]),
    );
  }

  static pw.Widget platinumBlueTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Invoice', style: pw.TextStyle(font: bold, fontSize: 40, color: brandColor)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 30),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 30),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, brandColor),
        pw.SizedBox(height: 30),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, brandColor),
        pw.SizedBox(height: 12),
        PdfWidgets.buildPaymentDetails(biz, font, bold, color: brandColor),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
        pw.SizedBox(height: 20),
        PdfWidgets.buildFooter(invoice, biz, font, bold),
      ]),
    );
  }

  static pw.Widget platinumPurpleTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 60, color: brandColor)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold)),
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold)),
        ]),
        pw.SizedBox(height: 40),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, brandColor),
        pw.SizedBox(height: 20),
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

  static pw.Widget platinumDarkTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final dark = PdfColor.fromHex('#111827');
    return pw.Container(
      color: dark,
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 80, color: brandColor)),
            if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
          ]),
          pw.SizedBox(height: 30),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: PdfColors.white)),
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: PdfColors.white)),
          ]),
          pw.SizedBox(height: 30),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, brandColor, isDark: true),
          pw.SizedBox(height: 20),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.SizedBox(height: 12),
          PdfWidgets.buildPaymentDetails(biz, font, bold, color: brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
        ]),
      ),
    );
  }

  static pw.Widget platinumNobleBlueTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 44, color: brandColor)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 50),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 50),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, brandColor),
        pw.SizedBox(height: 24),
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
