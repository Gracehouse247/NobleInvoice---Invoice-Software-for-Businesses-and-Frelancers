import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/invoice_pdf_service.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:printing/printing.dart';

class LiveInvoicePreview extends StatelessWidget {
  final Invoice invoice;
  final PdfTemplate template;
  final BusinessInfo business;
  final bool compact;

  const LiveInvoicePreview({
    super.key,
    required this.invoice,
    required this.template,
    required this.business,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 12 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(compact ? 12 : 24),
        child: PdfPreview(
          build: (format) => InvoicePdfService.generateBytes(
            invoice,
            template: template,
            business: business,
          ),
          useActions: false,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          loadingWidget: const Center(child: CircularProgressIndicator.adaptive()),
          // Error handling for incomplete draft data
          onError: (context, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.grey, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Preview will update as you add items.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
