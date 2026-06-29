import 'package:flutter/material.dart';

class BrandModel {
  final String logoUrl;
  final String iconUrl;
  final List<Color> colors;
  final String fontFace;
  final String brandVoice;

  BrandModel({
    required this.logoUrl,
    required this.iconUrl,
    required this.colors,
    required this.fontFace,
    required this.brandVoice,
  });

  BrandModel copyWith({
    String? logoUrl,
    String? iconUrl,
    List<Color>? colors,
    String? fontFace,
    String? brandVoice,
  }) {
    return BrandModel(
      logoUrl: logoUrl ?? this.logoUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      colors: colors ?? this.colors,
      fontFace: fontFace ?? this.fontFace,
      brandVoice: brandVoice ?? this.brandVoice,
    );
  }
}
