// lib/core/widgets/upgrade_prompt_sheet.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class UpgradePromptSheet extends StatelessWidget {
  final String feature;

  const UpgradePromptSheet({super.key, required this.feature});

  /// Show the upgrade prompt for the given feature.
  static void show(BuildContext context, {required String feature}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UpgradePromptSheet(feature: feature),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _featureInfo[feature] ?? _featureInfo['default']!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 28),
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Icon(info['icon'] as IconData, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            info['title'] as String,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            info['subtitle'] as String,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          // Benefits
          ...(info['benefits'] as List<String>).map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 14),
              ),
              const SizedBox(width: 12),
              Text(b, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            ]),
          )),
          const SizedBox(height: 28),
          // Upgrade CTA
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.pricingPlans);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Upgrade to Noble Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  static const _featureInfo = {
    'clients': {
      'icon': Icons.people_rounded,
      'title': 'Unlimited Clients',
      'subtitle': 'You\'ve reached the 3-client limit on the Free plan.',
      'benefits': [
        'Add unlimited clients',
        'Full CRM with notes & documents',
        'Client revenue tracking',
      ],
    },
    'inventory': {
      'icon': Icons.inventory_2_rounded,
      'title': 'Inventory & Stock Ledger',
      'subtitle': 'Product management is a Noble Pro feature.',
      'benefits': [
        'Unlimited products & services',
        'Stock level tracking',
        'Add items directly to invoices',
      ],
    },
    'pdf_export': {
      'icon': Icons.picture_as_pdf_rounded,
      'title': 'Professional PDF Branding',
      'subtitle': 'Branded PDF export requires Noble Pro.',
      'benefits': [
        'Custom logo & colors on invoices',
        'Professional footer & watermark',
        'High-resolution print quality',
      ],
    },
    'business_card_print': {
      'icon': Icons.credit_card_rounded,
      'title': 'Business Card Export',
      'subtitle': 'Print-ready card export requires Noble Pro.',
      'benefits': [
        '30+ premium card templates',
        '300 DPI print-ready export',
        'Front & back card design',
      ],
    },
    'qr_custom_styles': {
      'icon': Icons.qr_code_2_rounded,
      'title': 'Custom QR Styles',
      'subtitle': 'Branded QR codes require Noble Pro.',
      'benefits': [
        'Custom colors and dot styles',
        'Embed your logo in the QR',
        'Analytics & scan tracking',
      ],
    },
    'advanced_reports': {
      'icon': Icons.analytics_rounded,
      'title': 'Advanced Reports',
      'subtitle': 'Detailed financial reports require Noble Pro.',
      'benefits': [
        'Revenue breakdown by period',
        'Client profitability analysis',
        'Export to CSV & PDF',
      ],
    },
    'team_management': {
      'icon': Icons.groups_rounded,
      'title': 'Team Workspace',
      'subtitle': 'Multi-user collaboration requires Noble Squad.',
      'benefits': [
        'Unlimited team members',
        'Shared client & invoice hub',
        'Team activity audit logs',
      ],
    },
    'default': {
      'icon': Icons.rocket_launch_rounded,
      'title': 'Pro Feature',
      'subtitle': 'This feature requires Noble Pro to unlock.',
      'benefits': [
        'Unlimited clients & invoices',
        'Professional branding tools',
        'Priority support',
      ],
    },
  };
}
