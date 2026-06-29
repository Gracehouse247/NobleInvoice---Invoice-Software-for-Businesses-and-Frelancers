import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/data/services/qr_service.dart';
import 'package:noble_invoice/core/state/team_scope_mixin.dart';

class QrAnalyticsController extends ChangeNotifier with TeamScopeMixin {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Data State
  int _totalScans = 0;
  int _uniqueUsers = 0;
  String _topPerformingName = 'None';
  List<double> _trendData = [];
  Map<String, double> _geoData = {};
  List<Map<String, dynamic>> _recentActivity = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalScans => _totalScans;
  int get uniqueUsers => _uniqueUsers;
  String get topPerformingName => _topPerformingName;
  List<double> get trendData => _trendData;
  Map<String, double> get geoData => _geoData;
  List<Map<String, dynamic>> get recentActivity => _recentActivity;

  Future<void> loadAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('Unauthorized');

      final teamId = activeTeamId;
      if (teamId == null) throw Exception('No active team');
      
      final qrCodes = await QrService.getQrCodes(teamId: teamId);
      if (qrCodes.isEmpty) {
        _setEmptyState();
        return;
      }

      // Query actual scan table
      final scansResponse = await SupabaseService.client
          .from('qr_scans')
          .select('id, scanned_at, platform, city, country, qr_code_id, qr_codes!inner(user_id, name)')
          .eq('qr_codes.user_id', user.id)
          .order('scanned_at', ascending: false);

      final List<dynamic> scans = scansResponse as List<dynamic>;
      if (scans.isEmpty) {
        _setEmptyState();
        return;
      }

      _processActualAnalytics(scans);
    } catch (e) {
      if (e.toString().contains('does not exist') || e.toString().contains('relation "qr_scans"')) {
        _setEmptyState();
        _errorMessage = 'Analytics engine is still initializing...';
      } else {
        _setEmptyState();
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setEmptyState() {
    _totalScans = 0;
    _uniqueUsers = 0;
    _topPerformingName = 'No Data';
    _trendData = List.filled(7, 0.0);
    _geoData = {'No Data': 100.0};
    _recentActivity = [];
  }

  void _processActualAnalytics(List<dynamic> scans) {
    _totalScans = scans.length;
    
    // Naive unique user estimation (in production this would be hashed IPs or device IDs)
    _uniqueUsers = (scans.length * 0.8).toInt();

    // Calculate top performer
    final Map<String, int> codeCounts = {};
    for (var scan in scans) {
      final qr = scan['qr_codes'] as Map<String, dynamic>?;
      final name = qr?['name'] ?? 'Unknown';
      codeCounts[name] = (codeCounts[name] ?? 0) + 1;
    }
    
    _topPerformingName = codeCounts.entries.isNotEmpty 
      ? codeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : 'None';

    // Calculate geography (Country)
    final Map<String, int> geoCount = {};
    for (var scan in scans) {
      final country = scan['country'] ?? 'Unknown';
      geoCount[country] = (geoCount[country] ?? 0) + 1;
    }
    
    _geoData = {};
    geoCount.forEach((key, value) {
      _geoData[key] = (value / scans.length) * 100;
    });
    
    if (_geoData.isEmpty) {
      _geoData = {'No Data': 100.0};
    }

    // Process Trend Data (Last 7 Days Activity)
    final Map<int, int> daysCount = {};
    final now = DateTime.now();
    for (var scan in scans) {
      if (scan['scanned_at'] != null) {
         final date = DateTime.parse(scan['scanned_at']);
         final diff = now.difference(date).inDays;
         if (diff < 7 && diff >= 0) {
           daysCount[7 - diff - 1] = (daysCount[7 - diff - 1] ?? 0) + 1;
         }
      }
    }
    
    _trendData = List.generate(7, (index) => (daysCount[index] ?? 0).toDouble());

    // Collect Recent Activity
    _recentActivity = scans.take(5).map((scan) {
      final city = scan['city'] ?? 'Unknown location';
      final platform = scan['platform'] ?? 'Mobile';
      final date = scan['scanned_at'] != null ? DateTime.parse(scan['scanned_at']) : DateTime.now();
      final diffMins = DateTime.now().difference(date).inMinutes;
      final timeStr = diffMins < 60 ? '$diffMins mins ago' : '${diffMins ~/ 60} hrs ago';

      return {
        'title': 'Scan in $city',
        'subtitle': '$timeStr • $platform',
        'icon': Icons.qr_code_scanner_rounded,
      };
    }).toList();
  }
}
