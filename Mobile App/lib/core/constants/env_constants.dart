class EnvConstants {
  // SUPABASE CONFIGURATION (Loaded from Environment)
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://iyvikdxzcpcjivmbiwik.supabase.co');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2');

  // FLUTTERWAVE CONFIGURATION (Loaded from Environment)
  static const String flutterwavePublicKey = String.fromEnvironment('FLW_PUBLIC_KEY', defaultValue: 'FLWPUBK_TEST-69c37a54525731634bd9a9de7007efee-X');
  static const bool flutterwaveIsTestMode = bool.fromEnvironment('FLW_TEST_MODE', defaultValue: true);
  
  // GOOGLE AUTHENTICATION
  static const String googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '940069461087-tgdq2bsgo1rifnep9igif3ccuideve3l.apps.googleusercontent.com');

  // REVENUECAT CONFIGURATION
  static const String rcAndroidKey = String.fromEnvironment('RC_ANDROID_KEY', defaultValue: 'goog_example_key_abc123');
  static const String rciOSKey     = String.fromEnvironment('RC_IOS_KEY',     defaultValue: 'appl_example_key_abc123');
  
  // AI CONFIGURATION
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'AIzaSyBlNRjUq7Zqry4QbfDU-7DWR1WPHnD-4_4');

  static void validate() {
    if (supabaseUrl.isEmpty || supabaseUrl == 'REDACTED') {
      print('WARNING: SUPABASE_URL is missing or REDACTED. Ensure you have valid secrets for production.');
    }
    if (supabaseAnonKey.isEmpty || supabaseAnonKey == 'REDACTED') {
      print('WARNING: SUPABASE_ANON_KEY is missing or REDACTED.');
    }
  }
}
