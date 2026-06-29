// lib/features/brand/controllers/brand_controller.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/profile/controllers/team_controller.dart';
import 'package:noble_invoice/core/utils/color_utils.dart';

class BrandKit {
  final Color primaryColor;
  final Color secondaryColor;
  final String brandVoice;
  final String? logoUrl;
  final bool showWatermark;

  BrandKit({
    required this.primaryColor,
    required this.secondaryColor,
    required this.brandVoice,
    this.logoUrl,
    this.showWatermark = true,
  });

  factory BrandKit.fromMap(Map<String, dynamic> map) {
    return BrandKit(
      primaryColor:   ColorUtils.fromHex(map['brand_color'], fallback: const Color(0xFF2563EB)),
      secondaryColor: ColorUtils.fromHex(map['secondary_color'], fallback: const Color(0xFF1E293B)),
      brandVoice:     map['brand_voice'] ?? 'Professional & Trusted',
      logoUrl:        map['brand_logo_url'],
      showWatermark:  map['show_watermark'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'brand_color':     ColorUtils.toHex(primaryColor),
    'secondary_color': ColorUtils.toHex(secondaryColor),
    'brand_voice':     brandVoice,
    'brand_logo_url':  logoUrl,
    'show_watermark':  showWatermark,
  };
}

class BrandController extends ChangeNotifier {
  final TeamController teamCtrl;
  BrandKit? _brandKit = BrandKit(
    primaryColor:   const Color(0xFF2563EB),
    secondaryColor: const Color(0xFF1E293B),
    brandVoice:     'Professional & Trusted',
    showWatermark:  true,
  );
  bool _isLoading = false;
  String? _lastTeamId;

  BrandController(this.teamCtrl);

  BrandKit? get brandKit => _brandKit;
  bool get isLoading => _isLoading;

  Future<void> loadBrandKit() async {
    final teamId = teamCtrl.activeTeamId;
    if (teamId == null || teamId == _lastTeamId) return;

    _lastTeamId = teamId;
    _isLoading = true;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('teams')
          .select('brand_color, secondary_color, brand_voice, brand_logo_url, show_watermark')
          .eq('id', teamId)
          .single();
      
      _brandKit = BrandKit.fromMap(data);
    } catch (e) {
      debugPrint('Error loading brand kit: $e');
      // Set defaults if data is missing or table not migrated
      _brandKit = BrandKit(
        primaryColor:   const Color(0xFF2563EB),
        secondaryColor: const Color(0xFF1E293B),
        brandVoice:     'Professional & Trusted',
        showWatermark:  true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveBrandKit(BrandKit kit) async {
    final teamId = teamCtrl.activeTeamId;
    if (teamId == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.client
          .from('teams')
          .update(kit.toMap())
          .eq('id', teamId);
          
      // SYNC TO PROFILE
      final userId = SupabaseService.currentUser?.id;
      if (userId != null) {
        await SupabaseService.client
            .from('profiles')
            .update({
              'brand_color': ColorUtils.toHex(kit.primaryColor),
              'brand_logo_url': kit.logoUrl,
            })
            .eq('id', userId);
      }
      
      _brandKit = kit;
      return true;
    } catch (e) {
      debugPrint('Error saving brand kit: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
