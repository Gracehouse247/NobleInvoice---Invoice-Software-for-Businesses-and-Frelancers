// lib/features/analytics/controllers/intelligence_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/core/services/currency_service.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

class CashFlowPoint {
  final DateTime date;
  final double projected;
  final double actual;
  final String label;

  CashFlowPoint({
    required this.date,
    required this.projected,
    required this.actual,
    required this.label,
  });
}

class ClientReliability {
  final String name;
  final double totalBilled;
  final double totalPaid;
  final double avgDaysToPay;
  final int invoiceCount;
  final int overdueCount;

  double get payRate => totalBilled == 0 ? 0 : (totalPaid / totalBilled) * 100;
  double get reliabilityScore {
    if (invoiceCount == 0) return 0;
    final overdueRatio = overdueCount / invoiceCount;
    final payRateFactor = payRate / 100;
    final speedFactor = avgDaysToPay == 0 ? 1 : (1 - (avgDaysToPay.clamp(0, 60) / 60));
    return ((payRateFactor * 0.5) + (speedFactor * 0.3) + ((1 - overdueRatio) * 0.2)) * 100;
  }

  ClientReliability({
    required this.name,
    required this.totalBilled,
    required this.totalPaid,
    required this.avgDaysToPay,
    required this.invoiceCount,
    required this.overdueCount,
  });
}

class ExpenseBurn {
  final String category;
  final double amount;
  final double budget; // 0 = no budget set
  final Color color;

  double get burnRatio => budget == 0 ? 0 : (amount / budget).clamp(0, 1.5);
  bool get isOverBudget => budget > 0 && amount > budget;

  ExpenseBurn({
    required this.category,
    required this.amount,
    this.budget = 0,
    required this.color,
  });
}

class SmartAlert {
  final String title;
  final String body;
  final SmartAlertType type;
  final IconData icon;

  SmartAlert({
    required this.title,
    required this.body,
    required this.type,
    required this.icon,
  });
}

enum SmartAlertType { danger, warning, insight, positive }

// ─── Controller ─────────────────────────────────────────────────────────────

class IntelligenceController extends ChangeNotifier {
  bool _loading = false;
  String _error = '';

  // KPIs
  double _dso = 0; // Days Sales Outstanding
  double _collectionRate = 0; // % of billed that is paid
  double _burnRate = 0; // avg monthly expense
  double _cashRunway = 0; // months of cash at current burn rate
  double _projectedNextMonth = 0;
  double _currentBalance = 0; // paid - expenses as proxy

  // Data sets
  List<CashFlowPoint> _cashFlowPoints = [];
  List<ClientReliability> _clientReliability = [];
  List<ExpenseBurn> _expenseBurns = [];
  List<SmartAlert> _alerts = [];

  // Getters
  bool get isLoading => _loading;
  String get error => _error;
  double get dso => _dso;
  double get collectionRate => _collectionRate;
  double get burnRate => _burnRate;
  double get cashRunway => _cashRunway;
  double get projectedNextMonth => _projectedNextMonth;
  double get currentBalance => _currentBalance;
  List<CashFlowPoint> get cashFlowPoints => _cashFlowPoints;
  List<ClientReliability> get clientReliability => _clientReliability;
  List<ExpenseBurn> get expenseBurns => _expenseBurns;
  List<SmartAlert> get alerts => _alerts;

  String? _activeTeamId;
  void setActiveTeamId(String? id) {
    if (_activeTeamId == id) return;
    _activeTeamId = id;
    if (id != null) load(id);
  }

  Future<void> load(String teamId, {String baseCurrency = 'USD'}) async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      // Fetch 12 months for better seasonal analysis
      final since = DateTime.now().subtract(const Duration(days: 365));

      // ── Fetch invoices (6 months) ──────────────────────────────────────────
      final invRows = await SupabaseService.client
          .from('invoices')
          .select('id, total_amount, currency_code, status, issue_date, due_date, clients(name)')
          .eq('team_id', teamId)
          .gte('issue_date', since.toIso8601String().split('T')[0])
          .order('issue_date');

      // ── Fetch expenses (6 months) ──────────────────────────────────────────
      final expRows = await SupabaseService.client
          .from('expenses')
          .select('amount, category, expense_date')
          .eq('user_id', userId)
          .gte('expense_date', since.toIso8601String().split('T')[0]);

      // ── Process Invoices ───────────────────────────────────────────────────
      double totalBilled = 0;
      double totalPaid = 0;
      double totalDaysToPaySum = 0;
      int paidCount = 0;
      final clientMap = <String, Map<String, dynamic>>{};
      final monthlyPaid = <String, double>{};

      for (final row in invRows) {
        final rawAmount = _toDouble(row['total_amount']);
        final code = row['currency_code'] as String? ?? 'USD';
        final amount = CurrencyService.convert(rawAmount, code, baseCurrency);
        
        final status = row['status'] as String? ?? 'draft';
        final issueStr = row['issue_date'] as String? ?? '';
        final clientName = (row['clients'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown';

        if (status == 'draft' || status == 'cancelled') continue;
        totalBilled += amount;

        // Client reliability tracking
        if (!clientMap.containsKey(clientName)) {
          clientMap[clientName] = {
            'billed': 0.0,
            'paid': 0.0,
            'invoiceCount': 0,
            'overdueCount': 0,
            'daysSum': 0.0,
            'paidCount': 0,
          };
        }
        clientMap[clientName]!['billed'] = (clientMap[clientName]!['billed'] as double) + amount;
        clientMap[clientName]!['invoiceCount'] = (clientMap[clientName]!['invoiceCount'] as int) + 1;

        if (status == 'paid') {
          totalPaid += amount;
          paidCount++;

          // Precise DSO: use actual paid_at timestamp
          final paidAtStr = row['paid_at'] as String?;
          if (issueStr.length >= 10 && paidAtStr != null && paidAtStr.length >= 10) {
            try {
              final issue  = DateTime.parse(issueStr);
              final paidAt = DateTime.parse(paidAtStr);
              final days   = paidAt.difference(issue).inDays.abs().toDouble();
              totalDaysToPaySum += days;
              clientMap[clientName]!['paidCount'] = (clientMap[clientName]!['paidCount'] as int) + 1;
              clientMap[clientName]!['daysSum'] = (clientMap[clientName]!['daysSum'] as double) + days;
              clientMap[clientName]!['paid'] = (clientMap[clientName]!['paid'] as double) + amount;
            } catch (_) {}
          }

          // Monthly bucket for cash flow
          if (issueStr.length >= 7) {
            final key = issueStr.substring(0, 7);
            monthlyPaid[key] = (monthlyPaid[key] ?? 0) + amount;
          }
        } else if (status == 'overdue') {
          clientMap[clientName]!['overdueCount'] = (clientMap[clientName]!['overdueCount'] as int) + 1;
        }
      }

      // ── Process Expenses ───────────────────────────────────────────────────
      double totalExpenses = 0;
      final expCategoryMap = <String, double>{};
      final monthlyExp = <String, double>{};

      for (final row in expRows) {
        final rawAmount = _toDouble(row['amount']);
        final amount = rawAmount;
        
        final category = row['category'] as String? ?? 'General';
        final dateStr = row['expense_date'] as String? ?? '';

        totalExpenses += amount;
        expCategoryMap[category] = (expCategoryMap[category] ?? 0) + amount;

        if (dateStr.length >= 7) {
          final key = dateStr.substring(0, 7);
          monthlyExp[key] = (monthlyExp[key] ?? 0) + amount;
        }
      }

      // ── Compute KPIs ───────────────────────────────────────────────────────
      _dso = paidCount > 0 ? totalDaysToPaySum / paidCount : 0;
      _collectionRate = totalBilled > 0 ? (totalPaid / totalBilled) * 100 : 0;

      const months = 6;
      _burnRate = months > 0 ? totalExpenses / months : 0;
      _currentBalance = totalPaid - totalExpenses;
      _cashRunway = _burnRate > 0 ? _currentBalance / _burnRate : 99;

      // ── Cash Flow Forecast (6 months history + 3 projected) ───────────────
      final allKeys = <String>{...monthlyPaid.keys, ...monthlyExp.keys}.toList()..sort();
      final points = <CashFlowPoint>[];

      for (final key in allKeys) {
        final paid = monthlyPaid[key] ?? 0;
        final exp = monthlyExp[key] ?? 0;
        final date = DateTime.parse('$key-01');
        points.add(CashFlowPoint(
          date: date,
          projected: 0,
          actual: paid - exp,
          label: _monthLabel(key),
        ));
      }

      // ── Seasonal Trend Analysis ──────────────────────────────────────────
      final last3 = points.where((p) => p.actual != 0).toList().reversed.take(3).toList();
      if (last3.isNotEmpty) {
        final avgNet = last3.fold(0.0, (s, p) => s + p.actual) / last3.length;
        _projectedNextMonth = avgNet;

        // Calculate Seasonality Index
        final seasonalityMap = _calculateSeasonalityIndex(allKeys, monthlyPaid, monthlyExp);

        for (int i = 1; i <= 3; i++) {
          final projDate = DateTime.now().add(Duration(days: i * 30));
          final key = '${projDate.year}-${projDate.month.toString().padLeft(2, '0')}';
          final monthInt = projDate.month;
          final seasonalFactor = seasonalityMap[monthInt] ?? 1.0;

          if (!allKeys.contains(key)) {
            points.add(CashFlowPoint(
              date: projDate,
              projected: avgNet * seasonalFactor,
              actual: 0,
              label: '${_monthLabel(key)}*',
            ));
          }
        }
      }
      _cashFlowPoints = points;

      // ── Client Reliability ─────────────────────────────────────────────────
      final reliabilityList = clientMap.entries.map((e) {
        final data = e.value;
        final pc = data['paidCount'] as int;
        final avg = pc > 0 ? (data['daysSum'] as double) / pc : 0.0;
        return ClientReliability(
          name: e.key,
          totalBilled: data['billed'] as double,
          totalPaid: data['paid'] as double,
          avgDaysToPay: avg,
          invoiceCount: data['invoiceCount'] as int,
          overdueCount: data['overdueCount'] as int,
        );
      }).toList()
        ..sort((a, b) => b.reliabilityScore.compareTo(a.reliabilityScore));
      _clientReliability = reliabilityList.take(8).toList();

      // ── Expense Burns ──────────────────────────────────────────────────────
      const categoryColors = <String, Color>{
        'Marketing': Color(0xFF8B5CF6),
        'Utilities': Color(0xFFF59E0B),
        'Office': Color(0xFF06B6D4),
        'Travel': Color(0xFF10B981),
        'Salaries': Color(0xFFEF4444),
        'General': Color(0xFF6366F1),
        'Software': Color(0xFF3B82F6),
        'Equipment': Color(0xFFEC4899),
      };
      _expenseBurns = expCategoryMap.entries.map((e) {
        return ExpenseBurn(
          category: e.key,
          amount: e.value,
          color: categoryColors[e.key] ?? const Color(0xFF64748B),
        );
      }).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount));

      // ── Generate Smart Alerts ──────────────────────────────────────────────
      _alerts = _generateAlerts();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  List<SmartAlert> _generateAlerts() {
    final alerts = <SmartAlert>[];

    if (_dso > 45) {
      alerts.add(SmartAlert(
        title: 'Slow Collections Detected',
        body: 'Clients are taking an average of ${_dso.toStringAsFixed(0)} days to pay.',
        type: SmartAlertType.warning,
        icon: Icons.access_time_rounded,
      ));
    }

    if (_cashRunway < 3 && _cashRunway > 0) {
      alerts.add(SmartAlert(
        title: 'Low Cash Runway',
        body: 'You have less than 3 months of operating cash left.',
        type: SmartAlertType.danger,
        icon: Icons.warning_amber_rounded,
      ));
    }

    if (_collectionRate < 75) {
      alerts.add(SmartAlert(
        title: 'Low Collection Rate',
        body: 'Only ${_collectionRate.toStringAsFixed(0)}% of billed revenue is collected.',
        type: SmartAlertType.danger,
        icon: Icons.money_off_rounded,
      ));
    }

    final problematicClients = _clientReliability.where((c) => c.reliabilityScore < 40).toList();
    if (problematicClients.isNotEmpty) {
      alerts.add(SmartAlert(
        title: 'Client Reliability Risk',
        body: '${problematicClients.length} clients have low reliability scores.',
        type: SmartAlertType.warning,
        icon: Icons.person_remove_rounded,
      ));
    }

    final nextProj = _cashFlowPoints.firstWhere((p) => p.actual == 0, orElse: () => _cashFlowPoints.last).projected;
    final lastActual = _cashFlowPoints.where((p) => p.actual != 0).lastOrNull?.actual ?? 0;
    
    if (lastActual > 0) {
      if (nextProj > lastActual * 1.2) {
        alerts.add(SmartAlert(
          title: 'High-Season Peak',
          body: 'Historical data suggests a high-performance period ahead.',
          type: SmartAlertType.insight,
          icon: Icons.auto_graph_rounded,
        ));
      } else if (nextProj < lastActual * 0.8 && nextProj > 0) {
        alerts.add(SmartAlert(
          title: 'Low-Season Dip',
          body: 'Next month is historically a slower period.',
          type: SmartAlertType.warning,
          icon: Icons.vertical_align_bottom_rounded,
        ));
      }
    }

    return alerts;
  }

  Map<int, double> _calculateSeasonalityIndex(List<String> keys, Map<String, double> paid, Map<String, double> exp) {
    final monthTotals = <int, List<double>>{};
    double grandTotal = 0;
    int count = 0;

    for (final key in keys) {
      final net = (paid[key] ?? 0) - (exp[key] ?? 0);
      final month = int.parse(key.substring(5, 7));
      
      if (!monthTotals.containsKey(month)) monthTotals[month] = [];
      monthTotals[month]!.add(net);
      grandTotal += net;
      count++;
    }

    if (count == 0) return {};
    final avgNet = grandTotal / count;
    if (avgNet == 0) return {};

    final result = <int, double>{};
    monthTotals.forEach((month, values) {
      final monthAvg = values.fold(0.0, (s, v) => s + v) / values.length;
      result[month] = (monthAvg / avgNet).clamp(0.6, 1.4);
    });

    return result;
  }

  static double _toDouble(dynamic val) => double.tryParse(val?.toString() ?? '0') ?? 0;
  static String _monthLabel(String key) {
    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    try {
      final m = int.parse(key.substring(5, 7));
      return labels[m - 1];
    } catch (_) {
      return '?';
    }
  }
}
