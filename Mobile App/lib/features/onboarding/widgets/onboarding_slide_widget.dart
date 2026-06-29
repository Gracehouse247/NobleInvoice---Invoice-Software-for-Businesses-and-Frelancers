import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/theme/app_text_styles.dart';
import 'onboarding_visuals.dart';

class OnboardingSlideData {
  final String title;
  final String? highlightWord;
  final String subtitle;
  final Color color;

  OnboardingSlideData({
    required this.title,
    this.highlightWord,
    required this.subtitle,
    required this.color,
  });
}

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingSlideData data;
  final int index;

  const OnboardingSlideWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visual Illustration
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: PremiumVisual(index: index),
          ),
        ),
        
        // Text Content
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRichTitle(data),
                  const SizedBox(height: 16),
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.grey.shade500,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRichTitle(OnboardingSlideData data) {
    if (data.highlightWord == null || !data.title.contains(data.highlightWord!)) {
      return Text(
        data.title,
        textAlign: TextAlign.center,
        style: AppTextStyles.headlineLarge.copyWith(
          height: 1.2,
          fontWeight: FontWeight.w800,
        ),
      );
    }

    final parts = data.title.split(data.highlightWord!);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.headlineLarge.copyWith(
          height: 1.2,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade900,
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: data.highlightWord,
            style: const TextStyle(color: AppColors.primary),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
