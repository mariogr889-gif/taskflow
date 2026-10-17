import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'header_card.dart';
import 'nueva_tarea_screen.dart';
import 'priority_chip.dart';
import 'quote_card.dart';
import 'section_header.dart';
import 'task.dart';
import 'top_bottom_bars.dart';
import 'validadores_tarea.dart';

class TaskflowPage extends StatefulWidget {
  const TaskflowPage({super.key});

  @override
  State<TaskflowPage> createState() => _TaskflowPageState();
}

class _TaskflowPageState extends State<TaskflowPage> {
  int _currentIndex = 0;

  List<Task> _tasks = [
    const Task(
      id: '1',
      title: 'Diseñar interfaz de usuario',
      category: 'Diseño',
      priority: Priority.high,
      isCompleted: false,
    ),
    const Task(
      id: '2',
      title: 'Configurar entorno Flutter',
      category: 'Desarrollo',
      priority: Priority.medium,
      isCompleted: true,
    ),
    const Task(
      id: '3',
      title: 'Revisar documentación',
      category: 'Investigación',
      priority: Priority.low,
      isCompleted: false,
    ),
  ];

  void _toggleTask(String id) {
    setState(() {
      _tasks = _tasks.map((t) {
        if (t.id == id) {
          return t.copyWith(isCompleted: !t.isCompleted);
        }
        return t;
      }).toList();
    });
  }

  /// Estado de la APP: solo entran tareas ya validadas.
  /// Defensa en profundidad: se valida otra vez aunque la UI ya lo hizo.
  void _addTask(Task task) {
    if (ValidadoresTarea.titulo(task.title) != null) return;
    setState(() => _tasks = [..._tasks, task]);
  }

  Future<void> _abrirNuevaTarea() async {
    final nueva = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const NuevaTareaScreen()),
    );

    // El usuario regresó sin guardar.
    if (nueva == null) return;
    // Safe-await: la pantalla pudo destruirse durante el await.
    if (!mounted) return;

    _addTask(nueva);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tarea "${nueva.title}" creada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((t) => t.isCompleted).length;
    final progress = _tasks.isEmpty ? 0.0 : completedCount / _tasks.length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(title: 'TaskFlow', avatarLetter: 'M'),
              const SizedBox(height: 8),
              HeaderCard(
                greeting: '¡Hola, Mario!',
                date: 'Viernes, 16 de Octubre',
                subtitle:
                    'Tienes ${_tasks.length - completedCount} tareas pendientes',
                progress: progress,
              ),
              const SizedBox(height: 48),
              const QuoteCard(
                quote:
                    'El éxito es la suma de pequeños esfuerzos repetidos día tras día.',
                author: 'Robert Collier',
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Mis Tareas',
                actionLabel: 'Ver todas',
                onAction: () {},
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.margin),
                itemCount: _tasks.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppDimensions.gap),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final subtitulo = task.dueDate == null
                      ? task.category
                      : '${task.category} · vence ${formatearFecha(task.dueDate!)}';
                  return Container(
                    padding:
                        const EdgeInsets.all(AppDimensions.taskCardPadding),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.taskCardRadius),
                      border: Border.all(color: AppColors.chipBg),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: AppColors.accent,
                          onChanged: (_) => _toggleTask(task.id),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitulo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PriorityChip(priority: task.priority),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
        onPressed: _abrirNuevaTarea,
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        destinations: const [
          BottomDestination(icon: Icons.home_rounded, label: 'Inicio'),
          BottomDestination(icon: Icons.task_alt_rounded, label: 'Tareas'),
          BottomDestination(icon: Icons.person_rounded, label: 'Perfil'),
        ],
      ),
    );
  }
}
