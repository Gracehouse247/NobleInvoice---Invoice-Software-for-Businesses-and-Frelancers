// lib/features/clients/controllers/client_crm_controller.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/clients/models/crm_models.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_list_item_model.dart';
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/core/services/sentiment_service.dart';

class ClientCrmController extends ChangeNotifier {
  bool   _loading = false;
  String _error   = '';

  List<Client>           _clients      = [];
  List<ClientNote>       _notes        = [];
  List<InvoiceListItem>  _invoices     = [];
  List<ClientDocument>   _documents    = [];
  List<CommunicationLog> _commLogs     = [];
  SubscriptionTier       _currentTier      = SubscriptionTier.solo;
  bool                   _canCreateClient  = false;
  String?                _activeTeamId;
  String                 _searchQuery      = '';
  LeadStatus?            _filterStatus;
  double                 _clientRevenue    = 0;

  void setSubscriptionStatus(SubscriptionTier tier, bool canCreate) {
    _currentTier = tier;
    _canCreateClient = canCreate;
    notifyListeners();
  }

  void setActiveTeamId(String? id) {
    if (_activeTeamId != id) {
      _activeTeamId = id;
      if (id != null) {
        _error = '';
        loadClients();
      } else {
        _error = 'Syncing your business session...';
      }
      notifyListeners();
    }
  }

  bool get isLoading  => _loading;
  String get error    => _error;
  double get clientRevenue => _clientRevenue;
  String? get activeTeamId => _activeTeamId;

  List<Client> get clients {
    var list = _searchQuery.isEmpty
        ? _clients
        : _clients.where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.companyName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
            c.email.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (_filterStatus != null) {
      list = list.where((c) =>
          LeadStatusExtension.fromString(c.leadStatus) == _filterStatus).toList();
    }
    return list;
  }

  List<ClientNote>       get notes    => _notes;
  List<InvoiceListItem>  get invoices => _invoices;
  List<ClientDocument>   get documents => _documents;
  List<CommunicationLog> get commLogs  => _commLogs;

  String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    return e.toString();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(LeadStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }

  // ── Fetch Roster ──────────────────────────────────────────────────────────
  Future<void> loadClients() async {
    if (_activeTeamId == null) return;
    _loading = true;
    _error   = '';
    notifyListeners();
    try {
      final response = await SupabaseService.client
          .from('clients')
          .select()
          .eq('team_id', _activeTeamId!);
      _clients = (response as List).map((data) => Client.fromJson(data)).toList();
      _clients.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      _error = 'Fetch Error: ${_parseError(e)}';
      _clients = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Fetch Timeline Assets ──────────────────────────────────────────────────
  Future<void> loadTimeline(int clientId) async {
    _loading = true;
    _error   = '';
    notifyListeners();
    try {
      // 1. Notes
      final noteRes = await SupabaseService.client
          .from('client_notes')
          .select('*, profiles(name)')
          .eq('client_id', clientId)
          .order('created_at', ascending: false);
      _notes = (noteRes as List).map((j) => ClientNote.fromJson(j)).toList();

      // 2. Invoices
      final invRes = await SupabaseService.client
          .from('invoices')
          .select('*, clients(name, email)')
          .eq('client_id', clientId)
          .order('created_at', ascending: false);
      _invoices = (invRes as List).map((j) => InvoiceListItem.fromJson(j)).toList();

      // 3. Documents
      final docRes = await SupabaseService.client
          .from('client_documents')
          .select('*')
          .eq('client_id', clientId)
          .order('created_at', ascending: false);
      _documents = (docRes as List).map((j) => ClientDocument.fromJson(j)).toList();

      // 4. Communication logs
      final logRes = await SupabaseService.client
          .from('client_communication_logs')
          .select('*')
          .eq('client_id', clientId)
          .order('logged_at', ascending: false);
      _commLogs = (logRes as List).map((j) => CommunicationLog.fromJson(j)).toList();

      // 5. Total client revenue (paid invoices only)
      final revRes = await SupabaseService.client
          .from('invoices')
          .select('total_amount')
          .eq('client_id', clientId)
          .eq('status', 'paid');
      _clientRevenue = (revRes as List).fold(0.0,
          (s, r) => s + (double.tryParse(r['total_amount']?.toString() ?? '0') ?? 0));

    } catch (e) {
      _error = _parseError(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Lead Status ────────────────────────────────────────────────────────────
  Future<bool> updateLeadStatus(int clientId, LeadStatus status) async {
    try {
      final oldClient = _clients.firstWhere((c) => c.id == clientId);
      final oldStatus = LeadStatusExtension.fromString(oldClient.leadStatus);
      
      await SupabaseService.client
          .from('clients')
          .update({'lead_status': status.name})
          .eq('id', clientId);

      // Log status change to timeline
      await addCommunicationLog(
        clientId, 
        'system', 
        'Status changed from ${oldStatus.label} to ${status.label}'
      );

      final idx = _clients.indexWhere((c) => c.id == clientId);
      if (idx != -1) {
        _clients[idx] = _clients[idx].copyWith(leadStatus: status.name);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Communication Log ──────────────────────────────────────────────────────
  Future<bool> addCommunicationLog(int clientId, String type, String summary) async {
    final user = SupabaseService.currentUser;
    if (user == null || _activeTeamId == null) return false;
    try {
      await SupabaseService.client.from('client_communication_logs').insert({
        'team_id':   _activeTeamId!,
        'client_id': clientId,
        'author_id': user.id,
        'type':      type,
        'summary':   summary,
      });
      await loadTimeline(clientId);
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Add Client ────────────────────────────────────────────────────────────
  Future<bool> addClient(Client newClient, SubscriptionController sub) async {
    if (_activeTeamId == null) {
      _error = 'No active business session.';
      notifyListeners();
      return false;
    }
    
    final limitMsg = sub.checkCreateLimit('clients');
    if (limitMsg != null) {
      _error = 'SUBSCRIPTION_LIMIT: $limitMsg';
      notifyListeners();
      return false;
    }

    _loading = true;
    _error   = '';
    notifyListeners();
    try {
      final userId = SupabaseService.currentUser?.id;
      final payload = <String, dynamic>{
        'team_id': _activeTeamId!,
        if (userId != null) 'user_id': userId,
        'name':   newClient.name,
        'email':  newClient.email,
        if (newClient.businessName != null && newClient.businessName!.isNotEmpty)
          'business_name': newClient.businessName,
        if (newClient.phone != null && newClient.phone!.isNotEmpty)
          'phone': newClient.phone,
        if (newClient.country != null) 'country': newClient.country,
        if (newClient.countryCode != null) 'country_code': newClient.countryCode,
        if (newClient.address != null && newClient.address!.isNotEmpty)
          'address': newClient.address,
        if (newClient.position != null && newClient.position!.isNotEmpty)
          'position': newClient.position,
        'lead_status': 'active',
      };
      final response = await SupabaseService.client
          .from('clients').insert(payload).select().single();
      
      await sub.trackUsage('clients'); // Track monthly creation
      
      final savedClient = Client.fromJson(response);
      _clients.add(savedClient);
      _clients.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Save Error: ${_parseError(e)}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Update Client ────────────────────────────────────────────────────────
  Future<bool> updateClient(Client updated, SubscriptionController sub) async {
    final limitMsg = sub.checkEditLimit('clients');
    if (limitMsg != null) {
      _error = 'SUBSCRIPTION_LIMIT: $limitMsg';
      notifyListeners();
      return false;
    }

    _loading = true;
    _error   = '';
    notifyListeners();
    try {
      final payload = <String, dynamic>{
        'name':   updated.name,
        'email':  updated.email,
        if (updated.businessName != null && updated.businessName!.isNotEmpty)
          'business_name': updated.businessName,
        if (updated.phone != null && updated.phone!.isNotEmpty)
          'phone': updated.phone,
        if (updated.country != null)   'country':      updated.country,
        if (updated.countryCode != null) 'country_code': updated.countryCode,
        if (updated.address != null && updated.address!.isNotEmpty)
          'address': updated.address,
        if (updated.position != null && updated.position!.isNotEmpty)
          'position': updated.position,
      };
      await SupabaseService.client
          .from('clients')
          .update(payload)
          .eq('id', updated.id);

      await sub.trackUsage('clients', isEdit: true); // Track monthly edit

      final idx = _clients.indexWhere((c) => c.id == updated.id);
      if (idx != -1) {
        _clients[idx] = updated;
        _clients.sort((a, b) => a.name.compareTo(b.name));
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Update Error: ${_parseError(e)}';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> addNote(int clientId, String content) async {
    final user = SupabaseService.currentUser;
    if (user == null || _activeTeamId == null) return false;
    try {
      final sentimentResult = await SentimentService.analyse(content);

      await SupabaseService.client.from('client_notes').insert({
        'team_id':   _activeTeamId!,
        'client_id': clientId,
        'author_id': user.id,
        'content':   content,
        'sentiment': sentimentResult.label.name,
        'sentiment_confidence': sentimentResult.confidence,
      });
      await loadTimeline(clientId);
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> addDocument(int clientId, String name, String url, {int? size, String? type}) async {
    final user = SupabaseService.currentUser;
    if (user == null || _activeTeamId == null) return false;
    try {
      await SupabaseService.client.from('client_documents').insert({
        'team_id':     _activeTeamId!,
        'client_id':   clientId,
        'uploader_id': user.id,
        'name':        name,
        'file_url':    url,
        'file_size':   size,
        'file_type':   type,
      });
      await loadTimeline(clientId);
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  // ── Convert to Invoice (Returns client for pre-fill) ──────────────────────
  Future<Client?> convertToInvoice(int clientId) async {
    try {
      final client = _clients.firstWhere((c) => c.id == clientId);
      await addNote(clientId, 'Invoice creation initiated from CRM.');
      return client;
    } catch (_) {
      return null;
    }
  }
}
