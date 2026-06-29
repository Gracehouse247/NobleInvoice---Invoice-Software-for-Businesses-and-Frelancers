// lib/features/wallet/widgets/upgrade_prompt_sheet.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class UpgradePromptSheet extends StatelessWidget {
  final String feature;
  final bool isModal;

  const UpgradePromptSheet({
    super.key,
    required this.feature,
    this.isModal = false,
  });

  static Future<void> show(BuildContext context, String feature) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UpgradePromptSheet(feature: feature, isModal: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: isModal 
            ? const BorderRadius.vertical(top: Radius.circular(32))
            : BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Premium Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Unlock $feature',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          
          Text(
            'This feature is exclusive to our Noble Pro & Squad members. Upgrade now to scale your business with elite tools.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 32),
          
          // Benefits list
          _buildBenefitItem(Icons.verified_rounded, 'Advanced Revenue Analytics'),
          _buildBenefitItem(Icons.people_alt_rounded, 'Team Collaboration Tools'),
          _buildBenefitItem(Icons.folder_shared_rounded, 'Unlimited CRM Documents'),
          _buildBenefitItem(Icons.print_rounded, 'High-Resolution Card Exports'),
          
          const SizedBox(height: 40),
          
          ElevatedButton(
            onPressed: () {
              if (isModal) Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.pricingPlans);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: const Text('VIEW PRICING PLANS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          ),
          
          if (isModal) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Maybe Later', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );

    if (isModal) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: content,
      );
    }

    return content;
  }

  Widget _buildBenefitItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF59E0B), size: 18),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
        ],
      ),
    );
  }
}
