// lib/core/cache/schemas/invoice_cache.dart
import 'package:isar/isar.dart';

part 'invoice_cache.g.dart';

@collection
class InvoiceCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int remoteId;

  late String teamId;
  late String invoiceNumber;
  late String clientName;
  late String status;
  late String type;
  late DateTime issueDate;
  late DateTime dueDate;
  late double totalAmount;
  late String currencyCode;
  
  String? notes;
  DateTime? updatedAt;
}
