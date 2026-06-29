import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';

class ProBadgeAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final bool isPro;
  final double radius;
  final bool showCrown; // Alternative to "PRO" text

  const ProBadgeAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.isPro = false,
    this.radius = 60.0,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Avatar
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPro ? AppColors.primary.withOpacity(0.3) : AppColors.lightGrey,
              width: isPro ? 4 : 2,
            ),
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildInitials(),
                  ),
                )
              : _buildInitials(),
        ),

        // Pro Badge Override
        if (isPro) ...[
          Positioned(
            bottom: showCrown ? -5 : 0, // Crown sits a bit lower
            right: showCrown ? -5 : 0,  // Pro text is inset slightly
            child: showCrown ? _buildCrownBadge() : _buildTextBadge(),
          ),
        ]
      ],
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber, // Premium gold color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCrownBadge() {
     return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.amber, 
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
