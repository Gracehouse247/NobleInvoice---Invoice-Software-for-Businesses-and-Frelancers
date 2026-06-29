// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleGeometricTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleGeometricTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFACC15); // Vibrant Yellow
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                Positioned(
                  right: 0, top: 0, width: 220, height: 140,
                  child: CustomPaint(painter: YellowGeometricPainter()),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (business.logoUrl != null) 
                            Image.network(business.logoUrl!, height: 40)
                          else
                            const Icon(Icons.business_center_rounded, size: 40),
                          const SizedBox(height: 8),
                          Text(business.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, right: 8),
                        child: Text('INVOICE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBlock('BILL TO', invoice.client.name, invoice.client.email),
                    _buildBlock('DETAILS', 'INV #${invoice.id}', invoice.issueDate.toString().split(' ')[0]),
                  ],
                ),
                const SizedBox(height: 40),
                _buildTable(primary),
                const SizedBox(height: 32),
                buildTotals(),
                const SizedBox(height: 48),
                buildFooter(),
              ],
            ),
          ),
        ],
      ),
     ),
    );
  }

  Widget _buildBlock(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable(Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          color: color,
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
              Expanded(child: Text('AMOUNT', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.center, child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)))),
              Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))),
            ],
          ),
        )),
      ],
    );
  }
}

class YellowGeometricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0xFFFACC15);
    final paint2 = Paint()..color = Colors.black;
    
    final p1 = Path();
    p1.moveTo(size.width * 0.2, 0);
    p1.lineTo(size.width, 0);
    p1.lineTo(size.width, size.height * 0.8);
    p1.lineTo(size.width * 0.5, size.height);
    p1.close();
    canvas.drawPath(p1, paint1);

    final p2 = Path();
    p2.moveTo(size.width * 0.6, 0);
    p2.lineTo(size.width * 0.7, 0);
    p2.lineTo(size.width, size.height * 0.4);
    p2.lineTo(size.width, size.height * 0.5);
    p2.close();
    canvas.drawPath(p2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// ── Simple Angled Template ───────────────────────────────────────────────────