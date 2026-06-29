// lib/features/invoicing/models/invoice_type.dart
// All supported invoice types with display metadata.

enum InvoiceType {
  standard,
  proforma,
  commercial,
  progress,
  recurring,
  finalInvoice,
  creditMemo,
  debitMemo,
  mixed,
  estimate,
  quote,
}

extension InvoiceTypeExtension on InvoiceType {
  /// The value stored in the Supabase `invoice_type` column.
  String get dbValue {
    switch (this) {
      case InvoiceType.standard:     return 'standard';
      case InvoiceType.proforma:     return 'proforma';
      case InvoiceType.commercial:   return 'commercial';
      case InvoiceType.progress:     return 'progress';
      case InvoiceType.recurring:    return 'recurring';
      case InvoiceType.finalInvoice: return 'final';
      case InvoiceType.creditMemo:   return 'credit_memo';
      case InvoiceType.debitMemo:    return 'debit_memo';
      case InvoiceType.mixed:        return 'mixed';
      case InvoiceType.estimate:     return 'estimate';
      case InvoiceType.quote:        return 'quote';
    }
  }

  /// Human-readable display name.
  String get label {
    switch (this) {
      case InvoiceType.standard:     return 'Standard Invoice';
      case InvoiceType.proforma:     return 'Proforma Invoice';
      case InvoiceType.commercial:   return 'Commercial Invoice';
      case InvoiceType.progress:     return 'Progress Invoice';
      case InvoiceType.recurring:    return 'Recurring Invoice';
      case InvoiceType.finalInvoice: return 'Final Invoice';
      case InvoiceType.creditMemo:   return 'Credit Memo';
      case InvoiceType.debitMemo:    return 'Debit Memo';
      case InvoiceType.mixed:        return 'Mixed Invoice';
      case InvoiceType.estimate:     return 'Estimate';
      case InvoiceType.quote:        return 'Quote';
    }
  }

  /// Short description shown in the type selection carousel.
  String get description {
    switch (this) {
      case InvoiceType.standard:
        return 'A standard bill for completed goods or services.';
      case InvoiceType.proforma:
        return 'A preliminary quote before final billing. Not a legal doc.';
      case InvoiceType.commercial:
        return 'Used for international trade and customs clearance.';
      case InvoiceType.progress:
        return 'Bill for a portion of a larger project at a milestone.';
      case InvoiceType.recurring:
        return 'Automatically re-issues on a set schedule.';
      case InvoiceType.finalInvoice:
        return 'The last invoice for a project, closing all outstanding amounts.';
      case InvoiceType.creditMemo:
        return 'Issue a credit to reduce a client\'s outstanding balance.';
      case InvoiceType.debitMemo:
        return 'Increase the amount a client owes for additional charges.';
      case InvoiceType.mixed:
        return 'Combine credit and debit charges on a single invoice layout.';
      case InvoiceType.estimate:
        return 'A detailed list of costs for a project. Not a bill.';
      case InvoiceType.quote:
        return 'A fixed price offer that can be accepted by the client.';
    }
  }

  /// Parse a DB string back to enum.
  static InvoiceType fromDb(String? value) {
    switch (value) {
      case 'proforma':    return InvoiceType.proforma;
      case 'commercial':  return InvoiceType.commercial;
      case 'progress':    return InvoiceType.progress;
      case 'recurring':   return InvoiceType.recurring;
      case 'final':       return InvoiceType.finalInvoice;
      case 'credit_memo': return InvoiceType.creditMemo;
      case 'debit_memo':  return InvoiceType.debitMemo;
      case 'mixed':       return InvoiceType.mixed;
      case 'estimate':    return InvoiceType.estimate;
      case 'quote':       return InvoiceType.quote;
      default:            return InvoiceType.standard;
    }
  }
}
