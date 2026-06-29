import 'package:flutter/material.dart';

class ColorPalettePicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color>? palette;

  const ColorPalettePicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final colors = palette ??
        [
          Colors.blue,
          Colors.green,
          Colors.red,
          Colors.orange,
          Colors.purple,
          Colors.teal,
          Colors.indigo,
          Colors.pink,
          Colors.brown,
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose a Theme Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: colors.map((color) {
            final isSelected = color == selectedColor;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
