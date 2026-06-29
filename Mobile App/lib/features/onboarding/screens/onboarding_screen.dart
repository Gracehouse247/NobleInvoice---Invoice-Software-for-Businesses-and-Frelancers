import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import '../widgets/onboarding_slide_widget.dart';
import '../widgets/final_onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      title: 'Smart Business Toolkit',
      highlightWord: 'Business',
      subtitle: 'Generate & manage professional invoicing, QR codes, and Business cards in one powerful dashboard.',
      color: AppColors.primary,
    ),
    OnboardingSlideData(
      title: 'Invoicing Made Simple',
      highlightWord: 'Simple',
      subtitle: 'Create and send professional invoices in seconds. Stay organized with cloud-based tracking, designed for businesses.',
      color: AppColors.primary,
    ),
    OnboardingSlideData(
      title: 'Smart QR Codes',
      highlightWord: 'Codes',
      subtitle: 'Create versatile QR codes for your business. From digital cards to contactless menus, share info instantly.',
      color: AppColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isFinalSlide = _currentPage == 3;
    
    return Scaffold(
      backgroundColor: isFinalSlide ? Colors.white : AppColors.background,
      body: SafeArea(
        child: isFinalSlide ? const FinalOnboardingSlide() : _buildNormalFlow(),
      ),
    );
  }
  
  Widget _buildNormalFlow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 48),
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text('NobleInvoice',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 12, letterSpacing: 2, color: AppColors.primary, fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                child: Text('Skip', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index == 3) return const SizedBox.shrink();
              return OnboardingSlideWidget(data: _slides[index], index: index);
            },
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _PaginationIndicator(count: 4, activeIndex: _currentPage),
              const SizedBox(height: 16),
              _buildActionButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaginationIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  const _PaginationIndicator({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool active = activeIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 6, height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}
