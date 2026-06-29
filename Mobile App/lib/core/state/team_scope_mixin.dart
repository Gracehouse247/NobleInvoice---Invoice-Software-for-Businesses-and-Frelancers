// lib/core_v2/state/team_scope_mixin.dart
import 'package:flutter/foundation.dart';

mixin TeamScopeMixin on ChangeNotifier {
  String? _activeTeamId;
  String? get activeTeamId => _activeTeamId;

  /// Called by ProxyProvider when ProfileController updates.
  /// Returns true if team changed (so subclass can reload).
  bool setActiveTeamId(String? id) {
    if (_activeTeamId == id) return false; // No change — don't re-fetch
    _activeTeamId = id;
    notifyListeners();
    return true; // Team changed
  }

  /// Guard: throws if no team is set. Use in all DB methods.
  String get requireTeamId {
    if (_activeTeamId == null) throw Exception('No active team. Please complete setup.');
    return _activeTeamId!;
  }
}
