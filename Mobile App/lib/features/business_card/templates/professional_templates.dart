import 'package:flutter/material.dart';
import 'package:noble_invoice/features/brand/controllers/brand_controller.dart';
import 'package:noble_invoice/features/profile/models/profile_model.dart';
import 'base_template.dart';

// ── 14. LAWYER PRO ──────────────────────────────────────────────────────────
class LawyerTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF1E3A8A),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
            const Text('ATTORNEY AT LAW', style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 2)),
            const Spacer(),
            info(Icons.gavel, 'Justice & Integrity', color: Colors.white),
            info(Icons.phone, profile?.phone ?? 'Counsel Line', color: Colors.white),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: const Center(child: Icon(Icons.account_balance, color: Color(0xFF1E3A8A), size: 50)));
  }
}

// ── 15. MEDICAL CARD ────────────────────────────────────────────────────────
class MedicalTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: Icon(Icons.local_hospital, size: 150, color: Colors.blue.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. ${profile?.displayName ?? 'Name'}', style: const TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('Specialist Physician', style: TextStyle(color: Colors.grey, fontSize: 10)),
                const Spacer(),
                info(Icons.medical_services, 'General Practice'),
                info(Icons.phone, profile?.phone ?? 'Clinic Contact'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.blue, child: const Center(child: Icon(Icons.favorite, color: Colors.white, size: 40)));
  }
}

// ── 16. REAL ESTATE ─────────────────────────────────────────────────────────
class RealEstateTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: const Color(0xFF111827),
      child: Column(
        children: [
          Expanded(child: Container(width: double.infinity, color: kit.primaryColor, child: const Icon(Icons.home_work, color: Colors.white, size: 50))),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(profile?.displayName ?? 'Name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('LUXURY PROPERTY AGENT', style: TextStyle(color: Colors.white60, fontSize: 8)),
                const Spacer(),
                info(Icons.phone, profile?.phone ?? 'Agent Line', color: Colors.white),
              ],
            ),
          )),
        ],
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: Colors.white, child: Center(child: Text(teamName, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 20))));
  }
}

// ── 17. CONSULTANT ──────────────────────────────────────────────────────────
class ConsultantTemplate extends BusinessCardTemplate {
  @override
  Widget buildFront(BuildContext context, BrandKit kit, UserProfile? profile) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(children: [
               Container(width: 40, height: 40, color: kit.primaryColor),
               const SizedBox(width: 12),
               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Text(profile?.displayName ?? 'Name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                 const Text('STRATEGY CONSULTANT', style: TextStyle(fontSize: 8, color: Colors.grey)),
               ]),
            ]),
            const Spacer(),
            info(Icons.trending_up, 'Scale your business'),
            info(Icons.email, profile?.email ?? ''),
          ],
        ),
      ),
    );
  }
  @override
  Widget buildBack(BuildContext context, BrandKit kit, String teamName) {
    return Container(color: kit.primaryColor, child: const Center(child: Text('STRATEGY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 4))));
  }
}
