import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/data/models/qr_code_model.dart';
import 'package:noble_invoice/data/services/qr_service.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';

enum QrSaveStatus { idle, saving, saved, error }

class QrGeneratorController extends ChangeNotifier {
  SubscriptionTier _currentTier = SubscriptionTier.solo;
  bool _canUseDynamicFeatures = false;

  void setSubscriptionStatus(SubscriptionTier tier, bool canUse) {
    _currentTier = tier;
    _canUseDynamicFeatures = canUse;
  }
  // Common QR properties
  String _name = '';
  String _type = 'website';
  Map<String, dynamic> _content = {};
  Color _colorPrimary = AppColors.primary;
  String? _folderId;
  String? _assetPath;
  String? _assetUrl;

  QrSaveStatus _status = QrSaveStatus.idle;
  String _errorMessage = '';
  DateTime? _lastCreatedAt;
  String? _lastSavedId;

  // Getters
  String get name => _name;
  String get type => _type;
  Map<String, dynamic> get content => _content;
  Color get colorPrimary => _colorPrimary;
  String? get folderId => _folderId;
  QrSaveStatus get status => _status;
  String get errorMessage => _errorMessage;
  DateTime? get lastCreatedAt => _lastCreatedAt;
  String? get lastSavedId => _lastSavedId;
  bool get isSaving => _status == QrSaveStatus.saving;

  // Setters
  void updateData({
    String? name,
    String? type,
    Map<String, dynamic>? content,
    Color? colorPrimary,
    String? folderId,
    String? assetPath,
    String? assetUrl,
  }) {
    if (name != null) _name = name;
    if (type != null) _type = type;
    if (content != null) _content = content;
    if (colorPrimary != null) _colorPrimary = colorPrimary;
    if (folderId != null) _folderId = folderId;
    if (assetPath != null) _assetPath = assetPath;
    if (assetUrl != null) _assetUrl = assetUrl;
    notifyListeners();
  }

  bool isColorTooLight(Color color) {
    // Standard relative luminance formula
    return color.computeLuminance() > 0.8;
  }

  void setColor(Color color) {
    if (isColorTooLight(color)) {
      _errorMessage = 'This color is too light for reliable scanning. Please pick a darker shade.';
      _status = QrSaveStatus.error;
    } else {
      _colorPrimary = color;
      if (_status == QrSaveStatus.error && _errorMessage.contains('light')) {
        _status = QrSaveStatus.idle;
        _errorMessage = '';
      }
    }
    notifyListeners();
  }

  // Save to backend
  Future<bool> saveQrCode() async {
    // ── Phase 3: Enforce Dynamic Edit Lock ───────────────────────────────────
    if (isEditing && !_canUseDynamicFeatures) {
      _status = QrSaveStatus.error;
      _errorMessage = 'SUBSCRIPTION_LIMIT: Dynamic QR editing requires Noble Pulse.';
      notifyListeners();
      return false;
    }

    _status = QrSaveStatus.saving;
    _errorMessage = '';
    notifyListeners();

    try {
      final qrCode = QrCode(
        id: _lastSavedId,
        name: _name.isEmpty ? 'Untitled $_type QR' : _name,
        type: _type,
        content: _content,
        colorPrimary: '#${_colorPrimary.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
        folderId: _folderId,
        assetPath: _assetPath,
        assetUrl: _assetUrl,
      );

      final savedId = await QrService.saveQrCode(qrCode);
      
      _lastSavedId = savedId;
      _lastCreatedAt = DateTime.now();
      _status = QrSaveStatus.saved;
      notifyListeners();
      return true;
    } catch (e) {
      _status = QrSaveStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _name = '';
    _type = 'website';
    _content = {};
    _colorPrimary = AppColors.primary;
    _status = QrSaveStatus.idle;
    _errorMessage = '';
    _assetPath = null;
    _assetUrl = null;
    _lastSavedId = null;
    notifyListeners();
  }

  // ── Load for Editing ──────────────────────────────────────────────────────
  bool get isEditing => _lastSavedId != null;

  void loadFromQrCode(QrCode qr) {
    _name = qr.name;
    _type = qr.type;
    _content = Map<String, dynamic>.from(qr.content);
    _colorPrimary = Color(int.parse(qr.colorPrimary.replaceFirst('#', '0xFF')));
    _folderId = qr.folderId;
    _assetPath = qr.assetPath;
    _assetUrl = qr.assetUrl;
    _lastSavedId = qr.id;
    _status = QrSaveStatus.idle;
    notifyListeners();
  }
}
