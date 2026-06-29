// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulOrangeBlobTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulOrangeBlobTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE65100); // Deep Orange
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
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -20, left: -20,
            child: Container(width: 150, height: 150, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          ),
          const Positioned(top: 40, left: 40, child: Text('INV', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold))),
          Padding(
            padding: const EdgeInsets.only(top: 100, right: 32),
            child: Align(alignment: Alignment.topRight, child: Text('INVOICE', style: TextStyle(color: accent, fontSize: 40, fontWeight: FontWeight.w900))),
          ),
        ],
      ),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      ...invoice.items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text(item.description)),
          Text(fmtMoney(item.total), style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Align(alignment: Alignment.centerRight, child: Text('TOTAL: ${fmtMoney(invoice.totalAmount)}', style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 24)));
  }
}

// 14. Colorful Sky Blue Soft