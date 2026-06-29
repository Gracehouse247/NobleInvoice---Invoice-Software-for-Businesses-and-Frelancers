// lib/features/invoicing/models/invoice_details_model.dart
import 'package:noble_invoice/features/invoicing/models/client_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';

class InvoiceDetails {
  final int             id;
  final String          invoiceNumber;
  final Client          client;
  final List<InvoiceItem> items;
  final String          status;
  final InvoiceType     invoiceType;
  final String          issueDate;
  final String          dueDate;
  final String?         notes;
  final double          subtotal;
  final double          taxRate;
  final String          taxType;         // 'inclusive' | 'exclusive'
  final double          taxAmount;
  final String          discountType;    // 'none' | 'flat' | 'percentage'
  final double          discountValue;
  final double          discountAmount;
  final double          totalAmount;
  final String?         currencyCode;
  final String?         openedAt;
  final int             viewCount;
  final String?         trackingToken;
  final Map<String, dynamic> metadata;

  InvoiceDetails({
    required this.id,
    required this.invoiceNumber,
    required this.client,
    required this.items,
    required this.status,
    this.invoiceType    = InvoiceType.standard,
    required this.issueDate,
    required this.dueDate,
    this.notes,
    this.subtotal       = 0,
    this.taxRate        = 0,
    this.taxType        = 'exclusive',
    this.taxAmount      = 0,
    this.discountType   = 'none',
    this.discountValue  = 0,
    this.discountAmount = 0,
    required this.totalAmount,
    this.currencyCode   = 'USD',
    this.openedAt,
    this.viewCount      = 0,
    this.trackingToken,
    this.metadata       = const {},
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    final clientData = (json['client'] ?? json['clients']) as Map<String, dynamic>? ?? {};
    final itemsData  = (json['items'] as List?) ?? (json['invoice_items'] as List?) ?? [];

    return InvoiceDetails(
      id:             json['id'] as int? ?? 0,
      invoiceNumber:  json['invoice_number'] as String? ?? 'Unknown',
      client:         Client.fromJson(clientData),
      items:          itemsData.map((i) => InvoiceItem.fromJson(i as Map<String, dynamic>)).toList(),
      status:         json['status'] as String? ?? 'draft',
      invoiceType:    InvoiceTypeExtension.fromDb(json['invoice_type'] as String?),
      issueDate:      json['issue_date'] as String? ?? '',
      dueDate:        json['due_date'] as String? ?? '',
      notes:          json['notes'] as String?,
      subtotal:       double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0,
      taxRate:        double.tryParse(json['tax_rate']?.toString() ?? '0') ?? 0,
      taxType:        json['tax_type'] as String? ?? 'exclusive',
      taxAmount:      double.tryParse(json['tax_amount']?.toString() ?? '0') ?? 0,
      discountType:   json['discount_type'] as String? ?? 'none',
      discountValue:  double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0,
      discountAmount: double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0,
      totalAmount:    double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      currencyCode:   json['currency_code'] as String? ?? 'USD',
      openedAt:       json['opened_at'] as String?,
      viewCount:      json['view_count'] as int? ?? 0,
      trackingToken:  json['tracking_token'] as String?,
      metadata:       json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}
