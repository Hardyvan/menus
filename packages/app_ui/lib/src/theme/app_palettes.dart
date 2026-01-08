import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme_config.dart';

/// Colección centralizada de paletas de colores (Temas) disponibles en la app.
///
/// Permite definir múltiples opciones visuales para que el usuario o cliente
/// elija la que más le agrade.
class AppPalettes {
  // Paleta por defecto (Dark Mode Moderno)
  static const ThemeConfig defaultDark = ThemeConfig(
    id: 'default',
    name: 'Modern Dark',
    primary: Color(0xFFFF5722),
    secondary: Color(0xFFFFC107),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
  );

  // Paleta Light (Nuevo Default)
  static const ThemeConfig modernLight = ThemeConfig(
    id: 'light',
    name: 'Modern Light',
    primary: Color(0xFFFF5722), // Mismo naranja vibrante
    secondary: Color(0xFFFFC107), // Mismo amarillo
    background: Color(0xFFF5F5F7), // Gris muy claro ("White Smoke")
    surface: Color(0xFFFFFFFF), // Blanco puro
    onBackground: Color(0xFF121212), // Texto oscuro
    onSurface: Color(0xFF121212),
    brightness: Brightness.light,
  );

  /// Lista maestra de todos los temas disponibles.
  static const List<ThemeConfig> all = [
    modernLight, // Primera en la lista
    defaultDark,
    
    ThemeConfig(
      id: 'ocean_breeze',
      name: 'Ocean Breeze',
      primary: Color(0xFF00B4D8),
      secondary: Color(0xFF48CAE4),
      background: Color(0xFF03045E),
      surface: Color(0xFF0077B6),
    ),
    
    ThemeConfig(
      id: 'fresh_green',
      name: 'Fresh Green',
      primary: Color(0xFF2E7D32),
      secondary: Color(0xFF66BB6A),
      background: Color(0xFF1B5E20),
      surface: Color(0xFF388E3C),
    ),
    
    ThemeConfig(
      id: 'coffee_warm',
      name: 'Coffee Warm',
      primary: Color(0xFF795548),
      secondary: Color(0xFFA1887F),
      background: Color(0xFF3E2723),
      surface: Color(0xFF4E342E),
    ),
    
    ThemeConfig(
      id: 'gourmet_gold',
      name: 'Gourmet Gold',
      primary: Color(0xFFFFD700),
      secondary: Color(0xFFFFA000),
      background: Color(0xFF212121),
      surface: Color(0xFF424242),
    ),
    
    ThemeConfig(
      id: 'night_neon',
      name: 'Night Neon',
      primary: Color(0xFFE040FB),
      secondary: Color(0xFF7C4DFF),
      background: Color(0xFF000000),
      surface: Color(0xFF121212),
    ),

    // Nuevo tema solicitado
    ThemeConfig(
      id: 'royal_imperial',
      name: 'Realeza Imperial (Light)',
      primary: Color(0xFF311B92), // Indigo profundo
      secondary: Color(0xFFFFAB00), // Oro brillante
      background: Color(0xFFF3F4F6), // Gris azulado claro
      surface: Color(0xFFFFFFFF), // Blanco puro para tarjetas
      onBackground: Color(0xFF1A237E), // Texto azul oscuro
      onSurface: Color(0xFF1A237E), // Texto azul oscuro en tarjetas
      brightness: Brightness.light, 
    ),
  ];
}
