// lib/features/invoicing/widgets/builder_preview.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_model.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/features/invoicing/models/business_info.dart';
import 'package:noble_invoice/features/invoicing/widgets/live_invoice_preview.dart';

class BuilderPreview extends StatelessWidget {
  final Invoice invoice;
  final PdfTemplate template;
  final BusinessInfo business;
  final Widget editor;
  final Widget bottomBar;
  final bool isWide;
  final BoxConstraints constraints;

  const BuilderPreview({
    super.key,
    required this.invoice,
    required this.template,
    required this.business,
    required this.editor,
    required this.bottomBar,
    required this.isWide,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // ── Tablet / Desktop layout ───────────────────────────────────────────────
    if (isWide) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 4, child: editor),
                Container(width: 1, color: AppColors.lightGrey),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: const Color(0xFFF1F5F9),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(children: [
                          const Icon(Icons.remove_red_eye_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          const Text('LIVE PREVIEW',
                            style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569), fontSize: 13)),
                          const Spacer(),
                          _templateBadge(),
                        ]),
                        const SizedBox(height: 16),
                        Expanded(
                          child: LiveInvoicePreview(
                            // Key forces rebuild when template changes
                            key: ValueKey(template.name),
                            invoice: invoice,
                            template: template,
                            business: business,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomBar,
        ],
      );
    }

    // ── Mobile layout ─────────────────────────────────────────────────────────
    // bottomBar lives BELOW the Stack — the draggable sheet can never cover it.
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Editor (without its own bottom bar — it's been moved below)
              editor,

              // Draggable preview sheet
              // ValueKey on template.name forces the sheet to fully rebuild
              // whenever the user switches templates in the builder.
              DraggableScrollableSheet(
                key: ValueKey(template.name),
                initialChildSize: 0.09,
                minChildSize: 0.07,
                maxChildSize: 0.88,
                snapSizes: const [0.09, 0.50, 0.88],
                snap: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        // ── Drag handle ──────────────────────────────────────
                        Center(
                          child: Container(
                            width: 40, height: 5,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // ── Header row ───────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(children: [
                            const Icon(Icons.remove_red_eye_rounded, color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            const Text('DRAG TO PREVIEW PDF',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: AppColors.black)),
                            const Spacer(),
                            _templateBadge(),
                          ]),
                        ),

                        const SizedBox(height: 16),

                        // ── PDF preview ───────────────────────────────────────
                        SizedBox(
                          height: constraints.maxHeight * 0.72,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: LiveInvoicePreview(
                              key: ValueKey(template.name),
                              invoice: invoice,
                              template: template,
                              business: business,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // ── Action buttons — OUTSIDE the Stack, always visible ────────────────
        bottomBar,
      ],
    );
  }

  Widget _templateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        template.name.toUpperCase(),
        style: const TextStyle(
          fontSize: 9, fontWeight: FontWeight.w900,
          color: AppColors.primary, letterSpacing: 1,
        ),
      ),
    );
  }
}
