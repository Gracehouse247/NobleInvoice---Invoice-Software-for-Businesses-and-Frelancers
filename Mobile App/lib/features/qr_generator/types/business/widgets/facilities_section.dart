import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';

class FacilitiesSection extends StatelessWidget {
  const FacilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // A predefined list of common business facilities.
    final List<String> allFacilities = [
      'WiFi',
      'Parking',
      'Elevator',
      'Air Conditioning',
      'Wheelchair Accessible',
      'Credit Cards Accepted',
      'Pet Friendly',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facilities & Amenities',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        // The Consumer widget ensures that only this part of the UI rebuilds
        // when the list of selected facilities changes.
        Consumer<BusinessQRController>(
          builder: (context, controller, child) {
            return Wrap(
              spacing: 8.0, // Horizontal space between chips.
              runSpacing: 4.0, // Vertical space between lines of chips.
              children: allFacilities.map((facility) {
                final isSelected = controller.selectedFacilities.contains(facility);
                return FilterChip(
                  label: Text(facility),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    controller.toggleFacility(facility);
                  },
                  backgroundColor: const Color.fromRGBO(224, 224, 224, 0.5),
                  selectedColor: const Color.fromRGBO(26, 115, 232, 0.8),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textBlack,
                  ),
                  checkmarkColor: AppColors.white,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.lightGrey,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

