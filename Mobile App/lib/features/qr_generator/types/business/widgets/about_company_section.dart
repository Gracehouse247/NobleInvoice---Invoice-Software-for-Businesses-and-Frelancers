import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart'; // <--- FIX: Added the missing import

class AboutCompanySection extends StatelessWidget {
  const AboutCompanySection({super.key});

  @override
  Widget build(BuildContext context) {
    // This line will now work correctly.
    final controller = Provider.of<BusinessQRController>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About the Company',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Describe your business, services, and mission...',
            alignLabelWithHint: true,
          ),
          maxLines: 5, // Allows for a multi-line text input field.
          onChanged: controller.setAboutCompany,
        ),
      ],
    );
  }
}

