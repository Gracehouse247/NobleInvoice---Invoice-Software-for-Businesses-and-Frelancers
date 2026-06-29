import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';

class CurrencyService {
  static const String _cacheKey = 'noble_exchange_rates';
  static const String _cacheDateKey = 'noble_exchange_rates_date';
  static Map<String, dynamic> _rates = {};

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load from cache first for immediate offline support
    final cachedStr = prefs.getString(_cacheKey);
    if (cachedStr != null) {
      try {
        _rates = jsonDecode(cachedStr) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Failed to decode cached rates: $e');
      }
    }

    // Check if we need to refresh (cache older than 12 hours)
    final cacheDateStr = prefs.getString(_cacheDateKey);
    bool shouldRefresh = true;
    if (cacheDateStr != null) {
      final cacheDate = DateTime.tryParse(cacheDateStr);
      if (cacheDate != null && DateTime.now().difference(cacheDate).inHours < 12) {
        shouldRefresh = false;
      }
    }

    if (shouldRefresh) {
      _fetchLiveRates();
    }
  }

  static Future<void> _fetchLiveRates() async {
    try {
      final url = Uri.parse('https://open.er-api.com/v6/latest/USD');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['rates'] != null) {
          _rates = data['rates'] as Map<String, dynamic>;
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_cacheKey, jsonEncode(_rates));
          await prefs.setString(_cacheDateKey, DateTime.now().toIso8601String());
          debugPrint('Successfully refreshed live exchange rates.');
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch live rates, falling back to cache if available: $e');
    }
  }

  /// Converts an [amount] from [fromCurrency] to [toCurrency] using live/cached rates.
  static double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    if (_rates.isEmpty) return amount; // Fallback gracefully if completely offline and empty
    
    final fromRate = (_rates[fromCurrency] as num?)?.toDouble();
    final toRate   = (_rates[toCurrency] as num?)?.toDouble();
    
    // If either rate is unsupported, return raw to prevent zeroing out
    if (fromRate == null || toRate == null || fromRate == 0) return amount;

    // Everything is mapped relative to USD in the API
    final amountInUsd = amount / fromRate;
    return amountInUsd * toRate;
  }

  /// Recalculates a list of [InvoiceItem] from [fromCurrency] to [toCurrency].
  static List<InvoiceItem> recalculateItems(List<InvoiceItem> items, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return items;
    
    return items.map((item) {
      final newPrice = convert(item.unitPrice, fromCurrency, toCurrency);
      return InvoiceItem(
        id:          item.id,
        description: item.description,
        productId:   item.productId,
        quantity:    item.quantity,
        unitPrice:   double.parse(newPrice.toStringAsFixed(2)),
      );
    }).toList();
  }
}
