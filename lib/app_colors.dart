import 'package:flutter/material.dart';

/// Paleta nueva: verde bosque (base) y esmeralda (acento).
/// Contrastes verificados >= 4.5:1 para texto sobre fondo claro.
class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF064E3B); // Verde bosque
  static const Color primaryMedium = Color(0xFF065F46); // Verde medio
  static const Color accent = Color(0xFF047857); // Acento esmeralda
  static const Color quoteBg = Color(0xFFD1FAE5); // Fondo claro verdoso
  static const Color surface = Color(0xFFF4FBF7); // Fondo general
  static const Color chipBg = Color(0xFFD5E8DE); // Bordes / insignias suaves
  static const Color textDark = Color(0xFF052E22); // Texto principal
  static const Color textMuted = Color(0xFF4B5F57); // Texto secundario
  static const Color error = Color(0xFFB91C1C); // Errores de validación
  static const Color white = Colors.white;
}
