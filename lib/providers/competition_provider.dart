import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../data/database.dart';

/// Estado de la configuración de la competencia.
class CompetitionState {
  final int totalRounds;
  final int currentRoundId;
  final int currentRoundNumber;
  final int initialRoundId;
  final int shotsPerRound;

  const CompetitionState({
    required this.totalRounds,
    required this.currentRoundId,
    required this.currentRoundNumber,
    required this.initialRoundId,
    required this.shotsPerRound,
  });
}

/// StateNotifier que gestiona la configuración de la competencia.
class CompetitionNotifier extends StateNotifier<AsyncValue<CompetitionState>> {
  final Ref ref;

  CompetitionNotifier(this.ref)
      : super(
          const AsyncValue.data(
            CompetitionState(
              totalRounds: 0,
              currentRoundId: 0,
              currentRoundNumber: 0,
              initialRoundId: 0,
              shotsPerRound: 0,
            ),
          ),
        );

  Future<void> configureCompetition({
    required int rounds,
    required int shotsPerRound,
  }) async {
    state = const AsyncValue.loading();
    try {
      final db = ref.read(databaseProvider);

      // 🧹 Limpiar todo
      await db.delete(db.pairings).go();
      await db.delete(db.rounds).go();

      final roundId = await db.createRound(1);

      state = AsyncValue.data(
        CompetitionState(
          totalRounds: rounds,
          currentRoundId: roundId,
          currentRoundNumber: 1,
          initialRoundId: roundId,
          shotsPerRound: shotsPerRound,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 

/// Provider global del estado de competencia.
final competitionProvider =
    StateNotifierProvider<CompetitionNotifier, AsyncValue<CompetitionState>>(
  (ref) => CompetitionNotifier(ref),
);
