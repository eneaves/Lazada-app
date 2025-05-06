import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import '../data/database.dart';
import '../data/tables.dart';
import '../services/export_service.dart';
import '../theme/app_styles.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  Future<List<Pairing>> _loadPairings(AppDatabase db) => db.select(db.pairings).get();
  Future<List<Participant>> _loadParticipants(AppDatabase db) => db.getAllParticipants();
  Future<List<Round>> _loadRounds(AppDatabase db) => db.select(db.rounds).get();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyles.background,
        appBar: AppBar(
          title: const Text('Resumen de Competencia'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Por Pareja'),
              Tab(text: 'Individual'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Exportar a Excel',
              onPressed: () async {
                final pairings = await db.select(db.pairings).get();
                final participants = await db.getAllParticipants();
                final rounds = await db.select(db.rounds).get();

                final exporter = ExportService(
                  pairings: pairings,
                  participants: participants,
                  rounds: rounds,
                );

                await exporter.exportToExcel(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              tooltip: 'Nueva Competencia',
              onPressed: () async {
                await db.delete(db.pairings).go();
                await db.delete(db.rounds).go();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: Future.wait([
            _loadPairings(db),
            _loadParticipants(db),
            _loadRounds(db),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final pairings = snapshot.data![0] as List<Pairing>;
            final participants = snapshot.data![1] as List<Participant>;
            final rounds = snapshot.data![2] as List<Round>;

            final roundMap = {for (var r in rounds) r.id: r.number};
            final partMap = {for (var p in participants) p.id: p};

            final round1Pairings = pairings.where((p) => roundMap[p.roundId] == 1).toList();
            final Map<String, _PairData> pairDataMap = {};

            for (final base in round1Pairings) {
              final head = partMap[base.participantHeadId]!;
              final heel = partMap[base.participantHeelId]!;

              final key = ([head.id, heel.id]..sort()).join('-');
              final label = '${head.firstName} ${head.lastName} (head) ↔ ${heel.firstName} ${heel.lastName} (heel)';

              pairDataMap[key] = _PairData(label: label, ids: [head.id, heel.id]);
            }


            for (final p in pairings) {
              final ids = [p.participantHeadId, p.participantHeelId]..sort();
              final key = '${ids[0]}-${ids[1]}';
              if (pairDataMap.containsKey(key)) {
                pairDataMap[key]!.rounds.add(_RoundResult(
                  round: roundMap[p.roundId] ?? p.roundId,
                  time: p.timeSeconds,
                ));
              }
            }

            for (final pd in pairDataMap.values) {
              pd.rounds.sort((a, b) => a.round.compareTo(b.round));
              pd.totalTime = pd.rounds.fold(0, (sum, r) => sum + r.time);
              pd.avgTime = pd.rounds.isEmpty ? 0 : pd.totalTime / pd.rounds.length;
            }

            final pairList = pairDataMap.values.toList();
            final activePairs = <_PairData>[];
            final eliminatedPairs = <_PairData>[];

            for (final pair in pairList) {
              if (pair.rounds.isNotEmpty && pair.rounds.last.time == 0) {
                eliminatedPairs.add(pair);
              } else {
                activePairs.add(pair);
              }
            }

            activePairs.sort((a, b) => a.totalTime.compareTo(b.totalTime));
            eliminatedPairs.sort((a, b) => a.totalTime.compareTo(b.totalTime));
            final orderedPairs = [...activePairs, ...eliminatedPairs];

            final Map<int, _IndividualStats> indivStats = {
              for (final p in participants)
                p.id: _IndividualStats(name: '${p.firstName} ${p.lastName}')
            };

            for (final p in pairings) {
              for (final id in [p.participantHeadId, p.participantHeelId]) {
                final stat = indivStats[id];
                if (stat != null) {
                  stat.totalTime += p.timeSeconds;
                  stat.count += 1;
                }
              }
            }

            for (final s in indivStats.values) {
              s.avgTime = s.count == 0 ? 0 : s.totalTime / s.count;
            }

            return TabBarView(
              children: [
                // POR PAREJA
                ListView.builder(
                  padding: const EdgeInsets.all(AppStyles.padding),
                  itemCount: orderedPairs.length,
                  itemBuilder: (_, i) {
                    final pd = orderedPairs[i];
                    final isEliminated = pd.rounds.isNotEmpty && pd.rounds.last.time == 0;
                    final placeEmoji = ['🥇', '🥈', '🥉'];
                    final place = i + 1;
                    final prefix = isEliminated
                        ? '🚫'
                        : (place <= 3 ? placeEmoji[place - 1] : '$place.');

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        title: Text('$prefix ${pd.label}'),
                        subtitle: Text(
                          isEliminated
                              ? 'Eliminado en ronda ${pd.rounds.last.round}'
                              : 'Total: ${pd.totalTime}s — Promedio: ${pd.avgTime.toStringAsFixed(2)}s',
                        ),
                        children: [
                          ...pd.rounds.map((r) => ListTile(
                                title: Text('Ronda ${r.round}'),
                                trailing: Text('${r.time}s'),
                              )),
                          const Divider(),
                          ListTile(
                            title: const Text('Resumen', style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text(
                              isEliminated
                                  ? 'Eliminado en ronda ${pd.rounds.last.round}'
                                  : 'Total: ${pd.totalTime}s — Promedio: ${pd.avgTime.toStringAsFixed(2)}s',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // INDIVIDUAL
                ListView(
                  padding: const EdgeInsets.all(AppStyles.padding),
                  children: indivStats.values.map((s) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(s.name),
                        subtitle: Text(
                          'Lanzamientos: ${s.count} — Total: ${s.totalTime}s — Promedio: ${s.avgTime.toStringAsFixed(2)}s',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PairData {
  final String label;
  final List<int> ids;
  final List<_RoundResult> rounds = [];
  int totalTime = 0;
  double avgTime = 0;

  _PairData({required this.label, required this.ids});
}

class _RoundResult {
  final int round;
  final int time;

  _RoundResult({required this.round, required this.time});
}

class _IndividualStats {
  final String name;
  int totalTime = 0;
  int count = 0;
  double avgTime = 0;

  _IndividualStats({required this.name});
}
