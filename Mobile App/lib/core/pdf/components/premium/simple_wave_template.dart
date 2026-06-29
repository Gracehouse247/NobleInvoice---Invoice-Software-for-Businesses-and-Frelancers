// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleWaveTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleWaveTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF6B00); // Vibrant Orange
    const secondary = Color(0xFF0F172A); // Dark Navy
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: WavePainter(primary: primary, secondary: secondary))),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (business.logoUrl != null) 
                            Image.network(business.logoUrl!, height: 45)
                          else
                            const Icon(Icons.waves_rounded, color: Colors.white, size: 45),
                          const SizedBox(height: 8),
                          Text(business.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const Text('INVOICE', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMeta('BILL TO', invoice.client.name, invoice.client.email)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMeta('DATE', invoice.issueDate.toString().split(' ')[0], 'INV #${invoice.id}')),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildTable(secondary),
                  const SizedBox(height: 24),
                  buildTotals(),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 60,
                    child: CustomPaint(painter: WaveFooterPainter(primary: primary, secondary: secondary)),
                  ),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTable(Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('QTY', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))),
              Expanded(child: Text('TOTAL', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))),
            ],
          ),
        ),
        ...invoice.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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

class WavePainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  WavePainter({required this.primary, required this.secondary});
  @override
  void paint(Canvas canvas, Size size) {
    final p2 = Paint()..color = secondary;
    final path2 = Path();
    path2.lineTo(0, size.height * 0.7);
    path2.quadraticBezierTo(size.width * 0.5, size.height, size.width, size.height * 0.7);
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, p2);

    final p1 = Paint()..color = primary;
    final path1 = Path();
    path1.moveTo(size.width * 0.4, 0);
    path1.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width, size.height * 0.3);
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, p1);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaveFooterPainter extends CustomPainter {
  final Color primary;
  final Color secondary;
  WaveFooterPainter({required this.primary, required this.secondary});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = primary;
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.3);
    path1.quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.6, size.height * 0.6);
    path1.lineTo(size.width * 0.6, size.height);
    path1.close();
    canvas.drawPath(path1, p1);

    final p2 = Paint()..color = secondary;
    final path2 = Path();
    path2.moveTo(size.width, size.height);
    path2.lineTo(size.width, size.height * 0.1);
    path2.quadraticBezierTo(size.width * 0.6, size.height * 0.4, size.width * 0.4, size.height);
    path2.close();
    canvas.drawPath(path2, p2);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Modern Template ───────────────────────────────────────────────────