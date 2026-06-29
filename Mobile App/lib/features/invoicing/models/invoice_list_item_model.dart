// lib/features/invoicing/models/invoice_list_item_model.dart
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';

class InvoiceListItem {
  final int         id;
  final String      invoiceNumber;
  final String      clientName;
  final String      clientEmail;
  final String      status;
  final InvoiceType invoiceType;
  final String      issueDate;
  final String      dueDate;
  final double      totalAmount;
  final String      currencyCode;

  final String?     createdAt;
  final String?     teamId;
  final Map<String, dynamic> metadata;

  InvoiceListItem({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.clientEmail,
    required this.status,
    this.invoiceType = InvoiceType.standard,
    required this.issueDate,
    required this.dueDate,
    required this.totalAmount,
    this.currencyCode = 'USD',
    this.createdAt,
    this.teamId,
    this.metadata = const {},
  });

  factory InvoiceListItem.fromJson(Map<String, dynamic> json) {
    final clientData = json['clients'] as Map<String, dynamic>? ?? {};
    return InvoiceListItem(
      id:            json['id'] as int,
      invoiceNumber: json['invoice_number'] as String? ?? '',
      clientName:    (json['client_name'] as String?) ?? (clientData['name'] as String?) ?? 'Unknown Client',
      clientEmail:   (json['client_email'] as String?) ?? (clientData['email'] as String?) ?? '',
      status:        json['status'] as String? ?? 'draft',
      invoiceType:   InvoiceTypeExtension.fromDb(json['invoice_type'] as String?),
      issueDate:     json['issue_date'] as String? ?? '',
      dueDate:       json['due_date'] as String? ?? '',
      totalAmount:   double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      currencyCode:  json['currency_code'] as String? ?? 'USD',
      createdAt:     json['created_at'] as String?,
      teamId:        json['team_id']?.toString(),
      metadata:      json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}
