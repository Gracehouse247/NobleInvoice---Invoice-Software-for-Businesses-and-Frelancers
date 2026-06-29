import 'package:flutter/material.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/models/profile_model.dart';
import 'base_template.dart';

// ── 18. GRADIENT FLASH ──────────────────────────────────────────────────────
class GradientFlashTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [kit.primaryColor, kit.secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            const Spacer(),
            qr(size: 60, dark: true),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: Icon(Icons.flash_on, color: kit.primaryColor, size: 40)));
  }
}

// ── 19. GLASS CARD 2 ────────────────────────────────────────────────────────
class GlassCard2Template extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Container(
          width: 250, height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(profile?.displayName ?? 'Name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(profile?.email ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: kit.primaryColor, child: const Center(child: Icon(Icons.blur_circular, color: Colors.white, size: 40)));
  }
}

// ── 20. NEON BORDER ─────────────────────────────────────────────────────────
class NeonBorderTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.black,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: kit.primaryColor, width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(profile?.displayName ?? 'Name', style: TextStyle(color: kit.primaryColor, fontSize: 22, fontWeight: FontWeight.bold, shadows: [Shadow(color: kit.primaryColor, blurRadius: 10)])),
              const Spacer(),
              info(Icons.web, 'neon.future', color: kit.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: Center(child: Text('NEON', style: TextStyle(color: kit.primaryColor, fontWeight: FontWeight.bold, fontSize: 24, shadows: [Shadow(color: kit.primaryColor, blurRadius: 20)]))));
  }
}

// ── 52. INFLUENCER ──────────────────────────────────────────────────────────
class InfluencerTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(right: 0, child: Container(width: 100, height: 200, color: Colors.pink.shade50)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('@influencer_handle', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                const Spacer(),
                info(Icons.camera_alt, 'Instagram / TikTok'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.pink, child: const Center(child: Icon(Icons.star, color: Colors.white, size: 40)));
  }
}

// ── 53. CREATOR ─────────────────────────────────────────────────────────────
class CreatorTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
            const Spacer(),
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('CONTENT CREATOR', style: TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.red, child: const Center(child: Text('SUBSCRIBE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
  }
}

// ── 54. PORTFOLIO ───────────────────────────────────────────────────────────
class PortfolioTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(child: GridView.count(crossAxisCount: 3, children: List.generate(3, (i) => Container(margin: const EdgeInsets.all(2), color: Colors.grey.shade100)))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                qr(size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: const Center(child: Text('VIEW WORK', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2))));
  }
}

// ── 57. PRISM ───────────────────────────────────────────────────────────────
class PrismTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue, Colors.teal], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(child: Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: qr(size: 50)));
  }
}

// ── 58. TRIANGLE EDGE ───────────────────────────────────────────────────────
class TriangleTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Icon(Icons.change_history, size: 100, color: kit.primaryColor.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                info(Icons.details, 'GEOMETRIC DESIGN'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: kit.primaryColor, child: const Center(child: Icon(Icons.architecture, color: Colors.white, size: 40)));
  }
}

// ── 59. HEXAGON GRID ────────────────────────────────────────────────────────
class HexagonTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.hexagon_outlined, color: Colors.amber, size: 30),
            const Spacer(),
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.amber, child: const Center(child: Icon(Icons.hexagon, color: Colors.white, size: 40)));
  }
}

// ── 60. STELLAR ─────────────────────────────────────────────────────────────
class StellarTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Center(child: Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.2), size: 100)),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: Center(child: Text(teamName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))));
  }
}

// ── 63. MODERN MINIMAL ──────────────────────────────────────────────────────
class ModernMinimalTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((profile?.displayName ?? 'Noble User').toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 4),
            Text(profile?.email ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                qr(profileId: profile?.id, size: 45),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('PREMIUM IDENTITY', style: TextStyle(color: kit.primaryColor.withOpacity(0.3), fontSize: 6, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    const SizedBox(height: 2),
                    Text(profile?.phone ?? '', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(
      color: Colors.white, 
      child: Stack(
        children: [
          Positioned(bottom: 0, left: 0, right: 0, child: Container(height: 2, color: kit.primaryColor.withOpacity(0.1))),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(teamName.toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4)),
                const SizedBox(height: 4),
                Container(width: 20, height: 1, color: kit.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 64. CORPORATE BOLD ──────────────────────────────────────────────────────
class CorporateBoldTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: kit.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            info(Icons.phone, profile?.phone ?? '', color: Colors.white),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: Text(teamName, style: TextStyle(color: kit.primaryColor, fontWeight: FontWeight.w900))));
  }
}
