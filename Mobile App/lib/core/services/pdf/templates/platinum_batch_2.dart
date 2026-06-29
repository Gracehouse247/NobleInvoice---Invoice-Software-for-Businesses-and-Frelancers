// lib/core/services/pdf/templates/platinum_batch_2.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch2 {
  static pw.Widget platinumOrganicAmethystTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Invoice', style: pw.TextStyle(font: bold, fontSize: 48, color: brandColor)),
            pw.Text('REF: ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10, color: PdfColors.grey700)),
            pw.Text('Issued: ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
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

  static pw.Widget platinumSlateExecutiveTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkAccent = PdfColor(brandColor.red * 0.4, brandColor.green * 0.4, brandColor.blue * 0.4);
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, color: darkAccent, letterSpacing: 2)),
            pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 10, color: PdfColors.grey600)),
          ]),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 100),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: darkAccent)),
          pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: darkAccent)),
        ]),
        pw.SizedBox(height: 40),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, darkAccent),
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

  static pw.Widget platinumScarletSwooshTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkNavy = PdfColor(brandColor.red * 0.2, brandColor.green * 0.2, brandColor.blue * 0.3);
    return pw.Padding(
       padding: const pw.EdgeInsets.all(50),
       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 60),
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, color: darkNavy, letterSpacing: 1.5)),
          ]),
          pw.SizedBox(height: 40),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: darkNavy)),
            pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 40),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
          PdfWidgets.itemsTable(invoice, font, bold, darkNavy),
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

  static pw.Widget platinumGeometricAzureTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 18, color: brandColor)),
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, color: brandColor)),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
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

  static pw.Widget platinumPaucekTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 40, letterSpacing: 4, color: brandColor)),
          ]),
          pw.SizedBox(height: 40),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 40),
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
      ]),
    );
  }
}
