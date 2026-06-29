// lib/features/invoicing/widgets/builder_metadata_strip.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/pdf_template.dart';
import 'package:noble_invoice/features/invoicing/widgets/create_invoice_widgets.dart';
import 'package:noble_invoice/features/invoicing/widgets/template_selection_sheet.dart';
import 'package:noble_invoice/core/widgets/currency_picker_sheet.dart';

class BuilderHeader extends StatelessWidget {
  final DateTime issueDate;
  final DateTime dueDate;
  final String currencyCode;
  final PdfTemplate selectedTemplate;
  final VoidCallback onSelectIssueDate;
  final VoidCallback onSelectDueDate;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<PdfTemplate> onTemplateChanged;

  const BuilderHeader({
    super.key,
    required this.issueDate,
    required this.dueDate,
    required this.currencyCode,
    required this.selectedTemplate,
    required this.onSelectIssueDate,
    required this.onSelectDueDate,
    required this.onCurrencyChanged,
    required this.onTemplateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.lightGrey.withOpacity(0.5))),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          MetadataPill(
            icon: Icons.calendar_today_rounded,
            label: 'Issued: ${DateFormat('MMM dd').format(issueDate)}',
            onTap: onSelectIssueDate,
          ),
          const SizedBox(width: 8),
          MetadataPill(
            icon: Icons.event_available_rounded,
            label: 'Due: ${DateFormat('MMM dd').format(dueDate)}',
            onTap: onSelectDueDate,
            isAlert: dueDate.difference(issueDate).inDays < 7,
          ),
          const SizedBox(width: 8),
          const SizedBox(width: 8),
          MetadataPill(
            icon: Icons.palette_rounded,
            label: 'Theme: ${selectedTemplate.label.replaceAll('★ ', '').replaceAll('✦ ', '')}',
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => TemplateSelectionSheet(
                onSelected: onTemplateChanged,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
