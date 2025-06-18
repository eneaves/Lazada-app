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
  late Future<Map<int, List<_PairingWithNames>>> _groupedPairingsFuture;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadPairings();
  }

  void _loadPairings() {
    final db = ref.read(databaseProvider);
    _groupedPairingsFuture = () async {
      final list = await db.getPairingsByRound(widget.roundId);

      // Debug para verificar que isEliminated llega
      for (final p in list) {
        print('[DEBUG] pairing ID: ${p.id}, eliminado: ${p.isEliminated}, tiempo: ${p.timeSeconds}');
      }

      final result = <int, List<_PairingWithNames>>{};

      for (final p in list) {
        final head = await db.getParticipantById(p.participantHeadId);
        final heel = await db.getParticipantById(p.participantHeelId);

        final shot = p.shotNumber;
        result.putIfAbsent(shot, () => []).add(
          _PairingWithNames(
            pairing: p,
            headName: '${head.firstName} ${head.lastName}',
            heelName: '${heel.firstName} ${heel.lastName}',
          ),
        );

        _controllers.putIfAbsent(p.id, () {
          final c = TextEditingController();
          // Solo precargar si no está eliminado
          if (!p.isEliminated && p.timeSeconds > 0) {
            c.text = p.timeSeconds.toString();
          }
          return c;
        });
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

  Future<void> _saveAndNext(List<Pairing> allPairings) async {
    final db = ref.read(databaseProvider);

    // ⚠️ Validación: que no haya campos vacíos en pares activos
    final missingTimes = allPairings.where((p) {
      final raw = _controllers[p.id]?.text.trim();
      return raw == null || raw.isEmpty || int.tryParse(raw) == null;
    }).toList();

    if (missingTimes.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Todos los tiros deben tener un número válido.')),
      );
      return;
    }

    // Guardar tiempos
    for (final p in allPairings) {
      final secs = int.parse(_controllers[p.id]!.text.trim());
      await db.setPairingTime(p.id, secs);
    }

    // Marcar eliminados
    await db.marcarParejasEliminadasPorTiempoCero(widget.roundId);

    final compState = ref.read(competitionProvider).asData!.value;
    final isLastRound = compState.currentRoundNumber >= compState.totalRounds;

    if (!isLastRound) {
      final nextNumber = compState.currentRoundNumber + 1;
      final nextId = await db.createRound(nextNumber);

      await PairingService(db).generateNextRoundPairings(
        compState.initialRoundId,
        nextId,
        compState.shotsPerRound,
      );

      final nextRoundPairings = await db.getPairingsByRound(nextId);
      if (nextRoundPairings.isEmpty) {
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Competencia Finalizada'),
            content: const Text('Ninguna pareja pasó a la siguiente ronda.\n\nSe mostrará el resumen de resultados.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // cierra el dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SummaryScreen()),
                  );
                },
                child: const Text('Ver resumen'),
              ),
            ],
          ),
        );
        return;
      }

      // Actualizar estado
      ref.read(competitionProvider.notifier).state = AsyncValue.data(
        CompetitionState(
          totalRounds: compState.totalRounds,
          currentRoundId: nextId,
          currentRoundNumber: nextNumber,
          initialRoundId: compState.initialRoundId,
          shotsPerRound: compState.shotsPerRound,
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
      // Última ronda, ir directo al resumen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SummaryScreen()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, List<_PairingWithNames>>>(
      future: _groupedPairingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppStyles.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final grouped = snapshot.data!;
        final allPairings = grouped.values.expand((e) => e.map((x) => x.pairing)).toList();

        return Scaffold(
          backgroundColor: AppStyles.background,
          appBar: AppBar(title: Text('Ronda ${widget.roundNumber}')),
          body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: grouped.entries.map((entry) {
                      final shotNum = entry.key;
                      final list = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎯 Tiro $shotNum',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...list.map((p) {
                            final isEliminated = p.pairing.isEliminated;

                            return Card(
                              color: isEliminated ? Colors.red.shade50 : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(AppStyles.padding),
                                leading: Icon(
                                  isEliminated ? Icons.block : Icons.sports,
                                  color: isEliminated ? Colors.red : null,
                                ),
                                title: Text(
                                  '${p.headName} ↔ ${p.heelName}',
                                  style: isEliminated
                                      ? const TextStyle(
                                          color: Colors.red,
                                          fontStyle: FontStyle.italic,
                                        )
                                      : null,
                                ),
                                subtitle: isEliminated
                                    ? const Text(
                                        'Eliminado en esta ronda',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : null,
                                trailing: SizedBox(
                                  width: 90,
                                  child: TextField(
                                    enabled: !isEliminated,
                                    controller: _controllers[p.pairing.id],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Segs',
                                      labelStyle: isEliminated
                                          ? const TextStyle(color: Colors.grey)
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _saveAndNext(allPairings),
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
