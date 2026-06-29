
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart'; // <--- FIX: Added the missing import

class WelcomeScreenSection extends StatelessWidget {
  const WelcomeScreenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Screen',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        // This Consumer widget will now work correctly.
        Consumer<BusinessQRController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(224, 224, 224, 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: controller.welcomeImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      controller.welcomeImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Center(
                      child: Text(
                        'No Image Selected',
                        style: AppTextStyles.bodyMedium,
                      )),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text('Upload Cover Image'),
                    onPressed: () {
                      // Use the controller directly since we are inside the Consumer's builder
                      controller.pickWelcomeImage();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Welcome Text',
            hintText: 'e.g., Welcome to our page!',
          ),
          onChanged: (value) {
            // FIX: Replaced context.read<T>() with the more explicit version.
            Provider.of<BusinessQRController>(context, listen: false)
                .setWelcomeText(value);
          },
        ),
      ],
    );
  }
}

