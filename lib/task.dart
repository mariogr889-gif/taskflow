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
  /// Identificador LOCAL (único en la app).
  final String id;

  /// Identificador en el servidor; null mientras no se ha enviado/recibido.
  final int? remoteId;
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
    this.remoteId,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
  });

  static int _contador = 0;

  /// Construye una Task a partir del JSON de la API.
  /// Lanza FormatException si el dato no es utilizable.
  factory Task.fromJson(Map<String, dynamic> json) {
    final titulo = json['title'];
    if (titulo is! String || titulo.trim().isEmpty) {
      throw const FormatException(
          'La tarea recibida no tiene un título válido.');
    }
    final idRemoto = json['id'];
    return Task(
      id: idRemoto is int ? 'remota-$idRemoto' : 'remota-x${_contador++}',
      remoteId: idRemoto is int ? idRemoto : null,
      title: titulo.trim(),
      category: 'General',
      priority: Priority.medium,
      // La API no envía fecha: se asigna hoy + 7 días (limitación documentada).
      dueDate: DateTime.now().add(const Duration(days: 7)),
      isCompleted: json['completed'] == true,
    );
  }

  /// Convierte la Task al formato que espera la API.
  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': isCompleted,
        'userId': 1,
      };

  Task copyWith({
    String? id,
    int? remoteId,
    String? title,
    String? description,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
