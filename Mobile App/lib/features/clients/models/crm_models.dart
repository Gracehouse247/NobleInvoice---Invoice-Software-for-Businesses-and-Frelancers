// lib/features/clients/models/crm_models.dart
import 'package:flutter/material.dart';

enum LeadStatus { lead, active, vip, churned }

extension LeadStatusExtension on LeadStatus {
  String get label {
    switch (this) {
      case LeadStatus.lead:    return 'Lead';
      case LeadStatus.active:  return 'Active';
      case LeadStatus.vip:     return 'VIP';
      case LeadStatus.churned: return 'Churned';
    }
  }

  String get emoji {
    switch (this) {
      case LeadStatus.lead:    return '🎯';
      case LeadStatus.active:  return '✅';
      case LeadStatus.vip:     return '⭐';
      case LeadStatus.churned: return '💤';
    }
  }

  Color get color {
    switch (this) {
      case LeadStatus.lead:    return const Color(0xFF6366F1); // Indigo
      case LeadStatus.active:  return const Color(0xFF10B981); // Green
      case LeadStatus.vip:     return const Color(0xFFF59E0B); // Amber
      case LeadStatus.churned: return const Color(0xFF94A3B8); // Slate
    }
  }

  static LeadStatus fromString(String? s) {
    switch (s?.toLowerCase()) {
      case 'lead':    return LeadStatus.lead;
      case 'vip':     return LeadStatus.vip;
      case 'churned': return LeadStatus.churned;
      default:        return LeadStatus.active;
    }
  }
}

class ClientNote {
  final String id;
  final String clientId;
  final String? authorId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? authorName;
  final String? sentiment;
  final double? sentimentConfidence;

  ClientNote({
    required this.id,
    required this.clientId,
    this.authorId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.sentiment,
    this.sentimentConfidence,
  });

  factory ClientNote.fromJson(Map<String, dynamic> json) {
    return ClientNote(
      id:         json['id']?.toString() ?? '',
      clientId:   json['client_id']?.toString() ?? '',
      authorId:   json['author_id']?.toString(),
      content:    json['content'] ?? '',
      createdAt:  DateTime.parse(json['created_at']),
      updatedAt:  DateTime.parse(json['updated_at']),
      authorName: json['profiles']?['name'],
      sentiment:  json['sentiment'] as String?,
      sentimentConfidence: (json['sentiment_confidence'] as num?)?.toDouble(),
    );
  }
}

class ClientDocument {
  final String id;
  final String clientId;
  final String? uploaderId;
  final String name;
  final String fileUrl;
  final int? fileSize;
  final String? fileType;
  final DateTime createdAt;

  ClientDocument({
    required this.id,
    required this.clientId,
    this.uploaderId,
    required this.name,
    required this.fileUrl,
    this.fileSize,
    this.fileType,
    required this.createdAt,
  });

  factory ClientDocument.fromJson(Map<String, dynamic> json) {
    return ClientDocument(
      id:         json['id']?.toString() ?? '',
      clientId:   json['client_id']?.toString() ?? '',
      uploaderId: json['uploader_id']?.toString(),
      name:       json['name'] ?? '',
      fileUrl:    json['file_url'] ?? '',
      fileSize:   json['file_size'],
      fileType:   json['file_type'],
      createdAt:  DateTime.parse(json['created_at']),
    );
  }

  String get displaySize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class CommunicationLog {
  final String id;
  final String clientId;
  final String? authorId;
  final String type; // 'call' | 'meeting' | 'whatsapp' | 'email' | 'note'
  final String? summary;
  final DateTime loggedAt;

  CommunicationLog({
    required this.id,
    required this.clientId,
    this.authorId,
    required this.type,
    this.summary,
    required this.loggedAt,
  });

  factory CommunicationLog.fromJson(Map<String, dynamic> json) {
    return CommunicationLog(
      id:        json['id']?.toString() ?? '',
      clientId:  json['client_id']?.toString() ?? '',
      authorId:  json['author_id']?.toString(),
      type:      json['type'] as String? ?? 'note',
      summary:   json['summary'] as String?,
      loggedAt:  DateTime.parse(json['logged_at']),
    );
  }

  IconData get icon {
    switch (type) {
      case 'call':     return Icons.phone_rounded;
      case 'meeting':  return Icons.handshake_rounded;
      case 'whatsapp': return Icons.chat_rounded;
      case 'email':    return Icons.email_rounded;
      case 'system':   return Icons.track_changes_rounded;
      default:         return Icons.sticky_note_2_rounded;
    }
  }
}
