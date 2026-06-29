import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/core/widgets/animated_interactive_card.dart';
import 'package:noble_invoice/core/widgets/glass_container.dart';
import 'package:noble_invoice/features/expenses/controllers/expense_controller.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class RecentActivityList extends StatelessWidget {
  final InvoiceController invoiceCtrl;
  final ExpenseController expenseCtrl;
  final int? limit;
  final bool showSeeAll;

  const RecentActivityList({
    super.key,
    required this.invoiceCtrl,
    required this.expenseCtrl,
    this.limit,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final allActivities = [
      ...invoiceCtrl.invoices.map((inv) => {
        'type': 'invoice',
        'id': inv.id,
        'icon': Icons.description_rounded,
        'title': inv.clientName,
        'sub': 'Invoice #${inv.invoiceNumber}',
        'amt': '+${CurrencyFormatter.format(context, inv.totalAmount)}',
        'status': inv.status,
        'color': inv.status == 'paid' ? AppColors.success : AppColors.secondary,
        'date': DateTime.tryParse(inv.issueDate) ?? DateTime.fromMillisecondsSinceEpoch(0),
      }),
      ...expenseCtrl.expenses.map((exp) => {
        'type': 'expense',
        'id': exp.id,
        'icon': Icons.shopping_bag_rounded,
        'title': exp.vendorName ?? exp.categoryName ?? 'Expense',
        'sub': DateFormat('MMM dd').format(exp.date),
        'amt': '-${CurrencyFormatter.format(context, exp.amount)}',
        'status': 'logged',
        'color': AppColors.darkGrey,
        'date': exp.date,
      }),
    ];

    // Sort by date descending
    allActivities.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    
    // Take the X most recent
    final items = limit != null ? allActivities.take(limit!).toList() : allActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent History',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.black),
            ),
            if (showSeeAll)
              AnimatedInteractiveCard(
                onTap: () => Navigator.pushNamed(context, AppRoutes.activityHistory),
                child: Text(
                  'See all',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key('${item['type']}_${item['id']}'),
            direction: item['type'] == 'invoice' ? DismissDirection.horizontal : DismissDirection.none,
            background: _buildSwipeBackground(Icons.send_rounded, 'Mark Sent', AppColors.primary, Alignment.centerLeft),
            secondaryBackground: _buildSwipeBackground(Icons.edit_rounded, 'Rapid Edit', Colors.orange, Alignment.centerRight),
            confirmDismiss: (direction) async {
              if (item['type'] == 'invoice') {
                HapticFeedback.mediumImpact();
                if (direction == DismissDirection.startToEnd) {
                  // Mark as Sent
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice marked as Sent!')));
                  return false; // Don't actually remove from list
                } else {
                  // Rapid Edit
                  Navigator.pushNamed(context, AppRoutes.createInvoice, arguments: item['id']);
                  return false;
                }
              }
              return false;
            },
            child: AnimatedInteractiveCard(
              onTap: () {
                if (item['type'] == 'invoice') {
                  Navigator.pushNamed(context, AppRoutes.invoiceDetails, arguments: item['id']);
                } else if (item['type'] == 'expense') {
                  Navigator.pushNamed(context, AppRoutes.expenseHistory);
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: _buildActivityItem(
                context,
                item['icon'] as IconData,
                item['title'] as String,
                item['sub'] as String,
                item['amt'] as String,
                item['color'] as Color,
                statusBadge: item['status'] as String?,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSwipeBackground(IconData icon, String label, Color color, Alignment alignment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[Icon(icon, color: Colors.white), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
          if (alignment == Alignment.centerRight) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white)],
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, IconData icon, String title, String subtitle, String amount, Color amountColor, {String? statusBadge}) {
    return GlassContainer(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(24),
      opacity: 0.75,
      blur: 20,
      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF64748B), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title, 
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -0.2),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (statusBadge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: amountColor.withOpacity(0.1), 
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusBadge.toUpperCase(), 
                          style: TextStyle(
                            color: amountColor, 
                            fontSize: 9, 
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount, 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w800, 
              color: amountColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
