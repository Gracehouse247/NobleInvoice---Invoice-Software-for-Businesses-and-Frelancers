// lib/core/cache/isar_service.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:noble_invoice/core/cache/schemas/client_cache.dart';
import 'package:noble_invoice/core/cache/schemas/invoice_cache.dart';

class IsarService {
  static Isar? _instance;

  static Future<Isar> get instance async {
    if (_instance != null) return _instance!;
    
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [ClientCacheSchema, InvoiceCacheSchema],
      directory: dir.path,
      inspector: true, // Useful for debugging in dev
    );
    return _instance!;
  }

  // ── Client Caching ─────────────────────────────────────────────────────────
  static Future<void> cacheClients(List<ClientCache> clients) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.clientCaches.putAll(clients);
    });
  }

  static Future<List<ClientCache>> getCachedClients(String teamId) async {
    final isar = await instance;
    return await isar.clientCaches.filter().teamIdEqualTo(teamId).findAll();
  }

  // ── Invoice Caching ────────────────────────────────────────────────────────
  static Future<void> cacheInvoices(List<InvoiceCache> invoices) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.invoiceCaches.putAll(invoices);
    });
  }

  static Future<List<InvoiceCache>> getCachedInvoices(String teamId) async {
    final isar = await instance;
    return await isar.invoiceCaches.filter().teamIdEqualTo(teamId).sortByIssueDateDesc().findAll();
  }

  static Future<void> clearAll() async {
    final isar = await instance;
    await isar.writeTxn(() => isar.clear());
  }
}
