class InvoiceItem {
  final int? id;
  final String? productId; // Link to Catalog
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem({
    this.id,
    this.productId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json['id'],
    productId: json['product_id']?.toString(),
    description: json['description'] ?? '',
    quantity: json['quantity'] ?? 1,
    unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'product_id':  productId,
    'description': description,
    'quantity':    quantity,
    'unit_price':  unitPrice,
  };

  InvoiceItem copyWith({
    int? id,
    String? productId,
    String? description,
    int? quantity,
    double? unitPrice,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
