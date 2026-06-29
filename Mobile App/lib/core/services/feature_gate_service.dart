import 'package:supabase_flutter/supabase_flutter.dart';

class FeatureGateService {
  static final FeatureGateService _instance = FeatureGateService._internal();
  factory FeatureGateService() => _instance;
  FeatureGateService._internal();

  final _supabase = Supabase.instance.client;
  
  Map<String, dynamic>? _limits;
  Map<String, dynamic>? _features;
  String _tier = 'explorer';

  Future<void> initialize() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _reset();
      return;
    }

    try {
      final response = await _supabase.rpc('resolve_user_limits', params: {'p_user_id': user.id});
      if (response != null) {
        _tier = response['tier'] as String? ?? 'explorer';
        _limits = response['limits'] as Map<String, dynamic>?;
        _features = response['features'] as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching feature gates: $e');
      _reset();
    }
  }

  void _reset() {
    _tier = 'explorer';
    _limits = null;
    _features = null;
  }

  bool hasFeature(String featureId) {
    if (_tier == 'admin') return true;
    if (_features == null) return false;
    return _features![featureId] == true;
  }

  int get maxInvoicesPerMonth => _limits?['max_invoices_per_month'] ?? 10;
  int get maxClients => _limits?['max_clients'] ?? 5;
  bool get hasAdvancedEditing => _limits?['has_advanced_editing'] ?? false;
  
  String get currentTier => _tier;
  bool get isProOrElite => ['pro', 'elite', 'pulse', 'admin'].contains(_tier);
}
