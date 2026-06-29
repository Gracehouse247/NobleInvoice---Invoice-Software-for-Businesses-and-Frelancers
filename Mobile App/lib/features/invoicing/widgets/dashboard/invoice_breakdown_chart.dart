import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';

class InvoiceBreakdownChart extends StatelessWidget {
  final InvoiceController ctrl;

  const InvoiceBreakdownChart({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invoice Breakdown',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF0F172A), letterSpacing: -0.8),
                  ),
                  Text('Distribution by status', style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle),
                child: const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusBar(ctrl, 'paid',    const [Color(0xFF22C55E), Color(0xFF16A34A)], 'Paid'),
                _buildStatusBar(ctrl, 'pending', const [Color(0xFFF59E0B), Color(0xFFD97706)], 'Pending'),
                _buildStatusBar(ctrl, 'overdue', const [Color(0xFFEF4444), Color(0xFFDC2626)], 'Overdue'),
                _buildStatusBar(ctrl, 'draft',   const [Color(0xFF94A3B8), Color(0xFF64748B)], 'Draft'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(InvoiceController ctrl, String status, List<Color> colors, String label) {
    final total = ctrl.invoices.length;
    final count = ctrl.invoices.where((i) => i.status == status).length;
    final ratio = total > 0 ? count / total : 0.0;
    final primaryColor = colors[0];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: primaryColor),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 44,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastOutSlowIn,
              width: 44,
              height: (120 * ratio).clamp(24.0, 120.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 1.5,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey[400], letterSpacing: 0.5),
        ),
      ],
    );
  }
}
