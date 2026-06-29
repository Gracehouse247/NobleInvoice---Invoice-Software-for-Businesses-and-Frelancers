import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

enum LogoTheme { dark, light, unknown }

class LogoContrastUtil {
  static LogoTheme _analyzeBrightness(img.Image decoded) {
    double totalLum = 0;
    int validPixels = 0;
    final step = decoded.width > 200 ? 5 : 1;

    for (var p in decoded) {
      if (p.a > 50) { 
         double lum = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
         totalLum += lum;
         validPixels++;
      }
    }

    if (validPixels == 0) return LogoTheme.unknown;
    return (totalLum / validPixels) > 130 ? LogoTheme.light : LogoTheme.dark;
  }

  static pw.Widget adaptiveLogo({
    required Uint8List? logoBytes, 
    required bool isDarkTemplate,
    double? width,
    double? height,
    bool isWatermark = false,
  }) {
    if (logoBytes == null) return pw.SizedBox();
    
    pw.Widget render(Uint8List bytes) {
      final imgWidget = pw.Image(pw.MemoryImage(bytes), width: width, height: height);
      if (isWatermark) {
        return pw.Opacity(opacity: 0.05, child: imgWidget);
      }
      return imgWidget;
    }

    try {
      final decoded = img.decodeImage(logoBytes);
      if (decoded == null) return render(logoBytes);

      final theme = _analyzeBrightness(decoded);

      if (isDarkTemplate && theme == LogoTheme.dark) {
        // Logo is dark, background is dark. Force White silhouette.
        for (var p in decoded) {
           if (p.a > 10) { p.r = 255; p.g = 255; p.b = 255; }
        }
        return render(Uint8List.fromList(img.encodePng(decoded)));
      } else if (!isDarkTemplate && theme == LogoTheme.light) {
        // Logo is light, background is light. Force Dark silhouette.
        for (var p in decoded) {
           if (p.a > 10) { p.r = 0; p.g = 0; p.b = 0; }
        }
        return render(Uint8List.fromList(img.encodePng(decoded)));
      }

      return render(logoBytes);

    } catch (e) {
      return render(logoBytes);
    }
  }
}
