import 'dart:math';
import 'package:drift/drift.dart';
import '../data/database.dart';
import '../data/tables.dart';

class PairingService {
  final AppDatabase db;
  final Random _rand = Random();

  int? _lastRepeatedParticipantId;
  int? _currentRepeatedParticipantId;

  PairingService(this.db);

  bool _involves(int id, PairingsCompanion? p) {
    if (p == null) return false;
    return p.participantHeadId.value == id || p.participantHeelId.value == id;
  }

  void _separateRepeatedParticipant(List<PairingsCompanion> list, int repeatedId) {
    int lastSeenIndex = -2;
    for (int i = 0; i < list.length; i++) {
      final hasRepeated = _involves(repeatedId, list[i]);
      if (hasRepeated) {
        if (i - lastSeenIndex == 1) {
          for (int j = i + 1; j < list.length; j++) {
            final before = j > 0 ? list[j - 1] : null;
            final after = j + 1 < list.length ? list[j + 1] : null;
            if (!_involves(repeatedId, list[j]) &&
                !_involves(repeatedId, before) &&
                !_involves(repeatedId, after)) {
              final temp = list[i];
              list[i] = list[j];
              list[j] = temp;
              lastSeenIndex = j;
              break;
            }
          }
        } else {
          lastSeenIndex = i;
        }
      }
    }
  }

  Future<void> generateInitialPairings(int roundId, int shotsPerRound) async {
    final all = await db.getAllParticipants();

    for (int shot = 1; shot <= shotsPerRound; shot++) {
      final heads = all.where((p) => p.role == Role.head).toList();
      final heels = all.where((p) => p.role == Role.heel).toList();
      heads.shuffle(_rand);
      heels.shuffle(_rand);

      final n = min(heads.length, heels.length);
      final usedIds = <int>{};
      final List<PairingsCompanion> pairings = [];

      for (int i = 0; i < n; i++) {
        final head = heads[i];
        final heel = heels[i];
        if (head.id == heel.id) continue;

        usedIds.addAll([head.id, heel.id]);

        pairings.add(PairingsCompanion(
          roundId: Value(roundId),
          participantHeadId: Value(head.id),
          participantHeelId: Value(heel.id),
          timeSeconds: const Value(0),
          shotNumber: Value(shot),
        ));
      }

      final total = heads.length + heels.length;
      if (total % 2 != 0) {
        final allIds = all.map((p) => p.id).toSet();
        final remaining = allIds.difference(usedIds).toList();

        if (remaining.isNotEmpty) {
          final selectedId = remaining.first;
          final selectedParticipant = all.firstWhere((p) => p.id == selectedId);
          final selectedRole = selectedParticipant.role;

          final validPartners = all.where((p) =>
              p.id != selectedId &&
              p.role != selectedRole &&
              !pairings.any((pair) =>
                  (pair.participantHeadId.value == selectedId &&
                      pair.participantHeelId.value == p.id) ||
                  (pair.participantHeelId.value == selectedId &&
                      pair.participantHeadId.value == p.id))).toList();

          if (validPartners.isNotEmpty) {
            final partner = validPartners[_rand.nextInt(validPartners.length)];
            if (selectedId == partner.id) return;

            _currentRepeatedParticipantId = selectedId;

            final extraPair = PairingsCompanion(
              roundId: Value(roundId),
              participantHeadId:
                  Value(selectedRole == Role.head ? selectedId : partner.id),
              participantHeelId:
                  Value(selectedRole == Role.heel ? selectedId : partner.id),
              timeSeconds: const Value(0),
              shotNumber: Value(shot),
            );

            pairings.add(extraPair);
            _separateRepeatedParticipant(pairings, selectedId);
          }
        }
      }

      for (final p in pairings) {
        await db.insertPairing(p);
      }
    }

    _lastRepeatedParticipantId = _currentRepeatedParticipantId;
  }

  Future<void> generateNextRoundPairings(int firstRoundId, int newRoundId, int shotsPerRound) async {
    for (int shot = 1; shot <= shotsPerRound; shot++) {
      // Traer las parejas originales del tiro desde la primera ronda
      final originalPairs = await db.getPairingsByRoundAndShot(firstRoundId, shot);

      final List<PairingsCompanion> inserted = [];

      for (final pair in originalPairs) {
        // Revisar si esta pareja fue eliminada en este tiro en alguna ronda anterior
        final historial = await db.getPairingsByPairAndShot(
          pair.participantHeadId,
          pair.participantHeelId,
          shot,
        );

        final fueEliminada = historial.any((p) => p.isEliminated);

        if (fueEliminada) {
          print('[⛔ OMITIDA] ${pair.participantHeadId} ↔ ${pair.participantHeelId} (eliminada en tiro $shot)');
          continue;
        }

        inserted.add(PairingsCompanion(
          roundId: Value(newRoundId),
          participantHeadId: Value(pair.participantHeadId),
          participantHeelId: Value(pair.participantHeelId),
          timeSeconds: const Value(0),
          shotNumber: Value(shot),
        ));
      }

      for (final p in inserted) {
        await db.insertPairing(p);
      }

      print('[✅] Ronda $newRoundId - Tiro $shot: ${inserted.length} parejas copiadas desde ronda $firstRoundId');
    }

    _lastRepeatedParticipantId = _currentRepeatedParticipantId;
  }
}
