// lib/core/services/chat_service.dart
import 'package:noble_invoice/core/services/supabase_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;
  final bool isSupport;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.isSupport,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id:        json['id']?.toString() ?? '',
      text:      json['message'] ?? '',
      senderId:  json['user_id']?.toString() ?? '',
      timestamp: DateTime.parse(json['created_at']),
      isSupport: json['is_support'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'message':    text,
    'user_id':    senderId,
    'is_support': isSupport,
  };
}

class ChatService {
  /// Stream of messages for a specific user chat using Supabase Realtime
  Stream<List<ChatMessage>> getMessages(String userId) {
    return SupabaseService.client
        .from('live_chat_messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => ChatMessage.fromJson(json)).toList());
  }

  /// Send a message to the support chat via Supabase
  Future<void> sendMessage(String userId, String text, {bool isSupport = false}) async {
    if (text.trim().isEmpty) return;

    await SupabaseService.client.from('live_chat_messages').insert({
      'user_id':    userId,
      'message':    text,
      'is_support': isSupport,
    });
  }
}
