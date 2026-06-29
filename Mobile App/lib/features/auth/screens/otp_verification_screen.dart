import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 8;
  final List<TextEditingController> _controllers = List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(_otpLength, (_) => FocusNode());

  int _secondsLeft = 60;
  Timer? _timer;
  late String _email;
  bool _emailLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_emailLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['email'] != null) {
        _email = args['email'] as String;
      } else {
        _email = context.read<AuthController>().pendingEmail;
      }
      _emailLoaded = true;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onChanged(String value, int index) {
    // ── Handle Paste ──────────────────────────────────────────────────────────
    if (value.length > 1) {
      final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < _otpLength && i < cleanValue.length; i++) {
        _controllers[i].text = cleanValue[i];
      }
      // Focus last filled or next empty
      final nextIndex = cleanValue.length < _otpLength ? cleanValue.length : _otpLength - 1;
      _focusNodes[nextIndex].requestFocus();
      return;
    }

    // ── Normal Typing ─────────────────────────────────────────────────────────
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent && 
        event.logicalKey == LogicalKeyboardKey.backspace && 
        _controllers[index].text.isEmpty && 
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _handleVerify() async {
    if (_otp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter all 8 digits'),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    final auth = context.read<AuthController>();
    final ok = await auth.verifyOtp(email: _email, otp: _otp);
    if (!mounted) return;
    if (ok) {
      final profileCtrl = context.read<ProfileController>();
      await profileCtrl.loadProfile();
      if (!mounted) return;
      if (profileCtrl.onboardingCompleted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingManager);
      }
    }
  }

  Future<void> _handleResend() async {
    if (_secondsLeft > 0) return;
    final auth = context.read<AuthController>();
    await auth.resendOtp(_email);
    setState(() => _secondsLeft = 60);
    _startTimer();
  }

  Future<void> _openEmailApp() async {
    final url = Uri.parse('mailto:'); 
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = (screenWidth - 48 - (_otpLength * 6)) / _otpLength;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Verify Email',
                  style: AppTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkGrey, height: 1.5, fontSize: 13),
                  children: [
                    const TextSpan(text: "We've sent a code to "),
                    TextSpan(
                        text: _emailLoaded ? _email : '...',
                        style: const TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ── 8-box OTP Input ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) => SizedBox(
                  width: boxWidth.clamp(30.0, 42.0),
                  height: 54,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(), // Dummy node to capture key events
                    onKey: (event) => _handleKeyEvent(event, index),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (val) => _onChanged(val, index),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 22),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                )),
              ),
              
              const SizedBox(height: 32),

              // ── Error Banner ──────────────────────────────────────────────
              if (auth.status == AuthStatus.error) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200)),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.red.shade600, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(auth.errorMessage, style: TextStyle(color: Colors.red.shade700, fontSize: 13))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Open Email App ──────────────────────────────────────────────
              Center(
                child: OutlinedButton.icon(
                  onPressed: _openEmailApp,
                  icon: const Icon(Icons.email_outlined, size: 18),
                  label: const Text('Open Email App'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkGrey,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),

              // ── Resend ────────────────────────────────────────────────────
              Center(
                child: Column(children: [
                  Text("Didn't receive a code?", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _secondsLeft == 0 ? _handleResend : null,
                    child: AnimatedOpacity(
                      opacity: _secondsLeft == 0 ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Resend New Code',
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        if (_secondsLeft > 0) ...[
                          const SizedBox(width: 8),
                          Text('(${_secondsLeft}s)',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGrey, fontWeight: FontWeight.bold)),
                        ],
                      ]),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 40),

              // ── Verify Button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Verify Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 10),
                            Icon(Icons.verified_user_rounded, size: 20),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
