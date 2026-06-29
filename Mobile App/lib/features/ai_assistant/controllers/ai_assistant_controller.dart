import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/gemini_service.dart';
import 'package:noble_invoice/features/auth/controllers/auth_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiMessage({required this.text, required this.isUser, required this.timestamp});
}

class AiAssistantController extends ChangeNotifier {
  final List<AiMessage> _messages = [];
  List<AiMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool get isListening => _isListening;
  String _lastWords = '';
  String get lastWords => _lastWords;

  Future<void> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _lastWords = '';
      notifyListeners();
      _speech.listen(
        onResult: (val) {
          _lastWords = val.recognizedWords;
          notifyListeners();
        },
      );
    }
  }

  Future<void> stopListening(BuildContext context) async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
    if (_lastWords.isNotEmpty) {
      sendMessage(_lastWords, context);
    }
  }

  Future<void> sendMessage(String text, BuildContext context) async {
    if (text.trim().isEmpty) return;

    _messages.add(AiMessage(text: text, isUser: true, timestamp: DateTime.now()));
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate context for the agent
      final authCtrl = context.read<AuthController>();
      final userContext = "User: ${authCtrl.currentUser?.email ?? 'Unknown'}";
      
      final response = await GeminiService.instance.processAgentCommand(text, userContext);
      
      _messages.add(AiMessage(text: response, isUser: false, timestamp: DateTime.now()));
    } catch (e) {
      _messages.add(AiMessage(text: "Error: $e", isUser: false, timestamp: DateTime.now()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
