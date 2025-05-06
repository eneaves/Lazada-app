import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/competition_provider.dart';
import '../providers/database_provider.dart';
import '../services/pairing_service.dart';
import '../theme/app_styles.dart';
import 'rounds_screen.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roundsCtrl = TextEditingController();

  @override
  void dispose() {
    _roundsCtrl.dispose();
    super.dispose();
  }

  Future<void> _startCompetition() async {
    if (!_formKey.currentState!.validate()) return;
    final rounds = int.parse(_roundsCtrl.text.trim());

    await ref.read(competitionProvider.notifier).configureCompetition(rounds);
    final comp = ref.read(competitionProvider).asData!.value;

    // Generar emparejamientos iniciales
    final db = ref.read(databaseProvider);
    await PairingService(db).generateInitialPairings(comp.currentRoundId);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoundsScreen(
          roundId: comp.currentRoundId,
          roundNumber: comp.currentRoundNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comp = ref.watch(competitionProvider);

    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(title: const Text('Configuración de Competencia')),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding * 2),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.padding * 1.5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _roundsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Número de rondas',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa número de rondas';
                          final n = int.tryParse(v);
                          if (n == null || n < 1) return 'Debe ser un entero ≥ 1';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _startCompetition,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Iniciar Competencia'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            comp.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('❌ Error: $e'),
              data: (_) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
