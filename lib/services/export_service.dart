import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import '../data/database.dart';

class ExportService {
  final List<Pairing> pairings;
  final List<Participant> participants;
  final List<Round> rounds;

  ExportService({
    required this.pairings,
    required this.participants,
    required this.rounds,
  });

  Future<void> exportToExcel(BuildContext context) async {
    final excel = Excel.createExcel();
    final roundMap = {for (var r in rounds) r.id: r.number};
    final partMap = {for (var p in participants) p.id: '${p.firstName} ${p.lastName}'};

    final parejaSheet = excel['ResumenPorPareja'];
    parejaSheet.appendRow(['Posición', 'Pareja', 'Ronda', 'Tiempo']);

    // Agrupar parejas desde ronda 1
    final round1Pairings = pairings.where((p) => roundMap[p.roundId] == 1).toList();
    final Set<String> clavesBase = {
      for (final p in round1Pairings)
        ([p.participantHeadId, p.participantHeelId]..sort()).join('-')
    };

    final Map<String, List<Pairing>> agrupadas = {};
    for (final p in pairings) {
      final ids = [p.participantHeadId, p.participantHeelId]..sort();
      final key = '${ids[0]}-${ids[1]}';
      if (!clavesBase.contains(key)) continue;
      agrupadas.putIfAbsent(key, () => []).add(p);
    }

    // Construir datos por pareja
    final List<_ExportPair> exportPairs = agrupadas.entries.map((entry) {
      final ids = entry.key.split('-').map(int.parse).toList();
      final nombre = '${partMap[ids[0]]} ↔ ${partMap[ids[1]]}';
      final rondas = entry.value.map((p) {
        return _RoundResult(
          round: roundMap[p.roundId] ?? p.roundId,
          time: p.timeSeconds,
        );
      }).toList()
        ..sort((a, b) => a.round.compareTo(b.round));

      final total = rondas.fold(0, (sum, r) => sum + r.time);
      final avg = rondas.isEmpty ? 0 : total / rondas.length;
      final eliminado = rondas.isNotEmpty && rondas.last.time == 0;

      return _ExportPair(
        label: nombre,
        rondas: rondas,
        totalTime: total,
        avgTime: avg.toDouble(),
        eliminatedRound: eliminado ? rondas.last.round : null,
      );
    }).toList();

    // Separar activos y eliminados
    final activos = exportPairs.where((e) => e.eliminatedRound == null).toList()
      ..sort((a, b) => a.totalTime.compareTo(b.totalTime));
    final eliminados = exportPairs.where((e) => e.eliminatedRound != null).toList()
      ..sort((a, b) => a.totalTime.compareTo(b.totalTime));

    // Escribir activos (con 🥇🥈🥉)
    for (int i = 0; i < activos.length; i++) {
      final p = activos[i];
      final posEmoji = i < 3 ? ['🥇', '🥈', '🥉'][i] : '${i + 1}.';
      parejaSheet.appendRow([posEmoji, p.label, '', '']);
      for (final r in p.rondas) {
        parejaSheet.appendRow(['', '', 'Ronda ${r.round}', '${r.time}s']);
      }
      parejaSheet.appendRow(['', '', 'TOTAL', '${p.totalTime}s']);
      parejaSheet.appendRow(['', '', 'PROMEDIO', '${p.avgTime.toStringAsFixed(2)}s']);
      parejaSheet.appendRow([]);
    }

    // Escribir eliminados
    for (final p in eliminados) {
      parejaSheet.appendRow(['🚫', p.label, '', '']);
      for (final r in p.rondas) {
        parejaSheet.appendRow(['', '', 'Ronda ${r.round}', '${r.time}s']);
      }
      parejaSheet.appendRow(['', '', 'TOTAL', '${p.totalTime}s']);
      parejaSheet.appendRow(['', '', 'PROMEDIO', '${p.avgTime.toStringAsFixed(2)}s']);
      parejaSheet.appendRow(['', '', 'ELIMINADO en ronda', '${p.eliminatedRound}']);
      parejaSheet.appendRow([]);
    }

    // Hoja individual
    final indivSheet = excel['ResumenIndividual'];
    indivSheet.appendRow(['Participante', 'Lanzamientos', 'Total', 'Promedio']);

    final Map<int, List<int>> tiempoPorPersona = {};
    for (final p in pairings) {
      for (final id in [p.participantHeadId, p.participantHeelId]) {
        tiempoPorPersona.putIfAbsent(id, () => []).add(p.timeSeconds);
      }
    }

    for (final id in tiempoPorPersona.keys) {
      final nombre = partMap[id]!;
      final tiempos = tiempoPorPersona[id]!;
      final total = tiempos.reduce((a, b) => a + b);
      final promedio = total / tiempos.length;
      indivSheet.appendRow([
        nombre,
        tiempos.length,
        '$total s',
        '${promedio.toStringAsFixed(2)} s',
      ]);
    }

    // Guardar archivo
    final Uint8List fileBytes = excel.encode() as Uint8List;
    final result = await getSaveLocation(
      suggestedName: 'resumen_competencia.xlsx',
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'Excel',
          extensions: ['xlsx'],
          mimeTypes: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
        ),
      ],
    );

    if (result == null) return;
    final file = XFile.fromData(fileBytes, name: 'resumen_competencia.xlsx');
    await file.saveTo(result.path);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Archivo guardado en:\n${result.path}')),
      );
    }

    if (Platform.isMacOS) {
      await Process.run('open', [result.path]);
    } else if (Platform.isWindows) {
      await Process.run('explorer', [result.path]);
    }
  }
}

class _ExportPair {
  final String label;
  final List<_RoundResult> rondas;
  final int totalTime;
  final double avgTime;
  final int? eliminatedRound;

  _ExportPair({
    required this.label,
    required this.rondas,
    required this.totalTime,
    required this.avgTime,
    this.eliminatedRound,
  });
}

class _RoundResult {
  final int round;
  final int time;

  _RoundResult({required this.round, required this.time});
}
