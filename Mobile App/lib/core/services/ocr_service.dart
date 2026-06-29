import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<Map<String, dynamic>> parseReceipt(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String fullText = recognizedText.text;
    
    return {
      'amount': _extractAmount(fullText),
      'date': _extractDate(fullText),
      'merchant': _extractMerchant(recognizedText),
      'rawText': fullText,
    };
  }

  double? _extractAmount(String text) {
    // Look for patterns like "Total: $123.45" or "Amount 1,234.00"
    final RegExp amountRegex = RegExp(r'(total|amount|sum|grand total|net)[\s:]*([\$£€₦]?\s?\d{1,3}(?:,\d{3})*(?:\.\d{2})?)', caseSensitive: false);
    final match = amountRegex.firstMatch(text);
    
    if (match != null) {
      String val = match.group(2)!.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(val);
    }

    // Fallback: search for the largest number that looks like a price
    final RegExp genericPrice = RegExp(r'\d{1,3}(?:,\d{3})*(?:\.\d{2})');
    final allMatches = genericPrice.allMatches(text);
    double? max;
    for (final m in allMatches) {
      double? val = double.tryParse(m.group(0)!.replaceAll(',', ''));
      if (val != null && (max == null || val > max)) {
        max = val;
      }
    }
    return max;
  }

  DateTime? _extractDate(String text) {
    // Standard date patterns
    final RegExp dateRegex = RegExp(r'(\d{1,2}[/\-.]\d{1,2}[/\-.]\d{2,4})');
    final match = dateRegex.firstMatch(text);
    if (match != null) {
      try {
        // Try parsing common formats
        return DateTime.tryParse(match.group(0)!.replaceAll('.', '-').replaceAll('/', '-'));
      } catch (_) {}
    }
    return null;
  }

  String? _extractMerchant(RecognizedText recognized) {
    // Often the merchant name is the largest/top-most text
    if (recognized.blocks.isEmpty) return null;
    
    // HEURISTIC: The first block is often the header/merchant
    return recognized.blocks.first.text.split('\n').first;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
