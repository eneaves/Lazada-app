import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';

/// Proveedor global de la instancia de AppDatabase
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
