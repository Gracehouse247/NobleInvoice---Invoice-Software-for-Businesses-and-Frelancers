// lib/features/invoicing/models/client_model.dart
class Client {
  final int    id;
  final String name;
  final String email;
  final String? phone;
  final String? country;       // e.g. 'Nigeria', 'United States'
  final String? countryCode;   // e.g. '+234'
  final String? address;
  final String? businessName;
  final String? companyName;   // alias used in some places
  final String? position;      // CEO, MD, Manager etc.
  final List<String> tags;
  final String? leadStatus;  // 'lead' | 'active' | 'vip' | 'churned'

  Client({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.country,
    this.countryCode = '+234',
    this.address,
    this.businessName,
    this.companyName,
    this.position,
    this.tags = const [],
    this.leadStatus = 'active',
  });

  // Full phone with country code prefix (for display)
  String get fullPhone {
    if (phone == null || phone!.isEmpty) return '';
    final code = countryCode ?? '+234';
    if (phone!.startsWith('+')) return phone!;
    return '$code${phone!.replaceFirst(RegExp('^0'), '')}';
  }

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id:           (json['id'] as num?)?.toInt() ?? 0,
    name:         json['name'] ?? 'Unknown Client',
    email:        json['email'] ?? '',
    phone:        json['phone'] as String?,
    country:      json['country'] as String?,
    countryCode:  json['country_code'] as String? ?? '+234',
    address:      json['address'] as String?,
    businessName: json['business_name'] as String?,
    companyName:  json['company_name'] as String? ?? json['business_name'] as String?,
    position:     json['position'] as String?,
    tags:         List<String>.from(json['tags'] ?? []),
    leadStatus:   json['lead_status'] as String? ?? 'active',
  );

  Client copyWith({String? leadStatus, String? country}) => Client(
    id:           id,
    name:         name,
    email:        email,
    phone:        phone,
    country:      country ?? this.country,
    countryCode:  countryCode,
    address:      address,
    businessName: businessName,
    companyName:  companyName,
    position:     position,
    tags:         tags,
    leadStatus:   leadStatus ?? this.leadStatus,
  );

  Map<String, dynamic> toJson() => {
    'name':          name,
    'email':         email,
    if (phone        != null && phone!.isNotEmpty)        'phone':         phone,
    if (country      != null)                             'country':       country,
    if (countryCode  != null)                             'country_code':  countryCode,
    if (address      != null && address!.isNotEmpty)      'address':       address,
    if (businessName != null && businessName!.isNotEmpty) 'business_name': businessName,
    if (position     != null && position!.isNotEmpty)     'position':      position,
  };
}
