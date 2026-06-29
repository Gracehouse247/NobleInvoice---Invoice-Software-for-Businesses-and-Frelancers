import 'package:flutter/material.dart';
import 'package:noble_invoice/data/models/qr_code_model.dart';
import 'package:noble_invoice/data/services/qr_service.dart';
import 'package:noble_invoice/core/state/team_scope_mixin.dart';

class QrHistoryController extends ChangeNotifier with TeamScopeMixin {
  List<QrCode> _allQrs = [];
  List<QrCode> _filteredQrs = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  String _searchQuery = '';
  String _selectedType = 'All Types';
  String? _selectedFolderId;

  List<QrCode> get qrs => _filteredQrs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  String? get selectedFolderId => _selectedFolderId;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final teamId = activeTeamId;
      if (teamId == null) throw Exception('No active team');
      _allQrs = await QrService.getQrCodes(teamId: teamId);
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedType(String type) {
    _selectedType = type;
    _applyFilters();
  }

  void setSelectedFolderId(String? folderId) {
    _selectedFolderId = folderId;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredQrs = _allQrs.where((qr) {
      final matchesSearch = _searchQuery.isEmpty || 
          qr.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesType = _selectedType == 'All Types' || 
          qr.type.toUpperCase() == _selectedType.toUpperCase();

      final matchesFolder = _selectedFolderId == null || qr.folderId == _selectedFolderId;

      return matchesSearch && matchesType && matchesFolder;
    }).toList();
    notifyListeners();
  }

  Future<void> deleteQr(String id) async {
    try {
      await QrService.deleteQrCode(id);
      _allQrs.removeWhere((q) => q.id == id);
      _applyFilters();
    } catch (e) {
      rethrow;
    }
  }
}
