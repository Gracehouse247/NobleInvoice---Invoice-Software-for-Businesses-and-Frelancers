import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';

class CurrencyFormatter {
  static String format(BuildContext context, double amount, {String? currency, bool compact = false}) {
    final profileCtrl = context.read<ProfileController>();
    
    // Priority: Explicit parameter > Profile preferred > Default
    final currencyCode = currency ?? profileCtrl.preferredCurrency;
    final locale = _getLocaleForCurrency(currencyCode);
    
    if (compact) {
      return NumberFormat.compactSimpleCurrency(
        locale: locale,
        name: currencyCode,
      ).format(amount);
    }

    return NumberFormat.simpleCurrency(
      locale: locale,
      name: currencyCode,
      decimalDigits: 2,
    ).format(amount);
  }

  static String _getLocaleForCurrency(String code) {
    switch (code.toUpperCase()) {
      case 'NGN': return 'en_NG';
      case 'USD': return 'en_US';
      case 'GBP': return 'en_GB';
      case 'EUR': return 'de_DE';
      case 'CAD': return 'en_CA';
      case 'AUD': return 'en_AU';
      case 'INR': return 'en_IN';
      case 'JPY': return 'ja_JP';
      case 'ZAR': return 'en_ZA';
      case 'KES': return 'en_KE';
      case 'GHS': return 'en_GH';
      case 'UGX': return 'en_UG';
      case 'RWF': return 'en_RW';
      case 'TZS': return 'en_TZ';
      case 'XAF': return 'fr_CM';
      case 'XOF': return 'fr_SN';
      case 'EGP': return 'ar_EG';
      case 'MAD': return 'ar_MA';
      default: return 'en_US';
    }
  }
}
