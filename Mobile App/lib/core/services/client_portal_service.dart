// lib/core/services/client_portal_service.dart
//
// Generates secure tracking links for clients to view invoices in the browser.
// Uses the 'view-invoice' Supabase Edge Function.

import 'package:noble_invoice/core/constants/env_constants.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientPortalService {
  ClientPortalService._();

  /// Generates the secure public URL for a specific invoice.
  /// Requires the 'tracking_token' field from the invoice model.
  static String getPublicInvoiceUrl(Invoice invoice) {
    final token = invoice.trackingToken;
    if (token == null || token.isEmpty) return '';

    // The portal is served via the Edge Function
    return '${EnvConstants.supabaseUrl}/functions/v1/view-invoice?token=$token';
  }

  /// Opens the invoice in the system browser for the business owner to preview.
  static Future<void> previewAsClient(Invoice invoice) async {
    final url = getPublicInvoiceUrl(invoice);
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Shares the portal link via the system share sheet (WhatsApp, Email, etc.)
  static Future<void> sharePortalLink(Invoice invoice) async {
    final url = getPublicInvoiceUrl(invoice);
    if (url.isEmpty) return;

    final message = '''
Hello ${invoice.clientName},

Your invoice #${invoice.invoiceNumber} is ready for review. 
You can view it and complete payment securely here:

$url

Thank you for your business!
''';

    await Share.share(message, subject: 'Invoice #${invoice.invoiceNumber}');
  }
}
