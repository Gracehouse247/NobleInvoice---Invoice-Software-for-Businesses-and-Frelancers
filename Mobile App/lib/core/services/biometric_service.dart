import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  static final _auth = LocalAuthentication();
  static const String _prefKey = 'biometric_enabled';

  /// Check if the device can use biometrics and specifically if Fingerprint is available
  static Future<bool> isFingerprintAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      
      if (!canAuthenticate) return false;

      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      
      // Specifically look for fingerprint on Android/iOS
      return availableBiometrics.contains(BiometricType.fingerprint) || 
             availableBiometrics.contains(BiometricType.strong); // Android often reports 'strong' for fingerprint
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Check if the user has opted-in to biometric login
  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  /// Enable biometric login for the user
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
  }

  /// Start the authentication prompt
  static Future<bool> authenticate({String reason = 'Scan your fingerprint to authenticate'}) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true, // Specifically enforce biometrics over PIN/Pattern fallback
          stickyAuth: true,    // Keep the prompt alive briefly if the app goes to the background
          useErrorDialogs: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Fingerprint Authentication required',
            cancelButton: 'Cancel',
            biometricHint: 'Scan fingerprint to continue',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            localizedFallbackTitle: '', // Don't allow password fallback here
          ),
        ],
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Global purge of biometric settings during logout/expiration
  static Future<void> purge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }
}
