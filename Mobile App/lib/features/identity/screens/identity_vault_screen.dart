// lib/features/identity/screens/identity_vault_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/widgets/subscription_guard.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';
import 'package:noble_invoice/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:noble_invoice/core/widgets/subscription_guard.dart';

class IdentityVaultScreen extends StatefulWidget {
  const IdentityVaultScreen({super.key});

  @override
  State<IdentityVaultScreen> createState() => _IdentityVaultScreenState();
}

class _IdentityVaultScreenState extends State<IdentityVaultScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // AppColors.lightGrey
      body: Stack(
        children: [
          // 1. Immersive Background Layer
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.05),
                    const Color(0xFFF1F5F9),
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content View
          Column(
            children: [
              const SizedBox(height: 60), // Status bar spacer
              _buildHeader(),
              const SizedBox(height: 40),
              
              // 3. Apple Wallet 3D Carousel
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _build3DCardWrapper(index);
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identity Vault',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                    color: AppColors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Your Professional OS',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.palette_outlined, color: AppColors.primary),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.brandKit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DCardWrapper(int index) {
    // Calculate difference for the tilt effect
    double difference = index - _currentPage;
    
    // Apply 3D transformation
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateY(-difference * 0.3) // Rotate based on scroll distance
      ..rotateZ(difference * 0.05) // Slight twist
      ..scale(1 - (difference.abs() * 0.15)); // Scale down non-focused cards

    final sub = context.watch<SubscriptionController>();
    final isLocked = (index == 3) && (!sub.isPulseOrElite || sub.isExpired);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            Navigator.pushNamed(context, AppRoutes.pricingPlans);
            return;
          }
          switch (index) {
            case 0: Navigator.pushNamed(context, AppRoutes.businessCardDesigner); break;
            case 1: Navigator.pushNamed(context, AppRoutes.qrHistory); break;
            case 2: Navigator.pushNamed(context, AppRoutes.crmDashboard); break;
            case 3: Navigator.pushNamed(context, AppRoutes.financialIntelligence); break;
            case 4: Navigator.pushNamed(context, AppRoutes.productList); break;
          }
        },
        child: SubscriptionGuard(
          isLocked: isLocked,
          featureName: 'Advanced Intelligence',
          upgradeMessage: 'Unlock financial insights and revenue tracking.',
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white, // pure white cards
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                // Deep shadows to make it "float"
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: -10,
                ),
                BoxShadow(
                  color: _getThemeColor(index).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: _buildCardContent(index),
            ),
          ),
        ),
      ),
    );
  }

  Color _getThemeColor(int index) {
    switch (index) {
      case 0: return AppColors.primary;
      case 1: return AppColors.secondary;
      case 2: return const Color(0xFF6366F1); // Indigo
      case 3: return const Color(0xFF10B981); // Emerald
      case 4: return const Color(0xFFF59E0B); // Amber
      default: return AppColors.primary;
    }
  }

  Widget _buildCardContent(int index) {
    final color = _getThemeColor(index);
    final data = _getCardData(index);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 64, color: color),
            ),
            const SizedBox(height: 32),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _CardData _getCardData(int index) {
    switch (index) {
      case 0: return _CardData(Icons.badge_rounded, 'Digital Card', 'Tap to open designer');
      case 1: return _CardData(Icons.qr_code_2_rounded, 'My QR Hub', 'Professional tracking engine');
      case 2: return _CardData(Icons.groups_rounded, 'Client CRM', 'Manage relationships & leads');
      case 3: return _CardData(Icons.auto_graph_rounded, 'Intelligence', 'Financial insights & reports');
      case 4: return _CardData(Icons.inventory_2_rounded, 'Inventory', 'Products & asset library');
      default: return _CardData(Icons.badge_rounded, 'Module', 'Tap to open');
    }
  }
}

class _CardData {
  final IconData icon;
  final String title;
  final String subtitle;
  _CardData(this.icon, this.title, this.subtitle);
}

