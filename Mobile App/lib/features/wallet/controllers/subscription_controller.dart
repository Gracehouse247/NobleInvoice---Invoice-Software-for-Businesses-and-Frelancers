// lib/features/wallet/controllers/subscription_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:intl/intl.dart';

enum SubscriptionTier { solo, pulse, elite, consumption }

class UsageMetrics {
  final int clientsCreated;
  final int clientsEdited;
  final int invoicesCreated;
  final int invoicesEdited;
  final int cardsCreated;

  UsageMetrics({
    this.clientsCreated = 0,
    this.clientsEdited = 0,
    this.invoicesCreated = 0,
    this.invoicesEdited = 0,
    this.cardsCreated = 0,
  });

  factory UsageMetrics.fromJson(Map<String, dynamic> json) {
    return UsageMetrics(
      clientsCreated: json['clients_created'] ?? 0,
      clientsEdited:  json['clients_edited'] ?? 0,
      invoicesCreated: json['invoices_created'] ?? 0,
      invoicesEdited:  json['invoices_edited'] ?? 0,
      cardsCreated:    json['cards_created'] ?? 0,
    );
  }
}


class SubscriptionController extends ChangeNotifier {
  SubscriptionTier _currentTier      = SubscriptionTier.solo;
  DateTime?        _expiresAt;
  bool             _isYearly         = false;
  UsageMetrics     _usage            = UsageMetrics();
  bool             _isLoading        = false;
  String           _error            = '';

  // Getters
  SubscriptionTier get currentTier => _currentTier;
  DateTime?        get expiresAt   => _expiresAt;
  bool             get isYearly    => _isYearly;
  UsageMetrics     get usage       => _usage;
  bool             get isLoading   => _isLoading;
  String           get error       => _error;

  bool get isPulseOrElite => _currentTier == SubscriptionTier.pulse || _currentTier == SubscriptionTier.elite;
  bool get isElite        => _currentTier == SubscriptionTier.elite;
  bool get isExpired      => _expiresAt != null && _expiresAt!.isBefore(DateTime.now());

  // ── Initialization & Sync ──────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await loadSubscription();
      await fetchUsageMetrics();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSubscription() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    final res = await SupabaseService.client
        .from('profiles')
        .select('subscription_tier, subscription_expires_at, is_yearly_plan')
        .eq('id', user.id)
        .single();

    _currentTier = _parseTier(res['subscription_tier'] ?? 'solo');
    _expiresAt   = res['subscription_expires_at'] != null ? DateTime.parse(res['subscription_expires_at']) : null;
    _isYearly    = res['is_yearly_plan'] ?? false;

    // Rollback logic: If expired, treat as Solo (but keep meta for "renew" prompts)
    if (isExpired) {
      _currentTier = SubscriptionTier.solo;
    }
    notifyListeners();
  }

  Future<void> fetchUsageMetrics() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    final monthYear = DateFormat('yyyy-MM').format(DateTime.now());
    
    try {
      final res = await SupabaseService.client
          .from('usage_metrics')
          .select()
          .eq('user_id', user.id)
          .eq('month_year', monthYear)
          .maybeSingle();

      if (res != null) {
        _usage = UsageMetrics.fromJson(res);
      } else {
        // Initialize new month
        await SupabaseService.client.from('usage_metrics').insert({
          'user_id': user.id,
          'month_year': monthYear,
        });
        _usage = UsageMetrics();
      }
    } catch (e) {
      debugPrint('Usage metrics fetch error: $e');
    }
    notifyListeners();
  }

  // ── Feature Gating Helpers ────────────────────────────────────────────────
  
  bool get canAccessPulse => isPulseOrElite;
  bool get canAccessElite => isElite;

  /// Generic feature check for simple booleans or count-based limits
  bool canUse(String feature, {int? currentCount}) {
    if (isElite) return true; // Elite bypasses all limits

    switch (feature) {
      case 'clients':
        final max = _currentTier == SubscriptionTier.solo ? 3 : 15;
        return (currentCount ?? _usage.clientsCreated) < max;
      case 'invoices':
        final max = _currentTier == SubscriptionTier.solo ? 6 : 12;
        return (currentCount ?? _usage.invoicesCreated) < max;
      case 'cards':
        if (_currentTier == SubscriptionTier.solo) return _usage.cardsCreated < 3;
        return true; // Pulse/Elite unlimited cards
      case 'crm_deep':      return isPulseOrElite;
      case 'dynamic_qr':    return isPulseOrElite;
      case 'team_workspace': return isElite;
      case 'advanced_analytics': return isPulseOrElite;
      case 'business_card_print': return isPulseOrElite;
      default: return false;
    }
  }

  // ── Limit Enforcement Logic ────────────────────────────────────────────────
  
  /// Checks if a user can create a new item based on their tier.
  /// Returns a specific error message if limit is reached.
  String? checkCreateLimit(String type) {
    if (isElite) return null; // Elite is unlimited

    if (type == 'clients') {
      if (!canUse('clients')) {
        return _currentTier == SubscriptionTier.solo 
          ? 'SOLO_LIMIT: You have reached the 3-client limit. Upgrade to Pulse for 15 clients/month.'
          : 'PULSE_LIMIT: You have reached your 15-client monthly limit. Upgrade to Elite for unlimited clients.';
      }
    }

    if (type == 'invoices') {
      if (!canUse('invoices')) {
        return _currentTier == SubscriptionTier.solo
          ? 'SOLO_LIMIT: You have reached the 6-invoice limit this month. Upgrade to Pulse for 12 invoices.'
          : 'PULSE_LIMIT: You have reached your 12-invoice monthly limit. Upgrade to Elite for unlimited invoicing.';
      }
    }

    if (type == 'cards') {
      if (!canUse('cards')) {
        return 'SOLO_LIMIT: You have reached the 3 Digital Business Card limit. Upgrade to Pulse for unlimited cards.';
      }
    }
    return null;
  }

  /// Checks if a user can edit an item.
  String? checkEditLimit(String type) {
    if (isElite) return null; // Elite can edit anything

    if (_currentTier == SubscriptionTier.solo) {
      return 'SOLO_LOCK: Solo plan does not support editing once created. Upgrade to Pulse to unlock editing.';
    }

    if (type == 'clients' && _usage.clientsEdited >= 5) {
      return 'PULSE_EDIT_LIMIT: You have reached the 5-client edit limit this month. Upgrade to Elite for unlimited editing.';
    }

    if (type == 'invoices' && _usage.invoicesEdited >= 3) {
      return 'PULSE_EDIT_LIMIT: You have reached the 3-invoice edit limit this month. Upgrade to Elite for unlimited editing.';
    }

    return null;
  }

  // ── Usage Tracking ─────────────────────────────────────────────────────────
  Future<void> trackUsage(String type, {bool isEdit = false}) async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    final monthYear = DateFormat('yyyy-MM').format(DateTime.now());
    final column = _getColumnName(type, isEdit);
    
    try {
      await SupabaseService.client.rpc('increment_usage', params: {
        'u_id': user.id,
        'm_year': monthYear,
        'col_name': column,
      });
      await fetchUsageMetrics();
    } catch (e) {
      debugPrint('Usage tracking error: $e');
    }
  }

  String _getColumnName(String type, bool isEdit) {
    if (type == 'clients') return isEdit ? 'clients_edited' : 'clients_created';
    if (type == 'invoices') return isEdit ? 'invoices_edited' : 'invoices_created';
    if (type == 'cards') return 'cards_created';
    return '';
  }

  SubscriptionTier _parseTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'pulse':
      case 'pro':   return SubscriptionTier.pulse;
      case 'elite': return SubscriptionTier.elite;
      default:      return SubscriptionTier.solo;
    }
  }
}
