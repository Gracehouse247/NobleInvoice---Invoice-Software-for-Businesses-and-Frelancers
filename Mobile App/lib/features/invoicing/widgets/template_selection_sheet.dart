import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noble_invoice/features/shared/widgets/web_engine_view.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';

class TemplateSelectionSheet extends StatelessWidget {
  final Function(PdfTemplate) onSelected;

  const TemplateSelectionSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Column(
          children: [
            // Native drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // WebView fills the rest
            Expanded(
              child: WebEngineView(
                path: '/embed/template-gallery',
                showAppBar: false,
                onMessageReceived: (String message) {
                  try {
                    final Map<String, dynamic> data = jsonDecode(message);
                    if (data['type'] == 'TEMPLATE_SELECTED') {
                      final String templateId = data['payload'];

                      // Map Web App template ID back to PdfTemplate enum
                      // Fall back to 'modern' if there's no exact match
                      PdfTemplate matched;
                      try {
                        matched = PdfTemplate.values.firstWhere(
                          (t) => t.name == templateId || t.name.toLowerCase() == templateId.toLowerCase(),
                        );
                      } catch (_) {
                        matched = PdfTemplate.modern;
                      }

                      onSelected(matched);
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    debugPrint('Error processing template selection from sheet: $e');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
