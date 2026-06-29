// lib/features/inventory/models/product_model.dart
class Product {
  final String id;
  final String userId;
  final String teamId;
  final String? categoryId;
  final String name;
  final String? sku;
  final String? description;
  final double unitPrice;
  final int stockQuantity;
  final bool trackInventory;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined data
  final String? categoryName;

  Product({
    required this.id,
    required this.userId,
    required this.teamId,
    this.categoryId,
    required this.name,
    this.sku,
    this.description,
    required this.unitPrice,
    required this.stockQuantity,
    this.trackInventory = true,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id:            json['id']?.toString() ?? '',
      userId:        json['user_id'] ?? '',
      teamId:        json['team_id'] ?? '',
      categoryId:    json['category_id']?.toString(),
      name:          json['name'] ?? '',
      sku:           json['sku'],
      description:   json['description'],
      unitPrice:     double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0,
      stockQuantity: json['stock_quantity'] ?? 0,
      trackInventory:json['track_inventory'] ?? true,
      createdAt:     DateTime.parse(json['created_at']),
      updatedAt:     DateTime.parse(json['updated_at']),
      categoryName:  json['product_categories']?['name'],
    );
  }
}

class ProductCategory {
  final String id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id:   json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}

class StockLedger {
  final String id;
  final String productId;
  final int changeAmount;
  final String reason;
  final String? referenceId;
  final DateTime createdAt;

  StockLedger({
    required this.id,
    required this.productId,
    required this.changeAmount,
    required this.reason,
    this.referenceId,
    required this.createdAt,
  });

  factory StockLedger.fromJson(Map<String, dynamic> json) {
    return StockLedger(
      id:           json['id']?.toString() ?? '',
      productId:    json['product_id']?.toString() ?? '',
      changeAmount: json['change_amount'] ?? 0,
      reason:       json['reason'] ?? '',
      referenceId:  json['reference_id'],
      createdAt:    DateTime.parse(json['created_at']),
    );
  }
}
