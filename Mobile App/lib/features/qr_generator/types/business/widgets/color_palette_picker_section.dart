import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';
// <--- FIX: Corrected the typo in the import path.

class ColorPalettePickerSection extends StatelessWidget {
  const ColorPalettePickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of predefined colors for the user to choose from.
    final List<Color> colorOptions = [
      AppColors.primary,
      AppColors.secondary,
      const Color(0xFFD32F2F), // Red
      const Color(0xFF388E3C), // Green
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFF57C00), // Orange
      const Color(0xFF000000), // Black
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color Palette',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        // This Consumer widget will now work correctly.
        Consumer<BusinessQRController>(
          builder: (context, controller, child) {
            return SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: colorOptions.length,
                itemBuilder: (context, index) {
                  final color = colorOptions[index];
                  return ColorDot(
                    color: color,
                    isSelected: controller.primaryColor == color,
                    onTap: () {
                      context.read<BusinessQRController>().setPrimaryColor(color);
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}

// A reusable widget for each color option in the palette.
class ColorDot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorDot({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColors.primaryDark, width: 3)
              : null,
        ),
        child: isSelected
            ? const Icon(
          Icons.check,
          color: Colors.white,
          size: 28,
        )
            : null,
      ),
    );
  }
}

