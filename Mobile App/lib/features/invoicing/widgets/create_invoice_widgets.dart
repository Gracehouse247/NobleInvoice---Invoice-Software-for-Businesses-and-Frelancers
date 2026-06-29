// lib/features/invoicing/widgets/create_invoice_widgets.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2));
}

class ClientSelector extends StatelessWidget {
  final Client? client;
  final VoidCallback onTap;
  const ClientSelector({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: client != null ? AppColors.primary.withOpacity(0.1) : AppColors.lightGrey,
          width: client != null ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: client == null
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(children: [
                    Icon(Icons.person_add_rounded, color: AppColors.primary, size: 20),
                    SizedBox(width: 14),
                    Text('Bill To', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                  ]),
                  Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 20),
                ],
              )
            : Row(children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(client!.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(client!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(client!.email, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                ])),
                const Icon(Icons.edit_note_rounded, color: AppColors.darkGrey, size: 22),
              ]),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<InvoiceItem> items;
  final String currencyCode;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final ValueChanged<int>? onEdit;
  const ItemList({super.key, required this.items, required this.currencyCode, required this.onAdd, required this.onRemove, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (items.isEmpty)
        _buildEmptyState()
      else
        ...items.asMap().entries.map((e) => _buildItemTile(context, e.key, e.value)),
      const SizedBox(height: 12),
      _buildAddButton(),
    ]);
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.1)),
      ),
      child: Column(children: [
        Icon(Icons.layers_clear_rounded, color: AppColors.primary.withOpacity(0.1), size: 32),
        const SizedBox(height: 16),
        const Text('No items added yet', style: TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _buildItemTile(BuildContext context, int index, InvoiceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: InkWell(
        onTap: onEdit != null ? () => onEdit!(index) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(item.description,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  if (onEdit != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.edit_rounded, size: 10, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('Edit', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                ]),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} × ${CurrencyFormatter.format(context, item.unitPrice, currency: currencyCode)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                CurrencyFormatter.format(context, item.total, currency: currencyCode),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => onRemove(index),
                child: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onAdd,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
        label: const Text('Add Items', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const ToggleChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.lightGrey),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.darkGrey)),
      ),
    );
  }
}

class TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isDimmed;

  const TotalRow({
    super.key, 
    required this.label, 
    required this.value, 
    this.valueColor,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: isDimmed ? Colors.grey : AppColors.darkGrey,
                fontSize: isDimmed ? 12 : 14,
                fontWeight: isDimmed ? FontWeight.normal : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isDimmed ? FontWeight.normal : FontWeight.bold,
                  fontSize: isDimmed ? 12 : 14,
                  color: valueColor ?? (isDimmed ? Colors.grey : AppColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetadataPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isAlert;

  const MetadataPill({super.key, required this.icon, required this.label, required this.onTap, this.isAlert = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAlert ? Colors.red.withOpacity(0.1) : AppColors.lightGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isAlert ? Colors.red.withOpacity(0.3) : Colors.transparent),
        ),
        child: Row(children: [
          Icon(icon, size: 14, color: isAlert ? Colors.red : AppColors.darkGrey),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isAlert ? Colors.red : AppColors.black)),
        ]),
      ),
    );
  }
}

class BottomActionBar extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onDraft;
  final VoidCallback onIssue;

  const BottomActionBar({super.key, required this.isLoading, required this.onDraft, required this.onIssue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onDraft,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isLoading ? null : onIssue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Review & Issue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ]),
    );
  }
}


class DateRow extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  const DateRow({super.key, required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: AppColors.darkGrey)),
          Text(DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
