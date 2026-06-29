import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';

class InvoiceListCard extends StatelessWidget {
  final String clientName;
  final String invoiceId;
  final String date;
  final String amount;
  final InvoiceStatus status;
  final VoidCallback? onTap;

  const InvoiceListCard({
    super.key,
    required this.clientName,
    required this.invoiceId,
    required this.date,
    required this.amount,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getStatusColor(status);
    
    return Hero(
      tag: 'invoice-$invoiceId',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Dynamic Client Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.02)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withOpacity(0.1)),
                ),
                child: Icon(
                  _getIconForClient(clientName),
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              // Client & Invoice Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      clientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF0F172A), letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'INV-$invoiceId',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 2, height: 2,
                          decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                        ),
                        Text(
                          date,
                          style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Amount & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amount,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[300], size: 20),
            ],
          ),
        ),
      ),
    ));
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid: return Colors.green;
      case InvoiceStatus.pending: return Colors.amber;
      case InvoiceStatus.overdue: return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getIconForClient(String name) {
    if (name.contains('Corp')) return Icons.business_rounded;
    if (name.contains('Studio')) return Icons.brush_rounded;
    if (name.contains('Tech')) return Icons.computer_rounded;
    return Icons.storefront_rounded;
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color = _getStatusColor(status);
    String text = status == InvoiceStatus.paid ? 'PAID' : (status == InvoiceStatus.pending ? 'PENDING' : (status == InvoiceStatus.overdue ? 'OVERDUE' : 'DRAFT'));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

