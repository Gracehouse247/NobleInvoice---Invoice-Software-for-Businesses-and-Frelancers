import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BusinessQRController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Street Address',
            hintText: 'e.g., 123 Main Street',
          ),
          onChanged: controller.setStreet,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'e.g., Lagos',
                ),
                onChanged: controller.setCity,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  hintText: 'e.g., 100001',
                ),
                keyboardType: TextInputType.number,
                onChanged: controller.setPostalCode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Country',
            hintText: 'e.g., Nigeria',
          ),
          onChanged: controller.setCountry,
        ),
      ],
    );
  }
}

