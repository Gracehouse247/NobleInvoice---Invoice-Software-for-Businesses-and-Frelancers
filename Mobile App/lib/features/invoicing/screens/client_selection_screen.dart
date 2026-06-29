import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/features/clients/controllers/client_crm_controller.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:noble_invoice/features/clients/screens/add_client_sheet.dart';

class ClientSelectionScreen extends StatefulWidget {
  const ClientSelectionScreen({super.key});

  @override
  State<ClientSelectionScreen> createState() => _ClientSelectionScreenState();
}

class _ClientSelectionScreenState extends State<ClientSelectionScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientCrmController>().loadClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<ClientCrmController>();
    final teamCtrl = context.watch<TeamController>();
    final clients = crm.clients.where((c) {
      final q = _searchQuery.toLowerCase();
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
             c.email.toLowerCase().contains(q) ||
             (c.businessName?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Client', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (teamCtrl.activeTeamId != null)
            IconButton(
              icon: const Icon(Icons.person_add_rounded, color: AppColors.primary),
              onPressed: () async {
                // Show sheet and wait for result (the new Client object)
                final newClient = await showModalBottomSheet<Client>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AddClientSheet(),
                );
                // If a client was saved, auto-select it and return to invoice
                if (newClient != null && mounted) {
                  Navigator.pop(context, newClient);
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: crm.isLoading && crm.clients.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : crm.error.isNotEmpty && crm.clients.isEmpty
                  ? _buildErrorState(crm)
                  : clients.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => crm.loadClients(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: clients.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final client = clients[index];
                            return _buildClientCard(client);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: const InputDecoration(
            hintText: 'Search by name or email...',
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.darkGrey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(Client client) {
    return InkWell(
      onTap: () => Navigator.pop(context, client),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                client.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (client.businessName != null && client.businessName!.isNotEmpty)
                    Text(client.businessName!,
                      style: TextStyle(color: AppColors.primary.withOpacity(0.1),
                        fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(client.email,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.lightGrey),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No clients found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(_searchQuery.isEmpty 
            ? 'Start by adding your first client.' 
            : 'Try a different search term.',
            style: TextStyle(color: Colors.grey.shade500)),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final newClient = await showModalBottomSheet<Client>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AddClientSheet(),
                );
                // Auto-select and return newly created client to invoice builder
                if (newClient != null && mounted) {
                  Navigator.pop(context, newClient);
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add First Client'),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildErrorState(ClientCrmController crm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(crm.error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => crm.loadClients(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
