// lib/features/wallet/screens/billing_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:intl/intl.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});
  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = ''; });
    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('Not signed in');
      final res = await SupabaseService.client
          .from('billing_history')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      setState(() { _history = List<Map<String, dynamic>>.from(res); });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sub = context.watch<SubscriptionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Billing History',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.lightGrey),
                  const SizedBox(height: 12),
                  Text(_error, style: const TextStyle(color: AppColors.darkGrey)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Retry')),
                ]))
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _buildCurrentCycle(sub),
                    if (_history.isNotEmpty) ...[
                      _buildTransactionsHeader(),
                      ..._history.map((tx) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: _buildTransactionItem(tx),
                      )),
                    ] else
                      _buildEmptyHistory(),
                    const SizedBox(height: 80),
                  ]),
                ),
      ),
    );
  }

  Widget _buildCurrentCycle(SubscriptionController sub) {
    final tierLabel = sub.currentTier == SubscriptionTier.elite
        ? 'Noble Elite'
        : sub.currentTier == SubscriptionTier.pulse
            ? 'Noble Pulse'
            : 'Noble Solo (Free)';

    final expiryLabel = sub.expiresAt != null
        ? DateFormat('MMM dd, yyyy').format(sub.expiresAt!)
        : 'No expiry';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('CURRENT PLAN', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: sub.isPulseOrElite ? AppColors.success.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sub.isPulseOrElite ? 'ACTIVE' : 'FREE',
                    style: TextStyle(
                      color: sub.isPulseOrElite ? AppColors.success : Colors.grey,
                      fontSize: 9, fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(tierLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 28),
              ),
            ]),
            if (sub.isPulseOrElite) ...[
              const SizedBox(height: 20),
              Divider(color: AppColors.lightGrey.withOpacity(0.1)),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Renews on', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                Text(expiryLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }

  Widget _buildTransactionsHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 8, 24, 16),
      child: Text('PAST TRANSACTIONS',
          style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    final isSuccess = tx['status'] == 'success';
    final amount    = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final currency  = tx['currency'] as String? ?? 'USD';
    final plan      = tx['plan'] as String? ?? 'Unknown Plan';
    final period    = tx['billing_period'] as String? ?? '';
    final date      = tx['created_at'] != null
        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(tx['created_at'] as String))
        : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.1)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSuccess ? AppColors.background : Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSuccess ? Icons.receipt_long_rounded : Icons.error_outline_rounded,
            color: isSuccess ? Colors.grey : Colors.red, size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Noble $plan ${period.isNotEmpty ? '($period)' : ''}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w500)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$currency ${amount.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14,
                  color: isSuccess ? Colors.black : Colors.red)),
          if (!isSuccess)
            const Text('FAILED', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.w900)),
        ]),
      ]),
    );
  }

  Widget _buildEmptyHistory() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(child: Column(children: [
        Icon(Icons.history_edu_rounded, color: AppColors.lightGrey, size: 48),
        SizedBox(height: 12),
        Text('No billing history yet', style: TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w500)),
        SizedBox(height: 4),
        Text('Your payment receipts will appear here.', style: TextStyle(color: AppColors.lightGrey, fontSize: 12)),
      ])),
    );
  }
}
