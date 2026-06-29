// lib/features/invoicing/controllers/recurring_invoice_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/core/state/team_scope_mixin.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Data Models ─────────────────────────────────────────────────────────────

enum RecurringFrequency { weekly, monthly, quarterly, annually }

extension RecurringFrequencyExt on RecurringFrequency {
  String get dbValue {
    switch (this) {
      case RecurringFrequency.weekly:    return 'weekly';
      case RecurringFrequency.monthly:   return 'monthly';
      case RecurringFrequency.quarterly: return 'quarterly';
      case RecurringFrequency.annually:  return 'annually';
    }
  }

  String get label {
    switch (this) {
      case RecurringFrequency.weekly:    return 'Weekly';
      case RecurringFrequency.monthly:   return 'Monthly';
      case RecurringFrequency.quarterly: return 'Quarterly';
      case RecurringFrequency.annually:  return 'Annually';
    }
  }

  String get description {
    switch (this) {
      case RecurringFrequency.weekly:    return 'Invoice regenerates every 7 days';
      case RecurringFrequency.monthly:   return 'Invoice regenerates every month';
      case RecurringFrequency.quarterly: return 'Invoice regenerates every 3 months';
      case RecurringFrequency.annually:  return 'Invoice regenerates every year';
    }
  }

  static RecurringFrequency fromDb(String? v) {
    switch (v) {
      case 'weekly':    return RecurringFrequency.weekly;
      case 'quarterly': return RecurringFrequency.quarterly;
      case 'annually':  return RecurringFrequency.annually;
      default:          return RecurringFrequency.monthly;
    }
  }
}

class RecurringSchedule {
  final String             id;
  final String             clientName;
  final String             clientEmail;
  final RecurringFrequency frequency;
  final DateTime           nextRunAt;
  final DateTime?          lastRunAt;
  final bool               isActive;
  final Map<String, dynamic> templateData; // items, notes, tax, etc.

  RecurringSchedule({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.frequency,
    required this.nextRunAt,
    this.lastRunAt,
    this.isActive = true,
    required this.templateData,
  });

  double get totalAmount {
    final items = (templateData['items'] as List?) ?? [];
    return items.fold<double>(0, (s, i) {
      final qty   = double.tryParse(i['quantity']?.toString() ?? '1') ?? 1;
      final price = double.tryParse(i['unit_price']?.toString() ?? '0') ?? 0;
      return s + qty * price;
    });
  }

  factory RecurringSchedule.fromJson(Map<String, dynamic> j) {
    final clientData = j['clients'] as Map<String, dynamic>? ?? {};
    return RecurringSchedule(
      id:           j['id'] as String,
      clientName:   clientData['name'] as String? ?? 'Unknown',
      clientEmail:  clientData['email'] as String? ?? '',
      frequency:    RecurringFrequencyExt.fromDb(j['frequency'] as String?),
      nextRunAt:    DateTime.parse(j['next_run_at'] as String),
      lastRunAt:    j['last_run_at'] != null ? DateTime.parse(j['last_run_at'] as String) : null,
      isActive:     j['is_active'] as bool? ?? true,
      templateData: j['template_data'] as Map<String, dynamic>? ?? {},
    );
  }
}

// ── Controller ───────────────────────────────────────────────────────────────

enum RecurringLoadState { idle, loading, saving, error }

class RecurringInvoiceController extends ChangeNotifier with TeamScopeMixin {
  RecurringLoadState    _status    = RecurringLoadState.idle;
  List<RecurringSchedule> _schedules = [];
  String                _error     = '';

  RecurringLoadState      get status    => _status;
  List<RecurringSchedule> get schedules => _schedules;
  String                  get error     => _error;
  bool                    get isLoading => _status == RecurringLoadState.loading;
  bool                    get isSaving  => _status == RecurringLoadState.saving;

  String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    return e.toString();
  }

  // ── Load all recurring schedules ────────────────────────────────────────────
  Future<void> loadSchedules() async {
    _status = RecurringLoadState.loading;
    notifyListeners();
    try {
      final teamId = activeTeamId;
      if (teamId == null) throw Exception('No active team');

      final res = await SupabaseService.client
          .from('recurring_invoices')
          .select('*, clients(name, email)')
          .eq('team_id', teamId)
          .order('created_at', ascending: false);

      _schedules = (res as List)
          .map((j) => RecurringSchedule.fromJson(j as Map<String, dynamic>))
          .toList();
      _status = RecurringLoadState.idle;
    } catch (e) {
      _error  = _parseError(e);
      _status = RecurringLoadState.error;
    }
    notifyListeners();
  }

  // ── Create a new recurring schedule ────────────────────────────────────────
  Future<bool> createSchedule({
    required int               clientId,
    required RecurringFrequency frequency,
    required List<InvoiceItem> items,
    required DateTime          firstRunAt,
    String?                    notes,
    InvoiceType                invoiceType = InvoiceType.recurring,
    double                     taxRate     = 0,
    String                     taxType     = 'exclusive',
    String                     currencyCode = 'USD',
  }) async {
    _status = RecurringLoadState.saving;
    notifyListeners();
    try {
      final teamId = activeTeamId;
      if (teamId == null) throw Exception('No active team');
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      await SupabaseService.client.from('recurring_invoices').insert({
        'user_id':    userId,
        'team_id':    teamId,
        'client_id':  clientId,
        'frequency':  frequency.dbValue,
        'next_run_at': firstRunAt.toIso8601String(),
        'is_active':  true,
        'template_data': {
          'invoice_type': invoiceType.dbValue,
          'currency_code': currencyCode,
          'tax_rate':     taxRate,
          'tax_type':     taxType,
          'notes':        notes,
          'items': items.map((i) => {
            'description': i.description,
            'quantity':    i.quantity,
            'unit_price':  i.unitPrice,
          }).toList(),
        },
      });

      _status = RecurringLoadState.idle;
      await loadSchedules();
      return true;
    } catch (e) {
      _error  = _parseError(e);
      _status = RecurringLoadState.error;
      notifyListeners();
      return false;
    }
  }

  // ── Toggle active state ────────────────────────────────────────────────────
  Future<bool> toggleActive(String id, bool newState) async {
    try {
      await SupabaseService.client
          .from('recurring_invoices')
          .update({'is_active': newState})
          .eq('id', id);

      final idx = _schedules.indexWhere((s) => s.id == id);
      if (idx != -1) {
        final old = _schedules[idx];
        _schedules[idx] = RecurringSchedule(
          id:           old.id,
          clientName:   old.clientName,
          clientEmail:  old.clientEmail,
          frequency:    old.frequency,
          nextRunAt:    old.nextRunAt,
          lastRunAt:    old.lastRunAt,
          isActive:     newState,
          templateData: old.templateData,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Delete a schedule ──────────────────────────────────────────────────────
  Future<bool> deleteSchedule(String id) async {
    try {
      await SupabaseService.client.from('recurring_invoices').delete().eq('id', id);
      _schedules.removeWhere((s) => s.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _status = RecurringLoadState.idle;
    _error  = '';
    notifyListeners();
  }
}
