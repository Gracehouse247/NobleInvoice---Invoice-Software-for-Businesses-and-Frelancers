import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';

class BusinessInfoSection extends StatelessWidget {
  const BusinessInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Use context.read to get the controller for event handling without
    // causing this widget to rebuild when the controller's values change.
    final controller = context.read<BusinessQRController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Information',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Company Name',
            hintText: 'Enter your company name',
          ),
          onChanged: (value) {
            // Update the state in the controller when the text changes.
            controller.setCompanyName(value);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Headline',
            hintText: 'e.g., Digital Marketing Agency',
          ),
          onChanged: (value) {
            controller.setHeadline(value);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Website',
            hintText: 'https://www.your-website.com',
          ),
          keyboardType: TextInputType.url,
          onChanged: (value) {
            controller.setWebsite(value);
          },
        ),
      ],
    );
  }
}

