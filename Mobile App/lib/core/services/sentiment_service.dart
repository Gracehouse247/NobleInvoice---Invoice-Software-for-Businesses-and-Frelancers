// lib/core/services/sentiment_service.dart
//
// Uses Gemini to analyse CRM note text and return a structured sentiment result.
// Results are cached per text hash to avoid redundant API calls.

import 'package:noble_invoice/core/services/gemini_service.dart';

enum SentimentLabel { positive, neutral, negative, unknown }

class SentimentResult {
  final SentimentLabel label;
  final double confidence; // 0.0 – 1.0
  final String summary;   // one-line human-readable summary
  final String? suggestedAction;

  const SentimentResult({
    required this.label,
    required this.confidence,
    required this.summary,
    this.suggestedAction,
  });

  /// Fallback when the API is unavailable or parsing fails.
  static const SentimentResult unknown = SentimentResult(
    label: SentimentLabel.unknown,
    confidence: 0,
    summary: 'Could not analyse sentiment',
  );

  /// Emoji badge for display in CRM cards.
  String get badge {
    switch (label) {
      case SentimentLabel.positive: return '😊';
      case SentimentLabel.negative: return '😟';
      case SentimentLabel.neutral:  return '😐';
      case SentimentLabel.unknown:  return '❓';
    }
  }
}

class SentimentService {
  SentimentService._();

  // Simple in-memory cache: text hashCode → result
  static final Map<int, SentimentResult> _cache = {};

  /// Analyse [text] and return a [SentimentResult].
  /// Results are cached for the session to reduce API usage.
  static Future<SentimentResult> analyse(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return SentimentResult.unknown;

    final key = trimmed.hashCode;
    if (_cache.containsKey(key)) return _cache[key]!;

    const prompt = '''
You are a business sentiment analyser. Analyse the following CRM note and reply ONLY with a JSON object containing:
- "label": one of "positive", "neutral", "negative"
- "confidence": a float 0.0-1.0
- "summary": a single-sentence plain-English explanation
- "suggestedAction": a short (≤8 words) recommended CRM action, or null

Respond with raw JSON only — no markdown, no code block.

CRM Note:
''';

    try {
      final raw = await GeminiService.instance.generateText('$prompt"$trimmed"');
      final result = _parse(raw);
      _cache[key] = result;
      return result;
    } catch (e) {
      return SentimentResult.unknown;
    }
  }

  static SentimentResult _parse(String raw) {
    try {
      // Strip any accidental markdown fences
      final cleaned = raw
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Simple manual JSON extraction (avoids dart:convert dependency issues)
      final label     = _extract(cleaned, 'label');
      final confidence = double.tryParse(_extract(cleaned, 'confidence')) ?? 0.5;
      final summary   = _extract(cleaned, 'summary');
      final action    = _extract(cleaned, 'suggestedAction');

      return SentimentResult(
        label: _toLabel(label),
        confidence: confidence.clamp(0.0, 1.0),
        summary: summary.isNotEmpty ? summary : 'Sentiment analysed',
        suggestedAction: action == 'null' || action.isEmpty ? null : action,
      );
    } catch (_) {
      return SentimentResult.unknown;
    }
  }

  static String _extract(String json, String key) {
    final pattern = RegExp('"$key"\\s*:\\s*"?([^",}\\n]+)"?');
    final match = pattern.firstMatch(json);
    return match?.group(1)?.trim() ?? '';
  }

  static SentimentLabel _toLabel(String raw) {
    switch (raw.toLowerCase()) {
      case 'positive': return SentimentLabel.positive;
      case 'negative': return SentimentLabel.negative;
      case 'neutral':  return SentimentLabel.neutral;
      default:         return SentimentLabel.unknown;
    }
  }
}
