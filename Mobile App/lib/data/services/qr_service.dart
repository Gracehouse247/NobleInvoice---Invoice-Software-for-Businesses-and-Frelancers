import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:noble_invoice/core/services/supabase_service.dart';
import 'package:noble_invoice/data/models/qr_code_model.dart';
import 'package:noble_invoice/data/models/folder_model.dart';

class QrService {
  static String _parseError(dynamic e) {
    if (e is PostgrestException) return e.message;
    if (e is AuthException) return e.message;
    if (e is StorageException) return e.message;
    return e.toString();
  }

  /// Fetch all QR codes for the current user.
  static Future<List<QrCode>> getQrCodes({String? teamId}) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Unauthorized');
      
      var query = SupabaseService.client
          .from('qr_codes')
          .select('*')
          .eq('user_id', userId);
          
      if (teamId != null) {
        query = query.eq('team_id', teamId);
      }

      final data = await query.order('created_at', ascending: false);
          
      return data.map((m) => QrCode.fromMap(m)).toList();
    } catch (e) {
      throw _parseError(e);
    }
  }

  /// Save a new QR code metadata to the database.
  static Future<String> saveQrCode(QrCode qrCode) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      final map = qrCode.toMap();
      map['user_id'] = userId;
      
      final res = await SupabaseService.client
          .from('qr_codes')
          .upsert(map)
          .select('id')
          .single();
          
      return res['id']?.toString() ?? '';
    } catch (e) {
      throw _parseError(e);
    }
  }

  /// Upload an asset (PDF, MP3, Image) for a QR code.
  static Future<Map<String, dynamic>> uploadAsset(File file) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final path = '$userId/$fileName';

      await SupabaseService.client.storage.from('qr_assets').upload(path, file);
      
      // Get public URL
      final publicUrl = SupabaseService.client.storage.from('qr_assets').getPublicUrl(path);
      
      return {'url': publicUrl};
    } catch (e) {
      throw _parseError(e);
    }
  }

  /// Delete a QR code.
  static Future<void> deleteQrCode(String id) async {
    try {
      await SupabaseService.client.from('qr_codes').delete().eq('id', id);
    } catch (e) {
      throw _parseError(e);
    }
  }

  // ── Folders ────────────────────────────────────────────────────────────────

  static Future<List<Folder>> getFolders() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      final data = await SupabaseService.client
          .from('folders')
          .select('*')
          .eq('user_id', userId!);
          
      return data.map((m) => Folder.fromMap(m)).toList();
    } catch (e) {
      throw _parseError(e);
    }
  }

  static Future<Folder> createFolder(String name, {String? iconName}) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      final res = await SupabaseService.client.from('folders').insert({
        'user_id': userId,
        'name': name,
        'icon_name': iconName,
      }).select().single();
      
      return Folder.fromMap(res);
    } catch (e) {
      throw _parseError(e);
    }
  }

  static Future<void> deleteFolder(String id) async {
    try {
      await SupabaseService.client.from('folders').delete().eq('id', id);
    } catch (e) {
      throw _parseError(e);
    }
  }
}
