// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulBlueBannerTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulBlueBannerTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1565C0); // Blue
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(accent),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBillTo(),
                  const SizedBox(height: 20),
                  buildItemsTableWithHeader(accent),
                  const SizedBox(height: 20),
                  buildTotalsWithAccent(accent),
                  const SizedBox(height: 20),
                  buildPaymentDetails(),
                  const SizedBox(height: 20),
                  buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color accent) {
    return Container(
      width: double.infinity,
      color: accent,
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          if (business.logoUrl != null) Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Image.network(business.logoUrl!, height: 40, width: 40)),
        ],
      ),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      ...invoice.items.map((item) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border(left: BorderSide(color: accent, width: 4))),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total), style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Align(alignment: Alignment.centerRight, child: Text('TOTAL: ${fmtMoney(invoice.totalAmount)}', style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 24)));
  }
}

// 17. Colorful Clean Lined