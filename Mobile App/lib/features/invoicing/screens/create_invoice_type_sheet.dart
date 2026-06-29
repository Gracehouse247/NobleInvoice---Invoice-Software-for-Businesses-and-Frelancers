// lib/features/invoicing/screens/create_invoice_type_sheet.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';

class InvoiceTypeSelectionSheet extends StatelessWidget {
  final InvoiceType selected;
  final ValueChanged<InvoiceType> onSelect;

  const InvoiceTypeSelectionSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _typeIcons = {
    InvoiceType.standard:     Icons.receipt_long_rounded,
    InvoiceType.proforma:     Icons.description_rounded,
    InvoiceType.commercial:   Icons.local_shipping_rounded,
    InvoiceType.progress:     Icons.stacked_bar_chart_rounded,
    InvoiceType.recurring:    Icons.autorenew_rounded,
    InvoiceType.finalInvoice: Icons.done_all_rounded,
    InvoiceType.creditMemo:   Icons.arrow_downward_rounded,
    InvoiceType.debitMemo:    Icons.arrow_upward_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Invoice Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: InvoiceType.values.map((type) {
                final isSelected = selected == type;
                return InkWell(
                  onTap: () {
                    onSelect(type);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary.withOpacity(0.4) : Colors.transparent,
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _typeIcons[type] ?? Icons.receipt_rounded,
                          color: isSelected ? AppColors.primary : AppColors.darkGrey,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(type.label, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? AppColors.primary : AppColors.black,
                        )),
                        const SizedBox(height: 2),
                        Text(type.description, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                      ])),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
