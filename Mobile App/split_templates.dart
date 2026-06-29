import 'package:flutter/material.dart'; // Just to make it valid dart
import 'dart:io';

void main() async {
  await splitFile(
    'lib/features/invoicing/widgets/colorful_invoice_templates.dart',
    'lib/core/pdf/components/colorful',
  );
  await splitFile(
    'lib/features/invoicing/widgets/premium_simple_templates.dart',
    'lib/core/pdf/components/premium',
  );
}

Future<void> splitFile(String sourcePath, String targetDir) async {
  final file = File(sourcePath);
  if (!await file.exists()) {
    print('File not found: \');
    return;
  }
  final lines = await file.readAsLines();
  
  List<String> imports = [];
  int lineIndex = 0;
  
  // Read imports
  while (lineIndex < lines.length) {
    String line = lines[lineIndex];
    if (line.startsWith('import ') || line.trim() == '') {
      imports.add(line);
      lineIndex++;
    } else if (line.startsWith('//')) {
      imports.add(line);
      lineIndex++;
    } else {
      break;
    }
  }

  // Filter out any specific template header comments from imports if needed
  
  String currentClass = '';
  List<String> currentClassLines = [];
  bool inClass = false;

  for (int i = lineIndex; i < lines.length; i++) {
    String line = lines[i];
    
    // Check for start of a new class
    if (line.startsWith('class ') && line.contains('Template ')) {
      // If we were already in a class, save it
      if (inClass && currentClass.isNotEmpty) {
        await saveClass(currentClass, currentClassLines, imports, targetDir);
      }
      inClass = true;
      currentClass = line.split(' ')[1];
      currentClassLines = [line];
    } else if (inClass) {
      currentClassLines.add(line);
      // Wait, there might be helper classes like HexPatternPainter or DiagonalHeaderClipper following the template class.
      // We'll just group them together until the next Template class.
    }
  }
  
  // Save the last class
  if (inClass && currentClass.isNotEmpty) {
    await saveClass(currentClass, currentClassLines, imports, targetDir);
  }
}

Future<void> saveClass(String className, List<String> lines, List<String> imports, String targetDir) async {
  String fileName = className.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_' + match.group(0)!.toLowerCase()).substring(1) + '.dart';
  final file = File('\/\');
  
  String content = imports.join('\n') + '\n\n' + lines.join('\n');
  await file.writeAsString(content);
  print('Saved \');
}
