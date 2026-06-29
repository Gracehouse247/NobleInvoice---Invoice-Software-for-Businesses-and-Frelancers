// lib/features/business_card/models/business_card_model.dart

enum BusinessCardFormat {
  standard(width: 3.5, height: 2.0),
  square(width: 2.5, height: 2.5),
  slim(width: 3.5, height: 1.75);

  final double width;
  final double height;
  const BusinessCardFormat({required this.width, required this.height});
}

class BusinessCard {
  final String id;
  final String teamId;
  final BusinessCardFormat format;
  final String templateId;
  final String? customName;
  final String? customTitle;
  final String? customPhone;
  final String? customEmail;
  final String? customWebsite;
  final String? customAddress;
  final String? qrData; // Link to Digital Profile

  BusinessCard({
    required this.id,
    required this.teamId,
    this.format = BusinessCardFormat.standard,
    this.templateId = 'modern_flat',
    this.customName,
    this.customTitle,
    this.customPhone,
    this.customEmail,
    this.customWebsite,
    this.customAddress,
    this.qrData,
  });

  factory BusinessCard.fromJson(Map<String, dynamic> json) {
    return BusinessCard(
      id:            json['id']?.toString() ?? '',
      teamId:        json['team_id']?.toString() ?? '',
      format:        BusinessCardFormat.values.firstWhere((e) => e.name == json['format'], orElse: () => BusinessCardFormat.standard),
      templateId:    json['template_id'] ?? 'modern_flat',
      customName:    json['custom_name'],
      customTitle:   json['custom_title'],
      customPhone:   json['custom_phone'],
      customEmail:   json['custom_email'],
      customWebsite: json['custom_website'],
      customAddress: json['custom_address'],
      qrData:        json['qr_data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'team_id':     teamId,
    'format':      format.name,
    'template_id': templateId,
    'custom_name': customName,
    'custom_title':  customTitle,
    'custom_phone':  customPhone,
    'custom_email':  customEmail,
    'custom_website': customWebsite,
    'custom_address': customAddress,
    'qr_data':        qrData,
  };

  BusinessCard copyWith({
    String? id,
    String? teamId,
    BusinessCardFormat? format,
    String? templateId,
    String? customName,
    String? customTitle,
    String? customPhone,
    String? customEmail,
    String? customWebsite,
    String? customAddress,
    String? qrData,
  }) {
    return BusinessCard(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      format: format ?? this.format,
      templateId: templateId ?? this.templateId,
      customName: customName ?? this.customName,
      customTitle: customTitle ?? this.customTitle,
      customPhone: customPhone ?? this.customPhone,
      customEmail: customEmail ?? this.customEmail,
      customWebsite: customWebsite ?? this.customWebsite,
      customAddress: customAddress ?? this.customAddress,
      qrData: qrData ?? this.qrData,
    );
  }
}
