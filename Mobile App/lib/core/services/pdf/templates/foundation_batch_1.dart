// lib/core/services/pdf/templates/foundation_batch_1.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class FoundationBatch1 {
  static pw.Widget modernTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 24, color: brandColor)),
          pw.Text('#${invoice.id}', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),
        ]),
        if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 80),
      ]),
      pw.SizedBox(height: 40),
      pw.Row(children: [
        pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('FROM', style: pw.TextStyle(font: bold, fontSize: 10, color: brandColor)),
          pw.Text(biz.name, style: pw.TextStyle(font: bold, fontSize: 12)),
          pw.Text(biz.businessAddress ?? '', style: const pw.TextStyle(fontSize: 10)),
        ])),
        pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('BILL TO', style: pw.TextStyle(font: bold, fontSize: 10, color: brandColor)),
          pw.Text(invoice.client.name, style: pw.TextStyle(font: bold, fontSize: 12)),
          pw.Text(invoice.client.address ?? '', style: const pw.TextStyle(fontSize: 10)),
        ])),
      ]),
      pw.SizedBox(height: 40),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
      PdfWidgets.itemsTable(invoice, font, bold, brandColor),
      pw.SizedBox(height: 32),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
           PdfWidgets.buildPaymentDetails(biz, font, bold),
           pw.SizedBox(height: 12),
           PdfWidgets.paymentButton(invoice, brandColor),
        ]),
        PdfWidgets.totalsBlock(invoice, font, bold, brandColor),
      ]),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
      pw.Divider(color: PdfColors.grey300),
      pw.Text(biz.footerText ?? 'Thank you for your business!', style: pw.TextStyle(font: font, fontSize: 10, fontStyle: pw.FontStyle.italic)),
    ]);
  }

  static pw.Widget minimalTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 14, color: brandColor)),
        pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 14, letterSpacing: 2)),
      ]),
      pw.Divider(thickness: 2, color: brandColor),
      pw.SizedBox(height: 24),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Date: ${PdfWidgets.fmt(invoice.issueDate)}', style: const pw.TextStyle(fontSize: 10)),
          pw.Text('Invoice #: ${invoice.id}', style: const pw.TextStyle(fontSize: 10)),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('Bill To:', style: pw.TextStyle(font: bold, fontSize: 10, color: brandColor)),
          pw.Text(invoice.client.name, style: const pw.TextStyle(fontSize: 10)),
        ]),
      ]),
      pw.SizedBox(height: 48),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, PdfColors.black),
      PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
      pw.SizedBox(height: 32),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        PdfWidgets.buildPaymentDetails(biz, font, bold),
        PdfWidgets.totalsBlock(invoice, font, bold, brandColor),
      ]),
      pw.SizedBox(height: 24),
      PdfWidgets.paymentButton(invoice, brandColor),
      pw.Spacer(),
      PdfWidgets.signatureBlock(invoice, font, bold),
    ]);
  }

  static pw.Widget modernCurveTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Stack(children: [
      pw.Positioned(
        top: -40, right: -40,
        child: pw.CustomPaint(
          size: const PdfPoint(400, 300),
          painter: (PdfGraphics canvas, PdfPoint size) {
            canvas.moveTo(0, 0);
            canvas.curveTo(40, 200, 150, 280, 400, 280);
            canvas.lineTo(400, 0);
            canvas.setFillColor(brandColor);
            canvas.fillPath();
          },
        ),
      ),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(height: 20),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 100),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 36, color: PdfWidgets.getContrastColor(brandColor))),
            pw.Text('#${invoice.id}', style: pw.TextStyle(font: font, fontSize: 14, color: PdfWidgets.getContrastColor(brandColor))),
          ]),
        ]),
        pw.SizedBox(height: 60),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
        PdfWidgets.itemsTable(invoice, font, bold, brandColor),
        pw.SizedBox(height: 32),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          PdfWidgets.buildPaymentDetails(biz, font, bold),
          PdfWidgets.totalsBlock(invoice, font, bold, brandColor),
        ]),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, brandColor),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
      ]),
    ]);
  }

  static pw.Widget waveCorporateTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkAccent = PdfColor(brandColor.red * 0.4, brandColor.green * 0.4, brandColor.blue * 0.4);
    return pw.Stack(children: [
      pw.Positioned(
        top: -40, left: -40, right: -40,
        child: pw.CustomPaint(
          size: const PdfPoint(600, 180),
          painter: (PdfGraphics canvas, PdfPoint size) {
            canvas.moveTo(0, 0);
            canvas.lineTo(600, 0);
            canvas.lineTo(600, 100);
            canvas.curveTo(450, 180, 200, 80, 0, 180);
            canvas.setFillColor(darkAccent);
            canvas.fillPath();
          },
        ),
      ),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(height: 20),
        pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, color: PdfWidgets.getContrastColor(darkAccent))),
        pw.SizedBox(height: 100),
        PdfWidgets.buildTypeMetadataSection(invoice, font, bold, darkAccent),
        PdfWidgets.itemsTable(invoice, font, bold, darkAccent),
        pw.SizedBox(height: 24),
        pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, darkAccent)),
        pw.SizedBox(height: 24),
        PdfWidgets.paymentButton(invoice, darkAccent),
        pw.Spacer(),
        PdfWidgets.signatureBlock(invoice, font, bold),
      ]),
    ]);
  }
}
