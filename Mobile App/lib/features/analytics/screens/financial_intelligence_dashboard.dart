import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/features/analytics/controllers/intelligence_controller.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/analytics/widgets/cash_flow_tab.dart';
import 'package:noble_invoice/features/analytics/widgets/client_reliability_tab.dart';
import 'package:noble_invoice/features/analytics/widgets/expenses_tab.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/core/widgets/subscription_guard.dart';

class FinancialIntelligenceDashboard extends StatefulWidget {
  const FinancialIntelligenceDashboard({super.key});

  @override
  State<FinancialIntelligenceDashboard> createState() => _FinancialIntelligenceDashboardState();
}

class _FinancialIntelligenceDashboardState extends State<FinancialIntelligenceDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final teamId   = context.read<TeamController>().activeTeamId;
    final currency = context.read<InvoiceController>().currencyCode;
    if (teamId != null) context.read<IntelligenceController>().load(teamId, baseCurrency: currency);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Consumer<IntelligenceController>(
        builder: (context, ctrl, _) => NestedScrollView(
          headerSliverBuilder: (context, _) => [_buildSliverHeader(ctrl)],
          body: ctrl.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3))
              : ctrl.error.isNotEmpty
                  ? _buildError(ctrl.error)
                  : _buildBody(ctrl),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(IntelligenceController ctrl) {
    final bool canPop = ModalRoute.of(context)?.canPop ?? false;
    final bool isPushed = ModalRoute.of(context)?.settings.name == AppRoutes.financialIntelligence;

    return SliverAppBar(
      expandedHeight: 240, pinned: true, 
      backgroundColor: AppColors.lightGrey,
      elevation: 0,
      leading: (canPop && isPushed) 
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20), 
            onPressed: () => Navigator.maybePop(context),
          )
        : null,
      actions: [IconButton(icon: const Icon(Icons.refresh_rounded, color: AppColors.primary), onPressed: _load)],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            _buildHeroHeader(ctrl),
            // Decorative shapes
            Positioned(top: -50, right: -50, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.05)))),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.lightGrey),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary, indicatorWeight: 4,
            labelColor: AppColors.primary, unselectedLabelColor: AppColors.darkGrey.withOpacity(0.5),
            labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
            dividerColor: Colors.transparent,
            tabs: const [Tab(text: 'CASH FLOW'), Tab(text: 'CLIENTS'), Tab(text: 'EXPENSES')],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(IntelligenceController ctrl) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
          colors: [
            AppColors.primary.withOpacity(0.12), 
            AppColors.primary.withOpacity(0.04)
          ]
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.3))),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 14),
                  SizedBox(width: 8),
                  Text('NOBLE INTELLIGENCE', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: const Text('Financial Insights', style: TextStyle(color: AppColors.textBlack, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _heroKpi('Current Balance', CurrencyFormatter.format(context, ctrl.currentBalance), ctrl.currentBalance >= 0 ? const Color(0xFF10B981) : const Color(0xFFF43F5E)),
                _heroDivider(),
                _heroKpi('DSO Index', '${ctrl.dso.toStringAsFixed(0)}d', Colors.amberAccent),
                _heroDivider(),
                _heroKpi('Recovery Rate', '${ctrl.collectionRate.toStringAsFixed(0)}%', ctrl.collectionRate >= 80 ? const Color(0xFF10B981) : AppColors.warning),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroKpi(String label, String value, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: [
      Text(label, style: TextStyle(color: AppColors.darkGrey.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
    ],
  );

  Widget _heroDivider() => Container(width: 1, height: 32, color: AppColors.lightGrey);

  Widget _buildBody(IntelligenceController ctrl) {
    final sub = context.watch<SubscriptionController>();
    final isLocked = sub.currentTier == SubscriptionTier.solo || sub.isExpired;

    return SubscriptionGuard(
      isLocked: isLocked,
      featureName: 'Advanced Financial Analytics',
      upgradeMessage: 'Unlock deep insights into your cash flow, client reliability, and expense trends with Noble Pulse.',
      child: Container(
        color: const Color(0xFFF8FAFC),
        child: TabBarView(
          controller: _tabController, 
          physics: const BouncingScrollPhysics(),
          children: [
            CashFlowTab(ctrl: ctrl),
            ClientReliabilityTab(ctrl: ctrl),
            ExpensesTab(ctrl: ctrl),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error) => Center(child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
      const SizedBox(height: 16),
      Text(error, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      ElevatedButton.icon(
        onPressed: _load, 
        icon: const Icon(Icons.refresh_rounded), 
        label: const Text('RETRY SYNC'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ]),
  ));
}
