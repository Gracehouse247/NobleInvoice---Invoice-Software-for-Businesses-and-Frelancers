// lib/features/clients/screens/crm_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/clients/controllers/client_crm_controller.dart';
import 'package:noble_invoice/features/clients/models/crm_models.dart';
import 'package:noble_invoice/features/clients/screens/add_client_sheet.dart';
import 'package:noble_invoice/features/invoicing/screens/client_details_screen.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CrmDashboardScreen extends StatefulWidget {
  const CrmDashboardScreen({super.key});

  @override
  State<CrmDashboardScreen> createState() => _CrmDashboardScreenState();
}

class _CrmDashboardScreenState extends State<CrmDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  LeadStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientCrmController>().loadClients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setFilter(LeadStatus? status) {
    setState(() => _selectedFilter = status);
    context.read<ClientCrmController>().setFilter(status);
  }

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<ClientCrmController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Clients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        _buildSearchBox(context, crm),
        _buildPipelineStrip(crm),
        const Divider(height: 1),
        Expanded(
          child: crm.isLoading && crm.clients.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : crm.clients.isEmpty
                  ? _buildEmptyState()
                  : _buildClientList(crm.clients),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openAddClientSheet(context),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('New Client', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context, ClientCrmController crm) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => crm.setSearchQuery(val),
        decoration: InputDecoration(
          hintText: 'Search by name, company, or email...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () { _searchController.clear(); crm.setSearchQuery(''); },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildPipelineStrip(ClientCrmController crm) {
    final allClients = crm.clients;
    int count(LeadStatus? s) => s == null
        ? allClients.length
        : allClients.where((c) => LeadStatusExtension.fromString(c.leadStatus) == s).length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _filterChip(null, 'All', count(null)),
          const SizedBox(width: 8),
          ...LeadStatus.values.map((s) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _filterChip(s, '${s.emoji} ${s.label}', count(s)),
          )),
        ]),
      ),
    );
  }

  Widget _filterChip(LeadStatus? status, String label, int count) {
    final isSelected = _selectedFilter == status;
    final color = status?.color ?? AppColors.primary;
    return GestureDetector(
      onTap: () => _setFilter(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.people_outline, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text('No clients found',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Add your first client to start managing relationships.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ]),
    );
  }

  Widget _buildClientList(List<Client> clients) {
    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.all(16).copyWith(bottom: 100),
        itemCount: clients.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final client = clients[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: _buildClientCard(client)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClientCard(Client client) {
    final status = LeadStatusExtension.fromString(client.leadStatus);
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ClientDetailsScreen(client: client)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          // Avatar with status dot
          Stack(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18),
              ),
            ),
            Positioned(
              right: 0, bottom: 0,
              child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (client.businessName != null && client.businessName!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    client.position != null
                        ? '${client.position} @ ${client.businessName}'
                        : client.businessName!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              if (client.email.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(client.email,
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ),
            ]),
          ),
          // Status label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status.label,
                style: TextStyle(color: status.color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  void _openAddClientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddClientSheet(),
    );
  }
}
