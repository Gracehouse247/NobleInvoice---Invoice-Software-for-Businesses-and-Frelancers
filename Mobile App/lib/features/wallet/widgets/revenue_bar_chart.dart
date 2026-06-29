// lib/features/wallet/widgets/revenue_bar_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/wallet/controllers/revenue_analytics_controller.dart';

class RevenueBarChart extends StatefulWidget {
  final List<MonthPoint> points;
  final BuildContext parentContext;
  const RevenueBarChart({super.key, required this.points, required this.parentContext});

  @override
  State<RevenueBarChart> createState() => _RevenueBarChartState();
}

class _RevenueBarChartState extends State<RevenueBarChart> {
  int _touchedGroupIndex = -1;

  static const _paidColor   = AppColors.primary;
  static const _pendingColor = Color(0xFFFBBF24);
  static const _expenseColor = AppColors.error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue vs. Expenses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: _maxY,
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (event is FlTapUpEvent && response?.spot != null) {
                        _touchedGroupIndex = response!.spot!.touchedBarGroupIndex;
                      } else {
                        _touchedGroupIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final p = widget.points[groupIndex];
                      final labels = ['Paid', 'Pending', 'Expense'];
                      final vals = [p.paid, p.pending, p.expenses];
                      return BarTooltipItem(
                        '${labels[rodIndex]}\n${CurrencyFormatter.format(widget.parentContext, vals[rodIndex])}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= widget.points.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(widget.points[idx].label,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFEEF2F7), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(widget.points.length, (i) {
                  final p = widget.points[i];
                  final isTouched = i == _touchedGroupIndex;
                  return BarChartGroupData(
                    x: i,
                    groupVertically: false,
                    barRods: [
                      _rod(p.paid,     _paidColor,    isTouched),
                      _rod(p.pending,  _pendingColor,  isTouched),
                      _rod(p.expenses, _expenseColor,  isTouched),
                    ],
                  );
                }),
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
              swapAnimationCurve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            _legend(_paidColor,   'Paid'),
            const SizedBox(width: 16),
            _legend(_pendingColor, 'Pending'),
            const SizedBox(width: 16),
            _legend(_expenseColor, 'Expense'),
          ]),
        ],
      ),
    );
  }

  double get _maxY {
    if (widget.points.isEmpty) return 100;
    return widget.points.fold<double>(0, (m, p) {
      final max = [p.paid + p.pending, p.expenses].reduce((a, b) => a > b ? a : b);
      return max > m ? max : m;
    }) * 1.2;
  }

  BarChartRodData _rod(double value, Color color, bool isTouched) =>
    BarChartRodData(
      toY: value,
      color: isTouched ? color : color.withOpacity(0.1),
      width: value > 0 ? 10 : 6,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );

  Widget _legend(Color color, String label) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 6),
    Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
  ]);
}
