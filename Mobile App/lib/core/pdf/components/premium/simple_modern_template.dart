// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleModernTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleModernTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFBBF24); // Amber
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Positioned(right: 0, top: 0, width: 200, height: 150, child: CustomPaint(painter: ModernHeaderPainter(accent: accent))),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (business.logoUrl != null) Image.network(business.logoUrl!, height: 40),
                              const SizedBox(height: 8),
                              Text(business.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text((business.businessEmail ?? ''), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const Text('INVOICE', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: -1)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMeta('BILL TO', invoice.client.name, invoice.client.email)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMeta('INVOICE DETAILS', 'INV #${invoice.id}', 'Due: ${invoice.dueDate.toString().split(' ')[0]}')),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildTable(accent),
                  const SizedBox(height: 32),
                  buildTotals(),
                  const SizedBox(height: 40),
                  buildFooter(),
                  const SizedBox(height: 12),
                  Container(height: 4, width: 60, color: accent),
                  const SizedBox(height: 24),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.grey, letterSpacing: 1.5)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable(Color accent) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: accent, width: 2))),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('AMOUNT', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade50))),
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

class ModernHeaderPainter extends CustomPainter {
  final Color accent;
  ModernHeaderPainter({required this.accent});
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = accent;
    final path1 = Path();
    path1.moveTo(size.width * 0.3, 0);
    path1.lineTo(size.width, 0);
    path1.lineTo(size.width, size.height * 0.7);
    path1.lineTo(size.width * 0.6, size.height * 0.4);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()..color = const Color(0xFF1E293B); // Slate 800
    final path2 = Path();
    path2.moveTo(size.width, size.height * 0.5);
    path2.lineTo(size.width, size.height * 0.8);
    path2.lineTo(size.width * 0.8, size.height * 0.6);
    path2.close();
    canvas.drawPath(path2, paint2);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Immersive Template ────────────────────────────────────────────────