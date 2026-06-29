import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BrandingStep extends StatelessWidget {
  final File? logoPreview;
  final Color primaryColor;
  final Color secondaryColor;
  final int activeColorType;
  final String selectedVoice;
  final Function(File) onLogoChanged;
  final Function(Color) onPrimaryChanged;
  final Function(Color) onSecondaryChanged;
  final Function(int) onColorTypeChanged;
  final Function(String) onVoiceChanged;

  const BrandingStep({
    super.key,
    required this.logoPreview,
    required this.primaryColor,
    required this.secondaryColor,
    required this.activeColorType,
    required this.selectedVoice,
    required this.onLogoChanged,
    required this.onPrimaryChanged,
    required this.onSecondaryChanged,
    required this.onColorTypeChanged,
    required this.onVoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: FadeInRight(
        duration: const Duration(milliseconds: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Visual DNA', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
            const SizedBox(height: 8),
            Text('Sync your colors and logo across all client assets.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            const SizedBox(height: 32),
            
            _buildLogoUploader(),
            const SizedBox(height: 32),
            
            _buildColorStrategy(),
            const SizedBox(height: 32),
            
            _buildVoicePicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoUploader() {
    return InkWell(
      onTap: () async {
        final img = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (img != null) onLogoChanged(File(img.path));
      },
      child: _StepGlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                image: logoPreview != null ? DecorationImage(image: FileImage(logoPreview!), fit: BoxFit.cover) : null,
              ),
              child: logoPreview == null ? Icon(Icons.add_photo_alternate_rounded, color: primaryColor) : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Brand Logo', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(logoPreview == null ? 'Recommended: PNG with transparent background.' : 'Logo successfully added.', 
                       style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorStrategy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('COLOR STRATEGY', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildInteractiveColorRow('Primary', primaryColor, activeColorType == 0, () => onColorTypeChanged(0)),
            const SizedBox(width: 12),
            _buildInteractiveColorRow('Accent', secondaryColor, activeColorType == 1, () => onColorTypeChanged(1)),
          ],
        ),
        const SizedBox(height: 16),
        _buildPaletteStrip(),
      ],
    );
  }

  Widget _buildInteractiveColorRow(String label, Color color, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isActive ? color : Colors.grey.shade200, width: 1.5),
          ),
          child: Row(
            children: [
              Container(width: 24, height: 24, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const Spacer(),
              if (isActive) Icon(Icons.check_circle_rounded, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaletteStrip() {
    final colors = [const Color(0xFF2563EB), const Color(0xFF059669), const Color(0xFF7C3AED), const Color(0xFFDC2626), const Color(0xFFD97706), const Color(0xFF475569)];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.map((c) => GestureDetector(
          onTap: () {
            if (activeColorType == 0) {
              onPrimaryChanged(c);
            } else {
              onSecondaryChanged(c);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            width: 40, height: 40,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildVoicePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('BRAND VOICE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ['Professional', 'Friendly', 'Modern', 'Caring'].map((v) {
            final isSelected = selectedVoice == v;
            return ChoiceChip(
              label: Text(v),
              selected: isSelected,
              onSelected: (s) => onVoiceChanged(v),
              selectedColor: primaryColor.withOpacity(0.1),
              side: BorderSide(color: isSelected ? primaryColor : Colors.grey.shade200),
              labelStyle: TextStyle(color: isSelected ? primaryColor : Colors.grey.shade700, fontWeight: FontWeight.bold),
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StepGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _StepGlassContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }
}
