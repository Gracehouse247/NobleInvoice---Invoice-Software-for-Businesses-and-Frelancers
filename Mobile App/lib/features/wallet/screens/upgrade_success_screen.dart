import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class UpgradeSuccessScreen extends StatelessWidget {
  const UpgradeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // ── Background Glow ────────────────────────────────────────────────
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 400, height: 400, 
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: AppColors.primary.withOpacity(0.15)
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Animated Celebration Icon
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: ZoomIn(
                          delay: const Duration(milliseconds: 400),
                          child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryLight, size: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // 2. Success Text
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: const Text(
                      'UPGRADE ACTIVATED',
                      style: TextStyle(color: AppColors.primaryLight, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4.0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: const Text(
                      'Welcome to the Inner Circle',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Your professional toolkit has been upgraded. All premium features, unlimited quotas, and advanced intelligence are now at your command.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 64),
                  
                  // 3. Action Button
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (route) => false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: const Text('EXPLORE YOUR NEW TOOLS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (route) => false),
                      child: Text('NOT NOW', style: TextStyle(color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
