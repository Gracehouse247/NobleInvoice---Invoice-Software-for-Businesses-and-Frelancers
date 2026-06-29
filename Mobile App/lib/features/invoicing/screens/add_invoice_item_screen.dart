// lib/features/invoicing/screens/add_invoice_item_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/inventory/controllers/product_controller.dart';
import 'package:noble_invoice/features/inventory/models/product_model.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/core/widgets/glass_container.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:collection/collection.dart';
import 'package:noble_invoice/features/wallet/widgets/upgrade_prompt_sheet.dart';

class AddInvoiceItemScreen extends StatefulWidget {
  final InvoiceItem? existingItem;

  const AddInvoiceItemScreen({super.key, this.existingItem});

  @override
  State<AddInvoiceItemScreen> createState() => _AddInvoiceItemScreenState();
}

class _AddInvoiceItemScreenState extends State<AddInvoiceItemScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  String? _selectedProductId;
  
  double _total = 0.0;
  bool _showInventoryPanel = false;

  late AnimationController _calcAnimCtrl;
  late Animation<double> _calcScale;

  @override
  void initState() {
    super.initState();
    _calcAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _calcScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _calcAnimCtrl, curve: Curves.easeInOut),
    );

    if (widget.existingItem != null) {
      _descriptionController.text = widget.existingItem!.description;
      _qtyController.text = widget.existingItem!.quantity.toString();
      _priceController.text = widget.existingItem!.unitPrice.toString();
      _selectedProductId = widget.existingItem!.productId;
      _calculateTotal(isInit: true);
    }
    
    _qtyController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadProducts();
    });
  }

  void _onFieldChanged() {
    _calculateTotal();
    _animateCalculation();
  }

  void _animateCalculation() {
    if (_calcAnimCtrl.isAnimating) return;
    _calcAnimCtrl.forward().then((_) => _calcAnimCtrl.reverse());
  }

  void _calculateTotal({bool isInit = false}) {
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final newTotal = qty * price;
    if (newTotal != _total) {
      setState(() {
        _total = newTotal;
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final qty = int.tryParse(_qtyController.text) ?? 1;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      
      final item = InvoiceItem(
        id:          widget.existingItem?.id,
        productId:   _selectedProductId,
        description: _descriptionController.text,
        quantity:    qty,
        unitPrice:   price,
      );
      Navigator.pop(context, item);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _calcAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductController>().products;
    final sub = context.watch<SubscriptionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.existingItem != null ? 'Edit Premium Item' : 'New Invoice Item', 
            style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.black, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.darkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Dynamic Total Card
                  _buildTotalDisplay(),
                  const SizedBox(height: 32),

                  // 2. Inventory Quick-Select
                  _buildInventorySection(products, sub),
                  const SizedBox(height: 24),

                  // 3. Item Details Form
                  _buildDetailsForm(),
                  const SizedBox(height: 32),

                  // 4. Smart Suggestions
                  _buildSuggestionsSection(),
                ],
              ),
            ),
          ),
          
          // Floating Action Bar
          Positioned(
            left: 20, right: 20, bottom: 20,
            child: _buildFloatingBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalDisplay() {
    return ScaleTransition(
      scale: _calcScale,
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        blur: 10, opacity: 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LINE TOTAL', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(context, _total),
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventorySection(List<Product> products, SubscriptionController sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SELECT FROM INVENTORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2)),
            if (!sub.canUse('inventory'))
              GestureDetector(
                onTap: () => UpgradePromptSheet.show(context, 'Inventory Sync'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Row(children: [
                    Icon(Icons.lock_rounded, size: 10, color: Colors.amber),
                    SizedBox(width: 4),
                    Text('PRO ONLY', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (!sub.canUse('inventory')) {
              UpgradePromptSheet.show(context, 'Inventory Sync');
              return;
            }
            setState(() => _showInventoryPanel = !_showInventoryPanel);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey, width: 1.2),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(_selectedProductId != null ? 'Product Selected' : 'Search inventory...', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500))),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
        if (_showInventoryPanel && sub.canUse('inventory')) ...[
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = products[i];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.shopping_bag_rounded, size: 16, color: AppColors.primary)),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(CurrencyFormatter.format(context, p.unitPrice), style: const TextStyle(fontSize: 11)),
                  trailing: p.trackInventory ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Stock: ${p.stockQuantity}', style: TextStyle(fontSize: 10, color: p.stockQuantity < 5 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                      if (p.stockQuantity < 5) 
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: const Text('LOW', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.w900)),
                        ),
                    ],
                  ) : null,
                  onTap: () {
                    setState(() {
                      _selectedProductId = p.id;
                      _descriptionController.text = p.name;
                      _priceController.text = p.unitPrice.toString();
                      _showInventoryPanel = false;
                      _calculateTotal();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ITEM DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2)),
          const SizedBox(height: 20),
          _formField('Description', _descriptionController, placeholder: 'e.g. Graphic Design Services', maxLines: 2),
          if (_selectedProductId != null) ...[
            const SizedBox(height: 12),
            _buildStockWarning(context.watch<ProductController>().products),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(flex: 3, child: _formField('Rate', _priceController, placeholder: '0.00', isNumeric: true, prefix: context.read<InvoiceController>().currencyCode)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _formField('Quantity', _qtyController, placeholder: '1', isNumeric: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockWarning(List<Product> products) {
    final p = products.firstWhereOrNull((p) => p.id == _selectedProductId) ?? (products.isNotEmpty ? products.first : null);
    if (p == null || !p.trackInventory) return const SizedBox.shrink();
    if (p.stockQuantity >= 5) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.2))),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Low Stock Warning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
          Text('Only ${p.stockQuantity} items remaining in inventory.', style: TextStyle(fontSize: 11, color: Colors.red.shade700)),
        ])),
      ]),
    );
  }

  Widget _formField(String label, TextEditingController ctrl, {String? placeholder, bool isNumeric = false, int maxLines = 1, String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.darkGrey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixText: prefix != null ? '$prefix ' : null,
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildSuggestionsSection() {
    final suggestions = ['Consulting', 'Deposit', 'Fixed Project Fee', 'Subscription'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SMART SUGGESTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((s) => _suggestionChip(s)).toList(),
        ),
      ],
    );
  }

  Widget _suggestionChip(String label) {
    return GestureDetector(
      onTap: () => setState(() => _descriptionController.text = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkGrey)),
      ),
    );
  }

  Widget _buildFloatingBottomBar() {
    final isEditing = widget.existingItem != null;
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: isEditing ? const Color(0xFF0F766E) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveItem,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isEditing ? Icons.save_rounded : Icons.add_task_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                isEditing ? 'SAVE CHANGES' : 'ADD TO INVOICE',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
