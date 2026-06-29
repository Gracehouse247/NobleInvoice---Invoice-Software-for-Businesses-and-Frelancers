import 'package:provider/provider.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:flutter/material.dart';

class PricingConverter {
  /// Base pricing in USD
  static const double baseProMonthlyUSD = 9.99;

  /// Conversion rates (Static/Mock for demo)
  /// In a real app, these would come from an API
  static const Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'NGN': 1600.0,
    'GBP': 0.79,
    'EUR': 0.92,
    'CAD': 1.35,
    'AUD': 1.52,
    'INR': 83.0,
    'JPY': 150.0,
    'ZAR': 19.0,
    'GHS': 13.0,
    'KES': 130.0,
    'UGX': 3800.0,
    'RWF': 1280.0,
    'TZS': 2550.0,
    'XAF': 600.0,
    'XOF': 600.0,
    'EGP': 48.0,
    'MAD': 10.0,
  };

  static double convertUSD(BuildContext context, double usdAmount) {
    try {
      final currency = Provider.of<InvoiceController>(context, listen: false).currencyCode;
      final rate = _exchangeRates[currency] ?? 1.0;
      return usdAmount * rate;
    } catch (_) {
      return usdAmount;
    }
  }

  static double getProPrice(BuildContext context) {
    return convertUSD(context, baseProMonthlyUSD);
  }
}
