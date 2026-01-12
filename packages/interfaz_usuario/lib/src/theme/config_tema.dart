import 'package:flutter/material.dart';

/// 🎨 CONFIGURACIÓN DE TEMA (The Blueprint)
///
/// Esta clase es un "plano" que contiene solo los datos puros de un tema (colores).
/// No contiene lógica de Flutter (como TextStyles o InputDecorations), solo la paleta.
///
/// ¿Por qué? Para poder tener múltiples temas (Azul, Rojo, Oscuro)
/// sin duplicar la lógica de cómo se ven los botones o inputs.
class ThemeConfig {
  final String id; // Identificador único (ej: 'dark_blue')
  final String name; // Nombre visible (ej: 'Azul Corporativo')
  
  // Colores principales
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  
  // Colores "On" (Texto/Iconos sobre los colores principales)
  final Color? onPrimary;
  final Color? onSecondary;
  final Color onBackground;
  final Color onSurface;
  
  final Brightness brightness; // ¿Es tema claro u oscuro?

  const ThemeConfig({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    this.onPrimary,
    this.onSecondary,
    Color? onBackground,
    Color? onSurface,
    this.brightness = Brightness.dark,
  }) : onBackground = onBackground ?? (brightness == Brightness.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1C1E)),
       onSurface = onSurface ?? (brightness == Brightness.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1C1E));
}
