// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulPinkMagentaTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulPinkMagentaTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFC2185B); // Pink Magenta
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
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [accent, accent.withOpacity(0.7)])),
      child: Center(child: Text('INVOICE', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 4))),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: accent)), child: const Row(children: [
        Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
        Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
      ])),
      ...invoice.items.map((item) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: accent.withOpacity(0.2)))),
        child: Row(children: [
          Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 11))),
          Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11))),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: accent.withOpacity(0.1),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('TOTAL DUE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(fmtMoney(invoice.totalAmount), style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 20)),
      ]),
    );
  }
}

// 5. Colorful Blue Corporate