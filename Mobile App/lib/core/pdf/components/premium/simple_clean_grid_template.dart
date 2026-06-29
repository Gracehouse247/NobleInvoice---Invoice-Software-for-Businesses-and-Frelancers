// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleCleanGridTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleCleanGridTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (business.logoUrl != null) Image.network(business.logoUrl!, height: 60),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('INVOICE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 8)),
                      SizedBox(height: 4),
                      Text('ESTABLISHED 2024', style: TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 2)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
                child: Row(
                  children: [
                    Expanded(child: _buildMeta('ISSUED BY', business.name, (business.businessEmail ?? ''))),
                    Container(width: 1, height: 40, color: Colors.grey.shade200),
                    const SizedBox(width: 24),
                    Expanded(child: _buildMeta('BILLING TO', invoice.client.name, invoice.client.email)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildTable(),
              const SizedBox(height: 32),
              Align(alignment: Alignment.centerRight, child: buildTotals()),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildPaymentDetails(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('AUTHORIZED SIGNATURE', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(width: 120, height: 1, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeta(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 6),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300))),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('ITEM DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey))),
              Expanded(child: Text('SUBTOTAL', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400))),
              Expanded(child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
        )),
      ],
    );
  }
}

// ── Simple Minimalist Template ──────────────────────────────────────────────