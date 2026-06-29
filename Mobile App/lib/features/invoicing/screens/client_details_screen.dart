// lib/features/invoicing/screens/client_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/utils/currency_formatter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/clients/controllers/client_crm_controller.dart';
import 'package:noble_invoice/features/clients/models/crm_models.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/features/invoicing/widgets/client_details_widgets.dart';
import 'package:noble_invoice/features/invoicing/widgets/client_details_sheets.dart';
import 'package:noble_invoice/features/clients/screens/add_client_sheet.dart';
import 'package:intl/intl.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/core/widgets/subscription_guard.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Client client;
  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Client _client;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientCrmController>().loadTimeline(_client.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  LeadStatus get _currentStatus =>
      LeadStatusExtension.fromString(_client.leadStatus);

  @override
  Widget build(BuildContext context) {
    final crm = context.watch<ClientCrmController>();
    final sub = context.watch<SubscriptionController>();
    final isLocked = sub.currentTier == SubscriptionTier.solo || sub.isExpired;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [_buildSliverHeader(crm)],
        body: Column(children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(crm),
                SubscriptionGuard(
                  isLocked: isLocked,
                  featureName: 'Deep CRM Timeline',
                  upgradeMessage: 'Your relationship history is a premium asset. Renew Pulse to unlock this timeline.',
                  child: _buildTimelineTab(crm),
                ),
                SubscriptionGuard(
                  isLocked: isLocked,
                  featureName: 'Document Vault',
                  upgradeMessage: 'Secure contracts and briefs are Pulse features. Renew to access your files.',
                  child: _buildDocumentsTab(crm),
                ),
                _buildInvoicesTab(crm),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(crm),
    );
  }

  // ── Sliver Header ──────────────────────────────────────────────────────────
  Widget _buildSliverHeader(ClientCrmController crm) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
          tooltip: 'Edit Client',
          onPressed: () async {
            final updated = await showModalBottomSheet<Client>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => FractionallySizedBox(
                heightFactor: 0.92,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: AddClientSheet(existingClient: _client),
                ),
              ),
            );
            if (updated != null && mounted) {
              setState(() => _client = updated);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.primary),
          onPressed: () => _showOptionsMenu(crm),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF1F5F9)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50, right: -50,
                child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.03))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 84, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      // Avatar
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          _client.name.isNotEmpty ? _client.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 26),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_client.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                            overflow: TextOverflow.ellipsis),
                        if (_client.position != null || _client.businessName != null)
                          Text(
                            [_client.position, _client.businessName].where((s) => s != null && s.isNotEmpty).join(' @ '),
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                      ])),
                      // Lead Status Chip
                      _buildStatusChip(),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      ClientStatPill(icon: Icons.payments_rounded,
                          value: CurrencyFormatter.format(context, crm.clientRevenue), label: 'Revenue'),
                      const SizedBox(width: 12),
                      ClientStatPill(icon: Icons.receipt_long_rounded,
                          value: crm.invoices.length.toString(), label: 'Invoices'),
                      const SizedBox(width: 12),
                      ClientStatPill(icon: Icons.sticky_note_2_rounded,
                          value: crm.notes.length.toString(), label: 'Notes'),
                    ]),
                    const SizedBox(height: 12),
                    // Quick contact actions
                    Row(children: [
                      if (_client.email.isNotEmpty)
                        _contactButton(Icons.email_rounded, 'Email',
                            () => _launch('mailto:${_client.email}')),
                      if (_client.fullPhone.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _contactButton(Icons.phone_rounded, 'Call',
                            () => _launch('tel:${_client.fullPhone}')),
                        const SizedBox(width: 8),
                        _contactButton(Icons.chat_rounded, 'WhatsApp',
                            () => _launch('https://wa.me/${_client.fullPhone.replaceAll('+', '')}')),
                      ],
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final status = _currentStatus;
    return GestureDetector(
      onTap: () => _showStatusPicker(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: status.color.withOpacity(0.1)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(status.emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(status.label, style: TextStyle(color: status.color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 2),
          Icon(Icons.arrow_drop_down_rounded, color: status.color, size: 16),
        ]),
      ),
    );
  }


  Widget _contactButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
          padding: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.darkGrey,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Timeline'),
          Tab(text: 'Docs'),
          Tab(text: 'Invoices'),
        ],
      ),
    );
  }

  // ── Tab 1: Overview ────────────────────────────────────────────────────────
  Widget _buildOverviewTab(ClientCrmController crm) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      _sectionCard('Contact Information', [
        _infoRow(Icons.email_rounded, 'Email', _client.email, copyable: true),
        if (_client.fullPhone.isNotEmpty)
          _infoRow(Icons.phone_rounded, 'Phone', _client.fullPhone, copyable: true),
        if (_client.address != null && _client.address!.isNotEmpty)
          _infoRow(Icons.location_on_rounded, 'Address', _client.address!),
      ]),
      const SizedBox(height: 16),
      if (_client.tags.isNotEmpty)
        _sectionCard('Tags', [
          Wrap(spacing: 8, runSpacing: 8, children: _client.tags.map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
          )).toList()),
        ]),
    ]);
  }

  // ── Tab 2: Timeline ────────────────────────────────────────────────────────
  Widget _buildTimelineTab(ClientCrmController crm) {
    final notes   = crm.notes;
    final logs    = crm.commLogs;

    if (crm.isLoading) return const Center(child: CircularProgressIndicator());

    return Stack(children: [
      if (notes.isEmpty && logs.isEmpty)
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.timeline_rounded, size: 56, color: AppColors.lightGrey),
          const SizedBox(height: 12),
          const Text('No activity yet', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
          const SizedBox(height: 4),
          Text('Add a note or log a communication activity.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ]))
      else
        ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), children: [
          ...notes.map((n) => _timelineNote(n)),
          ...logs.map((l) => _timelineLog(l)),
        ]),
      Positioned(
        right: 20, bottom: 20,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddNoteSheet(crm),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Note', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  Widget _timelineNote(ClientNote note) {
    return ClientTimelineItem(
      icon: Icons.sticky_note_2_rounded,
      iconColor: AppColors.primary,
      title: note.content,
      subtitle: '${note.authorName ?? 'You'} · ${_fmtDate(note.createdAt)}',
    );
  }

  Widget _timelineLog(CommunicationLog log) {
    return ClientTimelineItem(
      icon: log.icon,
      iconColor: const Color(0xFF6366F1),
      title: log.summary ?? log.type,
      subtitle: '${log.type.toUpperCase()} · ${_fmtDate(log.loggedAt)}',
    );
  }

  // ── Tab 3: Documents ───────────────────────────────────────────────────────
  Widget _buildDocumentsTab(ClientCrmController crm) {
    final docs = crm.documents;

    return Stack(children: [
      if (crm.isLoading)
        const Center(child: CircularProgressIndicator())
      else if (docs.isEmpty)
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.folder_open_rounded, size: 56, color: AppColors.lightGrey),
          const SizedBox(height: 12),
          const Text('No documents yet', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
          const SizedBox(height: 4),
          Text('Upload contracts, briefs, or signed agreements.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ]))
      else
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => ClientDocCard(doc: docs[i], onTap: () => _launch(docs[i].fileUrl)),
        ),
      Positioned(
        right: 20, bottom: 20,
        child: FloatingActionButton.extended(
          onPressed: _uploading ? null : () => _uploadDocument(crm),
          backgroundColor: AppColors.primary,
          icon: _uploading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.upload_file_rounded),
          label: Text(_uploading ? 'Uploading...' : 'Upload',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }


  // ── Tab 4: Invoices ────────────────────────────────────────────────────────
  Widget _buildInvoicesTab(ClientCrmController crm) {
    final inv = crm.invoices;
    if (crm.isLoading) return const Center(child: CircularProgressIndicator());
    if (inv.isEmpty) {
      return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.receipt_long_rounded, size: 56, color: AppColors.lightGrey),
      SizedBox(height: 12),
      Text('No invoices yet', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey)),
    ]));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: inv.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => ClientInvoiceCard(inv: inv[i], onTap: () => Navigator.pushNamed(context, AppRoutes.invoiceDetails, arguments: inv[i].id)),
    );
  }


  // ── Bottom Bar ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar(ClientCrmController crm) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => _createInvoice(crm),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Create Invoice', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showLogActivitySheet(crm),
            icon: const Icon(Icons.add_comment_rounded, size: 16),
            label: const Text('Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
              minimumSize: const Size(0, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ]),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.darkGrey, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ])),
        if (copyable)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label copied'), duration: const Duration(seconds: 1)));
            },
            child: const Icon(Icons.copy_rounded, size: 16, color: AppColors.darkGrey),
          ),
      ]),
    );
  }

  String _fmtDate(DateTime dt) => DateFormat('MMM dd, yyyy').format(dt);

  Color _invoiceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':    return AppColors.success;
      case 'overdue': return AppColors.error;
      case 'pending': return const Color(0xFFF59E0B);
      default:        return AppColors.darkGrey;
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Future<void> _createInvoice(ClientCrmController crm) async {
    final client = await crm.convertToInvoice(_client.id);
    if (client != null && mounted) {
      Navigator.pushNamed(context, AppRoutes.createInvoice,
          arguments: {'preselectedClient': client});
    }
  }

  Future<void> _uploadDocument(ClientCrmController crm) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final file    = result.files.first;
    final name    = file.name;
    final bytes   = file.bytes;
    if (bytes == null) return;

    setState(() => _uploading = true);
    try {
      final path = 'client_docs/${_client.id}/${DateTime.now().millisecondsSinceEpoch}_$name';
      await SupabaseService.client.storage.from('documents').uploadBinary(path, bytes);
      final url = SupabaseService.client.storage.from('documents').getPublicUrl(path);
      await crm.addDocument(_client.id, name, url, size: file.size);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      setState(() => _uploading = false);
    }
  }

  void _showAddNoteSheet(ClientCrmController crm) =>
      ClientDetailsSheets.showAddNote(context: context, clientId: _client.id, crm: crm);

  void _showLogActivitySheet(ClientCrmController crm) =>
      ClientDetailsSheets.showLogActivity(context: context, clientId: _client.id, crm: crm);

  void _showStatusPicker() {
    final crm = context.read<ClientCrmController>();
    ClientDetailsSheets.showStatusPicker(
      context:       context,
      clientId:      _client.id,
      currentStatus: _currentStatus,
      crm:           crm,
      onStatusChanged: (name) => setState(() => _client = _client.copyWith(leadStatus: name)),
    );
  }

  void _showOptionsMenu(ClientCrmController crm) =>
      ClientDetailsSheets.showOptions(context: context, clientEmail: _client.email);
}

