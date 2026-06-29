// lib/features/analytics/widgets/expenses_tab.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/analytics/controllers/intelligence_controller.dart';

class ExpensesTab extends StatefulWidget {
  final IntelligenceController ctrl;
  const ExpensesTab({super.key, required this.ctrl});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.ctrl.expenseBurns.isEmpty) {
      return _emptyState('No expense data available.\nLog your business expenses to see your spending breakdown.', Icons.receipt_long_rounded);
    }
    final total = widget.ctrl.expenseBurns.fold(0.0, (s, e) => s + e.amount);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildPieChart(total),
        const SizedBox(height: 20),
        const Text('Category Breakdown', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.black)),
        const SizedBox(height: 12),
        ...widget.ctrl.expenseBurns.map((b) => _buildBurnRow(context, b, total)),
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _buildPieChart(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(children: [
        const Text('Expense Allocation', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.black)),
        const SizedBox(height: 20),
        SizedBox(height: 220, child: Row(children: [
          Expanded(child: PieChart(PieChartData(
            pieTouchData: PieTouchData(touchCallback: (event, response) => setState(() => _touchedPieIndex = response?.touchedSection?.touchedSectionIndex ?? -1)),
            sectionsSpace: 2, centerSpaceRadius: 50,
            sections: widget.ctrl.expenseBurns.asMap().entries.map((e) {
              final isTouched = e.key == _touchedPieIndex;
              final pct = total > 0 ? e.value.amount / total : 0;
              return PieChartSectionData(color: e.value.color, value: e.value.amount, title: isTouched ? '${(pct * 100).toStringAsFixed(0)}%' : '', radius: isTouched ? 72 : 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12));
            }).toList(),
          ))),
          const SizedBox(width: 16),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: widget.ctrl.expenseBurns.take(5).map((b) =>
            Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: b.color, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 6),
              Text(b.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.black)),
            ]))
          ).toList()),
        ])),
      ]),
    );
  }

  Widget _buildBurnRow(BuildContext context, ExpenseBurn burn, double total) {
    final pct = total > 0 ? burn.amount / total : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: burn.color, borderRadius: BorderRadius.circular(3))), const SizedBox(width: 8), Text(burn.category, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.black))]),
          Text(CurrencyFormatter.format(context, burn.amount), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.black)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.lightGrey, valueColor: AlwaysStoppedAnimation<Color>(burn.color), minHeight: 6)),
        const SizedBox(height: 4),
        Text('${(pct * 100).toStringAsFixed(1)}% of total spend', style: const TextStyle(fontSize: 11, color: AppColors.darkGrey)),
      ]),
    );
  }

  Widget _emptyState(String msg, IconData icon) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle), child: Icon(icon, size: 40, color: AppColors.darkGrey)), const SizedBox(height: 20), Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14, height: 1.5))])));
}
