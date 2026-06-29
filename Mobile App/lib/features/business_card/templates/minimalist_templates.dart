import 'package:flutter/material.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/models/profile_model.dart';
import 'base_template.dart';

// ── 11. PURE WHITE ──────────────────────────────────────────────────────────
class PureWhiteTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text((profile?.displayName ?? '').toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w200, letterSpacing: 8)),
            const SizedBox(height: 12),
            Container(width: 20, height: 1, color: Colors.black),
            const SizedBox(height: 12),
            Text(profile?.email ?? '', style: const TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: qr(size: 60)));
  }
}

// ── 12. DEEP NOIR ───────────────────────────────────────────────────────────
class DeepNoirTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF050505),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -1)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
               const Icon(Icons.phone, color: Colors.white38, size: 12),
               const SizedBox(width: 8),
               Text(profile?.phone ?? 'Direct', style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ]),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: Center(child: Container(width: 2, height: 100, color: kit.primaryColor)));
  }
}

// ── 13. SWISS GRID ──────────────────────────────────────────────────────────
class SwissGridTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFFE11D48), // Deep Red
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 30),
            const Spacer(),
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -2)),
            const Text('DESIGN PHILOSOPHY', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: Text(teamName.toUpperCase(), style: const TextStyle(color: Color(0xFFE11D48), fontSize: 20, fontWeight: FontWeight.w900))));
  }
}
