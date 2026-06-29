import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/wallet/models/payment_methods.dart';

/// Result from initiating a payment — contains everything the WebView needs.
class PaymentInitResult {
  final String checkoutUrl;
  final String txRef;         // Flutterwave tx_ref OR Paystack reference
  final PaymentGateway gateway; // which gateway actually produced this URL

  PaymentInitResult({
    required this.checkoutUrl,
    required this.txRef,
    required this.gateway,
  });
}

/// Central payment service.
/// Strategy:
///   1. Always try Flutterwave first (versatile, multi-currency, Pan-African).
///   2. If Flutterwave throws any error, automatically retry with Paystack.
///   3. If Paystack also fails, rethrow the last error.
class PaymentService {
  // ── Flutterwave (Primary) ────────────────────────────────────────────────

  static Future<PaymentInitResult> _initiateFlutterwave({
    required String planId,
    required double amount,
    required String currency,
    required String methodId,
    required String userEmail,
    required String userName,
    required String userPhone,
  }) async {
    final res = await SupabaseService.client.functions.invoke('flutterwave-initiate', body: {
      'plan_id': planId,
      'amount': amount,
      'currency': currency,
      'payment_method': methodId, // e.g. 'card', 'bank_transfer', 'ussd', 'mpesa', 'mobilemoney'
      'email': userEmail,
      'name': userName,
      'phone': userPhone,
    });

    final data = res.data as Map<String, dynamic>;
    final checkoutUrl = data['checkout_url'] as String?;
    final txRef = data['tx_ref'] as String?;

    if (checkoutUrl == null || txRef == null) {
      throw Exception('Flutterwave: Invalid response from server');
    }

    return PaymentInitResult(
      checkoutUrl: checkoutUrl,
      txRef: txRef,
      gateway: PaymentGateway.flutterwave,
    );
  }

  // ── Public: Initiate ──────────────────────────────────────────────────────

  /// Initiates a payment via Flutterwave.
  static Future<PaymentInitResult> initiatePayment({
    required String planId,
    required double amount,
    required String currency,
    required PaymentMethod method,
    required String userEmail,
    required String userName,
    required String userPhone,
  }) async {
    try {
      final res = await SupabaseService.client.functions.invoke('flutterwave-initiate', body: {
        'plan_id': planId,
        'amount': amount,
        'currency': currency,
        'payment_method': method.id, // e.g. 'card', 'bank_transfer', 'ussd', 'mpesa', 'mobilemoney'
        'email': userEmail,
        'name': userName,
        'phone': userPhone,
      });

      final data = res.data as Map<String, dynamic>;
      final checkoutUrl = data['checkout_url'] as String?;
      final txRef = data['tx_ref'] as String?;

      if (checkoutUrl == null || txRef == null) {
        throw Exception('Flutterwave: Invalid response from server');
      }

      return PaymentInitResult(
        checkoutUrl: checkoutUrl,
        txRef: txRef,
        gateway: PaymentGateway.flutterwave,
      );
    } catch (e) {
      throw Exception('Payment could not be initiated. Please check your connection and try again.');
    }
  }

  // ── Verify ───────────────────────────────────────────────────────────────

  /// Verifies a completed transaction on the backend.
  static Future<bool> verifyPayment({
    required String txRef,
  }) async {
    try {
      final res = await SupabaseService.client.functions.invoke(
        'flutterwave-verify', 
        body: {'tx_ref': txRef}
      );
      return (res.data as Map<String, dynamic>)['status'] == 'success';
    } catch (_) {
      return false;
    }
  }
}
