import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';

class PlatformStats {
  final int merchantCount;
  final double totalVolume;
  final int invoiceCount;
  final double platformRevenue;
  final DateTime updatedAt;

  PlatformStats({
    required this.merchantCount,
    required this.totalVolume,
    required this.invoiceCount,
    required this.platformRevenue,
    required this.updatedAt,
  });

  factory PlatformStats.fromJson(Map<String, dynamic> json) {
    return PlatformStats(
      merchantCount: json['merchant_count'] ?? 0,
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      invoiceCount: json['invoice_count'] ?? 0,
      platformRevenue: (json['platform_revenue'] ?? 0).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class AdminController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  PlatformStats? _stats;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  PlatformStats? get stats => _stats;

  Future<void> loadStats() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await SupabaseService.client.rpc('get_platform_stats');
      
      if (response != null) {
        _stats = PlatformStats.fromJson(response);
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading platform stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
