// lib/core/services/pdf/templates/base_templates.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:noble_invoice/core/services/pdf/utils/logo_contrast_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/core/services/invoice_qr_service.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class BaseTemplates {
  static pw.Widget modernTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, Uint8List? qrBytes, Uint8List? logoBytes, PdfColor accent) {
    final label     = PdfWidgets.typeLabel(invoice.invoiceType);
    final textStyle = pw.TextStyle(font: font, fontSize: 10);
    final boldStyle = pw.TextStyle(font: bold, fontSize: 10);

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Container(height: 6, color: accent),
      pw.SizedBox(height: 24),

      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          if (logoBytes != null) ...[
            LogoContrastUtil.adaptiveLogo(logoBytes: logoBytes, isDarkTemplate: false, width: 50, height: 50),
            pw.SizedBox(width: 12),
          ],
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(biz.name, style: pw.TextStyle(font: bold, fontSize: 18)),
            if (biz.businessAddress != null) pw.Text(biz.businessAddress!, style: textStyle.copyWith(color: PdfColors.grey600)),
            if (biz.businessEmail != null)   pw.Text(biz.businessEmail!,   style: textStyle.copyWith(color: PdfColors.grey600)),
            if (biz.businessPhone != null)   pw.Text(biz.businessPhone!,   style: textStyle.copyWith(color: PdfColors.grey600)),
          ]),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 20, color: accent)),
          pw.SizedBox(height: 8),
          pw.Text('No. ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 12)),
          pw.Text('Issued: ${PdfWidgets.fmt(invoice.issueDate)}', style: textStyle),
          pw.Text('Due:    ${PdfWidgets.fmt(invoice.dueDate)}',   style: textStyle.copyWith(color: PdfColors.red700)),
        ]),
      ]),

      if (PdfWidgets.needsWatermark(invoice.invoiceType)) PdfWidgets.watermark(invoice.invoiceType, accent),

      pw.SizedBox(height: 24),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 16),

      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('BILL TO', style: pw.TextStyle(font: bold, fontSize: 8, color: accent)),
          pw.SizedBox(height: 4),
          pw.Text(invoice.client.name, style: pw.TextStyle(font: bold, fontSize: 13)),
          pw.Text(invoice.client.email, style: textStyle.copyWith(color: PdfColors.grey600)),
          if (invoice.client.address != null) pw.Text(invoice.client.address!, style: textStyle.copyWith(color: PdfColors.grey600)),
        ]),
        if (biz.taxNumber != null) pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('TAX / VAT NUMBER', style: pw.TextStyle(font: bold, fontSize: 8, color: PdfColors.grey500)),
          pw.Text(biz.taxNumber!, style: boldStyle),
        ]),
      ]),

      pw.SizedBox(height: 28),
      PdfWidgets.buildTypeMetadataSection(invoice, font, bold, accent),
      PdfWidgets.itemsTable(invoice, font, bold, accent),
      pw.SizedBox(height: 24),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, accent)),
      pw.SizedBox(height: 32),

      if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
        pw.Text('NOTES & PAYMENT TERMS', style: pw.TextStyle(font: bold, fontSize: 8, color: PdfColors.grey500)),
        pw.SizedBox(height: 4),
        pw.Text(invoice.notes!, style: textStyle.copyWith(color: PdfColors.grey700)),
        pw.SizedBox(height: 16),
      ],
      PdfWidgets.paymentButton(invoice, PdfColor.fromHex("#1E293B")),
      PdfWidgets.signatureBlock(invoice, font, bold),

      if (qrBytes != null) ...[
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Image(pw.MemoryImage(qrBytes), width: 80, height: 80),
          pw.SizedBox(width: 12),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('SCAN TO PAY', style: pw.TextStyle(font: bold, fontSize: 9, color: accent)),
            pw.SizedBox(height: 4),
            pw.Text('Scan this QR code to view and pay this invoice online.',
              style: textStyle.copyWith(color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(InvoiceQrService.paymentUrl(invoice.id),
              style: textStyle.copyWith(color: PdfColors.blue700, fontSize: 8)),
          ])),
        ]),
        pw.SizedBox(height: 16),
      ],

      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 8),
      pw.Center(child: pw.Text(
        biz.footerText ?? 'Thank you for your business.',
        style: textStyle.copyWith(color: PdfColors.grey600, fontStyle: pw.FontStyle.italic),
      )),
      pw.SizedBox(height: 16),
      PdfWidgets.buildPaymentDetails(biz, font, bold),
    ]);
  }

  static pw.Widget minimalTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor accent) {
    final textStyle = pw.TextStyle(font: font, fontSize: 10);
    final boldStyle = pw.TextStyle(font: bold, fontSize: 10);
    final label     = PdfWidgets.typeLabel(invoice.invoiceType);

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(biz.name, style: pw.TextStyle(font: bold, fontSize: 18, color: PdfColors.black)),
        pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 18, color: PdfColors.grey700)),
      ]),
      pw.SizedBox(height: 8),
      pw.Divider(color: PdfColors.black, thickness: 2),
      pw.SizedBox(height: 12),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('To:', style: boldStyle),
          pw.Text(invoice.client.name, style: boldStyle),
          pw.Text(invoice.client.email, style: textStyle.copyWith(color: PdfColors.grey600)),
        ]),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('Invoice #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 12)),
          pw.Text(PdfWidgets.fmt(invoice.issueDate), style: textStyle),
          pw.Text('Due: ${PdfWidgets.fmt(invoice.dueDate)}', style: textStyle.copyWith(color: PdfColors.red700)),
        ]),
      ]),
      pw.SizedBox(height: 28),
      PdfWidgets.itemsTable(invoice, font, bold, PdfColors.black),
      pw.SizedBox(height: 20),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, PdfColors.black)),
      
      // FIX-06: Replaced pw.Spacer with SizedBox to prevent MultiPage layout errors
      pw.SizedBox(height: 48), 
      
      if (invoice.notes != null && invoice.notes!.isNotEmpty)
        pw.Text(invoice.notes!, style: textStyle.copyWith(color: PdfColors.grey600)),
      pw.SizedBox(height: 8),
      pw.Divider(thickness: 2, color: PdfColors.black),
      pw.Center(child: pw.Text(biz.footerText ?? 'Thank you.', style: textStyle.copyWith(color: PdfColors.grey700))),
      pw.SizedBox(height: 16),
      PdfWidgets.buildPaymentDetails(biz, font, bold),
    ]);
  }

  static pw.Widget boldTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, Uint8List? qrBytes, Uint8List? logoBytes, PdfColor accent) {
    final textStyle = pw.TextStyle(font: font, fontSize: 10, color: PdfColors.white);
    final label     = PdfWidgets.typeLabel(invoice.invoiceType);

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Container(
        color: accent,
        padding: const pw.EdgeInsets.all(24),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Row(children: [
            if (logoBytes != null) ...[
              pw.Container(
                width: 50, height: 50,
                decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(8)),
                padding: const pw.EdgeInsets.all(6),
                child: LogoContrastUtil.adaptiveLogo(logoBytes: logoBytes, isDarkTemplate: false),
              ),
              pw.SizedBox(width: 14),
            ],
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 26, color: PdfColors.white)),
              pw.SizedBox(height: 4),
              pw.Text(biz.name, style: pw.TextStyle(font: font, fontSize: 12, color: const PdfColor(1, 1, 1, 0.7))),
            ]),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('No. ${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 14, color: PdfColors.white)),
            pw.Text('Issued: ${PdfWidgets.fmt(invoice.issueDate)}', style: textStyle),
            pw.Text('Due: ${PdfWidgets.fmt(invoice.dueDate)}', style: textStyle.copyWith(color: const PdfColor(1, 0.6, 0.6))),
          ]),
        ]),
      ),
      pw.SizedBox(height: 24),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('BILLED TO', style: pw.TextStyle(font: bold, fontSize: 8, color: accent)),
          pw.SizedBox(height: 4),
          pw.Text(invoice.client.name, style: pw.TextStyle(font: bold, fontSize: 13)),
          pw.Text(invoice.client.email, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600)),
        ]),
        if (biz.businessAddress != null) pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Text('FROM', style: pw.TextStyle(font: bold, fontSize: 8, color: PdfColors.grey500)),
          pw.Text(biz.businessAddress!, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
        ]),
      ]),
      pw.SizedBox(height: 28),
      PdfWidgets.itemsTable(invoice, font, bold, accent),
      pw.SizedBox(height: 20),
      pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, accent)),
      
      pw.SizedBox(height: 40),

      if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
        pw.Text(invoice.notes!, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 8),
      ],
      PdfWidgets.paymentButton(invoice, PdfColor.fromHex("#1E293B")),
      PdfWidgets.signatureBlock(invoice, font, bold),
      if (qrBytes != null) ...[
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Image(pw.MemoryImage(qrBytes), width: 72, height: 72),
          pw.SizedBox(width: 12),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('SCAN TO PAY', style: pw.TextStyle(font: bold, fontSize: 9, color: accent)),
            pw.SizedBox(height: 3),
            pw.Text('Scan to view invoice and pay online.',
              style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
            pw.Text(InvoiceQrService.paymentUrl(invoice.id),
              style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.blue700)),
          ])),
        ]),
        pw.SizedBox(height: 12),
      ],
      pw.Container(
        color: accent,
        padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: pw.Center(child: pw.Text(
          biz.footerText ?? 'Thank you for your business.',
          style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.white),
        )),
      ),
      pw.SizedBox(height: 16),
      PdfWidgets.buildPaymentDetails(biz, font, bold),
    ]);
  }
}
