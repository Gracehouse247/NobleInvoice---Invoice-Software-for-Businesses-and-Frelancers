// lib/features/analytics/widgets/cash_flow_tab.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/analytics/controllers/intelligence_controller.dart';

class CashFlowTab extends StatelessWidget {
  final IntelligenceController ctrl;
  const CashFlowTab({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildAlertBanner(),
        if (ctrl.alerts.isNotEmpty) const SizedBox(height: 20),
        _buildKpiRow(context),
        const SizedBox(height: 20),
        _buildCashFlowChart(context),
        const SizedBox(height: 20),
        _buildForecastCard(context),
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _buildAlertBanner() {
    if (ctrl.alerts.isEmpty) return const SizedBox.shrink();
    return Column(children: ctrl.alerts.map(_buildAlertCard).toList());
  }

  Widget _buildAlertCard(SmartAlert alert) {
    final colors = {
      SmartAlertType.danger:   (const Color(0xFFFEE2E2), const Color(0xFF991B1B), AppColors.error),
      SmartAlertType.warning:  (const Color(0xFFFEF3C7), const Color(0xFF92400E), AppColors.warning),
      SmartAlertType.insight:  (const Color(0xFFEEF2FF), const Color(0xFF3730A3), AppColors.primary),
      SmartAlertType.positive: (const Color(0xFFDCFCE7), const Color(0xFF166534), AppColors.success),
    };
    final c = colors[alert.type]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.$1, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.$3.withOpacity(0.3))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(alert.icon, color: c.$3, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(alert.title, style: TextStyle(color: c.$2, fontWeight: FontWeight.w800, fontSize: 13)),
          const SizedBox(height: 2),
          Text(alert.body, style: TextStyle(color: c.$2.withOpacity(0.8), fontSize: 12, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _buildKpiRow(BuildContext context) {
    return Row(children: [
      Expanded(child: _kpiCard('Burn Rate', '${CurrencyFormatter.format(context, ctrl.burnRate)}/mo', Icons.local_fire_department_rounded, AppColors.error)),
      const SizedBox(width: 12),
      Expanded(child: _kpiCard(
        'Runway', '${ctrl.cashRunway > 99 ? "∞" : ctrl.cashRunway.toStringAsFixed(1)} mo',
        Icons.flight_takeoff_rounded,
        ctrl.cashRunway < 3 ? AppColors.error : ctrl.cashRunway < 6 ? AppColors.warning : AppColors.success,
      )),
    ]);
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _buildCashFlowChart(BuildContext context) {
    if (ctrl.cashFlowPoints.isEmpty) return _emptyState('No cash flow data yet.\nStart creating and collecting invoices.', Icons.waterfall_chart_rounded);

    final actual  = ctrl.cashFlowPoints.where((p) => p.actual != 0).toList();
    final proj    = ctrl.cashFlowPoints.where((p) => p.projected != 0).toList();
    final allVals = [...actual.map((p) => p.actual), ...proj.map((p) => p.projected)];
    final maxY    = allVals.isEmpty ? 100.0 : (allVals.reduce(math.max) * 1.3).toDouble();
    final minY    = allVals.isEmpty ? -10.0 : (allVals.reduce(math.min) * 1.3).clamp(-double.infinity, 0).toDouble();
    final actualSpots = actual.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.actual)).toList();
    final projOffset  = actual.isNotEmpty ? actual.length - 1.0 : 0.0;
    final projSpots   = proj.asMap().entries.map((e) => FlSpot(projOffset + e.key.toDouble(), e.value.projected)).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Cash Flow', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.black)),
          Row(children: [_legendDot(AppColors.primary, 'Actual'), const SizedBox(width: 12), _legendDot(AppColors.success, 'Forecast*')]),
        ]),
        const SizedBox(height: 24),
        SizedBox(height: 200, child: LineChart(LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.lightGrey, strokeWidth: 1)),
          titlesData: FlTitlesData(
            leftTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (val, meta) {
              final all = [...actual, ...proj]; final idx = val.toInt();
              if (idx < 0 || idx >= all.length) return const SizedBox.shrink();
              return Padding(padding: const EdgeInsets.only(top: 8), child: Text(all[idx].label, style: const TextStyle(fontSize: 10, color: AppColors.darkGrey, fontWeight: FontWeight.bold)));
            })),
          ),
          borderData: FlBorderData(show: false), minY: minY, maxY: maxY,
          lineBarsData: [
            if (actualSpots.isNotEmpty) LineChartBarData(spots: actualSpots, isCurved: true, color: AppColors.primary, barWidth: 3, dotData: FlDotData(show: actualSpots.length < 8), belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.0)]))),
            if (projSpots.isNotEmpty) LineChartBarData(spots: projSpots, isCurved: true, color: AppColors.success, barWidth: 2, dashArray: [6, 4], dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.success.withOpacity(0.15), AppColors.success.withOpacity(0.0)]))),
          ],
        ))),
      ]),
    );
  }

  Widget _buildForecastCard(BuildContext context) {
    final isPositive = ctrl.projectedNextMonth >= 0;
    final color = isPositive ? AppColors.primary : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(0.1), color.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Next Month Forecast', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(CurrencyFormatter.format(context, ctrl.projectedNextMonth), style: TextStyle(color: isPositive ? AppColors.success : AppColors.error, fontSize: 30, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(isPositive ? 'Projected net income based on your 3-month moving average.' : 'Projected deficit ahead. Focus on converting pending invoices now.', style: TextStyle(color: color.withOpacity(0.7), fontSize: 12, height: 1.5)),
      ]),
    );
  }

  Widget _legendDot(Color color, String label) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 11, color: AppColors.darkGrey, fontWeight: FontWeight.w600))]);
  Widget _emptyState(String msg, IconData icon) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle), child: Icon(icon, size: 40, color: AppColors.darkGrey)), const SizedBox(height: 20), Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14, height: 1.5))])));
}
