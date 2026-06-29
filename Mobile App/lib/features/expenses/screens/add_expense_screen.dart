// lib/features/expenses/screens/add_expense_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/expenses/controllers/expense_controller.dart';
import 'package:noble_invoice/features/expenses/models/expense_model.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:collection/collection.dart';
import 'package:noble_invoice/core/services/ocr_service.dart';

class AddExpenseScreen extends StatefulWidget {
  /// Optional: pre-link this expense to a specific invoice.
  /// Provided when navigating here from InvoiceDetailsScreen.
  final int?    preLinkedInvoiceId;
  final String? preLinkedInvoiceLabel;

  const AddExpenseScreen({
    super.key,
    this.preLinkedInvoiceId,
    this.preLinkedInvoiceLabel,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountCtrl = TextEditingController();
  final _notesCtrl  = TextEditingController();
  
  DateTime _date    = DateTime.now();
  String?   _catId;
  String?   _venId;
  File?     _receipt;

  // Invoice linking state
  int?    _linkedInvoiceId;
  String? _linkedInvoiceLabel;
  
  final _picker     = ImagePicker();
  bool _isProcessing = false;
  bool _ocrSuccess   = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate invoice link if navigated from InvoiceDetailsScreen
    _linkedInvoiceId    = widget.preLinkedInvoiceId;
    _linkedInvoiceLabel = widget.preLinkedInvoiceLabel;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final expenseCtrl = context.read<ExpenseController>();
      final teamCtrl    = context.read<TeamController>();
      final invoiceCtrl = context.read<InvoiceController>();
      
      // Session Safety Sync
      if (teamCtrl.activeTeamId != null) {
        expenseCtrl.setActiveTeamId(teamCtrl.activeTeamId);
      }
      
      expenseCtrl.loadAll();
      invoiceCtrl.loadDashboard(); // Ensure invoices are available for linking
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
    if (img != null) {
      final file = File(img.path);
      setState(() {
        _receipt = file;
        _isProcessing = true;
      });
      
      try {
        final data = await OcrService.instance.parseReceipt(file);
        if (mounted) {
          setState(() {
            if (data['amount'] != null) _amountCtrl.text = data['amount'].toString();
            if (data['date'] != null) _date = data['date'];
            if (data['merchant'] != null && _notesCtrl.text.isEmpty) {
              _notesCtrl.text = 'Receipt from ${data['merchant']}';
            }
          });
          setState(() => _ocrSuccess = true);
          _snack('Smart scan completed!');
        }
      } catch (e) {
        setState(() => _ocrSuccess = false);
        _snack('Auto-scan failed, but receipt is attached.', error: true);
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _save() async {
    if (_amountCtrl.text.isEmpty || _catId == null || _catId!.isEmpty) {
      _snack('Please enter amount and select a category', error: true);
      return;
    }

    final success = await context.read<ExpenseController>().addExpense(
      amount:      double.parse(_amountCtrl.text),
      categoryId:  _catId!,
      vendorId:    _venId,
      invoiceId:   _linkedInvoiceId,  // nullable — links expense to a project
      date:        _date,
      currency:    context.read<InvoiceController>().currencyCode, 
      notes:       _notesCtrl.text,
      receiptFile: _receipt,
    );

    if (success && mounted) {
      _snack('Expense logged successfully!');
      Navigator.pop(context);
    } else if (mounted) {
      _snack(context.read<ExpenseController>().error, error: true);
    }
  }

  void _snack(String m, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m), backgroundColor: error ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ExpenseController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black)),
        actions: [
          if (ctrl.isLoading)
            const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          else
            TextButton(onPressed: _save, child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        // 1. Amount Input
        const Text('AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextField(
          controller: _amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.primary),
          decoration: InputDecoration(
            prefixText: '${context.read<InvoiceController>().currencyCode} ', 
            border: InputBorder.none, 
            hintText: '0.00'
          ),
        ),
        const Divider(height: 40),

        // 2. Date & Category
        _buildListTile(Icons.calendar_today_rounded, 'Date', DateFormat('MMM dd, yyyy').format(_date), () async {
          final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
          if (d != null) setState(() => _date = d);
        }),
        if (_ocrSuccess) _buildOcrBadge(),
        _buildListTile(Icons.category_rounded, 'Category', 
          (_catId == null || _catId!.isEmpty) ? 'Select Category' : (ctrl.categories.firstWhereOrNull((c) => c.id.toString() == _catId.toString())?.name ?? 'Unknown Category'), 
          () => _showCategoryPicker(ctrl.categories, ctrl.isLoading)),
        _buildListTile(Icons.business_rounded, 'Vendor', 
          (_venId == null || _venId!.isEmpty) ? 'N/A' : (ctrl.vendors.firstWhereOrNull((v) => v.id.toString() == _venId.toString())?.name ?? 'Unknown Vendor'), 
          () => _showVendorPicker(ctrl.vendors, ctrl.isLoading)),
        _buildInvoiceLinkTile(),
        
        const SizedBox(height: 24),
        
        // 3. Receipt Upload
        _ReceiptBox(image: _receipt, onToggle: _pickImage),
        
        const SizedBox(height: 24),
        
        // 4. Notes
        TextField(
          controller: _notesCtrl, maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Notes / Description', labelStyle: const TextStyle(color: AppColors.darkGrey),
            fillColor: AppColors.lightGrey.withOpacity(0.1), filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),

        const SizedBox(height: 48),
      ]),
    );
  }

  Widget _buildListTile(IconData icon, String title, String val, VoidCallback onTap) {
    return ListTile(
      onTap: onTap, contentPadding: EdgeInsets.zero,
      leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey, fontWeight: FontWeight.bold)),
      subtitle: Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.black)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.lightGrey),
    );
  }

  /// Invoice link tile — shows selected invoice or a prompt to link one.
  Widget _buildInvoiceLinkTile() {
    final isLinked = _linkedInvoiceId != null;
    return ListTile(
      onTap: _showInvoicePicker,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isLinked ? AppColors.primary.withOpacity(0.1) : AppColors.lightGrey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.link_rounded, color: isLinked ? AppColors.primary : AppColors.darkGrey, size: 20),
      ),
      title: Text('Link to Invoice', style: const TextStyle(fontSize: 12, color: AppColors.darkGrey, fontWeight: FontWeight.bold)),
      subtitle: Text(
        isLinked ? (_linkedInvoiceLabel ?? 'Linked') : 'Optional — tag this cost to a project',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isLinked ? AppColors.primary : AppColors.black),
      ),
      trailing: isLinked
          ? IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColors.lightGrey, size: 20),
              onPressed: () => setState(() { _linkedInvoiceId = null; _linkedInvoiceLabel = null; }),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppColors.lightGrey),
    );
  }

  void _showInvoicePicker() {
    final invoices = context.read<InvoiceController>().invoices
        .where((inv) => inv.status != 'draft' && inv.status != 'voided')
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, scrollCtrl) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Link to Invoice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (_linkedInvoiceId != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() { _linkedInvoiceId = null; _linkedInvoiceLabel = null; });
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.link_off_rounded, size: 16),
                      label: const Text('Remove Link'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.error),
                    ),
                ],
              ),
            ),
            if (invoices.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No active invoices found.\nCreate an invoice first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.darkGrey)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: invoices.length,
                  itemBuilder: (_, i) {
                    final inv = invoices[i];
                    final isSelected = _linkedInvoiceId == inv.id;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _linkedInvoiceId    = inv.id;
                            _linkedInvoiceLabel = '${inv.invoiceNumber} · ${inv.clientName}';
                          });
                          Navigator.pop(context);
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 18),
                        ),
                        title: Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(inv.clientName, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: inv.status == 'paid' ? AppColors.success.withOpacity(0.1) : AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                inv.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w900,
                                  color: inv.status == 'paid' ? AppColors.success : AppColors.secondary,
                                ),
                              ),
                            ),
                            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(List<ExpenseCategory> cats, bool isLoading) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(padding: EdgeInsets.all(20), child: Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        if (isLoading && cats.isEmpty)
          const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())
        else if (context.read<ExpenseController>().error.isNotEmpty && cats.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text('Sync Failed: ${context.read<ExpenseController>().error}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.read<ExpenseController>().loadAll(), child: const Text('Retry Sync')),
            ]),
          )
        else if (cats.isEmpty)
          const Padding(padding: EdgeInsets.all(40), child: Text('No categories found. Syncing...', style: TextStyle(color: Colors.grey)))
        else
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: cats.length,
            itemBuilder: (_, i) => ListTile(
              leading: Icon(Icons.circle, color: Color(int.parse((cats[i].color ?? '#94A3B8').replaceAll('#', '0xFF'))), size: 14),
              title: Text(cats[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () { setState(() => _catId = cats[i].id); Navigator.pop(context); },
            ),
          )),
        const SizedBox(height: 20),
      ],
    ));
  }

  void _showVendorPicker(List<Vendor> vens, bool isLoading) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Column(children: [
      const Padding(padding: EdgeInsets.all(20), child: Text('Select Vendor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      if (isLoading && vens.isEmpty)
        const Expanded(child: Center(child: CircularProgressIndicator()))
      else
        Expanded(child: ListView.builder(
          itemCount: vens.length,
          itemBuilder: (_, i) => ListTile(title: Text(vens[i].name), onTap: () { setState(() => _venId = vens[i].id); Navigator.pop(context); }),
        )),
      ListTile(leading: const Icon(Icons.add_rounded, color: AppColors.primary), title: const Text('Add New Vendor', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)), onTap: () => _showAddVendor()),
    ]));
  }

  void _showAddVendor() {
    final nameCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('New Vendor'),
      content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Vendor Name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () async {
          if (nameCtrl.text.isNotEmpty) {
            final newVen = await context.read<ExpenseController>().addVendor(nameCtrl.text);
            if (mounted && newVen != null) {
              setState(() => _venId = newVen.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
            }
          }
        }, child: const Text('Add')),
      ],
    ));
  }

  Widget _buildOcrBadge() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: const Row(children: [
        Icon(Icons.auto_awesome_rounded, color: Colors.green, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Verified by AI: This expense was automatically scanned and verified from your receipt.',
            style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

class _ReceiptBox extends StatelessWidget {
  final File? image;
  final VoidCallback onToggle;
  const _ReceiptBox({this.image, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isProcessing = (context.findAncestorStateOfType<_AddExpenseScreenState>() as _AddExpenseScreenState)._isProcessing;
    
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 180, width: double.infinity,
        decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.lightGrey.withOpacity(0.3), style: BorderStyle.solid)),
        child: isProcessing 
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 12), Text('AI Analyzing Receipt...', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary))]))
          : (image != null 
            ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(image!, fit: BoxFit.cover))
            : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 32), SizedBox(height: 8), Text('Attach Receipt', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13))])),
      ),
    );
  }
}
