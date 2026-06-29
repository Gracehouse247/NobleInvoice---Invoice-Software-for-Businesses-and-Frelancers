import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class InvoiceTypeSelectionScreen extends StatelessWidget {
  const InvoiceTypeSelectionScreen({super.key});

  // Assign specific color-coding based on the invoice's financial purpose
  Color _getTypeColor(InvoiceType type) {
    switch (type) {
      case InvoiceType.standard:
      case InvoiceType.finalInvoice:
        return Colors.blue.shade600; // Standard Billing
      case InvoiceType.proforma:
      case InvoiceType.progress:
        return Colors.purple.shade500; // Estimates and Projects
      case InvoiceType.commercial:
        return Colors.teal.shade500; // Trade / International
      case InvoiceType.recurring:
        return Colors.green.shade500; // Automated
      case InvoiceType.creditMemo:
      case InvoiceType.debitMemo:
      case InvoiceType.mixed:
        return Colors.orange.shade600; // Adjustments or Complex
      case InvoiceType.estimate:
        return Colors.blueGrey.shade600;
      case InvoiceType.quote:
        return Colors.indigo.shade600;
    }
  }

  IconData _getTypeIcon(InvoiceType type) {
    switch (type) {
      case InvoiceType.standard:     return Icons.receipt_long_rounded;
      case InvoiceType.proforma:     return Icons.description_outlined;
      case InvoiceType.commercial:   return Icons.local_shipping_outlined;
      case InvoiceType.progress:     return Icons.stacked_bar_chart_rounded;
      case InvoiceType.recurring:    return Icons.autorenew_rounded;
      case InvoiceType.finalInvoice: return Icons.done_all_rounded;
      case InvoiceType.creditMemo:   return Icons.arrow_circle_down_rounded;
      case InvoiceType.debitMemo:    return Icons.arrow_circle_up_rounded;
      case InvoiceType.mixed:        return Icons.compare_arrows_rounded;
      case InvoiceType.estimate:     return Icons.architecture_rounded;
      case InvoiceType.quote:        return Icons.request_quote_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Select Invoice Type',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.black, letterSpacing: 0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSelectionHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: InvoiceType.values
                    .map((type) => _buildTypeCard(context, type))
                    .toList(),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are you creating?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.black, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the format that perfectly matches your current billing operation.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(BuildContext context, InvoiceType type) {
    final themeColor = _getTypeColor(type);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context, 
              AppRoutes.createInvoice,
              arguments: type, 
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeColor.withOpacity(0.1),
                      themeColor.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getTypeIcon(type), color: themeColor, size: 26),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  type.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    letterSpacing: -0.2,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
