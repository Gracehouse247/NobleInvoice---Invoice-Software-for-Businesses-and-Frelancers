// lib/features/profile/models/team_model.dart
import 'package:flutter/material.dart';

enum TeamRole {
  owner,
  admin,
  staff,
  accountant;

  String get label {
    switch (this) {
      case TeamRole.owner:      return 'Owner';
      case TeamRole.admin:      return 'Admin';
      case TeamRole.staff:      return 'Staff';
      case TeamRole.accountant: return 'Accountant';
    }
  }

  Color get color {
    switch (this) {
      case TeamRole.owner:      return Colors.purple;
      case TeamRole.admin:      return Colors.blue;
      case TeamRole.staff:      return Colors.green;
      case TeamRole.accountant: return Colors.orange;
    }
  }

  static TeamRole fromString(String role) {
    return TeamRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => TeamRole.staff,
    );
  }
}

class Team {
  final String id;
  final String ownerId;
  final String name;
  final DateTime createdAt;

  // New Branding Fields
  final String? industry;
  final String? brandLogoUrl;
  final String  brandColor;
  final String? businessAddress;
  final String? businessEmail;
  final String? businessPhone;
  final String? taxNumber;
  final String? invoiceFooter;
  final String? flutterwaveSubaccountId;
  final String? defaultInvoiceTemplate;
  final String? brandSignatureUrl;

  // Global Invoicing Settings
  final double  defaultVatRate;
  final double  defaultWhtRate;
  final String  defaultPaymentTerms;
  final String  invoicePrefix;
  final Map<String, dynamic> metadata;

  Team({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
    this.industry,
    this.brandLogoUrl,
    this.brandColor = '#2563EB',
    this.businessAddress,
    this.businessEmail,
    this.businessPhone,
    this.taxNumber,
    this.invoiceFooter,
    this.flutterwaveSubaccountId,
    this.defaultInvoiceTemplate,
    this.brandSignatureUrl,
    this.defaultVatRate = 0,
    this.defaultWhtRate = 0,
    this.defaultPaymentTerms = 'Payment is due within 14 days of invoice issue.',
    this.invoicePrefix = 'NGO',
    this.metadata = const {},
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id:        json['id']?.toString() ?? '',
      ownerId:   json['owner_id']?.toString() ?? '',
      name:      json['name'] ?? '',
      industry:  json['industry'],
      createdAt: DateTime.parse(json['created_at']),
      brandLogoUrl:    json['brand_logo_url'],
      brandColor:      json['brand_color'] ?? '#2563EB',
      businessAddress: json['business_address'],
      businessEmail:   json['business_email'],
      businessPhone:   json['business_phone'],
      taxNumber:       json['tax_number'],
      invoiceFooter:   json['invoice_footer'],
      flutterwaveSubaccountId: json['flutterwave_subaccount_id'],
      defaultInvoiceTemplate: json['default_invoice_template'],
      defaultVatRate:  double.tryParse(json['default_vat_rate']?.toString() ?? '0') ?? 0,
      defaultWhtRate:  double.tryParse(json['default_wht_rate']?.toString() ?? '0') ?? 0,
      invoicePrefix:   json['invoice_prefix'] ?? 'NGO',
      brandSignatureUrl: json['brand_signature_url'] as String?,
      metadata:        json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id':              id,
    'owner_id':        ownerId,
    'name':            name,
    'industry':         industry,
    'business_name':    name,
    'brand_logo_url':  brandLogoUrl,
    'brand_color':     brandColor,
    'business_address': businessAddress,
    'business_email':   businessEmail,
    'business_phone':   businessPhone,
    'tax_number':       taxNumber,
    'invoice_footer':   invoiceFooter,
    'default_invoice_template': defaultInvoiceTemplate,
    'default_vat_rate': defaultVatRate,
    'default_wht_rate': defaultWhtRate,
    'default_payment_terms': defaultPaymentTerms,
    'invoice_prefix':   invoicePrefix,
    'brand_signature_url': brandSignatureUrl,
    'metadata': metadata,
  };

  Team copyWith({
    String? id,
    String? ownerId,
    String? name,
    DateTime? createdAt,
    String? industry,
    String? brandLogoUrl,
    String? brandColor,
    String? businessAddress,
    String? businessEmail,
    String? businessPhone,
    String? taxNumber,
    String? invoiceFooter,
    String? flutterwaveSubaccountId,
    String? defaultInvoiceTemplate,
    double? defaultVatRate,
    double? defaultWhtRate,
    String? defaultPaymentTerms,
    String? invoicePrefix,
    String? brandSignatureUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Team(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      industry: industry ?? this.industry,
      brandLogoUrl: brandLogoUrl ?? this.brandLogoUrl,
      brandColor: brandColor ?? this.brandColor,
      businessAddress: businessAddress ?? this.businessAddress,
      businessEmail: businessEmail ?? this.businessEmail,
      businessPhone: businessPhone ?? this.businessPhone,
      taxNumber: taxNumber ?? this.taxNumber,
      invoiceFooter: invoiceFooter ?? this.invoiceFooter,
      flutterwaveSubaccountId: flutterwaveSubaccountId ?? this.flutterwaveSubaccountId,
      defaultInvoiceTemplate: defaultInvoiceTemplate ?? this.defaultInvoiceTemplate,
      defaultVatRate: defaultVatRate ?? this.defaultVatRate,
      defaultWhtRate: defaultWhtRate ?? this.defaultWhtRate,
      defaultPaymentTerms: defaultPaymentTerms ?? this.defaultPaymentTerms,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      brandSignatureUrl: brandSignatureUrl ?? this.brandSignatureUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}

class TeamMember {
  final int id;
  final String teamId;
  final String userId;
  final TeamRole role;
  final DateTime joinedAt;
  
  // Joined Data
  final String? userName;
  final String? userEmail;
  final String? userAvatarUrl;

  TeamMember({
    required this.id,
    required this.teamId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    this.userName,
    this.userEmail,
    this.userAvatarUrl,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id:        json['id'] ?? 0,
      teamId:    json['team_id']?.toString() ?? '',
      userId:    json['user_id']?.toString() ?? '',
      role:      TeamRole.fromString(json['role'] ?? 'staff'),
      joinedAt:  DateTime.parse(json['joined_at']),
      userName:  json['profiles']?['name'],
      userEmail: json['profiles']?['email'],
      userAvatarUrl: json['profiles']?['avatar_url'],
    );
  }
}
