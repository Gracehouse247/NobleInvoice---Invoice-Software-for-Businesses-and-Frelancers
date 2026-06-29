import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart'; // <--- FIX: Added the missing import

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    // This line will now work correctly.
    final controller = Provider.of<BusinessQRController>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'e.g., +234 801 234 5678',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          onChanged: controller.setPhone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'e.g., contact@your-business.com',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: controller.setEmail,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Fax Number (Optional)',
            hintText: 'e.g., +234 801 234 5679',
            prefixIcon: Icon(Icons.fax),
          ),
          keyboardType: TextInputType.phone,
          onChanged: controller.setFax,
        ),
      ],
    );
  }
}

