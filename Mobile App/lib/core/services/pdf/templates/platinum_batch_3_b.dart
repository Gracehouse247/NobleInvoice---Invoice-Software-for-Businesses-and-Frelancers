// lib/core/services/pdf/templates/platinum_batch_3_b.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch3B {
  static pw.Widget platinumAlvesTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkBar = PdfColor.fromHex('#1F2937');
    
    return pw.FullPage(ignoreMargins: true, child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
       pw.Container(
         width: 80, color: darkBar,
         child: pw.Column(children: [
            pw.Container(width: 80, height: 150, color: PdfColors.white, child: pw.Center(child: pw.Container(width: 4, height: 150, color: PdfColors.black))),
            pw.Spacer(),
            pw.Transform.rotate(angle: -1.5708, child: pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 64, color: PdfColors.white, letterSpacing: 10))),
            pw.Spacer(),
            pw.Container(width: 80, height: 300, color: brandColor),
         ]),
       ),
       pw.Expanded(child: pw.Padding(padding: const pw.EdgeInsets.all(60), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
             pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
                pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 9)),
             ]),
             if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 60),
          ]),
          pw.SizedBox(height: 40),
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 40),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, PdfColors.black),
          PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
          pw.SizedBox(height: 40),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
          pw.Spacer(),
          PdfWidgets.signatureBlock(invoice, font, bold),
          pw.SizedBox(height: 20),
          PdfWidgets.buildFooter(invoice, biz, font, bold),
       ]))),
    ]));
  }

  static pw.Widget platinumLaranaOrangeTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Stack(children: [
      pw.Positioned(top: -40, left: -40, child: pw.Container(width: 150, height: 100, decoration: pw.BoxDecoration(color: brandColor, borderRadius: const pw.BorderRadius.only(bottomRight: pw.Radius.circular(100))))),
      pw.Padding(
        padding: const pw.EdgeInsets.all(50),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.SizedBox(height: 40),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 56, color: brandColor, letterSpacing: 2)),
             if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
          ]),
          pw.SizedBox(height: 40),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
               pw.Text('REF NO. #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
               pw.Text('ISSUED ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 9)),
            ]),
          ]),
          pw.SizedBox(height: 30),
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
      ),
    ]);
  }

  static pw.Widget platinumBorcelleBlueTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(height: 20),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 60, color: PdfColors.black, letterSpacing: 2)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 40),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('REF# ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
            pw.Text('DATE ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 9)),
          ]),
        ]),
        pw.SizedBox(height: 30),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 44),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, PdfColors.black),
        PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
        pw.SizedBox(height: 40),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, brandColor),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
        pw.SizedBox(height: 20),
        PdfWidgets.buildFooter(invoice, biz, font, bold),
        pw.Container(height: 12, color: brandColor, width: double.infinity),
      ]),
    );
  }

  static pw.Widget platinumSalfordTealTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(50),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(height: 48),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 52, color: PdfColors.black, letterSpacing: 1.5)),
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
        ]),
        pw.SizedBox(height: 32),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
           pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
        ]),
        pw.SizedBox(height: 40),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, brandColor),
        pw.SizedBox(height: 32),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, PdfColors.black)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, brandColor),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
        pw.SizedBox(height: 20),
        PdfWidgets.buildFooter(invoice, biz, font, bold),
        pw.Container(height: 24, color: PdfColor.fromHex('#333'), width: double.infinity),
      ]),
    );
  }
}
