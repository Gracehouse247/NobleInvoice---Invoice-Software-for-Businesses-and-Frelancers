import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/core/services/feature_gate_service.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Removed hardcoded _currency
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Refresh list on tab change
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceController>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: Consumer<InvoiceController>(
              builder: (context, ctrl, _) {
                if (ctrl.isLoading && ctrl.invoices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInvoiceList(ctrl, 'all'),
                    _buildInvoiceList(ctrl, 'draft'),
                    _buildInvoiceList(ctrl, 'pending'),
                    _buildInvoiceList(ctrl, 'paid'),
                    _buildInvoiceList(ctrl, 'overdue'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkGrey, size: 20),
              ),
              const Text(
                'Invoice History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  final fg = FeatureGateService();
                  final ctrl = context.read<InvoiceController>();
                  final currentMonthInvoices = ctrl.invoices.where((i) {
                    final d = DateTime.tryParse(i.issueDate);
                    if (d == null) return false;
                    final now = DateTime.now();
                    return d.year == now.year && d.month == now.month;
                  }).length;

                  if (fg.maxInvoicesPerMonth != -1 && currentMonthInvoices >= fg.maxInvoicesPerMonth) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Monthly invoice limit reached. Please upgrade.')));
                    Navigator.pushNamed(context, AppRoutes.pricingPlans);
                    return;
                  }
                  await Navigator.pushNamed(context, AppRoutes.invoiceTypeSelection);
                  if (context.mounted) ctrl.loadDashboard();
                },
                icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search client or invoice #',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Drafts'),
          Tab(text: 'Pending'),
          Tab(text: 'Paid'),
          Tab(text: 'Overdue'),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(InvoiceController ctrl, String status) {
    final filtered = ctrl.invoices.where((i) {
      final matchesStatus = status == 'all' || i.status == status;
      final matchesSearch = i.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            i.invoiceNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No $status invoices found', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ctrl.loadDashboard(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = filtered[index];
          return _buildInvoiceCard(item);
        },
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceListItem item) {
    final statusColor = _getStatusColor(item.status);
    final date = item.issueDate.isNotEmpty 
      ? DateFormat('MMM dd, yyyy').format(DateTime.parse(item.issueDate))
      : 'No date';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceDetails, arguments: item.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.description_rounded, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${item.invoiceNumber} • $date', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                _buildStatusBadge(item.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.lightGrey),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(CurrencyFormatter.format(context, item.totalAmount), style: const TextStyle(color: AppColors.primary, fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green;
      case 'pending': return Colors.amber;
      case 'overdue': return Colors.red;
      default: return Colors.grey;
    }
  }
}
