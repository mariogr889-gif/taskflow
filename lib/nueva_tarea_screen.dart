import 'package:flutter/material.dart';

import 'task.dart';
import 'validadores_tarea.dart';

/// Formulario "Nueva tarea". Solo maneja estado EFÍMERO (borradores) y
/// DEVUELVE la tarea validada con Navigator.pop; quien la abre decide
/// qué hacer con ella.
class NuevaTareaScreen extends StatefulWidget {
  const NuevaTareaScreen({super.key});

  @override
  State<NuevaTareaScreen> createState() => _NuevaTareaScreenState();
}

class _NuevaTareaScreenState extends State<NuevaTareaScreen> {
  // Estado efímero: vive y muere con esta pantalla.
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _descripcionFocus = FocusNode();

  DateTime? _fechaLimite;
  Priority _prioridad = Priority.medium;
  String _categoria = 'General';

  static const _categorias = [
    'General',
    'Estudio',
    'Trabajo',
    'Personal',
    'Diseño',
    'Desarrollo',
    'Investigación',
  ];

  // 4 objetos con dispose() creados -> 4 liberaciones.
  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    _fechaCtrl.dispose();
    _descripcionFocus.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaLimite ?? hoy,
      firstDate: DateTime(hoy.year, hoy.month, hoy.day),
      lastDate: DateTime(hoy.year + 2),
      helpText: 'Fecha límite de la tarea',
    );
    if (elegida == null || !mounted) return;
    setState(() {
      _fechaLimite = elegida;
      _fechaCtrl.text = formatearFecha(elegida);
    });
    // Si ya había un error en el campo, se limpia al elegir fecha válida.
    _formKey.currentState?.validate();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final tarea = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _tituloCtrl.text.trim(),
      description: _descripcionCtrl.text.trim(),
      dueDate: _fechaLimite!, // seguro: el validador ya lo exigió
      category: _categoria,
      priority: _prioridad,
    );
    Navigator.pop(context, tarea);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // ListView y no Column: evita overflow con teclado o texto ampliado.
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(
                labelText: 'Título *',
                helperText:
                    'Obligatorio, entre ${ValidadoresTarea.tituloMin} y '
                    '${ValidadoresTarea.tituloMax} caracteres',
              ),
              maxLength: ValidadoresTarea.tituloMax,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _descripcionFocus.requestFocus(),
              validator: ValidadoresTarea.titulo,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descripcionCtrl,
              focusNode: _descripcionFocus,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                alignLabelWithHint: true,
              ),
              minLines: 2,
              maxLines: 4,
              maxLength: ValidadoresTarea.descripcionMax,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              validator: ValidadoresTarea.descripcion,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fechaCtrl,
              readOnly: true,
              onTap: _elegirFecha,
              decoration: const InputDecoration(
                labelText: 'Fecha límite *',
                hintText: 'Toca para elegir',
                helperText: 'Obligatoria. No puede estar en el pasado',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              // La fuente de verdad es _fechaLimite, no el texto.
              validator: (_) => ValidadoresTarea.fechaLimite(_fechaLimite),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Priority>(
              initialValue: _prioridad,
              decoration: const InputDecoration(labelText: 'Prioridad'),
              items: [
                for (final p in Priority.values)
                  DropdownMenuItem(value: p, child: Text(p.label)),
              ],
              onChanged: (valor) =>
                  setState(() => _prioridad = valor ?? Priority.medium),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: [
                for (final c in _categorias)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (valor) =>
                  setState(() => _categoria = valor ?? 'General'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.check),
              label: const Text('Guardar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
