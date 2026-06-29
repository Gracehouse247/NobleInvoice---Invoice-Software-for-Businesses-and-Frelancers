import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/clients/models/crm_models.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_list_item_model.dart';
import 'package:intl/intl.dart';

class ClientStatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ClientStatPill({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.darkGrey, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class ClientTimelineItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const ClientTimelineItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Container(width: 2, height: 20, color: Colors.grey.shade200),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class ClientDocCard extends StatelessWidget {
  final ClientDocument doc;
  final VoidCallback onTap;

  const ClientDocCard({super.key, required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ext = doc.name.split('.').last.toUpperCase();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(ext.length > 4 ? ext.substring(0, 4) : ext,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(doc.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis),
            Text('${doc.displaySize} · ${DateFormat('MMM dd, yyyy').format(doc.createdAt)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ])),
          const Icon(Icons.open_in_new_rounded, color: AppColors.primary, size: 18),
        ]),
      ),
    );
  }
}

class ClientInvoiceCard extends StatelessWidget {
  final InvoiceListItem inv;
  final VoidCallback onTap;

  const ClientInvoiceCard({super.key, required this.inv, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _invoiceStatusColor(inv.status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(inv.invoiceNumber ?? '#${inv.id}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(DateFormat('MMM dd, yyyy').format(DateTime.tryParse(inv.issueDate) ?? DateTime.now()),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(CurrencyFormatter.format(context, inv.totalAmount),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(inv.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w900)),
            ),
          ]),
        ]),
      ),
    );
  }

  Color _invoiceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':    return AppColors.success;
      case 'overdue': return AppColors.error;
      case 'pending': return const Color(0xFFF59E0B);
      default:        return AppColors.darkGrey;
    }
  }
}
