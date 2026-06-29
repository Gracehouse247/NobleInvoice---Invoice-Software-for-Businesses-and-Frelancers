// lib/features/profile/models/session_model.dart

class UserSession {
  final String id;
  final String deviceName;
  final String location;
  final DateTime lastActive;
  final bool isCurrent;

  UserSession({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id:         json['id']?.toString() ?? '',
      deviceName: json['device_name'] ?? 'Unknown Device',
      location:   json['location'] ?? 'Unknown Location',
      lastActive: DateTime.parse(json['last_active'] ?? DateTime.now().toIso8601String()),
      isCurrent:  json['is_current'] ?? false,
    );
  }
}
