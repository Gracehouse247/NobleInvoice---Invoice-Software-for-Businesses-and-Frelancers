// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleAngledTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleAngledTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1E3A8A); // Deep Blue
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: AngledTabPainter(color: primary))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (business.logoUrl != null) 
                            Image.network(business.logoUrl!, height: 45)
                          else
                            const Icon(Icons.business_rounded, color: Colors.white, size: 45),
                          const SizedBox(height: 12),
                          Text(business.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                        ],
                      ),
                      const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildBlock('BILL TO', invoice.client.name, invoice.client.email)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildBlock('INVOICE NO', invoice.id, invoice.issueDate.toString().split(' ')[0])),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTable(primary),
                  const SizedBox(height: 32),
                  buildTotals(),
                  const SizedBox(height: 40),
                  buildPaymentDetails(),
                  const SizedBox(height: 40),
                  buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 6),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable(Color primary) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2)),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
              Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
            ],
          ),
        )),
      ],
    );
  }
}

class AngledTabPainter extends CustomPainter {
  final Color color;
  AngledTabPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.lineTo(0, size.height * 0.85);
    path.lineTo(size.width * 0.4, size.height * 0.85);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Wave Template ─────────────────────────────────────────────────────