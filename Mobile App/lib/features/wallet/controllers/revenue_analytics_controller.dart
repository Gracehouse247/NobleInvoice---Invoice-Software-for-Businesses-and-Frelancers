// lib/features/wallet/controllers/revenue_analytics_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MonthPoint {
  final String label; // e.g. 'Jan'
  final double paid;
  final double pending;
  final double expenses;
  
  double get net => paid - expenses;

  MonthPoint({
    required this.label, 
    required this.paid, 
    required this.pending,
    this.expenses = 0,
  });
}

class ClientShare {
  final String name;
  final double total;
  ClientShare({required this.name, required this.total});
}

class RevenueAnalyticsController extends ChangeNotifier {
  bool   _loading = false;
  String _error   = '';
  String? _activeTeamId;

  double              _totalRevenue   = 0;
  double              _totalExpenses  = 0;
  double              _avgInvoice     = 0;
  double              _totalPending   = 0;
  int                 _pendingCount   = 0;
  List<MonthPoint>    _monthlyPoints  = [];
  List<ClientShare>   _clientShares   = [];
  double              _avgPaymentDays = 0;

  bool              get isLoading     => _loading;
  String            get error         => _error;
  double            get totalRevenue  => _totalRevenue;
  double            get totalExpenses => _totalExpenses;
  double            get netProfit     => _totalRevenue - _totalExpenses;
  double            get avgInvoice    => _avgInvoice;
  double            get totalPending  => _totalPending;
  int               get pendingCount  => _pendingCount;
  List<MonthPoint>  get monthlyPoints => _monthlyPoints;
  List<ClientShare> get clientShares  => _clientShares;
  double            get avgPaymentDays => _avgPaymentDays;

  /// Growth rate of net profit: ((current - previous) / previous) * 100
  double get growthRate {
    if (_monthlyPoints.length < 2) return 0;
    final prev = _monthlyPoints[_monthlyPoints.length - 2].net;
    final curr = _monthlyPoints.last.net;
    if (prev == 0) return 0;
    return ((curr - prev) / prev.abs()) * 100;
  }

  /// Simple 3-month moving average for next month forecast
  double get forecastNextMonth {
    if (_monthlyPoints.isEmpty) return 0;
    final last3 = _monthlyPoints.reversed.take(3).toList();
    return last3.fold(0.0, (s, p) => s + p.net) / last3.length;
  }

  void setActiveTeamId(String? id) {
    if (_activeTeamId != id) {
      _activeTeamId = id;
      if (id != null) {
        load();
      }
      notifyListeners();
    }
  }

  String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    return e.toString();
  }

  Future<void> load({int months = 6}) async {
    if (_activeTeamId == null) return;
    
    _loading = true;
    _error   = '';
    notifyListeners();

    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      final since = DateTime.now().subtract(Duration(days: months * 30));

      // Fetch all invoices in range (TEAM BASED)
      final List<dynamic> invRows = await SupabaseService.client
          .from('invoices')
          .select('status, total_amount, issue_date, clients(name)')
          .eq('team_id', _activeTeamId!)
          .gte('issue_date', since.toIso8601String().split('T')[0])
          .order('issue_date');

      // Fetch all expenses in range
      final List<dynamic> expRows = await SupabaseService.client
          .from('expenses')
          .select('amount, expense_date')
          .eq('user_id', userId)
          .gte('expense_date', since.toIso8601String().split('T')[0]);

      // Aggregate
      final monthMap  = <String, MonthPoint>{};
      final clientMap = <String, double>{};
      double revenue  = 0;
      double pending  = 0;
      int    pCount   = 0;
      int    total    = 0;
      double totalDays = 0;
      int    paidCountWithDates = 0;

      for (final row in invRows) {
        final amount  = double.tryParse(row['total_amount']?.toString() ?? '0') ?? 0;
        final status  = row['status'] as String? ?? 'draft';
        final rawDate = row['issue_date'] as String? ?? '';
        final clientName = (row['clients'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown';

        // Month bucket
        if (rawDate.length >= 7) {
          final month   = rawDate.substring(0, 7); // '2025-01'
          final label   = _monthLabel(rawDate);
          if (!monthMap.containsKey(month)) {
            monthMap[month] = MonthPoint(label: label, paid: 0, pending: 0, expenses: 0);
          }
          final existing = monthMap[month]!;
          monthMap[month] = MonthPoint(
            label:   label,
            paid:    existing.paid    + (status == 'paid' ? amount : 0),
            pending: existing.pending + (status == 'pending' || status == 'overdue' ? amount : 0),
            expenses: existing.expenses,
          );
        }

        // Revenue & pending
        if (status == 'paid') {
          revenue += amount;
          total++;

          // DSO calculation
          final paidAtStr = row['paid_at'] as String?;
          if (paidAtStr != null && rawDate.isNotEmpty) {
            final issueDate = DateTime.tryParse(rawDate);
            final paidAt    = DateTime.tryParse(paidAtStr);
            if (issueDate != null && paidAt != null) {
              totalDays += paidAt.difference(issueDate).inDays;
              paidCountWithDates++;
            }
          }
        } else if (status == 'pending' || status == 'overdue') {
          pending += amount;
          pCount++;
        }

        // Client share
        clientMap[clientName] = (clientMap[clientName] ?? 0) + amount;
      }

      // Add Expenses to buckets
      double totalExp = 0;
      for (final row in expRows) {
        final amount  = double.tryParse(row['amount']?.toString() ?? '0') ?? 0;
        final rawDate = row['expense_date'] as String? ?? '';
        totalExp += amount;

        if (rawDate.length >= 7) {
          final month = rawDate.substring(0, 7);
          final label = _monthLabel(rawDate);
          if (!monthMap.containsKey(month)) {
            monthMap[month] = MonthPoint(label: label, paid: 0, pending: 0, expenses: 0);
          }
          final existing = monthMap[month]!;
          monthMap[month] = MonthPoint(
            label:    label,
            paid:     existing.paid,
            pending:  existing.pending,
            expenses: existing.expenses + amount,
          );
        }
      }

      // Sort months chronologically
      final sortedMonths = monthMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
      _monthlyPoints = sortedMonths.map((e) => e.value).toList();

      // Sort clients by total
      final sortedClients = clientMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      _clientShares = sortedClients.take(5).map((e) => ClientShare(name: e.key, total: e.value)).toList();

      _totalRevenue  = revenue;
      _totalExpenses = totalExp;
      _avgInvoice    = total > 0 ? revenue / total : 0;
      _totalPending  = pending;
      _pendingCount  = pCount;
      _avgPaymentDays = paidCountWithDates > 0 ? totalDays / paidCountWithDates : 0;

    } catch (e) {
      _error = _parseError(e);
    }

    _loading = false;
    notifyListeners();
  }

  static String _monthLabel(String isoDate) {
    const labels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    try {
      final month = int.parse(isoDate.substring(5, 7));
      return labels[month - 1];
    } catch (_) {
      return '?';
    }
  }
}
