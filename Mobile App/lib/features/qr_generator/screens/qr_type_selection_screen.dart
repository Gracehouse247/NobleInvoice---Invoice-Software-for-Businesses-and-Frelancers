import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'package:noble_invoice/routes/app_routes.dart';

class QrTypeSelectionScreen extends StatelessWidget {
  const QrTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),
            
            // Main Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildTypeCard(context, Icons.language_rounded, 'Website'),
                      _buildTypeCard(context, Icons.wifi_rounded, 'WiFi'),
                      _buildTypeCard(context, Icons.contact_page_rounded, 'vCard'),
                      _buildTypeCard(context, Icons.storefront_rounded, 'Business'),
                      _buildTypeCard(context, Icons.restaurant_menu_rounded, 'Menu'),
                      _buildTypeCard(context, Icons.share_rounded, 'Social Media'),
                      _buildTypeCard(context, Icons.alternate_email_rounded, 'Email'),
                      _buildTypeCard(context, Icons.sms_rounded, 'SMS'),
                      _buildTypeCard(context, Icons.apple_rounded, 'App Store'),
                      _buildTypeCard(context, Icons.place_rounded, 'Location'),
                      _buildTypeCard(context, Icons.subject_rounded, 'Text'),
                      _buildTypeCard(context, Icons.picture_as_pdf_rounded, 'PDF'),
                      _buildTypeCard(context, Icons.image_rounded, 'Image'),
                      _buildTypeCard(context, Icons.videocam_rounded, 'Video'),
                      _buildTypeCard(context, Icons.event_rounded, 'Event'),
                      _buildTypeCard(context, Icons.currency_bitcoin_rounded, 'Bitcoin'),
                      _buildTypeCard(context, Icons.chat_bubble_rounded, 'WhatsApp'),
                      _buildTypeCard(context, Icons.confirmation_number_rounded, 'Coupon'),
                      _buildTypeCard(context, Icons.audio_file_rounded, 'MP3'),
                      _buildTypeCard(context, Icons.phone_callback_rounded, 'Call'),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Recent Activity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem('Summer Menu 2024', 'Digital Menu • Created 2d ago'),
                  const SizedBox(height: 12),
                  _buildActivityItem('Store WiFi Access', 'WiFi Config • Created 5d ago'),
                  const SizedBox(height: 100), // Padding for BottomNav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF1E40AF), // Deeper blue for premium depth
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Stack(
          children: [
            // Abstract Background Elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (Navigator.canPop(context))
                          _buildHeaderIconButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: () => Navigator.pop(context),
                          )
                        else
                          const SizedBox(width: 44), // Maintain spacing
                        Text(
                          'QR GENERATOR',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.1),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 2.0,
                          ),
                        ),
                        _buildHeaderIconButton(
                          icon: Icons.help_outline_rounded,
                          onTap: () {},
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE2E8F0)],
                      ).createShader(bounds),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Easily create a QR code\nfor any occasion',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: Colors.white,
                            height: 1.15,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: Colors.amber.shade300, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            'Select a type to get started',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.1),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton({required IconData icon, required VoidCallback onTap, double size = 28}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  Widget _buildTypeCard(BuildContext context, IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (label == 'Website') {
              Navigator.pushNamed(context, AppRoutes.websiteQrForm);
            } else if (label == 'WiFi') {
              Navigator.pushNamed(context, AppRoutes.wifiQrForm);
            } else if (label == 'vCard') {
              Navigator.pushNamed(context, AppRoutes.vCardQrForm);
            } else if (label == 'Business') {
              Navigator.pushNamed(context, AppRoutes.businessQrForm);
            } else if (label == 'Menu') {
              Navigator.pushNamed(context, AppRoutes.menuQrForm);
            } else if (label == 'Social Media') {
              Navigator.pushNamed(context, AppRoutes.socialMediaQrForm);
            } else if (label == 'App Store') {
              Navigator.pushNamed(context, AppRoutes.appStoreQrForm);
            } else if (label == 'PDF') {
              Navigator.pushNamed(context, AppRoutes.pdfQrForm);
            } else if (label == 'Image') {
              Navigator.pushNamed(context, AppRoutes.imageQrForm);
            } else if (label == 'Video') {
              Navigator.pushNamed(context, AppRoutes.videoQrForm);
            } else if (label == 'Event') {
              Navigator.pushNamed(context, AppRoutes.eventQrForm);
            } else if (label == 'Bitcoin') {
              Navigator.pushNamed(context, AppRoutes.bitcoinQrForm);
            } else if (label == 'Email') {
              Navigator.pushNamed(context, AppRoutes.emailQrForm);
            } else if (label == 'WhatsApp') {
              Navigator.pushNamed(context, AppRoutes.whatsappQrForm);
            } else if (label == 'Coupon') {
              Navigator.pushNamed(context, AppRoutes.couponQrForm);
            } else if (label == 'MP3') {
              Navigator.pushNamed(context, AppRoutes.mp3QrForm);
            } else if (label == 'SMS') {
              Navigator.pushNamed(context, AppRoutes.smsQrForm);
            } else if (label == 'Location') {
              Navigator.pushNamed(context, AppRoutes.locationQrForm);
            } else if (label == 'Text') {
              Navigator.pushNamed(context, AppRoutes.textQrForm);
            } else if (label == 'Call') {
              Navigator.pushNamed(context, AppRoutes.callQrForm);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_2_rounded, color: Color(0xFF94A3B8), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.darkGrey),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
