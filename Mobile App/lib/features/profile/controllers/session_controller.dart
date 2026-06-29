// lib/features/profile/controllers/session_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/session_service.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/profile/models/session_model.dart';

class SessionController extends ChangeNotifier {
  List<UserSession> _sessions = [];
  bool _isLoading = false;

  List<UserSession> get sessions => _sessions;
  bool get isLoading => _isLoading;

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId != null) {
        final raw = await SessionService.loadSessions(userId);
        _sessions = raw.map((s) => UserSession.fromJson(s)).toList();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> revokeSession(String sessionId) async {
    try {
      await SessionService.revokeSession(sessionId);
      _sessions.removeWhere((s) => s.id == sessionId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error revoking session: $e');
      return false;
    }
  }
}
