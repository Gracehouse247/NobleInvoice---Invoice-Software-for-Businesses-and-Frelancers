// lib/features/invoicing/widgets/invoice_type_modules.dart
// Phase 4: Dynamic Type-Specific Modules for the Smart Invoice Builder
// Each module surfaces contextually relevant fields ONLY for its invoice type.

import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';

import 'package:noble_invoice/features/invoicing/widgets/invoice_payment_module.dart';

// ── Main dispatcher ─────────────────────────────────────────────────────────

/// Renders the correct module widget for the given [invoiceType].
/// Returns [SizedBox.shrink] for standard invoices (no extras needed).
Widget buildTypeModule({
  required InvoiceType invoiceType,
  required Map<String, dynamic> metadata,
  required ValueChanged<Map<String, dynamic>> onMetadataChanged,
}) {
  return Column(
    children: [
      // 1. Type-Specific Module
      _buildSpecificModule(invoiceType, metadata, onMetadataChanged),
      
      // 2. Shared Financial Automations (Phase 6)
      PaymentManagementModule(metadata: metadata, onChanged: onMetadataChanged),
    ],
  );
}

Widget _buildSpecificModule(InvoiceType type, Map<String, dynamic> metadata, ValueChanged<Map<String, dynamic>> onChanged) {
  switch (type) {
    case InvoiceType.standard:
      return const SizedBox.shrink();
    case InvoiceType.proforma:
      return ProformaModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.commercial:
      return CommercialCustomsModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.progress:
      return ProgressBillingModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.recurring:
      return RecurringFrequencyModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.finalInvoice:
      return FinalInvoiceModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.creditMemo:
      return CreditMemoModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.debitMemo:
      return DebitMemoModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.mixed:
      return MixedInvoiceModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.estimate:
      return EstimateModule(metadata: metadata, onChanged: onChanged);
    case InvoiceType.quote:
      return QuoteModule(metadata: metadata, onChanged: onChanged);
  }
}

// ── Shared Card Shell ─────────────────────────────────────────────────────

Widget buildModuleCard({
  required Color accentColor,
  required IconData icon,
  required String title,
  required String subtitle,
  required List<Widget> children,
}) {
  return _ModuleCard(
    accentColor: accentColor,
    icon: icon,
    title: title,
    subtitle: subtitle,
    children: children,
  );
}

class _ModuleCard extends StatelessWidget {
  final Color accentColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _ModuleCard({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
        boxShadow: [BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: accentColor.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: accentColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: accentColor)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: accentColor.withOpacity(0.6))),
              ])),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }
}

// ── Shared field helpers ─────────────────────────────────────────────────

Widget _buildField(String label, String hint, String key, Map<String, dynamic> meta, ValueChanged<Map<String, dynamic>> onChange, {TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: meta[key]?.toString() ?? '',
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        filled: true, fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      onChanged: (v) { final updated = Map<String, dynamic>.from(meta); updated[key] = v; onChange(updated); },
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// 1. PROFORMA MODULE
// ══════════════════════════════════════════════════════════════════════════════
class ProformaModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const ProformaModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ModuleCard(
      accentColor: Colors.purple.shade500,
      icon: Icons.description_outlined,
      title: 'PROFORMA SETTINGS',
      subtitle: 'Quote / pre-invoice — not a demand for payment',
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded, color: Colors.purple, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('This document is a quote only. It will be watermarked "PROFORMA / NOT A TAX INVOICE".',
              style: TextStyle(fontSize: 12, color: Colors.purple))),
          ]),
        ),
        _buildField('Valid Until', 'e.g. 30 days from issue', 'valid_until', metadata, onChanged),
        _buildField('Estimated Delivery', 'e.g. 2–3 weeks', 'estimated_delivery', metadata, onChanged),
        _buildField('Deposit Required (%)', 'e.g. 30', 'deposit_required_pct', metadata, onChanged, keyboardType: TextInputType.number),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 2. COMMERCIAL INVOICE MODULE (International Trade / Customs)
// ══════════════════════════════════════════════════════════════════════════════
class CommercialCustomsModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const CommercialCustomsModule({super.key, required this.metadata, required this.onChanged});

  static const _incoterms = ['EXW', 'FCA', 'CPT', 'CIP', 'DAP', 'DPU', 'DDP', 'FAS', 'FOB', 'CFR', 'CIF'];
  static const _modesOfTransport = ['Sea Freight', 'Air Freight', 'Road Transport', 'Rail Freight', 'Courier'];

  @override
  Widget build(BuildContext context) {
    final currentIncoterm = metadata['incoterms'] ?? 'FOB';
    final currentMode     = metadata['mode_of_transport'] ?? 'Air Freight';

    return _ModuleCard(
      accentColor: Colors.teal.shade600,
      icon: Icons.local_shipping_outlined,
      title: 'CUSTOMS & TRADE DECLARATION',
      subtitle: 'Required for international shipments and import duties',
      children: [
        _buildField('Country of Origin', 'e.g. Nigeria', 'country_of_origin', metadata, onChanged),
        _buildField('HS / Tariff Code', 'e.g. 8471.30 (Laptops)', 'hs_tariff_code', metadata, onChanged),
        
        const Text('Mode of Transport', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkGrey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: currentMode,
          items: _modesOfTransport.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (v) { if (v != null) { final u = Map<String, dynamic>.from(metadata); u['mode_of_transport'] = v; onChanged(u); } },
          decoration: InputDecoration(
            filled: true, fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(children: [
          Expanded(child: _buildField('Net Weight (kg)', 'e.g. 450', 'net_weight', metadata, onChanged, keyboardType: TextInputType.number)),
          const SizedBox(width: 12),
          Expanded(child: _buildField('Gross Weight (kg)', 'e.g. 485', 'gross_weight', metadata, onChanged, keyboardType: TextInputType.number)),
        ]),
        
        _buildField('Package Marks & Numbers', 'e.g. PKG 1-10, NGO/TRADE/24', 'package_marks', metadata, onChanged),
        _buildField('Port of Loading', 'e.g. Lagos, Apapa', 'port_of_loading', metadata, onChanged),
        _buildField('Port of Destination', 'e.g. Felixstowe, UK', 'port_of_destination', metadata, onChanged),
        _buildField('Shipping Tracking #', 'Carrier tracking number', 'shipping_tracking', metadata, onChanged),
        const SizedBox(height: 4),
        const Text('Incoterms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkGrey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _incoterms.map((term) {
            final isSelected = currentIncoterm == term;
            return GestureDetector(
              onTap: () { final u = Map<String, dynamic>.from(metadata); u['incoterms'] = term; onChanged(u); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Colors.teal.shade600 : AppColors.lightGrey),
                ),
                child: Text(term, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.darkGrey)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 3. PROGRESS BILLING MODULE
// ══════════════════════════════════════════════════════════════════════════════
class ProgressBillingModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const ProgressBillingModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final billedPct  = double.tryParse(metadata['pct_previously_billed']?.toString() ?? '0') ?? 0;
    final currentPct = double.tryParse(metadata['pct_current_billing']?.toString() ?? '0') ?? 0;
    final totalPct   = (billedPct + currentPct).clamp(0.0, 100.0);

    return _ModuleCard(
      accentColor: Colors.purple.shade600,
      icon: Icons.stacked_bar_chart_rounded,
      title: 'PROGRESS BILLING',
      subtitle: 'Bill for milestone completion within a larger project',
      children: [
        _buildField('Project Name / Reference', 'e.g. Marina Tower Phase 2', 'project_name', metadata, onChanged),
        _buildField('Total Project Value', 'e.g. 250000', 'total_project_value', metadata, onChanged, keyboardType: TextInputType.number),
        _buildField('% Previously Billed', 'e.g. 25', 'pct_previously_billed', metadata, onChanged, keyboardType: TextInputType.number),
        _buildField('% Being Billed Now', 'e.g. 25', 'pct_current_billing', metadata, onChanged, keyboardType: TextInputType.number),
        const SizedBox(height: 8),
        // Visual Progress Bar
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Cumulative Progress', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple.shade700, fontSize: 13)),
          Text('${totalPct.toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.purple.shade700, fontSize: 16)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: totalPct / 100,
            backgroundColor: Colors.purple.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade500),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 4. RECURRING FREQUENCY MODULE
// ══════════════════════════════════════════════════════════════════════════════
class RecurringFrequencyModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const RecurringFrequencyModule({super.key, required this.metadata, required this.onChanged});

  static const _frequencies = ['Weekly', 'Bi-Weekly', 'Monthly', 'Quarterly', 'Annually'];

  @override
  Widget build(BuildContext context) {
    final current = metadata['frequency'] ?? 'Monthly';
    return _ModuleCard(
      accentColor: Colors.green.shade600,
      icon: Icons.autorenew_rounded,
      title: 'RECURRING SCHEDULE',
      subtitle: 'Auto-generate at set intervals for subscriptions & retainers',
      children: [
        const Text('Billing Frequency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkGrey)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _frequencies.map((freq) {
            final isSelected = current == freq;
            return GestureDetector(
              onTap: () { final u = Map<String, dynamic>.from(metadata); u['frequency'] = freq; onChanged(u); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Colors.green.shade600 : AppColors.lightGrey),
                ),
                child: Text(freq, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.darkGrey)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildField('Start Date', 'e.g. May 1, 2025', 'start_date', metadata, onChanged),
        _buildField('End Date (Optional)', 'Leave blank for indefinite', 'end_date', metadata, onChanged),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Auto-charge on Issue Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Switch.adaptive(
            value: metadata['auto_charge'] == true,
            onChanged: (v) { final u = Map<String, dynamic>.from(metadata); u['auto_charge'] = v; onChanged(u); },
            activeColor: Colors.green.shade600,
          ),
        ]),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 5. FINAL INVOICE MODULE
// ══════════════════════════════════════════════════════════════════════════════
class FinalInvoiceModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const FinalInvoiceModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final contract = double.tryParse(metadata['contract_value']?.toString() ?? '0') ?? 0.0;
    final paid     = double.tryParse(metadata['previously_paid']?.toString() ?? '0') ?? 0.0;
    final balance  = contract - paid;

    return _ModuleCard(
      accentColor: Colors.blue.shade700,
      icon: Icons.done_all_rounded,
      title: 'FINAL PROJECT SETTLEMENT',
      subtitle: 'Reconcile all progress payments and close the project',
      children: [
        _buildField('Original Contract Value', 'Total agreed project cost', 'contract_value', metadata, onChanged, keyboardType: TextInputType.number),
        _buildField('Total Previously Paid', 'Sum of all progress invoices paid', 'previously_paid', metadata, onChanged, keyboardType: TextInputType.number),
        _buildField('Project Reference / PO #', 'e.g. PRJ-2024-007', 'project_reference', metadata, onChanged),
        
        if (contract > 0) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Contract Value', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                Text(contract.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Previously Paid', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                Text('- ${paid.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
              ]),
              const Divider(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Remaining Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
                Text(balance.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.blue.shade700)),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
        ],
        
        _buildField('Completion Date', 'e.g. April 10, 2025', 'completion_date', metadata, onChanged),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 6. CREDIT MEMO MODULE
// ══════════════════════════════════════════════════════════════════════════════
class CreditMemoModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const CreditMemoModule({super.key, required this.metadata, required this.onChanged});

  static const _reasons = ['Goods Returned', 'Billing Error', 'Service Not Rendered', 'Partial Refund', 'Goodwill Gesture', 'Other'];

  @override
  Widget build(BuildContext context) {
    final current = metadata['reason_code'] ?? 'Billing Error';
    return _ModuleCard(
      accentColor: Colors.red.shade500,
      icon: Icons.arrow_circle_down_rounded,
      title: 'CREDIT MEMO DETAILS',
      subtitle: 'Reduction of amount owed — returns & dispute resolution',
      children: [
        _buildField('Original Invoice Reference', 'e.g. INV-2025-0031', 'original_invoice_ref', metadata, onChanged),
        const SizedBox(height: 4),
        const Text('Reason for Credit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkGrey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _reasons.map((reason) {
            final isSelected = current == reason;
            return GestureDetector(
              onTap: () { final u = Map<String, dynamic>.from(metadata); u['reason_code'] = reason; onChanged(u); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.shade500 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Colors.red.shade500 : AppColors.lightGrey),
                ),
                child: Text(reason, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.darkGrey)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        _buildField('Additional Notes', 'Explain the credit reason in detail...', 'credit_notes', metadata, onChanged),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 7. DEBIT MEMO MODULE
// ══════════════════════════════════════════════════════════════════════════════
class DebitMemoModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const DebitMemoModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ModuleCard(
      accentColor: Colors.orange.shade700,
      icon: Icons.arrow_circle_up_rounded,
      title: 'DEBIT MEMO DETAILS',
      subtitle: 'Additional charges appended to a previously issued invoice',
      children: [
        _buildField('Original Invoice Reference', 'e.g. INV-2025-0031', 'original_invoice_ref', metadata, onChanged),
        _buildField('Reason for Additional Charge', 'e.g. Scope extension, price correction', 'adjustment_reason', metadata, onChanged),
        _buildField('Additional Charge Amount', 'e.g. 350.00', 'additional_charge', metadata, onChanged, keyboardType: TextInputType.number),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('This memo links back to the original invoice so the client understands the change.',
              style: TextStyle(fontSize: 12, color: Colors.orange))),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 8. MIXED INVOICE MODULE
// ══════════════════════════════════════════════════════════════════════════════
class MixedInvoiceModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const MixedInvoiceModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ModuleCard(
      accentColor: Colors.deepOrange.shade500,
      icon: Icons.compare_arrows_rounded,
      title: 'MIXED INVOICE SETTINGS',
      subtitle: 'New charges combined with credits on a single document',
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Text('Add standard line items below for new charges. Prefix descriptions with "CREDIT:" for items that reduce the balance. The system will separate these automatically in the PDF.',
            style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
        ),
        _buildField('Account / Reconciliation Reference', 'e.g. AC-2025-Client-A', 'account_reference', metadata, onChanged),
        _buildField('Period Covered', 'e.g. Q1 2025 (Jan–Mar)', 'period_covered', metadata, onChanged),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Show Credit/Debit Subtotals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Switch.adaptive(
            value: metadata['show_subtotals'] != false,
            onChanged: (v) { final u = Map<String, dynamic>.from(metadata); u['show_subtotals'] = v; onChanged(u); },
            activeColor: Colors.deepOrange.shade500,
          ),
        ]),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 9. ESTIMATE MODULE
// ══════════════════════════════════════════════════════════════════════════════
class EstimateModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const EstimateModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ModuleCard(
      accentColor: Colors.blueGrey.shade600,
      icon: Icons.architecture_rounded,
      title: 'ESTIMATE SETTINGS',
      subtitle: 'Proposed costs and timeline — not a final bill',
      children: [
        _buildField('Estimated Timeline', 'e.g. 4-6 weeks', 'estimated_timeline', metadata, onChanged),
        _buildField('Validity Period', 'e.g. Valid for 14 days', 'valid_until', metadata, onChanged),
        _buildField('Deposit Required', 'e.g. 50% upfront', 'deposit_info', metadata, onChanged),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.info_outline, color: Colors.blueGrey, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('Estimates can be converted into standard invoices once the client approves.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey))),
          ]),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// 10. QUOTE MODULE
// ══════════════════════════════════════════════════════════════════════════════
class QuoteModule extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final ValueChanged<Map<String, dynamic>> onChanged;
  const QuoteModule({super.key, required this.metadata, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ModuleCard(
      accentColor: Colors.indigo.shade600,
      icon: Icons.request_quote_rounded,
      title: 'QUOTE SETTINGS',
      subtitle: 'Fixed price offer for specified goods or services',
      children: [
        _buildField('Quote Validity', 'e.g. Guaranteed for 30 days', 'valid_until', metadata, onChanged),
        _buildField('Scope of Work Ref', 'e.g. SOW-2024-001', 'sow_reference', metadata, onChanged),
        _buildField('Price Lock Duration', 'e.g. Fixed until June 1st', 'price_lock', metadata, onChanged),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.verified_outlined, color: Colors.indigo, size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('Quotes typically represent a firm commitment to the stated price.',
              style: TextStyle(fontSize: 12, color: Colors.indigo))),
          ]),
        ),
      ],
    );
  }
}
