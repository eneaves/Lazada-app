import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:excel/excel.dart';

import '../providers/participants_provider.dart';
import '../data/tables.dart';
import '../theme/app_styles.dart';

class ParticipantsScreen extends ConsumerStatefulWidget {
  const ParticipantsScreen({Key? key}) : super(key: key);

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends ConsumerState<ParticipantsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  Role? _selectedRole;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedRole == null) return;
    await ref.read(participantsProvider.notifier).add(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          role: _selectedRole!,
          email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        );
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    setState(() => _selectedRole = null);
  }

  Future<void> _importExcel() async {
    final typeGroup = XTypeGroup(label: 'Excel', extensions: ['xlsx', 'xls']);
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    if (excel.tables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El archivo no contiene hojas')),
      );
      return;
    }

    final sheet = excel.tables.values.first;
    int importados = 0;
    int omitidos = 0;

    for (var r = 1; r < sheet.maxRows; r++) {
      final row = sheet.row(r);
      final firstName = row.isNotEmpty ? row[0]?.value.toString().trim() ?? '' : '';
      final lastName = row.length > 1 ? row[1]?.value.toString().trim() ?? '' : '';
      final roleStr = row.length > 2 ? row[2]?.value.toString().toLowerCase().trim() ?? '' : '';
      final email = row.length > 3 ? row[3]?.value.toString().trim() : null;

      if (firstName.isEmpty || lastName.isEmpty || !(roleStr == 'head' || roleStr == 'heel')) {
        omitidos++;
        continue;
      }

      final role = roleStr == 'head' ? Role.head : Role.heel;

      await ref.read(participantsProvider.notifier).add(
            firstName: firstName,
            lastName: lastName,
            role: role,
            email: (email?.isEmpty ?? true) ? null : email,
          );
      importados++;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Importados: $importados — ❌ Omitidos: $omitidos')),
    );
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar todos los participantes'),
        content: const Text('¿Estás seguro de que deseas borrar todos los participantes? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sí, borrar todo')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(participantsProvider.notifier).clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Todos los participantes fueron eliminados')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantsAsync = ref.watch(participantsProvider);

    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        title: const Text('Registro de Participantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Importar Excel',
            onPressed: _importExcel,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Eliminar todos',
            onPressed: _confirmDeleteAll,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyles.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.padding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstNameCtrl,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese un nombre' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastNameCtrl,
                        decoration: const InputDecoration(labelText: 'Apellido'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese un apellido' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Role>(
                        value: _selectedRole,
                        decoration: const InputDecoration(labelText: 'Rol'),
                        items: Role.values.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (r) => setState(() => _selectedRole = r),
                        validator: (v) => v == null ? 'Seleccione un rol' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email (opcional)'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final pattern = r'^[^@]+@[^@]+\.[^@]+$';
                            if (!RegExp(pattern).hasMatch(v)) {
                              return 'Email inválido';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar Participante'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: participantsAsync.when(
                data: (list) {
                  if (list.isEmpty) return const Text('No hay participantes aún');
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final p = list[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            p.role == Role.head ? Icons.person : Icons.person_outline,
                            color: AppStyles.accent,
                          ),
                          title: Text('${p.firstName} ${p.lastName}'),
                          subtitle: Text(
                            'Rol: ${p.role.name.toUpperCase()}\nEmail: ${p.email ?? '—'}',
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
