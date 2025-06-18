import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

/// Abre la conexión a la base de datos SQLite local.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, 'competencia.db'));
    print('📂 Ruta de la base de datos: ${file.path}');
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Participants, Rounds, Pairings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -----------------------
  // Participantes
  // -----------------------

  Future<int> addParticipant(ParticipantsCompanion entry) =>
      into(participants).insert(entry);

  Future<List<Participant>> getAllParticipants() =>
      select(participants).get();

  Future<Participant> getParticipantById(int id) =>
      (select(participants)..where((t) => t.id.equals(id))).getSingle();

  // -----------------------
  // Rondas
  // -----------------------

  Future<int> createRound(int number) =>
      into(rounds).insert(RoundsCompanion(number: Value(number)));

  // -----------------------
  // Emparejamientos
  // -----------------------

  Future<int> insertPairing(PairingsCompanion entry) =>
      into(pairings).insert(entry);

  Future<List<Pairing>> getPairingsByRound(int roundId) =>
      (select(pairings)..where((t) => t.roundId.equals(roundId))).get();

  Future<void> setPairingTime(int pairingId, int seconds) {
    return (update(pairings)..where((tbl) => tbl.id.equals(pairingId)))
        .write(PairingsCompanion(timeSeconds: Value(seconds)));
  }

  Future<List<Pairing>> getAllRoundsForPair(int id1, int id2) {
    return (select(pairings)
          ..where((tbl) =>
              (tbl.participantHeadId.equals(id1) &
               tbl.participantHeelId.equals(id2)) |
              (tbl.participantHeadId.equals(id2) &
               tbl.participantHeelId.equals(id1))))
        .get();
  }

  Future<List<Pairing>> getPairingsByRoundAndShot(int roundId, int shotNumber) {
    return (select(pairings)
          ..where((tbl) =>
              tbl.roundId.equals(roundId) & tbl.shotNumber.equals(shotNumber)))
        .get();
  }

  Future<List<Pairing>> getShotsForParticipant(int participantId) {
    return (select(pairings)
          ..where((p) =>
              p.participantHeadId.equals(participantId) |
              p.participantHeelId.equals(participantId)))
        .get();
  }

  Future<List<Pairing>> getPairingsByPairAndShot(int id1, int id2, int shotNumber) {
    return (select(pairings)
          ..where((tbl) =>
              ((tbl.participantHeadId.equals(id1) &
                tbl.participantHeelId.equals(id2)) |
               (tbl.participantHeadId.equals(id2) &
                tbl.participantHeelId.equals(id1))) &
              tbl.shotNumber.equals(shotNumber)))
        .get();
  }

  Future<List<Pairing>> getPairingsByPairAndRoundAndShot(
      int id1, int id2, int roundId, int shotNumber) {
    return (select(pairings)
          ..where((tbl) =>
              ((tbl.participantHeadId.equals(id1) &
                tbl.participantHeelId.equals(id2)) |
               (tbl.participantHeadId.equals(id2) &
                tbl.participantHeelId.equals(id1))) &
              tbl.roundId.equals(roundId) &
              tbl.shotNumber.equals(shotNumber)))
        .get();
  }

  /// Marca como eliminados los emparejamientos individuales con tiempo 0.
  Future<void> marcarParejasEliminadasPorTiempoCero(int roundId) async {
    final pairings = await getPairingsByRound(roundId);

    for (final p in pairings) {
      if (p.timeSeconds == 0 && !p.isEliminated) {
        print('[⚠️ ELIMINADO] pairing ID ${p.id} en ronda $roundId');
        await (update(this.pairings)..where((tbl) => tbl.id.equals(p.id)))
            .write(PairingsCompanion(
              isEliminated: const Value(true),
              eliminatedInRoundId: Value(roundId),
            ));
      }
    }
  }

  /// Devuelve la primera ronda donde se eliminó esta pareja (en cualquier tiro).
  Future<int?> getRondaDeEliminacion(int headId, int heelId) async {
    final eliminadas = await (select(pairings)
          ..where((tbl) =>
              tbl.isEliminated.equals(true) &
              ((tbl.participantHeadId.equals(headId) &
                tbl.participantHeelId.equals(heelId)) |
               (tbl.participantHeadId.equals(heelId) &
                tbl.participantHeelId.equals(headId)))))
        .get();

    if (eliminadas.isEmpty) return null;

    eliminadas.sort((a, b) =>
        a.eliminatedInRoundId!.compareTo(b.eliminatedInRoundId!));
    return eliminadas.first.eliminatedInRoundId;
  }
}
