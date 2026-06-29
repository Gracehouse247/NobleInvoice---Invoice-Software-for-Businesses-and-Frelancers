import 'package:flutter/material.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/models/profile_model.dart';
import 'base_template.dart';

// ── 7. CIRCUIT BOARD ────────────────────────────────────────────────────────
class CircuitBoardTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF020617),
      child: Stack(
        children: [
          _lines(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -1)),
                Text('SYSTEMS ARCHITECT', style: TextStyle(color: Colors.cyanAccent.withOpacity(0.1), fontSize: 8)),
                const Spacer(),
                info(Icons.memory, '0xFF_IDENTITY_LOCK', color: Colors.cyanAccent),
                info(Icons.bolt, profile?.email ?? '', color: Colors.cyanAccent),
              ],
            ),
          ),
          Positioned(right: 20, bottom: 20, child: qr(size: 45, dark: true, border: Colors.cyanAccent)),
        ],
      ),
    );
  }

  Widget _lines() {
    return Opacity(opacity: 0.1, child: GridView.count(crossAxisCount: 5, children: List.generate(20, (i) => const Icon(Icons.add, color: Colors.cyanAccent, size: 40))));
  }

  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: const Center(child: Icon(Icons.developer_board, color: Colors.cyanAccent, size: 60)));
  }
}

// ── 8. BLOCKCHAIN ───────────────────────────────────────────────────────────
class BlockchainTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                   Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                   const Icon(Icons.currency_bitcoin, color: Colors.orangeAccent),
                ]),
                const Spacer(),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 12),
                info(Icons.vpn_key, 'HASH_UUID_741', color: Colors.white60),
                info(Icons.account_balance_wallet, profile?.email ?? '', color: Colors.white60),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.orangeAccent, child: const Center(child: Text('DECENTRALIZED', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2))));
  }
}

// ── 9. DIGITAL MESH ─────────────────────────────────────────────────────────
class DigitalMeshTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'), opacity: 0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.blur_on, color: Colors.blueAccent, size: 30),
            const Spacer(),
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w200, letterSpacing: 2)),
            const SizedBox(height: 8),
            info(Icons.web, 'mesh.network', color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.blueAccent, child: const Center(child: Icon(Icons.hub, color: Colors.white, size: 50)));
  }
}

// ── 10. QUANTUM ─────────────────────────────────────────────────────────────
class QuantumTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Stack(
        children: [
           const Center(child: Opacity(opacity: 0.05, child: Icon(Icons.wb_sunny, size: 300, color: Colors.white))),
           Padding(
             padding: const EdgeInsets.all(24),
             child: Column(
               children: [
                  Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -1)),
                  const SizedBox(height: 4),
                  Text('QUANTUM COMPUTING SPECIALIST', style: TextStyle(color: kit.primaryColor, fontSize: 8, letterSpacing: 1)),
                  const Spacer(),
                  qr(size: 80, dark: true, border: kit.primaryColor),
               ],
             ),
           ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.black, child: const Center(child: Icon(Icons.flare, color: Colors.white, size: 40)));
  }
}
