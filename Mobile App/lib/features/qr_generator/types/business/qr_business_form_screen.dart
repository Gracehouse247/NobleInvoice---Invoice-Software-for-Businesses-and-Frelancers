import 'package:flutter/material.dart';
import 'package:noble_invoice/features/qr_generator/controllers/qr_generator_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noble_invoice/features/qr_generator/types/business/controllers/business_qr_controller.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/about_company_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/business_info_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/color_palette_picker_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/contact_info_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/facilities_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/location_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/opening_hours_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/qr_name_password_section.dart';
import 'package:noble_invoice/features/qr_generator/types/business/widgets/welcome_screen_section.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';

class QrBusinessFormScreen extends StatelessWidget {
  const QrBusinessFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BusinessQRController>(
      create: (_) {
        final controller = BusinessQRController();
        final global = context.read<QrGeneratorController>();
        if (global.isEditing && global.type == 'business') {
          controller.loadFromContent(
            global.content,
            name: global.name,
            color: global.colorPrimary,
          );
        }
        return controller;
      },
      child: const _BusinessCardFormBody(),
    );
  }
}

class _BusinessCardFormBody extends StatelessWidget {
  const _BusinessCardFormBody();

  void _handleGenerate(BuildContext context, BusinessQRController controller) {
    if (controller.companyName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a company name'), backgroundColor: Colors.orange),
      );
      return;
    }

    // Map Advanced Business data to Global QR Controller
    final globalController = context.read<QrGeneratorController>();
    globalController.updateData(
      name: controller.companyName,
      type: 'business',
      colorPrimary: controller.primaryColor,
      content: {
        'name': controller.companyName,
        'headline': controller.headline,
        'website': controller.website,
        'phone': controller.phone,
        'email': controller.email,
        'address': '${controller.street}, ${controller.city}',
        // The preview/success screen will use these to generate the link
      },
    );

    Navigator.pushNamed(context, AppRoutes.qrPreview);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessQRController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.primary, size: 20),
            ),
            title: const Text('Business Page QR', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: AppColors.lightGrey, height: 1),
            ),
          ),
          body: Stack(
            children: [
              const SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 120, left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColorPalettePickerSection(),
                    SizedBox(height: 24),
                    BusinessInfoSection(),
                    SizedBox(height: 24),
                    OpeningHoursSection(),
                    SizedBox(height: 24),
                    LocationSection(),
                    SizedBox(height: 24),
                    ContactInfoSection(),
                    SizedBox(height: 24),
                    SocialNetworksSection(),
                    SizedBox(height: 24),
                    AboutCompanySection(),
                    SizedBox(height: 24),
                    FacilitiesSection(),
                    SizedBox(height: 24),
                    WelcomeScreenSection(),
                    SizedBox(height: 24),
                    QRNamePasswordSection(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              
              // Sticky Action Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleGenerate(context, controller),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: controller.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.read<QrGeneratorController>().isEditing ? 'Update Business QR' : 'Generate Business QR',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.qr_code_2_rounded, size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
