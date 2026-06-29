// lib/core/services/pdf/utils/pdf_template_components.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTemplateComponents {
  static pw.Widget mollyTotalRow(String label, String value, pw.Font font, PdfColor color) {
    return pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10, color: color, letterSpacing: 1)),
      pw.SizedBox(width: 40),
      pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ]);
  }

  static pw.Widget restaurantTotalRow(String label, String value, pw.Font font, PdfColor color) {
    return pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
       pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10, color: color, letterSpacing: 2)),
       pw.SizedBox(width: 40),
       pw.Text(value, style: pw.TextStyle(font: font, fontSize: 11)),
    ]);
  }

  static pw.Widget arowwaiInfo(String label, String value, pw.Font font, pw.Font bold) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
       pw.Text(label.toUpperCase(), style: pw.TextStyle(font: bold, fontSize: 8, color: PdfColors.grey500)),
       pw.SizedBox(height: 4),
       pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 10)),
    ]);
  }

  static pw.Widget boldTotalRow(String label, String value, pw.Font font) {
    return pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey500)),
      pw.SizedBox(width: 40),
      pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ]);
  }

  static pw.Widget tsTotalRow(String label, String value, pw.Font font, PdfColor color) {
    return pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
      pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey400)),
      pw.SizedBox(width: 40),
      pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.white)),
    ]);
  }

  static pw.Widget chadInfoBlock(String label, String value, pw.Font font, pw.Font bold, PdfColor color) {
    return pw.Column(children: [
       pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 8, color: PdfColor(color.red, color.green, color.blue, 0.6))),
       pw.SizedBox(height: 4),
       pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 14, color: color)),
    ]);
  }
}
