// lib/features/invoicing/widgets/invoice_maker_simple_templates.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/invoice_preview_templates.dart';

// ── Simple Diamond Template ──────────────────────────────────────────────────

class SimpleDiamondTemplate extends StatelessWidget with InvoiceTemplateHelpers {
  @override final Invoice invoice;
  @override final BusinessInfo business;
  @override final String Function(double) fmtMoney;
  const SimpleDiamondTemplate({super.key, required this.invoice, required this.business, required this.fmtMoney});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6); // Blue-500
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, bottom: 0, width: 24, child: CustomPaint(painter: DiamondBorderPainter(color: accent))),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 32, 32, 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text('INVOICE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: accent, letterSpacing: -1))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('No. ${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(invoice.issueDate.toString().split(' ')[0], style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoBlock('FROM', business.name, (business.businessEmail ?? ''))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoBlock('BILL TO', invoice.client.name, invoice.client.email)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  buildTypeMetadata(),
                  _buildTable(),
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

  Widget _buildInfoBlock(String label, String name, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: accent, letterSpacing: 1)),
        const SizedBox(height: 6),
        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
      ],
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4)),
          child: const Row(
            children: [
              Expanded(flex: 4, child: Text('Description', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(child: Text('Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(child: Text('Total', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
        ...invoice.items.asMap().entries.map((e) {
          final item = e.value;
          final isOdd = e.key % 2 != 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isOdd ? accent.withOpacity(0.05) : Colors.transparent,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(flex: 4, child: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
                Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.center, child: Text('${item.quantity}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)))),
                Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(fmtMoney(item.unitPrice), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12)))),
                Expanded(child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerRight, child: Text(fmtMoney(item.total), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class DiamondBorderPainter extends CustomPainter {
  final Color color;
  DiamondBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = color;
    final paint2 = Paint()..color = const Color(0xFF1E293B); // Dark slate
    
    double y = 0;
    bool alternate = false;
    while (y < size.height) {
      final p = Path();
      final centerX = size.width / 2;
      final centerY = y + 15;
      
      p.moveTo(centerX, centerY - 12);
      p.lineTo(centerX + 10, centerY);
      p.lineTo(centerX, centerY + 12);
      p.lineTo(centerX - 10, centerY);
      p.close();
      
      canvas.drawPath(p, alternate ? paint2 : paint1);
      y += 35;
      alternate = !alternate;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Simple Blobs Template ────────────────────────────────────────────────────