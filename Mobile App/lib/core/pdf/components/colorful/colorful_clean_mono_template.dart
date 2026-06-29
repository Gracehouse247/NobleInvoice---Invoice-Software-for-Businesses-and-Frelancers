// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulCleanMonoTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulCleanMonoTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Colors.black;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text('INVOICE', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 8)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBillTo(),
                  const SizedBox(height: 40),
                  buildItemsTableWithHeader(accent),
                  const SizedBox(height: 40),
                  buildTotalsWithAccent(accent),
                  const SizedBox(height: 40),
                  buildPaymentDetails(),
                  const SizedBox(height: 40),
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
      const Divider(thickness: 2, color: Colors.black),
      const SizedBox(height: 8),
      ...invoice.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(child: Text(item.description.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Text(fmtMoney(item.total), style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      )),
      const SizedBox(height: 8),
      const Divider(thickness: 2, color: Colors.black),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
      Text(fmtMoney(invoice.totalAmount), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
    ]);
  }
}

// 9. Colorful Navy Bold