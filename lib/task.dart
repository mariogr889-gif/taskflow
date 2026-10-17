import 'package:flutter/material.dart';

enum Priority {
  high('Alta', Color(0xFFFEE2E2), Color(0xFFB91C1C)),
  medium('Media', Color(0xFFFEF3C7), Color(0xFFB45309)),
  low('Baja', Color(0xFFE0E7FF), Color(0xFF4338CA));

  final String label;
  final Color background;
  final Color foreground;

  const Priority(this.label, this.background, this.foreground);
}

/// dd/mm/aaaa
String formatearFecha(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/${d.year}';

class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final Priority priority;
  final DateTime? dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
