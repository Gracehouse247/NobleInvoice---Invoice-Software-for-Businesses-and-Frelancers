// lib/features/invoicing/models/invoice_summary_model.dart

class InvoiceSummary {
  final double paid;
  final double outstanding;
  final int    totalCount;
  final double overdue;
  final double draft;
  final int    overdueCount;
  final int    pendingCount;

  InvoiceSummary({
    required this.paid,
    required this.outstanding,
    required this.totalCount,
    this.overdue = 0,
    this.draft   = 0,
    this.overdueCount = 0,
    this.pendingCount = 0,
  });

  double get total => paid + outstanding;

  factory InvoiceSummary.empty() => InvoiceSummary(
    paid: 0,
    outstanding: 0,
    totalCount: 0,
    overdue: 0,
    draft: 0,
    overdueCount: 0,
    pendingCount: 0,
  );
}
