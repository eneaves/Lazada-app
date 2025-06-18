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

            final Map<String, _PairData> pairDataMap = {};

            for (final p in pairings) {
              final head = partMap[p.participantHeadId]!;
              final heel = partMap[p.participantHeelId]!;

              final key = ([head.id, heel.id]..sort()).join('-');
              pairDataMap.putIfAbsent(
                key,
                () => _PairData(
                  label: '${head.firstName} ${head.lastName} (head) ↔ ${heel.firstName} ${heel.lastName} (heel)',
                  ids: [head.id, heel.id],
                ),
              );

              pairDataMap[key]!.shots.add(
                _ShotResult(
                  round: roundMap[p.roundId] ?? p.roundId,
                  shotNumber: p.shotNumber,
                  time: p.timeSeconds,
                  isEliminated: p.isEliminated,
                ),
              );
            }

            for (final pd in pairDataMap.values) {
              pd.shots.sort((a, b) {
                final cmp = a.round.compareTo(b.round);
                return cmp != 0 ? cmp : a.shotNumber.compareTo(b.shotNumber);
              });
              final validShots = pd.shots.where((s) => !s.isEliminated).toList();
              pd.totalTime = validShots.fold(0, (sum, s) => sum + s.time);
              pd.avgTime = validShots.isEmpty ? 0 : pd.totalTime / validShots.length;

              final firstEliminated = pd.shots.firstWhere(
                (s) => s.isEliminated,
                orElse: () => _ShotResult(round: -1, shotNumber: -1, time: 0, isEliminated: false),
              );
              if (firstEliminated.isEliminated) {
                pd.eliminatedInRound = firstEliminated.round;
                pd.eliminatedInShot = firstEliminated.shotNumber;
              }
            }

            final activePairs = <_PairData>[];
            final eliminatedPairs = <_PairData>[];
            for (final pd in pairDataMap.values) {
              if (pd.eliminatedInRound != null) {
                eliminatedPairs.add(pd);
              } else {
                activePairs.add(pd);
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
              final head = partMap[p.participantHeadId]!;
              final heel = partMap[p.participantHeelId]!;

              final pairs = [
                [p.participantHeadId, p.participantHeelId],
                [p.participantHeelId, p.participantHeadId],
              ];

              for (final [selfId, partnerId] in pairs) {
                final selfStat = indivStats[selfId];
                final partner = partMap[partnerId];
                if (selfStat != null && partner != null) {
                  selfStat.totalTime += p.timeSeconds;
                  selfStat.count += 1;

                  selfStat.partners.putIfAbsent(
                    partnerId,
                    () => _PartnerData(name: '${partner.firstName} ${partner.lastName}'),
                  );

                  final partnerStat = selfStat.partners[partnerId]!;
                  partnerStat.totalTime += p.timeSeconds;
                  partnerStat.count += 1;
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
                    final placeEmoji = ['🥇', '🥈', '🥉'];
                    final place = i + 1;
                    final prefix = pd.eliminatedInRound != null
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
                          pd.eliminatedInRound != null
                              ? 'Eliminado en ronda ${pd.eliminatedInRound}, tiro ${pd.eliminatedInShot}'
                              : 'Total: ${pd.totalTime}s — Promedio: ${pd.avgTime.toStringAsFixed(2)}s',
                        ),
                        children: [
                          ...pd.shots.map((s) => ListTile(
                                title: Text('Ronda ${s.round} — Tiro ${s.shotNumber}'),
                                trailing: s.isEliminated
                                    ? const Text('🚫 Eliminado', style: TextStyle(color: Colors.red))
                                    : Text('${s.time}s'),
                              )),
                          const Divider(),
                          ListTile(
                            title: const Text('Resumen', style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text(
                              pd.eliminatedInRound != null
                                  ? 'Eliminado en ronda ${pd.eliminatedInRound}, tiro ${pd.eliminatedInShot}'
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
                      child: ExpansionTile(
                        title: Text(s.name),
                        subtitle: Text(
                          'Lanzamientos: ${s.count} — Total: ${s.totalTime}s — Promedio: ${s.avgTime.toStringAsFixed(2)}s',
                        ),
                        children: s.partners.entries.map((entry) {
                          final partner = entry.value;
                          return ListTile(
                            leading: const Icon(Icons.group),
                            title: Text('Con ${partner.name}'),
                            subtitle: Text(
                              'Total: ${partner.totalTime}s — Promedio: ${partner.avgTime.toStringAsFixed(2)}s',
                            ),
                          );
                        }).toList(),
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
  final List<_ShotResult> shots = [];
  int totalTime = 0;
  double avgTime = 0;
  int? eliminatedInRound;
  int? eliminatedInShot;

  _PairData({required this.label, required this.ids});
}

class _ShotResult {
  final int round;
  final int shotNumber;
  final int time;
  final bool isEliminated;

  _ShotResult({
    required this.round,
    required this.shotNumber,
    required this.time,
    required this.isEliminated,
  });
}

class _IndividualStats {
  final String name;
  int totalTime = 0;
  int count = 0;
  double avgTime = 0;
  final Map<int, _PartnerData> partners = {};

  _IndividualStats({required this.name});
}

class _PartnerData {
  final String name;
  int totalTime = 0;
  int count = 0;

  _PartnerData({required this.name});

  double get avgTime => count == 0 ? 0 : totalTime / count;
}
