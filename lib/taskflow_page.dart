import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'header_card.dart';
import 'priority_chip.dart';
import 'quote_card.dart';
import 'section_header.dart';
import 'task.dart';
import 'top_bottom_bars.dart';

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
                subtitle: 'Tienes ${_tasks.length - completedCount} tareas pendientes',
                progress: progress,
              ),
              const SizedBox(height: 48),
              const QuoteCard(
                quote: 'El éxito es la suma de pequeños esfuerzos repetidos día tras día.',
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
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.margin),
                itemCount: _tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.gap),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Container(
                    padding: const EdgeInsets.all(AppDimensions.taskCardPadding),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.taskCardRadius),
                      border: Border.all(color: AppColors.chipBg),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: AppColors.gold,
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
                                task.category,
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
