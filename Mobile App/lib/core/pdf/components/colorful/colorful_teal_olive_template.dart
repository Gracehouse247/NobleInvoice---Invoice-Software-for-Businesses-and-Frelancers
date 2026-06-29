// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulTealOliveTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulTealOliveTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF004D40);
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(teal),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBillTo(),
                  const SizedBox(height: 20),
                  buildItemsTableWithHeader(teal),
                  const SizedBox(height: 20),
                  buildTotalsWithAccent(teal),
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
      height: 140,
      width: double.infinity,
      color: accent.withOpacity(0.1),
      child: Center(child: Text('INVOICE', style: TextStyle(color: accent, fontSize: 32, fontWeight: FontWeight.w900))),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      ...invoice.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Container(width: 20, height: 2, color: accent),
          const SizedBox(width: 8),
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('TOTAL'),
      Text(fmtMoney(invoice.totalAmount), style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 24)),
    ]);
  }
}

// 20. Colorful Light Slate