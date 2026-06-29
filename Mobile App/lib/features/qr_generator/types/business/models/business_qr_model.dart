class BusinessQr {
  final String name;
  final String category;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;

  BusinessQr({
    required this.name,
    required this.category,
    this.address,
    this.phone,
    this.email,
    this.website,
  });

  factory BusinessQr.fromMap(Map<String, dynamic> map) {
    return BusinessQr(
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other',
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
    };
  }
}
