// lib/features/invoicing/screens/create_recurring_invoice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/invoicing/controllers/recurring_invoice_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class CreateRecurringInvoiceScreen extends StatefulWidget {
  const CreateRecurringInvoiceScreen({super.key});

  @override
  State<CreateRecurringInvoiceScreen> createState() => _CreateRecurringInvoiceScreenState();
}

class _CreateRecurringInvoiceScreenState extends State<CreateRecurringInvoiceScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _notesCtrl       = TextEditingController();

  Client?              _selectedClient;
  RecurringFrequency   _frequency   = RecurringFrequency.monthly;
  DateTime             _firstRunAt  = DateTime.now().add(const Duration(days: 1));
  final List<InvoiceItem> _items    = [];
  double               _taxRate     = 0;
  bool                 _taxEnabled  = false;
  final String               _taxType     = 'exclusive';
  final String               _currencyCode = 'USD';

  double get _subtotal => _items.fold(0, (s, i) => s + i.total);

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectClient() async {
    final result = await Navigator.pushNamed<Client>(context, AppRoutes.clientSelection);
    if (result != null) setState(() => _selectedClient = result);
  }

  Future<void> _addItem() async {
    final result = await Navigator.pushNamed<InvoiceItem>(context, AppRoutes.addInvoiceItem);
    if (result != null) setState(() => _items.add(result));
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstRunAt,
      firstDate: DateTime.now(),
      lastDate:  DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _firstRunAt = picked);
  }

  bool _validate() {
    if (_selectedClient == null) { _snack('Please select a client', error: true); return false; }
    if (_items.isEmpty) { _snack('Add at least one line item', error: true); return false; }
    return _formKey.currentState?.validate() ?? true;
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  Future<void> _save() async {
    if (!_validate()) return;
    final ctrl = context.read<RecurringInvoiceController>();
    final ok   = await ctrl.createSchedule(
      clientId:    _selectedClient!.id,
      frequency:   _frequency,
      items:       _items,
      firstRunAt:  _firstRunAt,
      notes:       _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      taxRate:     _taxEnabled ? _taxRate : 0,
      taxType:     _taxType,
      currencyCode: _currencyCode,
    );
    if (!mounted) return;
    if (ok) {
      _snack('Recurring schedule created!');
      Navigator.pop(context);
    } else {
      _snack(ctrl.error, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<RecurringInvoiceController>().isSaving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        leadingWidth: 80,
        title: const Text('New Recurring Invoice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Explanation banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.autorenew_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    'A new invoice will be automatically created and sent to your client on the selected frequency. Set it once and forget it.',
                    style: TextStyle(fontSize: 12, color: AppColors.primary.withOpacity(0.85), height: 1.5),
                  )),
                ]),
              ),
              const SizedBox(height: 24),

              const _Label('CLIENT'),
              const SizedBox(height: 8),
              _ClientTile(client: _selectedClient, onTap: _selectClient),
              const SizedBox(height: 24),

              const _Label('FREQUENCY'),
              const SizedBox(height: 8),
              _FrequencySelector(selected: _frequency, onSelect: (f) => setState(() => _frequency = f)),
              const SizedBox(height: 24),

              const _Label('FIRST INVOICE DATE'),
              const SizedBox(height: 8),
              _DateTile(date: _firstRunAt, onTap: _selectDate),
              const SizedBox(height: 24),

              const _Label('LINE ITEMS'),
              const SizedBox(height: 8),
              ..._items.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.lightGrey)),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.value.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${e.value.quantity} × ${CurrencyFormatter.format(context, e.value.unitPrice)}',
                        style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
                      ),
                    ])),
                    Text(CurrencyFormatter.format(context, e.value.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 18),
                      onPressed: () => setState(() => _items.removeAt(e.key)),
                    ),
                  ]),
                ),
              )),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addItem,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                  label: const Text('Add Line Item', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),

              const _Label('TAX (OPTIONAL)'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.lightGrey)),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Apply Tax', style: TextStyle(fontWeight: FontWeight.bold)),
                    Switch.adaptive(value: _taxEnabled, onChanged: (v) => setState(() => _taxEnabled = v), activeColor: AppColors.primary),
                  ]),
                  if (_taxEnabled) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _taxRate > 0 ? _taxRate.toString() : '',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                      decoration: InputDecoration(
                        labelText: 'Tax Rate (%)', suffixText: '%',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (v) => setState(() => _taxRate = double.tryParse(v) ?? 0),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 24),

              // Total preview
              if (_items.isNotEmpty) Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.lightGrey)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Amount per cycle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(
                    CurrencyFormatter.format(context, _subtotal),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primary),
                  ),
                ]),
              ),
              const SizedBox(height: 24),

              const _Label('NOTES (OPTIONAL)'),
              const SizedBox(height: 8),
              TextField(
                controller: _notesCtrl, maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Monthly retainer for design services.',
                  fillColor: Colors.white, filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
                ),
              ),
              const SizedBox(height: 80),
            ]),
          )),
          // Bottom save bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.lightGrey))),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Activate Recurring Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Sub-Widgets ────────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2));
}

class _ClientTile extends StatelessWidget {
  final Client? client;
  final VoidCallback onTap;
  const _ClientTile({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: client != null ? AppColors.primary.withOpacity(0.3) : AppColors.lightGrey),
      ),
      child: client == null
        ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.person_add_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Select Client', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ])
        : Row(children: [
            CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(client!.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(client!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(client!.email, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
            ])),
            const Icon(Icons.edit_rounded, size: 16, color: AppColors.darkGrey),
          ]),
    ),
  );
}

class _FrequencySelector extends StatelessWidget {
  final RecurringFrequency selected;
  final ValueChanged<RecurringFrequency> onSelect;
  const _FrequencySelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(children: RecurringFrequency.values.map((f) {
      final isSelected = selected == f;
      return GestureDetector(
        onTap: () => onSelect(f),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? AppColors.primary.withOpacity(0.4) : AppColors.lightGrey),
          ),
          child: Row(children: [
            Icon(Icons.repeat_rounded, color: isSelected ? AppColors.primary : AppColors.darkGrey, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.black)),
              Text(f.description, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
            ])),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ]),
        ),
      );
    }).toList());
  }
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DateTile({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.lightGrey)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(DateFormat('MMMM dd, yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 18),
      ]),
    ),
  );
}
