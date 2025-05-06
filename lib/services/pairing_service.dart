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
          // Necesita mover list[i]
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

  Future<void> generateInitialPairings(int roundId) async {
    final all = await db.getAllParticipants();
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
      usedIds.addAll([head.id, heel.id]);

      pairings.add(PairingsCompanion(
        roundId: Value(roundId),
        participantHeadId: Value(head.id),
        participantHeelId: Value(heel.id),
        timeSeconds: const Value(0),
      ));
    }

    final total = heads.length + heels.length;
    if (total % 2 != 0) {
      final allIds = all.map((p) => p.id).toSet();
      final remaining = allIds.difference(usedIds).toList();

      if (remaining.isNotEmpty) {
        final selected = remaining.first;
        final selectedParticipant = all.firstWhere((p) => p.id == selected);
        final selectedRole = selectedParticipant.role;

        final validPartners = all.where((p) =>
            p.id != selected &&
            p.role != selectedRole &&
            !pairings.any((pair) =>
                (pair.participantHeadId.value == selected &&
                    pair.participantHeelId.value == p.id) ||
                (pair.participantHeelId.value == selected &&
                    pair.participantHeadId.value == p.id))).toList();

        if (validPartners.isNotEmpty) {
          final partner = validPartners[_rand.nextInt(validPartners.length)];
          _currentRepeatedParticipantId = selected;

          final extraPair = PairingsCompanion(
            roundId: Value(roundId),
            participantHeadId:
                Value(selectedRole == Role.head ? selected : partner.id),
            participantHeelId:
                Value(selectedRole == Role.heel ? selected : partner.id),
            timeSeconds: const Value(0),
          );

          pairings.add(extraPair);
          _separateRepeatedParticipant(pairings, selected);
        }
      }
    }

    for (final p in pairings) {
      await db.insertPairing(p);
    }

    _lastRepeatedParticipantId = _currentRepeatedParticipantId;
  }

  Future<void> generateNextRoundPairings(int firstRoundId, int newRoundId) async {
    final allRounds = await db.select(db.rounds).get();
    final isFinal = newRoundId == allRounds.length;

    final round1Pairings = await db.getPairingsByRound(firstRoundId);
    final prevPairings = await db.getPairingsByRound(newRoundId - 1);

    final Set<String> activeKeys = {
      for (final p in prevPairings)
        if (p.timeSeconds > 0)
          ([p.participantHeadId, p.participantHeelId]..sort()).join('-')
    };

    final validPairs = round1Pairings.where((p) {
      final key = ([p.participantHeadId, p.participantHeelId]..sort()).join('-');
      return activeKeys.contains(key);
    }).toList();

    if (isFinal) {
      final totals = <String, int>{};
      for (final p in validPairs) {
        final key = ([p.participantHeadId, p.participantHeelId]..sort()).join('-');
        final rounds = await db.getAllRoundsForPair(
          p.participantHeadId,
          p.participantHeelId,
        );
        totals[key] = rounds.fold(0, (sum, r) => sum + r.timeSeconds);
      }

      validPairs.sort((a, b) {
        final aKey = ([a.participantHeadId, a.participantHeelId]..sort()).join('-');
        final bKey = ([b.participantHeadId, b.participantHeelId]..sort()).join('-');
        return (totals[aKey] ?? 0).compareTo(totals[bKey] ?? 0);
      });
    }

    final usedIds = <int>{};
    final List<PairingsCompanion> inserted = [];

    for (final p in validPairs) {
      usedIds.addAll([p.participantHeadId, p.participantHeelId]);
      inserted.add(PairingsCompanion(
        roundId: Value(newRoundId),
        participantHeadId: Value(p.participantHeadId),
        participantHeelId: Value(p.participantHeelId),
        timeSeconds: const Value(0),
      ));
    }

    if (usedIds.length % 2 != 0) {
      final all = await db.getAllParticipants();
      final available = all.where((p) => !usedIds.contains(p.id) && p.id != _lastRepeatedParticipantId).toList();
      final fallback = all.where((p) => p.id != _lastRepeatedParticipantId).toList();

      final selected = (available.isNotEmpty ? available : fallback)[_rand.nextInt((available.isNotEmpty ? available : fallback).length)];
      _currentRepeatedParticipantId = selected.id;

      final selectedRole = selected.role;
      final validPartners = all.where((p) =>
        p.id != selected.id &&
        p.role != selectedRole &&
        !usedIds.contains(p.id)
      ).toList();

      if (validPartners.isNotEmpty) {
        final partner = validPartners[_rand.nextInt(validPartners.length)];

        final extraPair = PairingsCompanion(
          roundId: Value(newRoundId),
          participantHeadId: Value(selectedRole == Role.head ? selected.id : partner.id),
          participantHeelId: Value(selectedRole == Role.heel ? selected.id : partner.id),
          timeSeconds: const Value(0),
        );

        inserted.add(extraPair);
        _separateRepeatedParticipant(inserted, selected.id);
      }
    }

    for (final p in inserted) {
      await db.insertPairing(p);
    }

    _lastRepeatedParticipantId = _currentRepeatedParticipantId;
  }
}
