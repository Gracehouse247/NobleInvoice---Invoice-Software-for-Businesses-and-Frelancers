// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulYellowBlueSplitTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulYellowBlueSplitTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0D47A1);
    const yellow = Color(0xFFFFD600);
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 120, width: double.infinity, color: blue, child: const Center(child: Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)))),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBillTo(),
                  const SizedBox(height: 20),
                  buildItemsTableWithHeader(blue),
                  const SizedBox(height: 20),
                  buildTotalsWithAccent(yellow),
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

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      ...invoice.items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: accent.withOpacity(0.2))),
        child: Row(children: [
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total), style: TextStyle(color: accent, fontWeight: FontWeight.bold)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: accent,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('TOTAL PAYABLE', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(fmtMoney(invoice.totalAmount), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
      ]),
    );
  }
}

// 19. Colorful Teal Olive