import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart' as ctrl;

class InvoiceDetailsHeader extends StatelessWidget {
  final ctrl.InvoiceDetails invoice;

  const InvoiceDetailsHeader({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String statusText;

    switch (invoice.status) {
      case 'paid':
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        statusText = 'Paid';
        break;
      case 'pending':
        color = Colors.amber;
        icon = Icons.pending_rounded;
        statusText = 'Pending';
        break;
      case 'overdue':
        color = Colors.red;
        icon = Icons.error_rounded;
        statusText = 'Overdue';
        break;
      default:
        color = Colors.grey;
        icon = Icons.drafts_rounded;
        statusText = invoice.status.toUpperCase();
    }

    final hasBeenOpened = invoice.openedAt != null;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Status Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 6),
                Text(statusText, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          
          // Smart Tracking Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 14),
                const SizedBox(width: 6),
                Text('${invoice.viewCount} Views', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                if (hasBeenOpened) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.done_all, color: AppColors.primary, size: 14),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
