// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulFullOrangeTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulFullOrangeTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Colors.white;
    const background = Color(0xFFFF6D00); // Bright Orange
    return Container(
      color: background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Theme(
                data: ThemeData.dark(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      ...invoice.items.map((item) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.5))),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total), style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('TOTAL AMOUNT', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(fmtMoney(invoice.totalAmount), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      ]),
    );
  }
}

// 16. Colorful Blue Banner