// lib/core_v2/services/session_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';

class SessionService {
  /// UPSERT: creates or updates current session. Never creates duplicates.
  static Future<void> upsertCurrentSession(String userId) async {
    try {
      final deviceName = kIsWeb ? 'Web Browser'
          : Platform.isAndroid ? 'Android Device'
          : Platform.isIOS    ? 'iOS Device'
          : 'Unknown Device';

      await SupabaseService.client.from('user_sessions').upsert({
        'user_id':     userId,
        'device_name': deviceName,
        'last_active': DateTime.now().toIso8601String(),
        'is_current':  true,
      }, onConflict: 'user_id,device_name');
    } catch (e) {
      debugPrint('[SessionService] upsert skipped: $e');
    }
  }

  /// Load real sessions for a user from DB.
  static Future<List<Map<String, dynamic>>> loadSessions(String userId) async {
    try {
      final res = await SupabaseService.client
          .from('user_sessions')
          .select()
          .eq('user_id', userId)
          .order('last_active', ascending: false);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint('[SessionService] load failed: $e');
      return [];
    }
  }

  /// Revoke a specific session.
  static Future<bool> revokeSession(String sessionId) async {
    try {
      await SupabaseService.client
          .from('user_sessions').delete().eq('id', sessionId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
