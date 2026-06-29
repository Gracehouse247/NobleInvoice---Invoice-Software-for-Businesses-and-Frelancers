// lib/features/inventory/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/inventory/controllers/product_controller.dart';
import 'package:noble_invoice/features/inventory/models/product_model.dart';

import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/features/wallet/widgets/upgrade_prompt_sheet.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sub = context.read<SubscriptionController>();
      if (!sub.canUse('inventory')) {
        UpgradePromptSheet.show(context, 'Inventory Management');
      } else {
        context.read<ProductController>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ProductController>();
    final sub = context.watch<SubscriptionController>();
    
    if (!sub.canUse('inventory')) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: AppColors.primary)),
        body: const Center(
          child: UpgradePromptSheet(feature: 'Inventory Management'),
        ),
      );
    }

    final filtered = ctrl.products.where((p) {
      final matchName = p.name.toLowerCase().contains(_query.toLowerCase());
      final matchSku  = p.sku?.toLowerCase().contains(_query.toLowerCase()) ?? false;
      return matchName || matchSku;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Product Catalog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black)),
      ),
      body: Column(children: [
        // 1. Search Bar
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search by name or SKU...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        
        // 2. Product List
        Expanded(child: ctrl.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : filtered.isEmpty 
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _ProductListItem(product: filtered[i]),
              )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.inventory_2_rounded, size: 64, color: AppColors.lightGrey.withOpacity(0.5)),
      const SizedBox(height: 16),
      const Text('No products found', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey, fontSize: 16)),
      const SizedBox(height: 8),
      const Text('Register your items to use them on invoices.', style: TextStyle(color: AppColors.lightGrey, fontSize: 13)),
    ]));
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  const _ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final bool lowStock = product.trackInventory && product.stockQuantity <= 5;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        // 1. Icon / Image placeholder
        Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(14)), child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary.withOpacity(0.7), size: 24)),
        const SizedBox(width: 16),
        
        // 2. Main Info
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.black)),
          const SizedBox(height: 4),
          Row(children: [
            if (product.sku != null) ...[
              Text(product.sku!, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text('|', style: TextStyle(color: AppColors.lightGrey, fontSize: 11)),
              const SizedBox(width: 8),
            ],
            Text('\$${product.unitPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]),
        ])),

        // 3. Stock Level
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (product.trackInventory) ...[
            Text('${product.stockQuantity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: lowStock ? AppColors.error : AppColors.black)),
            Text(lowStock ? 'LOW STOCK' : 'IN STOCK', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: lowStock ? AppColors.error : AppColors.success, letterSpacing: 1)),
          ] else ...[
            const Text('SERVICE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1)),
          ],
        ]),
      ]),
    );
  }
}
