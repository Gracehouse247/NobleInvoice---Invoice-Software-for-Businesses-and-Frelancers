import 'package:flutter/material.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/models/profile_model.dart';
import 'base_template.dart';

// ── 21. PLATINUM VELVET ─────────────────────────────────────────────────────
class PlatinumVelvetTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Stack(
        children: [
          Positioned(left: -50, top: -50, child: Container(width: 200, height: 200, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.white12, Colors.transparent])))),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 22, fontWeight: FontWeight.w100, letterSpacing: 4)),
                const Spacer(),
                info(Icons.diamond, 'ELITE MEMBER', color: const Color(0xFFE5E7EB)),
                info(Icons.mail, profile?.email ?? '', color: const Color(0xFFE5E7EB)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: const Color(0xFF111827), child: Center(child: Text(teamName, style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2))));
  }
}

// ── 22. EMERALD SILK ────────────────────────────────────────────────────────
class EmeraldSilkTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    const emerald = Color(0xFF064E3B);
    return Container(
      color: emerald,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Icon(Icons.auto_awesome, color: Colors.white24),
             ]),
             const Spacer(),
             info(Icons.verified, 'EMERALD STATUS', color: Colors.white),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: const Color(0xFF065F46), child: const Center(child: Icon(Icons.eco, color: Colors.white, size: 40)));
  }
}

// ── 23. MARBLE ROYALE ───────────────────────────────────────────────────────
class MarbleRoyaleTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
           const Center(child: Opacity(opacity: 0.1, child: Icon(Icons.architecture, size: 200))),
           Padding(
             padding: const EdgeInsets.all(24),
             child: Column(
               children: [
                  Text(profile?.displayName ?? 'Name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 10)),
                  const Spacer(),
                  info(Icons.location_on, 'MARBLE PALACE'),
               ],
             ),
           ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: Center(child: Container(width: 40, height: 40, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)))));
  }
}
