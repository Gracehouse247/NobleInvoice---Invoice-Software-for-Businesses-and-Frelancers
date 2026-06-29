import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/widgets/glass_container.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:provider/provider.dart';

class PredictiveActionHub extends StatelessWidget {
  const PredictiveActionHub({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceCtrl = context.watch<InvoiceController>();
    final now = DateTime.now();
    final isEndOfMonth = now.day >= 25;
    final overdueCount = invoiceCtrl.summary.overdueCount;

    final List<Widget> cards = [];

    if (overdueCount > 0) {
      cards.add(_buildActionCard(
        context,
        icon: Icons.notification_important_rounded,
        title: 'Send Overdue Reminders',
        subtitle: '$overdueCount clients have outstanding payments.',
        color: Colors.orange,
        onTap: () => Navigator.pushNamed(context, '/invoice-dashboard', arguments: {'filter': 'overdue'}),
      ));
    }

    if (isEndOfMonth) {
      cards.add(_buildActionCard(
        context,
        icon: Icons.auto_awesome_rounded,
        title: 'Generate Monthly Retainers',
        subtitle: 'It\'s month-end. Automated invoices are ready.',
        color: AppColors.primary,
        onTap: () => Navigator.pushNamed(context, '/create-recurring-invoice'),
      ));
    }

    // Default card if nothing predictive
    if (cards.isEmpty) {
      cards.add(_buildActionCard(
        context,
        icon: Icons.insights_rounded,
        title: 'Revenue Forecast',
        subtitle: 'See your projected income for next month.',
        color: const Color(0xFF6366F1),
        onTap: () => Navigator.pushNamed(context, '/financial-intelligence'),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('PREDICTIVE HUB', style: TextStyle(color: Colors.blueGrey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            SizedBox(width: 8),
            Icon(Icons.auto_fix_high_rounded, color: Colors.blueGrey, size: 14),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: cards,
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          borderRadius: BorderRadius.circular(24),
          opacity: 0.8,
          blur: 20,
          border: Border.all(color: color.withOpacity(0.1), width: 1.5),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, 
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A), letterSpacing: -0.5),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(subtitle, 
                      style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.blueGrey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}
