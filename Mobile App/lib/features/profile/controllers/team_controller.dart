import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/core/services/notification_service.dart';
import 'package:noble_invoice/features/profile/models/team_model.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';

class TeamController extends ChangeNotifier {
  SubscriptionTier _currentTier = SubscriptionTier.solo;
  bool _canInviteMembers = false;

  void setSubscriptionStatus(SubscriptionTier tier, bool canInvite) {
    _currentTier = tier;
    _canInviteMembers = canInvite;
  }

  Team? _activeTeam;
  List<TeamMember> _teamMembers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Team? get activeTeam => _activeTeam;
  String? get activeTeamId => _activeTeam?.id;
  List<TeamMember> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  TeamRole get activeRole {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || _teamMembers.isEmpty) return TeamRole.staff;
    return _teamMembers.firstWhere(
      (m) => m.userId == userId,
      orElse: () => _teamMembers.firstWhere((m) => true, orElse: () => TeamMember(id: 0, teamId: '', userId: '', role: TeamRole.staff, joinedAt: DateTime.now()))
    ).role;
  }

  void setActiveTeam(Team? team) {
    _activeTeam = team;
    if (team != null) {
      _loadTeamMembers(team.id);
      NotificationService.syncTokenToTeam(team.id);
    }
    notifyListeners();
  }

  Future<void> _loadTeamMembers(String teamId) async {
    try {
      final membersData = await SupabaseService.client
          .from('team_members')
          .select('*, profiles(name, avatar_url, email)')
          .eq('team_id', teamId);
      
      _teamMembers = List<Map<String, dynamic>>.from(membersData)
          .map((m) => TeamMember.fromJson(m))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading team members: $e');
    }
  }

  Future<bool> inviteMember(String email, TeamRole role) async {
    if (_activeTeam == null) return false;

    // ── Phase 3: Enforce Elite Team Lock ─────────────────────────────────────
    if (!_canInviteMembers) {
      _errorMessage = 'SUBSCRIPTION_LIMIT: Team invites require Noble Elite.';
      notifyListeners();
      return false;
    }

    try {
      final userData = await SupabaseService.client
          .from('profiles')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (userData == null) {
        await SupabaseService.client.from('pending_invitations').insert({
          'team_id':    _activeTeam!.id,
          'email':      email,
          'role':       role.name,
          'invited_by': SupabaseService.currentUser?.id,
          'expires_at': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        });
        return true;
      }

      await SupabaseService.client.from('team_members').insert({
        'team_id': _activeTeam!.id,
        'user_id': userData['id'],
        'role': role.name,
      });

      await _loadTeamMembers(_activeTeam!.id);
      return true;
    } catch (e) {
      debugPrint('Error inviting member: $e');
      return false;
    }
  }

  Future<void> switchTeam(String teamId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final teamData = await SupabaseService.client
          .from('teams')
          .select()
          .eq('id', teamId)
          .single();
      _activeTeam = Team.fromJson(teamData);
      await _loadTeamMembers(teamId);
      NotificationService.syncTokenToTeam(teamId);
    } catch (e) {
      debugPrint('Error switching team: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTeamSubaccount(String subaccountId) async {
    if (_activeTeam == null) return false;
    try {
      await SupabaseService.client
          .from('teams')
          .update({'flutterwave_subaccount_id': subaccountId})
          .eq('id', _activeTeam!.id);
      
      _activeTeam = _activeTeam!.copyWith(flutterwaveSubaccountId: subaccountId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> updateTeamSettings({
    double? defaultVatRate,
    double? defaultWhtRate,
    String? defaultPaymentTerms,
    String? invoicePrefix,
    String? brandSignatureUrl,
    String? brandColor,
    String? businessName,
    String? businessAddress,
    String? businessEmail,
    String? businessPhone,
  }) async {
    if (_activeTeam == null) return false;
    try {
      final updates = {
        if (defaultVatRate != null)      'default_vat_rate':     defaultVatRate,
        if (defaultWhtRate != null)      'default_wht_rate':     defaultWhtRate,
        if (defaultPaymentTerms != null) 'default_payment_terms': defaultPaymentTerms,
        if (invoicePrefix != null)       'invoice_prefix':       invoicePrefix,
        if (brandSignatureUrl != null)  'brand_signature_url':   brandSignatureUrl,
        if (brandColor != null)          'brand_color':          brandColor,
        if (businessName != null)        'name':                 businessName,
        if (businessAddress != null)     'business_address':     businessAddress,
        if (businessEmail != null)       'business_email':       businessEmail,
        if (businessPhone != null)       'business_phone':       businessPhone,
      };

      await SupabaseService.client
          .from('teams')
          .update(updates)
          .eq('id', _activeTeam!.id);
      
      _activeTeam = _activeTeam!.copyWith(
        defaultVatRate: defaultVatRate,
        defaultWhtRate: defaultWhtRate,
        defaultPaymentTerms: defaultPaymentTerms,
        invoicePrefix: invoicePrefix,
        brandSignatureUrl: brandSignatureUrl,
        brandColor: brandColor,
        name: businessName,
        businessAddress: businessAddress,
        businessEmail: businessEmail,
        businessPhone: businessPhone,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<String?> uploadLogo(File file) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || _activeTeam == null) return null;
    _isLoading = true;
    notifyListeners();
    try {
      final path = '$userId/logo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await SupabaseService.client.storage.from('avatars').upload(
        path, 
        file,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      
      final url = SupabaseService.client.storage.from('avatars').getPublicUrl(path);
      
      await SupabaseService.client
          .from('teams')
          .update({'brand_logo_url': url})
          .eq('id', _activeTeam!.id);
      
      // SYNC: Also update profile
      await SupabaseService.client
          .from('profiles')
          .update({'brand_logo_url': url})
          .eq('id', userId);
          
      _activeTeam = _activeTeam!.copyWith(brandLogoUrl: url);
      notifyListeners();
      return url;
    } catch (e) {
      debugPrint('Error uploading team logo: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadSignature(File file) async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null || _activeTeam == null) return null;
    _isLoading = true;
    notifyListeners();
    try {
      // Simplified path to match successful logo upload pattern
      final path = '$userId/sig_${DateTime.now().millisecondsSinceEpoch}.png';
      
      await SupabaseService.client.storage.from('avatars').upload(
        path, 
        file,
        fileOptions: const FileOptions(contentType: 'image/png'),
      );
      
      final url = SupabaseService.client.storage.from('avatars').getPublicUrl(path);
      
      // Persist to teams table with metadata fallback
      final existingMetadata = _activeTeam?.metadata ?? {};
      final updatedMetadata = Map<String, dynamic>.from(existingMetadata);
      updatedMetadata['brand_signature_url'] = url;

      await SupabaseService.client
          .from('teams')
          .update({
            'brand_signature_url': url,
            'metadata': updatedMetadata,
          })
          .eq('id', _activeTeam!.id);
      
      // SYNC: Also update profile for redundancy (as logo is in profile)
      await SupabaseService.client
          .from('profiles')
          .update({'brand_signature_url': url})
          .eq('id', userId);
          
      _activeTeam = _activeTeam!.copyWith(
        brandSignatureUrl: url,
        metadata: updatedMetadata,
      );
      notifyListeners();
      
      return url;
    } catch (e) {
      debugPrint('Error uploading team signature: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
