// lib/core/services/pdf/templates/platinum_batch_3_a.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/core/services/pdf/pdf_widgets.dart';

class PlatinumBatch3A {
  static pw.Widget platinumTimmermanTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.Padding(padding: const pw.EdgeInsets.all(60), child: pw.Column(children: [
       pw.Center(child: pw.Column(children: [
          if (logoBytes != null) pw.Image(pw.MemoryImage(logoBytes), width: 60),
          pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 28, color: brandColor, letterSpacing: 2)),
          pw.Divider(color: brandColor, thickness: 1, indent: 40, endIndent: 40),
       ])),
       pw.SizedBox(height: 40),
       pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 32, letterSpacing: 3, color: brandColor)),
          pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 10)),
          pw.Text('ISSUED: ${PdfWidgets.fmt(invoice.issueDate).toUpperCase()}', style: pw.TextStyle(font: font, fontSize: 10)),
       ])),
       pw.SizedBox(height: 40),
       pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
          pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
       ]),
       pw.SizedBox(height: 40),
       PdfWidgets.buildTypeMetadataSection(invoice, font, bold, brandColor),
       PdfWidgets.itemsTable(invoice, font, bold, brandColor),
       pw.SizedBox(height: 20),
       pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
       pw.SizedBox(height: 24),
       PdfWidgets.paymentButton(invoice, brandColor),
       pw.Spacer(),
       pw.Container(
         width: double.infinity, padding: const pw.EdgeInsets.all(14),
         decoration: pw.BoxDecoration(color: brandColor, borderRadius: pw.BorderRadius.circular(15)),
         child: pw.Center(child: pw.Text('PLEASE MAKE PAYMENT BEFORE ${PdfWidgets.fmt(invoice.dueDate).toUpperCase()}', style: pw.TextStyle(font: font, fontSize: 12, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: 1))),
       ),
       pw.SizedBox(height: 20),
       PdfWidgets.buildFooter(invoice, biz, font, bold),
    ]));
  }

  static pw.Widget platinumVerticalSidebarTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    return pw.FullPage(
      ignoreMargins: true,
      child: pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(color: brandColor, width: 20)),
        child: pw.Row(children: [
           pw.Container(
             width: 150, color: brandColor,
             child: pw.Center(child: pw.Transform.rotate(
                angle: -1.5708,
                child: pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 140, color: PdfWidgets.getContrastColor(brandColor), letterSpacing: 10)),
             )),
           ),
           pw.Expanded(child: pw.Container(
             padding: const pw.EdgeInsets.all(60),
             color: PdfColors.white,
             child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Align(alignment: pw.Alignment.centerRight, child: logoBytes != null ? pw.Image(pw.MemoryImage(logoBytes), width: 60) : pw.SizedBox()),
                pw.SizedBox(height: 60),
                pw.Text('REF: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 12)),
                pw.Text('DATE: ${PdfWidgets.fmt(invoice.issueDate)}', style: pw.TextStyle(font: font, fontSize: 10)),
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
                PdfWidgets.buildFooter(invoice, biz, font, bold),
             ]),
           )),
        ]),
      ),
    );
  }

  static pw.Widget platinumIngoudeTemplate(Invoice invoice, BusinessInfo biz, pw.Font font, pw.Font bold, PdfColor brandColor, Uint8List? logoBytes) {
    final darkBrand = PdfColor(brandColor.red * 0.4, brandColor.green * 0.4, brandColor.blue * 0.4);
    
    return pw.FullPage(ignoreMargins: true, child: pw.Container(color: PdfColors.white, child: pw.Column(children: [
       pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(
            width: 300, height: 160, color: darkBrand,
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
               pw.Text(biz.name.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 36, color: PdfWidgets.getContrastColor(darkBrand))),
            ]),
          ),
          pw.Expanded(child: pw.Container(
            height: 160, color: PdfColors.white,
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
               pw.Text('INVOICE', style: pw.TextStyle(font: bold, fontSize: 48, color: darkBrand)),
               pw.Text('REF NO: #${invoice.id}', style: pw.TextStyle(font: bold, fontSize: 12, color: brandColor)),
               pw.Text(PdfWidgets.fmt(invoice.issueDate), style: pw.TextStyle(font: font, fontSize: 12, color: darkBrand)),
            ]),
          )),
       ]),
       pw.Padding(padding: const pw.EdgeInsets.all(40), child: pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
             pw.Expanded(child: PdfWidgets.buildBillToBlock(invoice, font, bold, color: brandColor)),
             pw.Expanded(child: PdfWidgets.buildBillFromBlock(biz, font, bold, color: brandColor)),
          ]),
          pw.SizedBox(height: 60),
          PdfWidgets.buildTypeMetadataSection(invoice, font, bold, darkBrand),
          PdfWidgets.itemsTable(invoice, font, bold, darkBrand),
          pw.SizedBox(height: 40),
          pw.Align(alignment: pw.Alignment.centerRight, child: PdfWidgets.totalsBlock(invoice, font, bold, brandColor)),
          pw.SizedBox(height: 24),
          PdfWidgets.paymentButton(invoice, brandColor),
       ])),
       pw.Spacer(),
       pw.Container(
         width: double.infinity, height: 80, color: darkBrand,
         padding: const pw.EdgeInsets.symmetric(horizontal: 40),
         child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Tel: ${biz.businessPhone ?? 'N/A'}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfWidgets.getContrastColor(darkBrand))),
            pw.Text(biz.businessEmail ?? '', style: pw.TextStyle(font: font, fontSize: 10, color: PdfWidgets.getContrastColor(darkBrand))),
         ]),
       ),
       pw.SizedBox(height: 12),
       PdfWidgets.buildFooter(invoice, biz, font, bold),
    ])));
  }
}
