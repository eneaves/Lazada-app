import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../data/database.dart';
import '../data/tables.dart';

/// StateNotifier que gestiona la lista de participantes.
class ParticipantsNotifier extends StateNotifier<AsyncValue<List<Participant>>> {
  ParticipantsNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadAll();
  }

  final Ref ref;

  Future<void> _loadAll() async {
    try {
      final db = ref.read(databaseProvider);
      final list = await db.getAllParticipants();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Agrega un participante y recarga la lista.
  Future<void> add({
    required String firstName,
    required String lastName,
    required Role role,
    String? email,
  }) async {
    state = const AsyncValue.loading();
    try {
      final db = ref.read(databaseProvider);
      await db.addParticipant(
        ParticipantsCompanion.insert(
          firstName: firstName,
          lastName: lastName,
          role: role,
          email: Value(email),
        ),
      );
      await _loadAll();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Elimina todos los participantes y recarga la lista.
  Future<void> clearAll() async {
    state = const AsyncValue.loading();
    try {
      final db = ref.read(databaseProvider);
      await db.delete(db.participants).go();
      await _loadAll();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider público de la lista de participantes.
final participantsProvider =
    StateNotifierProvider<ParticipantsNotifier, AsyncValue<List<Participant>>>(
  (ref) => ParticipantsNotifier(ref),
);
