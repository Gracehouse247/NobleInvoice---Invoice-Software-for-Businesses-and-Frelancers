// lib/features/invoicing/widgets/builder_sections.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/invoicing/widgets/create_invoice_widgets.dart';

class BuilderFinancials extends StatelessWidget {
  final String currencyCode;
  final bool taxEnabled;
  final double taxRate;
  final String taxType;
  final String discountType;
  final double discountValue;
  final TextEditingController discountCtrl;
  
  // Computed values passed for display
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;

  final ValueChanged<bool> onTaxEnabledChanged;
  final ValueChanged<double> onTaxRateChanged;
  final ValueChanged<String> onTaxTypeChanged;
  final ValueChanged<String> onDiscountTypeChanged;
  final ValueChanged<double> onDiscountValueChanged;

  const BuilderFinancials({
    super.key,
    required this.currencyCode,
    required this.taxEnabled,
    required this.taxRate,
    required this.taxType,
    required this.discountType,
    required this.discountValue,
    required this.discountCtrl,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.total,
    required this.onTaxEnabledChanged,
    required this.onTaxRateChanged,
    required this.onTaxTypeChanged,
    required this.onDiscountTypeChanged,
    required this.onDiscountValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('FINANCIAL SETTINGS'),
        const SizedBox(height: 12),
        _buildDiscountSection(context),
        const SizedBox(height: 16),
        _buildTaxSection(context),
        const SizedBox(height: 32),
        _buildTotalsCard(context),
      ],
    );
  }

  Widget _buildDiscountSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
           const Text('Apply Discount', style: TextStyle(fontWeight: FontWeight.bold)),
           Row(children: [
             ToggleChip(label: 'None', isSelected: discountType == 'none', onTap: () => onDiscountTypeChanged('none')),
             const SizedBox(width: 8),
             ToggleChip(label: 'Flat', isSelected: discountType == 'flat', onTap: () => onDiscountTypeChanged('flat')),
             const SizedBox(width: 8),
             ToggleChip(label: '%', isSelected: discountType == 'percentage', onTap: () => onDiscountTypeChanged('percentage')),
           ]),
        ]),
        if (discountType != 'none') ...[
          const SizedBox(height: 16),
          TextField(
            controller: discountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: discountType == 'flat' ? 'Discount Amount' : 'Discount Percentage',
              prefixText: discountType == 'flat' ? '$currencyCode ' : null,
              suffixText: discountType == 'percentage' ? '%' : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (v) => onDiscountValueChanged(double.tryParse(v) ?? 0.0),
          ),
        ],
      ]),
    );
  }

  Widget _buildTaxSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Enable Tax (VAT/GST)', style: TextStyle(fontWeight: FontWeight.bold)),
          Switch.adaptive(value: taxEnabled, activeColor: AppColors.primary, onChanged: onTaxEnabledChanged),
        ]),
        if (taxEnabled) ...[
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Tax Rate (%)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                onChanged: (v) => onTaxRateChanged(double.tryParse(v) ?? 0.0),
              ),
            ),
            const SizedBox(width: 12),
            ToggleChip(label: 'Exclusive', isSelected: taxType == 'exclusive', onTap: () => onTaxTypeChanged('exclusive')),
            const SizedBox(width: 8),
            ToggleChip(label: 'Inclusive', isSelected: taxType == 'inclusive', onTap: () => onTaxTypeChanged('inclusive')),
          ]),
        ],
      ]),
    );
  }

  Widget _buildTotalsCard(BuildContext context) {
    final taxableAmount = subtotal - discountAmount;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(children: [
        TotalRow(label: 'Subtotal (Items)', value: CurrencyFormatter.format(context, subtotal, currency: currencyCode)),
        if (discountAmount > 0) ...[
          const SizedBox(height: 8),
          TotalRow(label: 'Discount', value: '- ${CurrencyFormatter.format(context, discountAmount, currency: currencyCode)}', valueColor: Colors.green),
          const Divider(height: 24, color: Colors.transparent),
          TotalRow(label: 'Taxable Amount', value: CurrencyFormatter.format(context, taxableAmount, currency: currencyCode), isDimmed: true),
        ],
        if (taxAmount > 0) ...[
          const SizedBox(height: 8),
          TotalRow(label: '${taxType == 'inclusive' ? 'Inc. ' : ''}Tax (${taxRate.toStringAsFixed(1)}%)', value: '+ ${CurrencyFormatter.format(context, taxAmount, currency: currencyCode)}'),
        ],
        const Divider(height: 28),
        // Total row — stacks vertically on narrow screens to prevent overflow
        screenWidth < 380
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('TOTAL AMOUNT',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11,
                        color: AppColors.darkGrey, letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CurrencyFormatter.format(context, total, currency: currencyCode),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 32, color: AppColors.primary),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        CurrencyFormatter.format(context, total, currency: currencyCode),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
      ]),
    );
  }
}
