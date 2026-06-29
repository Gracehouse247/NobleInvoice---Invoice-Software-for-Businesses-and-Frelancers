// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimplePillTotalTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimplePillTotalTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('INVOICE', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -2)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('INV NO: #${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(invoice.issueDate.toString().split(' ')[0], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildBlock('FROM', business.name, (business.businessEmail ?? ''))),
                Expanded(child: _buildBlock('BILL TO', invoice.client.name, invoice.client.email)),
              ],
            ),
            const SizedBox(height: 40),
            _buildTable(),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(100)),
                  child: Column(
                    children: [
                      const Text('Total Amount', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(fmtMoney(invoice.totalAmount), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                buildTotals(),
              ],
            ),
            const SizedBox(height: 40),
            buildFooter(),
          ],
        ),
       ),
      ),
    );
  }

  Widget _buildBlock(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1.5))),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
              Expanded(child: Text('PRICE', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
              Expanded(child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            ],
          ),
        )),
      ],
    );
  }
}

// ── Simple Arrow Label Template ──────────────────────────────────────────────