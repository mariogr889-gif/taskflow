import 'package:flutter/material.dart';

enum Priority {
  high('Alta', Color(0xFFFEE2E2), Color(0xFFDC2626)),
  medium('Media', Color(0xFFFEF3C7), Color(0xFFD97706)),
  low('Baja', Color(0xFFE0E7FF), Color(0xFF4F46E5));

  final String label;
  final Color background;
  final Color foreground;

  const Priority(this.label, this.background, this.foreground);
}

class Task {
  final String id;
  final String title;
  final String category;
  final Priority priority;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    Priority? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
