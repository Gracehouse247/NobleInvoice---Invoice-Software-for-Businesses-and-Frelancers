// lib/features/invoicing/widgets/dashboard/aging_report_widget.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';

class AgingReportWidget extends StatelessWidget {
  final AgingSummary aging;

  const AgingReportWidget({super.key, required this.aging});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accounts Receivable Aging', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.black)),
                    SizedBox(height: 4),
                    Text('Breakdown of unpaid invoices', 
                      style: TextStyle(fontSize: 11, color: AppColors.darkGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Overdue: ${CurrencyFormatter.format(context, aging.totalOverdue)}',
                  style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildAgingColumn(context, 'Current', aging.current, AppColors.success),
              _buildDivider(),
              _buildAgingColumn(context, '1-30 Days', aging.days1to30, Colors.orange),
              _buildDivider(),
              _buildAgingColumn(context, '31-60 Days', aging.days31to60, Colors.deepOrange),
              _buildDivider(),
              _buildAgingColumn(context, '60+ Days', aging.days61to90 + aging.daysOver90, AppColors.error),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar(context),
        ],
      ),
    );
  }

  Widget _buildAgingColumn(BuildContext context, String label, double amount, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, 
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              CurrencyFormatter.format(context, amount),
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: amount > 0 ? color : AppColors.lightGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final total = aging.current + aging.totalOverdue;
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                if (aging.current > 0)
                  Expanded(flex: (aging.current / total * 100).toInt(), child: Container(color: AppColors.success)),
                if (aging.days1to30 > 0)
                  Expanded(flex: (aging.days1to30 / total * 100).toInt(), child: Container(color: Colors.orange)),
                if (aging.days31to60 > 0)
                  Expanded(flex: (aging.days31to60 / total * 100).toInt(), child: Container(color: Colors.deepOrange)),
                if (aging.days61to90 + aging.daysOver90 > 0)
                  Expanded(flex: ((aging.days61to90 + aging.daysOver90) / total * 100).toInt(), child: Container(color: AppColors.error)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
