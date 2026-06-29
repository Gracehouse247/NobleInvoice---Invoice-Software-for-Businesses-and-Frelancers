// lib/features/wallet/widgets/client_donut_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/wallet/controllers/revenue_analytics_controller.dart';

class ClientDonutChart extends StatefulWidget {
  final List<ClientShare> shares;
  final BuildContext parentContext;
  const ClientDonutChart({super.key, required this.shares, required this.parentContext});

  @override
  State<ClientDonutChart> createState() => _ClientDonutChartState();
}

class _ClientDonutChartState extends State<ClientDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.shares.isEmpty) return const SizedBox();
    final grandTotal = widget.shares.fold<double>(0, (s, c) => s + c.total);

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
          const Text('Revenue by Client',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            children: [
              // Donut Chart
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _touchedIndex = (event is FlTapUpEvent && response?.touchedSection != null)
                              ? response!.touchedSection!.touchedSectionIndex
                              : -1;
                        });
                      },
                    ),
                    sectionsSpace: 3,
                    centerSpaceRadius: 48,
                    sections: List.generate(widget.shares.length, (i) {
                      final share = widget.shares[i];
                      final pct = grandTotal > 0 ? share.total / grandTotal : 0.0;
                      final isTouched = i == _touchedIndex;
                      final color = HSLColor.fromAHSL(1, (i * 47).toDouble() % 360, 0.7, 0.55).toColor();
                      return PieChartSectionData(
                        value: share.total,
                        color: color,
                        radius: isTouched ? 52 : 44,
                        showTitle: isTouched,
                        title: '${(pct * 100).toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(widget.shares.length, (i) {
                    final share = widget.shares[i];
                    final pct  = grandTotal > 0 ? (share.total / grandTotal * 100) : 0.0;
                    final color = HSLColor.fromAHSL(1, (i * 47).toDouble() % 360, 0.7, 0.55).toColor();
                    final isTouched = i == _touchedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Container(
                          width: isTouched ? 12 : 8,
                          height: isTouched ? 12 : 8,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(share.name,
                                  style: TextStyle(fontWeight: isTouched ? FontWeight.bold : FontWeight.w500, fontSize: 12),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                '${pct.toStringAsFixed(1)}% · ${CurrencyFormatter.format(widget.parentContext, share.total)}',
                                style: const TextStyle(fontSize: 10, color: AppColors.darkGrey),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
