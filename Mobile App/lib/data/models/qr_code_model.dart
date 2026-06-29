import 'dart:convert';
import 'package:noble_invoice/core/constants/env_constants.dart';

class QrCode {
  final String? id;
  final String? folderId;
  final String name;
  final String type;
  final Map<String, dynamic> content;
  final String? assetPath;
  final String? assetUrl;
  final String? qrImagePath;
  final String colorPrimary;
  final DateTime? createdAt;

  QrCode({
    this.id,
    this.folderId,
    required this.name,
    required this.type,
    required this.content,
    this.assetPath,
    this.assetUrl,
    this.qrImagePath,
    required this.colorPrimary,
    this.createdAt,
  });

  factory QrCode.fromMap(Map<String, dynamic> map) {
    // Backend stores content as a JSON string — parse it properly
    Map<String, dynamic> parsedContent = {};
    final rawContent = map['content'];
    if (rawContent is Map<String, dynamic>) {
      parsedContent = rawContent;
    } else if (rawContent is String && rawContent.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawContent);
        if (decoded is Map<String, dynamic>) parsedContent = decoded;
      } catch (_) {}
    }

    return QrCode(
      id: map['id']?.toString(),
      folderId: map['folder_id']?.toString(),
      name: map['name'] ?? 'Untitled QR',
      type: map['type'] ?? 'website',
      content: parsedContent,
      assetPath: map['asset_path'],
      assetUrl: map['asset_url'],
      qrImagePath: map['qr_image_path'],
      colorPrimary: map['color_primary'] ?? '#137FEC',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
      'content': jsonEncode(content), // Always encode to string for backend
      'asset_path': assetPath,
      'qr_image_path': qrImagePath,
      'color_primary': colorPrimary,
      'folder_id': folderId,
    };
  }

  /// Get the tracking bridge URL for this QR code
  String? get trackingUrl {
    if (id == null) return null;
    // Only trackable types
    if (type == 'website' || type == 'business' || type == 'social_media') {
      return '${EnvConstants.supabaseUrl}/functions/v1/track-qr?id=$id';
    }
    return null;
  }
}
