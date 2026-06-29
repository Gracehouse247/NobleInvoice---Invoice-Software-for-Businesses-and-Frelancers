import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/auth/controllers/auth_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/profile/controllers/profile_controller.dart';

class SocialAuthButton extends StatelessWidget {
  final bool isLogin;
  
  const SocialAuthButton({
    super.key,
    this.isLogin = true,
  });

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final auth = context.read<AuthController>();
    final ok = await auth.signInWithGoogle();
    
    if (!context.mounted) return;
    
    if (ok) {
      final profileCtrl = context.read<ProfileController>();
      await profileCtrl.loadProfile();
      
      if (!context.mounted) return;
      
      if (profileCtrl.onboardingCompleted) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingManager);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: auth.isLoading ? null : () => _handleGoogleSignIn(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.lightGrey, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (auth.isLoading)
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              )
            else
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'G', style: TextStyle(color: Colors.blue.shade600,  fontWeight: FontWeight.w900, fontSize: 18)),
                  TextSpan(text: 'o', style: TextStyle(color: Colors.red.shade500,   fontWeight: FontWeight.w900, fontSize: 18)),
                  TextSpan(text: 'o', style: TextStyle(color: Colors.amber.shade600, fontWeight: FontWeight.w900, fontSize: 18)),
                  TextSpan(text: 'g', style: TextStyle(color: Colors.blue.shade600,  fontWeight: FontWeight.w900, fontSize: 18)),
                  TextSpan(text: 'l', style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w900, fontSize: 18)),
                  TextSpan(text: 'e', style: TextStyle(color: Colors.red.shade500,   fontWeight: FontWeight.w900, fontSize: 18)),
                ]),
              ),
            const SizedBox(width: 12),
            Text(
              'Continue with Google',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
