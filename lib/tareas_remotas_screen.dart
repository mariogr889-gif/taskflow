import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'laboratorio_async_screen.dart';
import 'nueva_tarea_screen.dart';
import 'tareas_api.dart';
import 'tareas_remotas_provider.dart';
import 'task.dart';

class TareasRemotasScreen extends ConsumerWidget {
  const TareasRemotasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTareas = ref.watch(tareasRemotasProvider);
    final notifier = ref.read(tareasRemotasProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas en la nube'),
        actions: [
          IconButton(
            tooltip: 'Laboratorio async',
            icon: const Icon(Icons.science_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const LaboratorioAsyncScreen()),
            ),
          ),
        ],
      ),
      body: asyncTareas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _VistaError(
          mensaje: error is ApiException
              ? error.mensaje
              : 'Ocurrió un error inesperado.',
          onReintentar: notifier.recargar,
        ),
        data: (tareas) => RefreshIndicator(
          onRefresh: notifier.recargar, // deslizar hacia abajo para recargar
          child: tareas.isEmpty
              ? ListView(children: const [
                  SizedBox(height: 120),
                  Center(child: Text('El servidor no tiene tareas.')),
                ])
              : ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (context, i) {
                    final t = tareas[i];
                    return ListTile(
                      leading: Icon(
                        t.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(t.title),
                      subtitle: Text(
                          t.remoteId == null ? 'Sin id' : 'id ${t.remoteId}'),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Nueva tarea'),
        onPressed: () => _crearTarea(context, ref),
      ),
    );
  }

  Future<void> _crearTarea(BuildContext context, WidgetRef ref) async {
    // Reutilizamos la pantalla de la Semana 13 sin modificarla.
    final nueva = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaTareaScreen()),
    );
    if (nueva == null || !context.mounted) return;

    // Se obtiene ANTES del siguiente await (uso seguro de context).
    final mensajero = ScaffoldMessenger.of(context);
    mensajero.showSnackBar(const SnackBar(content: Text('Enviando tarea...')));

    try {
      final creada =
          await ref.read(tareasRemotasProvider.notifier).crear(nueva);
      mensajero
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
              'Tarea "${creada.title}" creada (id ${creada.remoteId}).'),
        ));
    } on ApiException catch (e) {
      mensajero
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.mensaje)));
    }
  }
}

class _VistaError extends StatelessWidget {
  const _VistaError({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final Future<void> Function() onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
