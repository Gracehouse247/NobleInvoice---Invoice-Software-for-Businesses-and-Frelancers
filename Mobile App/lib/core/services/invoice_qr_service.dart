// lib/core/services/invoice_qr_service.dart
// Generates a payment QR code for any invoice.
// The QR encodes a link that can open the client payment portal.
//
// Phase 5 will deploy the actual Supabase-hosted payment page at this URL.
// For now, the QR encodes the link so it's ready the moment the portal launches.

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:noble_invoice/core/constants/env_constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InvoiceQrService {
  static const String _baseUrl = '${EnvConstants.supabaseUrl}/functions/v1/invoice-portal';

  /// Returns the canonical payment URL for an invoice.
  static String paymentUrl(String invoiceId) => '$_baseUrl?id=$invoiceId';

  /// Renders the payment QR as raw PNG bytes at [size] × [size] px.
  /// Used for embedding into the PDF and for displaying in the Flutter UI.
  static Future<Uint8List> generateQrPng({
    required String invoiceId,
    double size = 160,
  }) async {
    final url = paymentUrl(invoiceId);
    final painter = QrPainter(
      data: url,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: ui.Color(0xFF1E293B),
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: ui.Color(0xFF1E293B),
      ),
    );
    final image    = await painter.toImage(size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
