// lib/features/business_card/controllers/business_card_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/features/business_card/models/business_card_model.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';

class BusinessCardController extends ChangeNotifier {
  final TeamController teamCtrl;
  
  BusinessCard? _currentCard = BusinessCard(
    id: '',
    teamId: '',
    format: BusinessCardFormat.standard,
    templateId: 'modern_minimal',
  );
  bool _isLoading = false;
  String? _lastTeamId;

  BusinessCardController(this.teamCtrl);

  BusinessCard? get currentCard => _currentCard;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentCard() async {
    final teamId = teamCtrl.activeTeamId;
    if (teamId == null || teamId == _lastTeamId) return;

    _lastTeamId = teamId;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('business_cards')
          .select()
          .eq('team_id', teamId)
          .maybeSingle();

      if (response != null) {
        _currentCard = BusinessCard.fromJson(response);
      } else {
        // Initial defaults
        _currentCard = BusinessCard(
          id: '',
          teamId: teamId,
          format: BusinessCardFormat.standard,
          templateId: 'modern_minimal',
        );
      }
    } catch (e) {
      debugPrint('Error loading business card: $e');
      _currentCard = BusinessCard(
        id: '',
        teamId: teamId,
        format: BusinessCardFormat.standard,
        templateId: 'modern_minimal',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveCard(BusinessCard card, SubscriptionController sub) async {
    // 1. Check Create Limit for new cards
    if (card.id.isEmpty) {
      final limitMsg = sub.checkCreateLimit('cards');
      if (limitMsg != null) {
        debugPrint(limitMsg);
        return false;
      }
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (card.id.isNotEmpty) {
        await SupabaseService.client
            .from('business_cards')
            .update(card.toJson())
            .eq('id', card.id);
      } else {
        final response = await SupabaseService.client
            .from('business_cards')
            .insert(card.toJson())
            .select()
            .single();
        _currentCard = BusinessCard.fromJson(response);
        
        await sub.trackUsage('cards'); // Track creation
      }
      _currentCard = card;
      return true;
    } catch (e) {
      debugPrint('Error saving business card: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateLocal(BusinessCard card) {
    _currentCard = card;
    notifyListeners();
  }
}
