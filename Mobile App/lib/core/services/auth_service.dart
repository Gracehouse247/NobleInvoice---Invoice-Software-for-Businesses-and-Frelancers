// lib/core_v2/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/core/services/notification_service.dart';
import 'package:noble_invoice/core/services/biometric_service.dart';

class AuthService {
  static bool _listenerInitialized = false;

  /// Call once in AuthController constructor.
  static void initAuthStateListener() {
    if (_listenerInitialized) return;
    _listenerInitialized = true;

    SupabaseService.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == AuthChangeEvent.signedOut || event == AuthChangeEvent.userDeleted) {
        // Force purge of sensitive local data
        await BiometricService.purge();
        _navigateToAuth();
      }
    });
  }

  static void _navigateToAuth() {
    NotificationService.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.onboarding, (_) => false);
  }
}
