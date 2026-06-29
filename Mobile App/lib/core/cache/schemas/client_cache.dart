// lib/core/cache/schemas/client_cache.dart
import 'package:isar/isar.dart';

part 'client_cache.g.dart';

@collection
class ClientCache {
  Id id = Isar.autoIncrement; // Local ID

  @Index(unique: true, replace: true)
  late int remoteId; // Supabase ID

  late String teamId;
  late String name;
  String? email;
  String? phone;
  String? address;
  String? country;
  String? currency;
  DateTime? updatedAt;
}
