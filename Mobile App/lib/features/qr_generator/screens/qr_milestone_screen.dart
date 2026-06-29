import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class QrMilestoneScreen extends StatelessWidget {
  const QrMilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNav(context),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildConfettiBackground(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeroIllustration(),
                        const SizedBox(height: 32),
                        _buildBadge(),
                        const SizedBox(height: 16),
                        _buildTextContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildActionFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Help', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiBackground() {
    return Opacity(
      opacity: 0.1,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://img.freepik.com/free-vector/confetti-background-design_1048-1854.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(140),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)],
            ),
          ),
          // Illustration Box
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                image: NetworkImage('https://img.freepik.com/free-vector/rocket-launch-concept-illustration_114360-1282.jpg'),
                fit: BoxFit.cover,
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightGrey)),
                child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars_rounded, color: AppColors.primary, size: 16),
          SizedBox(width: 8),
          Text('MILESTONE REACHED', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return const Column(
      children: [
        Text(
          '100 QR Codes!\nYou\'re a Business Pro!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -0.5),
        ),
        SizedBox(height: 16),
        Text(
          'Congratulations on this incredible milestone. Your business is reaching more people than ever.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.1),
            ),
            icon: const Icon(Icons.share_rounded, size: 20),
            label: const Text('Share My Achievement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Keep Creating', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
