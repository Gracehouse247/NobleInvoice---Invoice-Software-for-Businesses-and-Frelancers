// lib/features/invoicing/screens/recurring_invoices_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/recurring_invoice_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class RecurringInvoicesScreen extends StatefulWidget {
  const RecurringInvoicesScreen({super.key});

  @override
  State<RecurringInvoicesScreen> createState() => _RecurringInvoicesScreenState();
}

class _RecurringInvoicesScreenState extends State<RecurringInvoicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecurringInvoiceController>().loadSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RecurringInvoiceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recurring Invoices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.createRecurringInvoice)
                  .then((_) => ctrl.loadSchedules()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
              label: const Text('New', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
      body: ctrl.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ctrl.schedules.isEmpty
          ? _buildEmpty()
          : RefreshIndicator(
              onRefresh: ctrl.loadSchedules,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryBanner(ctrl),
                  const SizedBox(height: 16),
                  ...ctrl.schedules.map((s) => _RecurringCard(
                    schedule: s,
                    onToggle: (v) => _toggle(ctrl, s.id, v),
                    onDelete: () => _delete(ctrl, s.id),
                  )),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryBanner(RecurringInvoiceController ctrl) {
    final active = ctrl.schedules.where((s) => s.isActive).length;
    final paused = ctrl.schedules.length - active;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        const Icon(Icons.autorenew_rounded, color: Colors.white, size: 36),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$active Active', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
          Text('$paused paused • ${ctrl.schedules.length} total', style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
          child: const Text('AUTO-RUNS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
        ),
      ]),
    );
  }

  Widget _buildEmpty() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
        child: const Icon(Icons.autorenew_rounded, size: 56, color: AppColors.primary),
      ),
      const SizedBox(height: 20),
      const Text('No Recurring Invoices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 8),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          'Set up automatic invoicing for retainers, subscriptions, or any recurring client work.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.darkGrey, height: 1.5),
        ),
      ),
      const SizedBox(height: 28),
      ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createRecurringInvoice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Create First Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ]));
  }

  Future<void> _toggle(RecurringInvoiceController ctrl, String id, bool value) async {
    await ctrl.toggleActive(id, value);
    if (ctrl.error.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ctrl.error), backgroundColor: AppColors.error));
    }
  }

  Future<void> _delete(RecurringInvoiceController ctrl, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Schedule?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This recurring invoice schedule will be permanently removed. Past invoices will not be affected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) await ctrl.deleteSchedule(id);
  }
}

// ── Recurring Schedule Card ────────────────────────────────────────────────────

class _RecurringCard extends StatelessWidget {
  final RecurringSchedule schedule;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _RecurringCard({required this.schedule, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final total      = schedule.totalAmount;
    final nextRun    = DateFormat('MMM dd, yyyy').format(schedule.nextRunAt);
    final lastRun    = schedule.lastRunAt != null ? DateFormat('MMM dd, yyyy').format(schedule.lastRunAt!) : 'Never';
    final isOverdue  = schedule.nextRunAt.isBefore(DateTime.now()) && schedule.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: schedule.isActive ? AppColors.primary.withOpacity(0.2) : AppColors.lightGrey),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // Top row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
          child: Row(children: [
            // Frequency icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: schedule.isActive ? AppColors.primary.withOpacity(0.1) : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.autorenew_rounded,
                color: schedule.isActive ? AppColors.primary : AppColors.darkGrey, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(schedule.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 2),
              Row(children: [
                _FrequencyBadge(schedule.frequency.label),
                const SizedBox(width: 8),
                if (!schedule.isActive) const _StatusChip('Paused', AppColors.darkGrey),
                if (isOverdue) const _StatusChip('Due Now', AppColors.warning),
              ]),
            ])),
            // Toggle & amount
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Switch.adaptive(
                value: schedule.isActive,
                onChanged: onToggle,
                activeColor: AppColors.primary,
              ),
              Text('\$${total.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
                  color: schedule.isActive ? AppColors.primary : AppColors.darkGrey)),
              const Text('per cycle', style: TextStyle(fontSize: 10, color: AppColors.darkGrey)),
            ]),
          ]),
        ),

        // Divider
        const Divider(height: 1, indent: 16, endIndent: 16),

        // Dates row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(children: [
            _InfoPill(icon: Icons.schedule_rounded, label: 'Next', value: nextRun,
              highlight: isOverdue, color: isOverdue ? AppColors.warning : AppColors.primary),
            const SizedBox(width: 8),
            _InfoPill(icon: Icons.history_rounded, label: 'Last Run', value: lastRun),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
              onPressed: onDelete,
              tooltip: 'Delete schedule',
            ),
          ]),
        ),
      ]),
    );
  }
}

class _FrequencyBadge extends StatelessWidget {
  final String label;
  const _FrequencyBadge(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color  color;
  const _StatusChip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
  );
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  final bool     highlight;
  final Color    color;
  const _InfoPill({required this.icon, required this.label, required this.value, this.highlight = false, this.color = AppColors.darkGrey});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 14, color: highlight ? color : AppColors.darkGrey),
    const SizedBox(width: 4),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.darkGrey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: highlight ? color : AppColors.black)),
    ]),
  ]);
}
