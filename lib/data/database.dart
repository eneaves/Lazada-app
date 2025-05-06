// lib/data/database.dart

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
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Participants, Rounds, Pairings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -----------------------
  // Métodos de acceso a BD
  // -----------------------

  // Participantes
  Future<int> addParticipant(ParticipantsCompanion entry) =>
      into(participants).insert(entry);

  Future<List<Participant>> getAllParticipants() =>
      select(participants).get();

  Future<Participant> getParticipantById(int id) =>
      (select(participants)..where((t) => t.id.equals(id))).getSingle();

  // Rondas
  Future<int> createRound(int number) =>
      into(rounds).insert(RoundsCompanion(number: Value(number)));

  // Emparejamientos
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
            (tbl.participantHeadId.equals(id1) & tbl.participantHeelId.equals(id2)) |
            (tbl.participantHeadId.equals(id2) & tbl.participantHeelId.equals(id1))))
      .get();
}


}
