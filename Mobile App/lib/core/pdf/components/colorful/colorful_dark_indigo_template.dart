// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulDarkIndigoTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulDarkIndigoTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF311B92); // Dark Indigo
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
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(color: accent, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(80))),
      child: const Center(child: Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 4))),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      Container(color: accent.withOpacity(0.1), padding: const EdgeInsets.all(12), child: const Row(children: [
        Expanded(child: Text('ITEM DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold))),
        Text('SUBTOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
      ])),
      ...invoice.items.map((item) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: accent.withOpacity(0.2)))),
        child: Row(children: [
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: accent, shape: BoxShape.rectangle),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('TOTAL PAYABLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(fmtMoney(invoice.totalAmount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
      ]),
    );
  }
}

// 12. Colorful Charcoal Block