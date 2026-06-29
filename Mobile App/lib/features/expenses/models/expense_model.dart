// lib/features/expenses/models/expense_model.dart
class Expense {
  final String id;
  final String userId;
  final String teamId;
  final String? vendorId;
  final String? categoryId;
  final int?    invoiceId;     // FK → invoices.id (nullable — expense may be unlinked)
  final double amount;
  final String currencyCode;
  final DateTime date;
  final String? receiptUrl;
  final String? notes;
  final bool isRecurring;
  final DateTime createdAt;

  // Joined data
  final String? vendorName;
  final String? categoryName;
  final String? categoryColor;
  final String? invoiceNumber;  // Denormalized from invoices join for display

  Expense({
    required this.id,
    required this.userId,
    required this.teamId,
    this.vendorId,
    this.categoryId,
    this.invoiceId,
    required this.amount,
    this.currencyCode = 'USD',
    required this.date,
    this.receiptUrl,
    this.notes,
    this.isRecurring = false,
    required this.createdAt,
    this.vendorName,
    this.categoryName,
    this.categoryColor,
    this.invoiceNumber,
  });

  /// Whether this expense has been linked to a specific invoice/project.
  bool get isLinked => invoiceId != null;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id:            json['id']?.toString() ?? '',
      userId:        json['user_id'] ?? '',
      teamId:        json['team_id'] ?? '',
      vendorId:      json['vendor_id']?.toString(),
      categoryId:    json['category_id']?.toString(),
      invoiceId:     json['invoice_id'] != null ? int.tryParse(json['invoice_id'].toString()) : null,
      amount:        double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      currencyCode:  json['currency_code'] ?? 'USD',
      date:          DateTime.parse(json['expense_date']),
      receiptUrl:    json['receipt_url'],
      notes:         json['notes'],
      isRecurring:   json['is_recurring'] ?? false,
      createdAt:     DateTime.parse(json['created_at']),
      vendorName:    json['vendors']?['name'],
      categoryName:  json['expense_categories']?['name'],
      categoryColor: json['expense_categories']?['color'],
      invoiceNumber: json['invoices']?['invoice_number'],
    );
  }
}

class Vendor {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? category;

  Vendor({required this.id, required this.name, this.email, this.phone, this.category});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id:       json['id']?.toString() ?? '',
      name:     json['name'] ?? '',
      email:    json['email'],
      phone:    json['phone'],
      category: json['category'],
    );
  }
}

class ExpenseCategory {
  final String id;
  final String name;
  final String? icon;
  final String? color;

  ExpenseCategory({required this.id, required this.name, this.icon, this.color});

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id:    json['id']?.toString() ?? '',
      name:  json['name'] ?? '',
      icon:  json['icon'],
      color: json['color'],
    );
  }
}
