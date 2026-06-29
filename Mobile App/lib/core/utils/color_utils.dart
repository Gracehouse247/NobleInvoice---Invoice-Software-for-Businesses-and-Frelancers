import 'package:flutter/material.dart';

class ColorUtils {
  /// Safely parses a hex string (e.g. #RRGGBB, RRGGBB, 0xRRGGBB, 0xFFRRGGBB) into a Color.
  /// Falls back to the provided default color if parsing fails.
  static Color fromHex(String? hex, {Color fallback = const Color(0xFF2563EB)}) {
    if (hex == null || hex.isEmpty) return fallback;
    
    try {
      String cleanHex = hex.replaceAll('#', '').replaceAll('0x', '');
      
      // Handle RRGGBB -> FFRRGGBB
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }
      
      // Handle RGB -> FFRRGGBB
      if (cleanHex.length == 3) {
        cleanHex = 'FF${cleanHex[0]}${cleanHex[0]}${cleanHex[1]}${cleanHex[1]}${cleanHex[2]}${cleanHex[2]}';
      }

      if (cleanHex.length != 8) return fallback;

      return Color(int.parse(cleanHex, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  /// Converts a Color to a hex string with '#' prefix (e.g. #2563EB)
  static String toHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
