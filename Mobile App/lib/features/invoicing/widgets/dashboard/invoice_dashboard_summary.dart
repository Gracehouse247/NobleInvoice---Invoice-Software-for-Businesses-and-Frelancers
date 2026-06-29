import 'package:flutter/material.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/invoicing/widgets/summary_card.dart';

class InvoiceDashboardSummary extends StatelessWidget {
  final InvoiceController ctrl;

  const InvoiceDashboardSummary({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Outstanding',
            amount: CurrencyFormatter.format(context, ctrl.summary.outstanding),
            subtitle: '${ctrl.invoices.where((i) => i.status == 'pending' || i.status == 'overdue').length} Pending payment',
            color: Colors.amber,
            icon: Icons.pending_actions_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SummaryCard(
            title: 'Collected',
            amount: CurrencyFormatter.format(context, ctrl.summary.paid),
            subtitle: '${ctrl.invoices.where((i) => i.status == 'paid').length} Settled invoices',
            color: Colors.green,
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }
}
