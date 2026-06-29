// lib/features/expenses/screens/expense_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/expenses/controllers/expense_controller.dart';
import 'package:noble_invoice/features/expenses/models/expense_model.dart';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String? _selectedCatId;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseController>().loadAll().then((_) {
        setState(() {
          _tabCtrl = TabController(length: context.read<ExpenseController>().categories.length + 1, vsync: this);
        });
      });
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ExpenseController>();
    final cats = [ExpenseCategory(id: 'all', name: 'All'), ...ctrl.categories];
    
    final filtered = _selectedCatId == null || _selectedCatId == 'all' 
        ? ctrl.expenses 
        : ctrl.expenses.where((e) => e.categoryId == _selectedCatId).toList();

    final total    = filtered.fold(0.0, (sum, e) => sum + e.amount);
    final linked   = filtered.where((e) => e.isLinked).length;
    final unlinked = filtered.length - linked;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary), onPressed: () => Navigator.pop(context)),
        title: const Text('Expenses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.black)),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          labelColor: AppColors.primary, unselectedLabelColor: AppColors.darkGrey,
          indicatorColor: AppColors.primary, indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          onTap: (i) => setState(() => _selectedCatId = i == 0 ? 'all' : cats[i].id),
          tabs: cats.map((c) => Tab(text: c.name)).toList(),
        ),
      ),
      body: ctrl.isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(children: [
            // Summary Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('TOTAL SPENDING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.darkGrey, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.black)),
                const SizedBox(height: 8),
                Row(children: [
                  _SummaryChip(
                    icon: Icons.link_rounded,
                    label: '$linked linked to invoice',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  if (unlinked > 0)
                    _SummaryChip(
                      icon: Icons.link_off_rounded,
                      label: '$unlinked unlinked',
                      color: AppColors.darkGrey,
                    ),
                ]),
              ]),
            ),
            
            // Expense List
            Expanded(child: filtered.isEmpty 
              ? const _EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16), itemCount: filtered.length,
                  itemBuilder: (_, i) => _ExpenseItem(expense: filtered[i], onDelete: () => ctrl.deleteExpense(filtered[i].id)),
                )),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addExpense),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  const _ExpenseItem({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final catColor = Color(int.parse((expense.categoryColor ?? '#94A3B8').replaceAll('#', '0xFF')));
    
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.delete_rounded, color: Colors.white)),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: catColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.receipt_long_rounded, color: catColor, size: 20)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(expense.vendorName ?? expense.categoryName ?? 'Other Expense', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(DateFormat('MMM dd, yyyy').format(expense.date), style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
            // Invoice badge — shown when expense is linked to an invoice
            if (expense.invoiceNumber != null) ...[
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.link_rounded, size: 11, color: AppColors.primary),
                const SizedBox(width: 3),
                Text(expense.invoiceNumber!, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ]),
            ],
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('-\$${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF1E293B))),
            if (expense.receiptUrl != null) const Icon(Icons.attachment_rounded, size: 14, color: AppColors.lightGrey),
          ]),
        ]),
      ),
    );
  }
}

/// Small chip showing linked/unlinked expense summary counts.
class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SummaryChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_rounded, size: 64, color: AppColors.lightGrey.withOpacity(0.5)), const SizedBox(height: 16), const Text('No expenses found', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey)), const SizedBox(height: 8), const Text('Log your business costs to track profit', style: TextStyle(color: AppColors.lightGrey, fontSize: 13))]));
}
