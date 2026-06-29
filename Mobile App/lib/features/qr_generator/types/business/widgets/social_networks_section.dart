import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:provider/provider.dart';

class SocialNetworksSection extends StatelessWidget {
  const SocialNetworksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BusinessQRController>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Social Networks',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildSocialField(
          controller: controller,
          platform: 'facebook',
          labelText: 'Facebook',
          iconPath: 'assets/icons/facebook_icon.svg',
        ),
        const SizedBox(height: 16),
        _buildSocialField(
          controller: controller,
          platform: 'instagram',
          labelText: 'Instagram',
          iconPath: 'assets/icons/instagram_icon.svg',
        ),
        const SizedBox(height: 16),
        _buildSocialField(
          controller: controller,
          platform: 'twitter',
          labelText: 'Twitter / X',
          iconData: Icons.close, // Placeholder for X logo
        ),
        const SizedBox(height: 16),
        _buildSocialField(
          controller: controller,
          platform: 'linkedin',
          labelText: 'LinkedIn',
          iconData: Icons.work, // Placeholder for LinkedIn logo
        ),
      ],
    );
  }

  // Helper method to create a social media text field to reduce code duplication.
  Widget _buildSocialField({
    required BusinessQRController controller,
    required String platform,
    required String labelText,
    String? iconPath,
    IconData? iconData,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter your profile URL',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: iconPath != null
              ? SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(AppColors.darkGrey, BlendMode.srcIn),
          )
              : Icon(iconData, color: AppColors.darkGrey),
        ),
      ),
      keyboardType: TextInputType.url,
      onChanged: (value) => controller.setSocialLink(platform, value),
    );
  }
}

