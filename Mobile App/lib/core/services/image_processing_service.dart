// lib/core/services/image_processing_service.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class ImageProcessingService {
  /// Removes the background from a logo image and returns the transparent PNG bytes.
  /// Works by sampling corners and applying a color-to-alpha filter with tolerance.
  static Future<Uint8List?> removeLogoBackground(File file) async {
    return compute(_processLogoInBackground, await file.readAsBytes());
  }

  static Uint8List? _processLogoInBackground(Uint8List bytes) {
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return null;

    // 1. Check if already transparent (more than 5% pixels have low alpha)
    int transparentPixels = 0;
    for (var pixel in image) {
      if (pixel.a < 100) transparentPixels++;
    }
    
    if (transparentPixels > (image.width * image.height * 0.05)) {
      // Already has transparency, just trim it
      return Uint8List.fromList(img.encodePng(_trimImage(image)));
    }

    // 2. Identify Background Color (Sample corners)
    final corners = [
      image.getPixel(0, 0),
      image.getPixel(image.width - 1, 0),
      image.getPixel(0, image.height - 1),
      image.getPixel(image.width - 1, image.height - 1),
    ];

    // Find the most frequent color among corners
    Map<int, int> colorCounts = {};
    for (var c in corners) {
      final key = (c.r.toInt() << 16) | (c.g.toInt() << 8) | c.b.toInt();
      colorCounts[key] = (colorCounts[key] ?? 0) + 1;
    }

    int bgColorKey = colorCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    int bgR = (bgColorKey >> 16) & 0xFF;
    int bgG = (bgColorKey >> 8) & 0xFF;
    int bgB = bgColorKey & 0xFF;

    // 3. Apply Transparency with Soft Edges
    const int tolerance = 45; // Primary threshold
    const int feather   = 15; // Smooth transition zone
    
    img.Image result = img.Image.from(image);
    for (var pixel in result) {
      int dr = (pixel.r - bgR).abs().toInt();
      int dg = (pixel.g - bgG).abs().toInt();
      int db = (pixel.b - bgB).abs().toInt();
      
      int diff = (dr + dg + db) ~/ 3;

      if (diff < tolerance) {
        if (diff < (tolerance - feather)) {
          // Fully transparent
          pixel.a = 0;
        } else {
          // Gradual transparency (Feathering)
          double ratio = (diff - (tolerance - feather)) / feather;
          pixel.a = (ratio * 255).toInt();
        }
      }
    }

    // 4. Trim and return
    return Uint8List.fromList(img.encodePng(_trimImage(result)));
  }

  /// Trims transparent edges from the image
  static img.Image _trimImage(img.Image image) {
    int top = 0, bottom = image.height - 1, left = 0, right = image.width - 1;

    // Top
    outer: for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a > 0) {
          top = y;
          break outer;
        }
      }
    }

    // Bottom
    outer: for (int y = image.height - 1; y >= 0; y--) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y).a > 0) {
          bottom = y;
          break outer;
        }
      }
    }

    // Left
    outer: for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        if (image.getPixel(x, y).a > 0) {
          left = x;
          break outer;
        }
      }
    }

    // Right
    outer: for (int x = image.width - 1; x >= 0; x--) {
      for (int y = 0; y < image.height; y++) {
        if (image.getPixel(x, y).a > 0) {
          right = x;
          break outer;
        }
      }
    }

    int width = right - left + 1;
    int height = bottom - top + 1;
    
    if (width <= 0 || height <= 0) return image;

    return img.copyCrop(image, x: left, y: top, width: width, height: height);
  }
}
