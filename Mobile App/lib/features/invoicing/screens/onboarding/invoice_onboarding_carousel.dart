import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class InvoiceOnboardingCarousel extends StatefulWidget {
  const InvoiceOnboardingCarousel({super.key});

  @override
  State<InvoiceOnboardingCarousel> createState() => _InvoiceOnboardingCarouselState();
}

class _InvoiceOnboardingCarouselState extends State<InvoiceOnboardingCarousel> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_TemplateSlide> _slides = [
    _TemplateSlide(
      title: 'Essentials Collection',
      description: 'Clean, professional, and minimalist designs for daily billing.',
      color: Colors.blue.shade700,
      icon: Icons.auto_awesome_outlined,
      features: ['Classic Modern', 'Minimalist', 'Compact Grid'],
    ),
    _TemplateSlide(
      title: 'Business Class',
      description: 'Sophisticated layouts with detailed branding and payment terms.',
      color: Colors.indigo.shade800,
      icon: Icons.business_center_outlined,
      features: ['Bold Header', 'Detailed Footer', 'Signature Ready'],
    ),
    _TemplateSlide(
      title: 'Platinum Collection',
      description: 'High-end designer templates for a million-dollar brand impression.',
      color: const Color(0xFF1E293B),
      icon: Icons.stars_rounded,
      features: ['Glassmorphic Layers', 'Dynamic Watermarking', 'QR Integration'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final s = _slides[index];
              return AnimatedScale(
                scale: _currentIndex == index ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [s.color, s.color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: s.color.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(s.icon, color: Colors.white, size: 32),
                      const SizedBox(height: 16),
                      Text(s.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text(s.description, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                      const Spacer(),
                      Wrap(
                        spacing: 8,
                        children: s.features.map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text(f, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentIndex == i ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentIndex == i ? AppColors.primary : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ),
      ],
    );
  }
}

class _TemplateSlide {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final List<String> features;
  _TemplateSlide({required this.title, required this.description, required this.color, required this.icon, required this.features});
}
