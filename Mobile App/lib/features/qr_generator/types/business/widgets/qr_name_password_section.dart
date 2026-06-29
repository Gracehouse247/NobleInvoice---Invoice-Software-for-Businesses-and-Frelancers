import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';

class QRNamePasswordSection extends StatelessWidget {
  const QRNamePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QR Code Details',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'QR Code Name',
            hintText: 'e.g., My Business Card',
          ),
          onChanged: (value) {
            Provider.of<BusinessQRController>(context, listen: false).setQrName(value);
          },
        ),
        const SizedBox(height: 16),
        // Consumer rebuilds this part when password settings change.
        Consumer<BusinessQRController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enable Password Protection', style: AppTextStyles.bodyLarge),
                    Switch(
                      value: controller.isPasswordEnabled,
                      onChanged: (value) {
                        controller.togglePasswordProtection(value);
                      },
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
                if (controller.isPasswordEnabled) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: controller.obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter a password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          controller.togglePasswordVisibility();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      controller.setPassword(value);
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

