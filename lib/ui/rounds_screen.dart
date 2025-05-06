import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/competition_provider.dart';
import '../providers/database_provider.dart';
import '../services/pairing_service.dart';
import '../theme/app_styles.dart';
import '../data/database.dart';
import 'summary_screen.dart';

class RoundsScreen extends ConsumerStatefulWidget {
  final int roundId;
  final int roundNumber;

  const RoundsScreen({
    Key? key,
    required this.roundId,
    required this.roundNumber,
  }) : super(key: key);

  @override
  ConsumerState<RoundsScreen> createState() => _RoundsScreenState();
}

class _RoundsScreenState extends ConsumerState<RoundsScreen> {
  late Future<List<_PairingWithNames>> _pairingsFuture;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadPairings();
  }

  void _loadPairings() {
    final db = ref.read(databaseProvider);
    _pairingsFuture = () async {
      final list = await db.getPairingsByRound(widget.roundId);
      final result = <_PairingWithNames>[];

      for (final p in list) {
        final head = await db.getParticipantById(p.participantHeadId);
        final heel = await db.getParticipantById(p.participantHeelId);
        result.add(
          _PairingWithNames(
            pairing: p,
            headName: '${head.firstName} ${head.lastName}',
            heelName: '${heel.firstName} ${heel.lastName}',
          ),
        );
      }

      return result;
    }();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveAndNext(List<Pairing> list) async {
    final db = ref.read(databaseProvider);
    for (final p in list) {
      final secs = int.tryParse(_controllers[p.id]!.text) ?? 0;
      await db.setPairingTime(p.id, secs);
    }

    final compState = ref.read(competitionProvider).asData!.value;
    if (compState.currentRoundNumber < compState.totalRounds) {
      final nextNumber = compState.currentRoundNumber + 1;
      final nextId = await db.createRound(nextNumber);
      await PairingService(db).generateNextRoundPairings(
        compState.initialRoundId,
        nextId,
      );

      ref.read(competitionProvider.notifier).state = AsyncValue.data(
        CompetitionState(
          totalRounds: compState.totalRounds,
          currentRoundId: nextId,
          currentRoundNumber: nextNumber,
          initialRoundId: compState.initialRoundId,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RoundsScreen(
            roundId: nextId,
            roundNumber: nextNumber,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SummaryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_PairingWithNames>>(
      future: _pairingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppStyles.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final list = snapshot.data!;
        for (var p in list) {
          _controllers.putIfAbsent(p.pairing.id, () => TextEditingController());
        }

        return Scaffold(
          backgroundColor: AppStyles.background,
          appBar: AppBar(title: Text('Ronda ${widget.roundNumber}')),
          body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final p = list[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(AppStyles.padding),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B3F00),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            '${p.headName} ↔ ${p.heelName}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: SizedBox(
                            width: 90,
                            child: TextField(
                              controller: _controllers[p.pairing.id],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Segs',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final pairings = list.map((e) => e.pairing).toList();
                    _saveAndNext(pairings);
                  },
                  icon: const Icon(Icons.navigate_next),
                  label: const Text('Guardar y Siguiente'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PairingWithNames {
  final Pairing pairing;
  final String headName;
  final String heelName;

  _PairingWithNames({
    required this.pairing,
    required this.headName,
    required this.heelName,
  });
}
