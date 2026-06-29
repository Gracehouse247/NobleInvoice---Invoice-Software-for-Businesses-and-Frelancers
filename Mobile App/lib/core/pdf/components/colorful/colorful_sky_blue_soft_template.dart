// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulSkyBlueSoftTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulSkyBlueSoftTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4FC3F7); // Light Sky Blue
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
      height: 120,
      width: double.infinity,
      color: accent.withOpacity(0.2),
      child: Center(child: Text('INVOICE', style: TextStyle(color: accent, fontSize: 32, fontWeight: FontWeight.w300, letterSpacing: 10))),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      const Row(children: [
        Expanded(child: Text('ITEM', style: TextStyle(fontWeight: FontWeight.w300))),
        Text('PRICE', style: TextStyle(fontWeight: FontWeight.w300)),
      ]),
      const Divider(),
      ...invoice.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20)),
      Text(fmtMoney(invoice.totalAmount), style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 24)),
    ]);
  }
}

// 15. Colorful Full Orange