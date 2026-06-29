// lib/features/inventory/screens/add_product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/inventory/controllers/product_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameCtrl  = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _skuCtrl   = TextEditingController();
  final _stockCtrl = TextEditingController(text: '0');
  final _descCtrl  = TextEditingController();
  
  bool _trackInventory = true;
  String? _selectedCatId;

  @override
  void dispose() {
    _nameCtrl.dispose(); _priceCtrl.dispose(); _skuCtrl.dispose();
    _stockCtrl.dispose(); _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      _snack('Product name and price are required', error: true);
      return;
    }

    final price = double.tryParse(_priceCtrl.text);
    if (price == null) {
      _snack('Please enter a valid price', error: true);
      return;
    }

    final success = await context.read<ProductController>().addProduct(
      name:           _nameCtrl.text,
      price:          price,
      sku:            _skuCtrl.text.isEmpty ? null : _skuCtrl.text,
      description:    _descCtrl.text.isEmpty ? null : _descCtrl.text,
      categoryId:     _selectedCatId,
      initialStock:   int.tryParse(_stockCtrl.text) ?? 0,
      trackInventory: _trackInventory,
    );

    if (success && mounted) {
      _snack('Product added to catalog');
      Navigator.pop(context);
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
    final ctrl = context.watch<ProductController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: const Text('New Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black)),
        actions: [
          if (ctrl.isLoading)
            const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
          else
            TextButton(onPressed: _save, child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        // 1. Basic Info
        _buildSectionHeader('BASIC INFORMATION'),
        _buildTextField(_nameCtrl, 'Product Name', 'e.g. Graphic Design Service', Icons.shopping_basket_rounded),
        const SizedBox(height: 16),
        _buildTextField(_skuCtrl, 'SKU / Item Code', 'e.g. GD-001', Icons.qr_code_rounded),
        
        const SizedBox(height: 32),
        
        // 2. Pricing
        _buildSectionHeader('PRICING'),
        _buildTextField(_priceCtrl, 'Unit Price', '0.00', Icons.attach_money_rounded, isNumber: true),
        
        const SizedBox(height: 32),

        // 3. Inventory
        _buildSectionHeader('INVENTORY'),
        SwitchListTile(
          value: _trackInventory,
          onChanged: (v) => setState(() => _trackInventory = v),
          title: const Text('Track Stock Levels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: const Text('Automatically deduct stock when invoiced', style: TextStyle(fontSize: 12)),
          activeThumbColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        if (_trackInventory) ...[
          const SizedBox(height: 12),
          _buildTextField(_stockCtrl, 'Initial Stock Quantity', '0', Icons.inventory_2_rounded, isNumber: true),
        ],

        const SizedBox(height: 32),

        // 4. Description
        _buildSectionHeader('ADDITIONAL DETAILS'),
        _buildTextField(_descCtrl, 'Description', 'Internal notes or details...', Icons.notes_rounded, maxLines: 3),
        
        const SizedBox(height: 48),
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.5)),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, String hint, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label, hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(color: AppColors.darkGrey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
