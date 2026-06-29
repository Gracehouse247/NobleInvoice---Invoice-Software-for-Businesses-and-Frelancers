class Folder {
  final String id;
  final String name;
  final String? iconName;
  final DateTime? createdAt;

  Folder({
    required this.id,
    required this.name,
    this.iconName,
    this.createdAt,
  });

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: (map['id'] ?? '').toString(),
      name: map['name'] ?? '',
      iconName: map['icon_name'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon_name': iconName,
    };
  }
}
