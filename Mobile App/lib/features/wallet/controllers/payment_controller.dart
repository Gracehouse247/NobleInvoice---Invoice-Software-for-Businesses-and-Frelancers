// lib/features/wallet/controllers/payment_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/core/services/payment_service.dart';
import 'package:noble_invoice/features/wallet/models/payment_methods.dart';
import 'package:noble_invoice/features/wallet/widgets/payment_webview_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum PaymentStatus { idle, loading, initiating, verifying, success, error }

class SavedPaymentMethod {
  final String  id;
  final String  type;    // 'visa', 'mastercard', 'paystack', 'flutterwave'
  final String? last4;
  final String? expiry;
  final bool    isDefault;
  final String? token;

  const SavedPaymentMethod({
    required this.id,
    required this.type,
    this.last4,
    this.expiry,
    this.isDefault = false,
    this.token,
  });

  factory SavedPaymentMethod.fromJson(Map<String, dynamic> j) => SavedPaymentMethod(
    id:        j['id'] as String,
    type:      j['type'] as String,
    last4:     j['last4'] as String?,
    expiry:    j['expiry'] as String?,
    isDefault: j['is_default'] as bool? ?? false,
    token:     j['token'] as String?,
  );
}

class PaymentController extends ChangeNotifier {
  PaymentStatus             _status      = PaymentStatus.idle;
  String                    _errorMessage = '';
  PaymentResult?            _lastResult;
  List<SavedPaymentMethod>  _savedMethods = [];

  PaymentStatus            get status      => _status;
  String                   get errorMessage => _errorMessage;
  PaymentResult?           get lastResult  => _lastResult;
  List<SavedPaymentMethod> get savedMethods => _savedMethods;
  bool                     get isInitiating => _status == PaymentStatus.initiating;
  bool                     get isVerifying  => _status == PaymentStatus.verifying;
  bool                     get isLoading    => _status == PaymentStatus.loading;

  String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    return e.toString();
  }

  // ── Load saved payment methods from Supabase ────────────────────────────────
  Future<void> loadPaymentMethods() async {
    _status = PaymentStatus.loading;
    notifyListeners();
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      final res = await SupabaseService.client
          .from('payment_methods')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _savedMethods = (res as List)
          .map((j) => SavedPaymentMethod.fromJson(j as Map<String, dynamic>))
          .toList();
      _status = PaymentStatus.idle;
    } catch (e) {
      _errorMessage = _parseError(e);
      _status = PaymentStatus.error;
    }
    notifyListeners();
  }

  // ── Save a new payment method ───────────────────────────────────────────────
  Future<bool> addPaymentMethod({
    required String type,
    String? last4,
    String? expiry,
    String? token,
    bool    setDefault = false,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      // If setting as default, clear existing defaults first
      if (setDefault) {
        await SupabaseService.client
            .from('payment_methods')
            .update({'is_default': false})
            .eq('user_id', userId);
      }

      await SupabaseService.client.from('payment_methods').insert({
        'user_id':    userId,
        'type':       type,
        'last4':      last4,
        'expiry':     expiry,
        'token':      token,
        'is_default': setDefault,
      });

      await loadPaymentMethods();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Remove a payment method ─────────────────────────────────────────────────
  Future<bool> removePaymentMethod(String id) async {
    try {
      await SupabaseService.client.from('payment_methods').delete().eq('id', id);
      _savedMethods.removeWhere((m) => m.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Initiate Payment (unchanged logic, now properly typed) ──────────────────
  Future<PaymentInitResult?> beginPayment({
    required String planId,
    required double amount,
    required PaymentMethod method,
    required String userEmail,
    required String userName,
    required String userPhone,
  }) async {
    _status = PaymentStatus.initiating;
    _errorMessage = '';
    _lastResult = null;
    notifyListeners();

    try {
      final result = await PaymentService.initiatePayment(
        planId:    planId,
        amount:    amount,
        currency:  method.currency,
        method:    method,
        userEmail: userEmail,
        userName:  userName,
        userPhone: userPhone,
      );
      notifyListeners();
      return result;
    } catch (e) {
      _status = PaymentStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  // ── Handle WebView Result ───────────────────────────────────────────────────
  void handleWebViewResult(PaymentResult result) {
    _lastResult   = result;
    _status        = result.isSuccess ? PaymentStatus.success : PaymentStatus.error;
    _errorMessage  = result.failureReason ?? '';
    notifyListeners();
  }

  void reset() {
    _status       = PaymentStatus.idle;
    _errorMessage = '';
    _lastResult   = null;
    notifyListeners();
  }
}
