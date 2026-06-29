// lib/features/expenses/controllers/expense_controller.dart
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/features/expenses/models/expense_model.dart';

class ExpenseController extends ChangeNotifier {
  bool _loading = false;
  String _error = '';

  List<Expense>         _expenses    = [];
  List<Vendor>          _vendors     = [];
  List<ExpenseCategory> _categories  = [];
  String?               _activeTeamId;

  void setActiveTeamId(String? id) {
    _activeTeamId = id;
    notifyListeners();
  }

  bool          get isLoading   => _loading;
  String        get error       => _error;
  List<Expense> get expenses    => _expenses;
  List<Vendor>  get vendors     => _vendors;
  List<ExpenseCategory> get categories => _categories;

  String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    return e.toString();
  }

  // ── Fetching Logic ─────────────────────────────────────────────────────────

  Future<void> loadAll() async {
    _loading = true;
    _error   = '';
    notifyListeners();

    try {
      if (_activeTeamId == null) throw Exception('No active team selected.');

      // 1. Fetch Categories (System: user_id IS NULL + User specific)
      final catRes = await SupabaseService.client
          .from('expense_categories')
          .select('*')
          .or('user_id.is.null,user_id.eq.${SupabaseService.currentUser?.id}')
          .order('name');
      _categories = (catRes as List).map((j) => ExpenseCategory.fromJson(j)).toList();
      
      // Seed defaults if table is totally empty (Failsafe)
      if (_categories.isEmpty) {
        final defaults = [
          {'name': 'Marketing', 'color': '#3B82F6', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Transport', 'color': '#F59E0B', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Utilities', 'color': '#10B981', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Salaries', 'color': '#6366F1', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Rent', 'color': '#EF4444', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Inventory', 'color': '#8B5CF6', 'user_id': SupabaseService.currentUser?.id},
          {'name': 'Other', 'color': '#6B7280', 'user_id': SupabaseService.currentUser?.id},
        ];
        await SupabaseService.client.from('expense_categories').insert(defaults);
        final retryRes = await SupabaseService.client
            .from('expense_categories')
            .select('*')
            .or('user_id.is.null,user_id.eq.${SupabaseService.currentUser?.id}')
            .order('name');
        _categories = (retryRes as List).map((j) => ExpenseCategory.fromJson(j)).toList();
      }

      // 2. Fetch Vendors
      final venRes = await SupabaseService.client
          .from('vendors')
          .select('*')
          .eq('team_id', _activeTeamId!)
          .order('name');
      _vendors = (venRes as List).map((j) => Vendor.fromJson(j)).toList();

      // 3. Fetch Expenses (Joined — includes linked invoice number)
      dynamic expRes;
      try {
        expRes = await SupabaseService.client
            .from('expenses')
            .select('*, vendors(name), expense_categories(name, color), invoices(invoice_number)')
            .eq('team_id', _activeTeamId!)
            .order('expense_date', ascending: false);
      } catch (e) {
        if (e.toString().contains('category_id') || e.toString().contains('column')) {
          // Fallback for old schema (no team_id, no joined categories)
          expRes = await SupabaseService.client
              .from('expenses')
              .select('*')
              .eq('user_id', SupabaseService.currentUser?.id ?? '')
              .order('expense_date', ascending: false);
        } else {
          rethrow;
        }
      }
      _expenses = (expRes as List).map((j) => Expense.fromJson(j)).toList();

    } catch (e) {
      _error = _parseError(e);
    }

    _loading = false;
    notifyListeners();
  }

  // ── Create Logic ──────────────────────────────────────────────────────────

  // ── Load expenses for a specific invoice (for Project Costs section) ─────

  /// Returns expenses linked to [invoiceId]. Does NOT call notifyListeners —
  /// callers manage their own state (avoids disrupting the global expense list).
  Future<List<Expense>> loadExpensesForInvoice(int invoiceId) async {
    try {
      final res = await SupabaseService.client
          .from('expenses')
          .select('*, vendors(name), expense_categories(name, color), invoices(invoice_number)')
          .eq('invoice_id', invoiceId)
          .order('expense_date', ascending: false);
      return (res as List).map((j) => Expense.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  // ── Create Logic ──────────────────────────────────────────────────────────

  Future<bool> addExpense({
    required double amount,
    required String categoryId,
    String? vendorId,
    int?    invoiceId,   // Optional: links this expense to a project/invoice
    required DateTime date,
    required String currency,
    String? notes,
    File? receiptFile,
  }) async {
    _loading = true;
    _error   = '';
    notifyListeners();

    try {
      if (_activeTeamId == null) throw Exception('No active team selected.');

      String? receiptUrl;
      if (receiptFile != null) {
        receiptUrl = await _uploadReceipt(_activeTeamId!, receiptFile);
      }

      try {
        await SupabaseService.client.from('expenses').insert({
          'team_id':      _activeTeamId!,
          'user_id':      SupabaseService.currentUser?.id,
          'amount':       amount,
          'category_id':  int.tryParse(categoryId.toString()),
          'vendor_id':    vendorId != null ? int.tryParse(vendorId.toString()) : null,
          'invoice_id':   invoiceId, // nullable — null = unlinked general expense
          'expense_date': date.toIso8601String().split('T')[0],
          'currency_code': currency,
          'receipt_url':  receiptUrl,
          'notes':        notes,
        });
      } catch (e) {
        if (e.toString().contains('category_id') || e.toString().contains('column')) {
          // Legacy Schema Fallback
          final categoryName = categories.firstWhereOrNull((c) => c.id.toString() == categoryId.toString())?.name ?? 'General';
          await SupabaseService.client.from('expenses').insert({
            'user_id':      SupabaseService.currentUser?.id,
            'amount':      amount,
            'category':    categoryName,
            'expense_date': date.toIso8601String().split('T')[0],
            'notes':        '${notes ?? ''} (Legacy Mode)'.trim(),
          });
        } else {
          rethrow;
        }
      }

      await loadAll(); // Refresh list
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<String?> _uploadReceipt(String userId, File file) async {
    final ext      = file.path.split('.').last;
    final fileName = 'receipt_${DateTime.now().millisecondsSinceEpoch}.$ext';
    final filePath = '$userId/$fileName';

    await SupabaseService.client.storage
        .from('receipts')
        .upload(filePath, file);

    return SupabaseService.client.storage
        .from('receipts')
        .getPublicUrl(filePath);
  }

  // ── Vendor Logic ──────────────────────────────────────────────────────────

  Future<Vendor?> addVendor(String name, {String? category}) async {
    try {
      if (_activeTeamId == null) throw Exception('No active team selected.');

      final res = await SupabaseService.client.from('vendors').insert({
        'team_id':  _activeTeamId!,
        'user_id':  SupabaseService.currentUser?.id,
        'name':     name,
        'category': category,
      }).select().single();

      final newVendor = Vendor.fromJson(res);
      // Direct Injection to prevent 'Unknown Vendor' lag
      if (!_vendors.any((v) => v.id == newVendor.id)) {
        _vendors.add(newVendor);
      }
      notifyListeners();
      
      await loadAll(); // Final sync in background
      return newVendor;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await SupabaseService.client.from('expenses').delete().eq('id', id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
    }
  }
}
