// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleMetallicTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleMetallicTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0, top: 0, bottom: 0, width: 200,
                  child: CustomPaint(painter: MetallicCurvePainter()),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(business.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                          Text((business.businessEmail ?? ''), style: const TextStyle(color: Colors.white60, fontSize: 11)),
                        ],
                      ),
                      const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildMeta('BILL TO', invoice.client.name, invoice.client.email)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMeta('INVOICE NO', invoice.id.toString(), invoice.issueDate.toString().split(' ')[0])),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildTable(),
                  const SizedBox(height: 24),
                  buildTotals(),
                  const SizedBox(height: 32),
                  buildPaymentDetails(),
                  const SizedBox(height: 32),
                  buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(val, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          color: const Color(0xFFF1F5F9),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
              Expanded(child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        )),
      ],
    );
  }
}

class MetallicCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange.shade400, Colors.orange.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(size.width * 0.4, 0);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.5, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Geometric Template ────────────────────────────────────────────────