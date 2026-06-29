// lib/features/invoicing/controllers/invoice_operations.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/invoicing/controllers/invoice_controller.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_details_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_item_model.dart';
import 'package:noble_invoice/features/invoicing/models/invoice_type.dart';
import 'package:noble_invoice/features/invoicing/services/invoice_ledger_service.dart';
import 'package:noble_invoice/features/wallet/controllers/subscription_controller.dart';

/// Extension to keep InvoiceController under 600 lines.
/// Contains all mutation logic (Create, Update, Delete, Convert).
extension InvoiceOperations on InvoiceController {
  
  // ── Invoice Creation ───────────────────────────────────────────────────────────
  Future<bool> createInvoice(InvoiceCreatePayload payload, SubscriptionController sub) async {
    final limitMsg = sub.checkCreateLimit('invoices');
    if (limitMsg != null) {
      setError('SUBSCRIPTION_LIMIT: $limitMsg');
      return false;
    }

    setSaving(true);
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');

      final ts = DateTime.now();
      final num = _generateInvoiceNumber(payload.metadata['custom_prefix']?.toString(), ts);

      final List<InvoiceItem> finalItems = List.from(payload.items);
      Map<String, dynamic> finalMetadata = Map.from(payload.metadata ?? {});
      
      if (finalMetadata['pass_fees'] == true) {
        final subtotalBefore = finalItems.fold<double>(0, (s, i) => s + (i.quantity * i.unitPrice));
        final fee = subtotalBefore * 0.038;
        if (fee > 0) {
          finalItems.add(InvoiceItem(description: 'Payment Processing Fee (3.8%)', quantity: 1, unitPrice: fee));
        }
      }

      final financials = _calculateFinancials(finalItems, payload.taxType, payload.taxRate, payload.discountType, payload.discountValue);

      if (payload.invoiceType == InvoiceType.recurring) {
        final frequency = finalMetadata['frequency'] ?? 'Monthly';
        finalMetadata['next_generation_date'] = calculateNextDate(ts, frequency);
      }

      final invoiceRes = await SupabaseService.client.from('invoices').insert({
        'team_id':        activeTeamId,
        'user_id':        userId,
        'client_id':      payload.clientId,
        'invoice_number': num,
        'invoice_type':   payload.invoiceType.dbValue,
        'issue_date':     ts.toIso8601String().split('T')[0],
        'due_date':       payload.dueDate.toIso8601String().split('T')[0],
        'notes':          payload.notes,
        'status':         payload.status,
        'currency_code':  payload.currencyCode,
        'tax_rate':       payload.taxRate,
        'tax_type':       payload.taxType,
        'tax_amount':     financials.taxAmount,
        'discount_type':  payload.discountType,
        'discount_value': payload.discountValue,
        'discount_amount': financials.discountAmount,
        'subtotal':       financials.subtotal,
        'total_amount':   financials.totalAmount,
        'metadata':       { ...finalMetadata, 'was_premium': sub.isPulseOrElite },
      }).select('id').single();

      await sub.trackUsage('invoices');
      final invoiceId = (invoiceRes)['id'] as int;

      if (finalMetadata['enable_flutterwave'] == true) {
        await _invokePaymentLink(invoiceId);
      }

      await SupabaseService.client.from('invoice_items').insert(
        finalItems.map((i) => {
          'invoice_id':  invoiceId,
          'description': i.description,
          'quantity':    i.quantity,
          'unit_price':  i.unitPrice,
          'total':       i.quantity * i.unitPrice,
        }).toList(),
      );

      if (payload.status != 'draft') {
        await InvoiceLedgerService.deductStock(teamId: activeTeamId, invoiceId: invoiceId, items: finalItems);
        await InvoiceLedgerService.updateClientLedger(
          teamId:    activeTeamId,
          invoiceId: invoiceId,
          clientId:  payload.clientId,
          amount:    payload.invoiceType == InvoiceType.creditMemo ? -financials.totalAmount : financials.totalAmount,
          type:      payload.invoiceType == InvoiceType.creditMemo ? 'credit_memo' : 'invoice',
        );
      }

      await loadDashboard();
      return true;
    } catch (e) {
      setError(parseError(e));
      return false;
    } finally {
      setSaving(false);
    }
  }

  // ── Invoice Update ──────────────────────────────────────────────────────────
  Future<bool> updateInvoice(int invoiceId, InvoiceCreatePayload payload, SubscriptionController sub) async {
    final limitMsg = sub.checkEditLimit('invoices');
    if (limitMsg != null) {
      setError('SUBSCRIPTION_LIMIT: $limitMsg');
      return false;
    }

    setSaving(true);
    try {
      final oldRes = await SupabaseService.client.from('invoices').select('status, client_id').eq('id', invoiceId).single();
      if (InvoiceLedgerService.isActiveStatus(oldRes['status'])) {
        final oldItemsRes = await SupabaseService.client.from('invoice_items').select('*').eq('invoice_id', invoiceId);
        final oldItems = (oldItemsRes as List).map((j) => InvoiceItem.fromJson(j)).toList();
        await InvoiceLedgerService.restockItems(teamId: activeTeamId, invoiceId: invoiceId, items: oldItems, reason: 'Invoice Updated');
        await InvoiceLedgerService.reverseLedgerEntry(teamId: activeTeamId, invoiceId: invoiceId);
      }

      final financials = _calculateFinancials(payload.items, payload.taxType, payload.taxRate, payload.discountType, payload.discountValue);

      await SupabaseService.client.from('invoices').update({
        'client_id':      payload.clientId,
        'invoice_type':   payload.invoiceType.dbValue,
        'due_date':       payload.dueDate.toIso8601String().split('T')[0],
        'notes':          payload.notes,
        'status':         payload.status,
        'currency_code':  payload.currencyCode,
        'tax_rate':       payload.taxRate,
        'tax_type':       payload.taxType,
        'tax_amount':     financials.taxAmount,
        'discount_type':  payload.discountType,
        'discount_value': payload.discountValue,
        'discount_amount': financials.discountAmount,
        'subtotal':       financials.subtotal,
        'total_amount':   financials.totalAmount,
        'metadata':       payload.metadata,
      }).eq('id', invoiceId);

      await sub.trackUsage('invoices', isEdit: true);
      await SupabaseService.client.from('invoice_items').delete().eq('invoice_id', invoiceId);
      await SupabaseService.client.from('invoice_items').insert(
        payload.items.map((i) => {
          'invoice_id':  invoiceId,
          'description': i.description,
          'quantity':    i.quantity,
          'unit_price':  i.unitPrice,
          'total':       i.quantity * i.unitPrice,
        }).toList(),
      );

      if (InvoiceLedgerService.isActiveStatus(payload.status)) {
        await InvoiceLedgerService.deductStock(teamId: activeTeamId, invoiceId: invoiceId, items: payload.items);
        await InvoiceLedgerService.updateClientLedger(
          teamId:    activeTeamId,
          invoiceId: invoiceId,
          clientId:  payload.clientId,
          amount:    payload.invoiceType == InvoiceType.creditMemo ? -financials.totalAmount : financials.totalAmount,
          type:      payload.invoiceType == InvoiceType.creditMemo ? 'credit_memo' : 'invoice',
        );
      }

      await loadDashboard();
      return true;
    } catch (e) {
      setError(parseError(e));
      return false;
    } finally {
      setSaving(false);
    }
  }

  // ── Convert Estimate to Invoice ──────────────────────────────────────────────
  Future<bool> convertToInvoice(int estimateId, SubscriptionController sub) async {
    setSaving(true);
    try {
      final res = await SupabaseService.client.from('invoices').select('*, clients(*), invoice_items(*)').eq('id', estimateId).single();
      final estimate = InvoiceDetails.fromJson(res);
      
      final payload = InvoiceCreatePayload(
        clientId:      estimate.client.id,
        items:         estimate.items,
        dueDate:       DateTime.now().add(const Duration(days: 14)),
        notes:         estimate.notes,
        status:        'pending',
        invoiceType:   InvoiceType.standard,
        taxRate:       estimate.taxRate,
        taxType:       estimate.taxType,
        discountType:  estimate.discountType,
        discountValue: estimate.discountValue,
        currencyCode:  estimate.currencyCode ?? 'USD',
        metadata:      { ...estimate.metadata, 'converted_from': estimateId, 'conversion_date': DateTime.now().toIso8601String() },
      );
      
      final success = await createInvoice(payload, sub);
      if (success) {
        await SupabaseService.client.from('invoices').update({'status': 'accepted'}).eq('id', estimateId);
      }
      return success;
    } catch (e) {
      setError(parseError(e));
      return false;
    } finally {
      setSaving(false);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String _generateInvoiceNumber(String? prefix, DateTime ts) {
    final pre = prefix ?? 'NGO';
    final suffix = (ts.millisecondsSinceEpoch % 9000 + 1000).toString();
    return '$pre-${ts.year}${ts.month.toString().padLeft(2,'0')}${ts.day.toString().padLeft(2,'0')}-$suffix';
  }

  _Financials _calculateFinancials(List<InvoiceItem> items, String taxType, double taxRate, String discType, double discVal) {
    final subtotal = items.fold<double>(0, (s, i) => s + (i.quantity * i.unitPrice));
    final discAmt  = discType == 'flat' ? discVal : discType == 'percentage' ? subtotal * (discVal / 100) : 0.0;
    final taxable  = subtotal - discAmt;
    final taxAmt   = taxType == 'exclusive' ? taxable * (taxRate / 100) : taxable - (taxable / (1 + taxRate / 100));
    return _Financials(subtotal, discAmt, taxAmt, taxType == 'exclusive' ? taxable + taxAmt : taxable);
  }

  Future<void> _invokePaymentLink(int id) async {
    try {
      await SupabaseService.client.functions.invoke('create-flutterwave-payment', body: { 'invoice_id': id });
    } catch (e) {
      debugPrint('Payment link error: $e');
    }
  }
}

class _Financials {
  final double subtotal, discountAmount, taxAmount, totalAmount;
  _Financials(this.subtotal, this.discountAmount, this.taxAmount, this.totalAmount);
}
