// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulBlueCorporateTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulBlueCorporateTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1976D2); // Blue
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
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          if (business.logoUrl != null) Image.network(business.logoUrl!, height: 60, width: 60),
          const SizedBox(height: 16),
          const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      const Row(children: [
        Expanded(flex: 4, child: Text('ITEM', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
      ]),
      const Divider(),
      ...invoice.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(flex: 4, child: Text(item.description)),
          Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Align(alignment: Alignment.centerRight, child: Text('Total: ${fmtMoney(invoice.totalAmount)}', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 24)));
  }
}

// 6. Colorful Teal Green