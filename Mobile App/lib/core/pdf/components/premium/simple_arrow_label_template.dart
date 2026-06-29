// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleArrowLabelTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleArrowLabelTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF16A34A); // Success Green
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomPaint(
                  size: const Size(180, 50),
                  painter: ArrowBadgePainter(color: accent),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(business.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text((business.businessEmail ?? ''), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMeta('BILL TO', invoice.client.name, invoice.client.email),
                    _buildMeta('INVOICE #', invoice.id, invoice.issueDate.toString().split(' ')[0]),
                  ],
                ),
                const SizedBox(height: 48),
                _buildTable(accent),
                const SizedBox(height: 32),
                buildTotals(),
                const SizedBox(height: 40),
                buildFooter(),
                const SizedBox(height: 24),
                Container(height: 8, color: accent.withOpacity(0.1)),
              ],
            ),
          ),
        ],
      ),
     ),
    );
  }

  Widget _buildMeta(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable(Color accent) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: accent, borderRadius: const BorderRadius.horizontal(right: Radius.circular(30))),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
              Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

class ArrowBadgePainter extends CustomPainter {
  final Color color;
  ArrowBadgePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.lineTo(size.width * 0.85, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.85, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Clean Grid Template ──────────────────────────────────────────────