// lib/features/analytics/widgets/client_reliability_tab.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/analytics/controllers/intelligence_controller.dart';

class ClientReliabilityTab extends StatelessWidget {
  final IntelligenceController ctrl;
  const ClientReliabilityTab({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (ctrl.clientReliability.isEmpty) {
      return _emptyState('No client data available.\nCreate invoices and assign them to clients to see reliability scores.', Icons.people_rounded);
    }
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Client Reliability Matrix', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.black)),
      const SizedBox(height: 4),
      const Text('Ranked by payment reliability score', style: TextStyle(color: AppColors.darkGrey, fontSize: 13)),
      const SizedBox(height: 16),
      ...ctrl.clientReliability.asMap().entries.map((e) => _buildClientCard(context, e.value, e.key)),
      const SizedBox(height: 80),
    ]);
  }

  Widget _buildClientCard(BuildContext context, ClientReliability client, int rank) {
    final score = client.reliabilityScore;
    final scoreColor = score >= 75 ? AppColors.success : score >= 50 ? AppColors.warning : AppColors.error;
    final medal = rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '${rank + 1}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(medal, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(client.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.black))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: scoreColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('${score.toStringAsFixed(0)}pts', style: TextStyle(color: scoreColor, fontWeight: FontWeight.w900, fontSize: 13))),
        ]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: score / 100, backgroundColor: AppColors.lightGrey, valueColor: AlwaysStoppedAnimation<Color>(scoreColor), minHeight: 8)),
        const SizedBox(height: 12),
        Row(children: [
          _clientStat('Billed', CurrencyFormatter.format(context, client.totalBilled)),
          _clientStat('Paid',   CurrencyFormatter.format(context, client.totalPaid)),
          _clientStat('Avg Days', '${client.avgDaysToPay.toStringAsFixed(0)}d'),
          _clientStat('Overdue', '${client.overdueCount}x'),
        ]),
      ]),
    );
  }

  Widget _clientStat(String label, String val) => Expanded(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      Text(val, style: const TextStyle(color: AppColors.black, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
    ]),
  );

  Widget _emptyState(String msg, IconData icon) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle), child: Icon(icon, size: 40, color: AppColors.darkGrey)), const SizedBox(height: 20), Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.darkGrey, fontSize: 14, height: 1.5))])));
}
