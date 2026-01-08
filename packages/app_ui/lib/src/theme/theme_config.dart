import 'package:flutter/material.dart';

/// Configuración de una paleta de tema.
class ThemeConfig {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color onBackground;
  final Color onSurface;
  final Brightness brightness;

  const ThemeConfig({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    this.onBackground = const Color(0xFFEEEEEE),
    this.onSurface = const Color(0xFFEEEEEE),
    this.brightness = Brightness.dark,
  });
}
