// lib/features/invoicing/services/invoice_ledger_service.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';

/// Handles all stock ledger and client balance ledger operations.
/// Extracted from InvoiceController to maintain single responsibility principle.
class InvoiceLedgerService {
  static bool isActiveStatus(String status) =>
      status == 'paid' || status == 'pending' || status == 'overdue';

  // ── Stock Management ─────────────────────────────────────────────────────────

  static Future<void> deductStock({
    required String? teamId,
    required int invoiceId,
    required List<InvoiceItem> items,
  }) async {
    try {
      final entries = items
          .where((i) => i.productId != null)
          .map((i) => {
            'team_id':       teamId,
            'product_id':    int.parse(i.productId!),
            'change_amount': -i.quantity,
            'reason':        'Invoice Sale',
            'reference_id':  invoiceId.toString(),
          })
          .toList();
      if (entries.isNotEmpty) {
        await SupabaseService.client.from('stock_ledger').insert(entries);
      }
    } catch (e) {
      debugPrint('Stock deduction failed: $e');
    }
  }

  static Future<void> restockItems({
    required String? teamId,
    required int invoiceId,
    required List<InvoiceItem> items,
    required String reason,
  }) async {
    try {
      final entries = items
          .where((i) => i.productId != null)
          .map((i) => {
            'team_id':       teamId,
            'product_id':    int.parse(i.productId!),
            'change_amount': i.quantity,
            'reason':        reason,
            'reference_id':  invoiceId.toString(),
          })
          .toList();
      if (entries.isNotEmpty) {
        await SupabaseService.client.from('stock_ledger').insert(entries);
      }
    } catch (e) {
      debugPrint('Stock restocking failed: $e');
    }
  }

  // ── Client Ledger (Balance Tracking) ─────────────────────────────────────────

  static Future<void> updateClientLedger({
    required String? teamId,
    required int invoiceId,
    required int clientId,
    required double amount,
    required String type,
  }) async {
    try {
      final clientRes = await SupabaseService.client
          .from('clients').select('current_balance').eq('id', clientId).single();
      final before = (clientRes['current_balance'] as num?)?.toDouble() ?? 0.0;
      await SupabaseService.client.from('client_ledger').insert({
        'team_id':          teamId,
        'client_id':        clientId,
        'invoice_id':       invoiceId,
        'transaction_type': type,
        'amount':           amount,
        'balance_before':   before,
        'balance_after':    before + amount,
      });
    } catch (e) {
      debugPrint('Client ledger update failed: $e');
    }
  }

  static Future<void> reverseLedgerEntry({
    required String? teamId,
    required int invoiceId,
  }) async {
    try {
      final res = await SupabaseService.client
          .from('client_ledger')
          .select('*')
          .eq('invoice_id', invoiceId)
          .order('created_at', ascending: false)
          .limit(1);
      if ((res as List).isNotEmpty) {
        final last           = res.first;
        final amountToReverse = -(last['amount'] as num).toDouble();
        await updateClientLedger(
          teamId:    teamId,
          invoiceId: invoiceId,
          clientId:  last['client_id'],
          amount:    amountToReverse,
          type:      'reversal',
        );
      }
    } catch (e) {
      debugPrint('Ledger reversal failed: $e');
    }
  }
}
