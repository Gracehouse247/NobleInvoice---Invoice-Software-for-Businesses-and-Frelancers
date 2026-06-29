// lib/features/invoicing/widgets/signature_strip.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class SignatureStrip extends StatelessWidget {
  final Uint8List? signatureBytes;
  final String? signatureSource;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const SignatureStrip({
    super.key,
    this.signatureBytes,
    this.signatureSource,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: signatureBytes != null ? AppColors.success.withOpacity(0.5) : AppColors.lightGrey,
            width: 1.5,
          ),
        ),
        child: signatureBytes != null
            ? Row(children: [
                Container(
                  height: 56, width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.memory(signatureBytes!, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                    SizedBox(width: 6),
                    Text('Signature Applied', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.success)),
                  ]),
                  const SizedBox(height: 4),
                  Text(signatureSource == 'uploaded' ? 'Uploaded image' : 'Hand-drawn', style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                ])),
                TextButton(
                  onPressed: onTap,
                  child: const Text('Replace', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.darkGrey),
                  onPressed: onClear,
                ),
              ])
            : Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.draw_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Add Signature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Draw freehand or upload an image', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.darkGrey),
              ]),
      ),
    );
  }
}
