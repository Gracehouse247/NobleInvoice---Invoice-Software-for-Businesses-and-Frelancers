// lib/features/invoicing/widgets/colorful_invoice_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_template_components.dart';

// ── Batch 1: Templates 1-10 ───────────────────────────────────────────────

// 1. Colorful Yellow Burst

class ColorfulNavyDiagonalTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const ColorfulNavyDiagonalTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF1A237E); // Navy
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
          ClipPath(
            clipper: DiagonalHeaderClipper(),
            child: Container(color: accent),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (business.logoUrl != null) Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Image.network(business.logoUrl!, height: 40, width: 40)),
                    const SizedBox(height: 12),
                    Text(business.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  ],
                ),
                Text('INVOICE', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemsTableWithHeader(Color accent) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: accent),
        child: const Row(children: [
          Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
          Expanded(child: Text('QTY', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
          Expanded(child: Text('PRICE', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
          Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
        ]),
      ),
      ...invoice.items.map((item) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
        child: Row(children: [
          Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 11))),
          Expanded(child: Text('${item.quantity}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
          Expanded(child: Text(fmtMoney(item.unitPrice), textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
          Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
        ]),
      )),
    ]);
  }

  Widget buildTotalsWithAccent(Color accent) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Subtotal: ${fmtMoney(invoice.subtotal)}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text('TOTAL: ${fmtMoney(invoice.totalAmount)}', style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 20)),
        ],
      ),
    );
  }
}

class DiagonalHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 3. Colorful Navy Hex