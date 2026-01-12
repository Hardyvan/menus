
import 'package:flutter/material.dart';
import 'config_tema.dart';

/// Colección centralizada de paletas de colores (Temas) disponibles en la app.
///
/// Permite definir múltiples opciones visuales para que el usuario o cliente
/// elija la que más le agrade.
class AppPalettes {
  // Paleta Default Para Referencia Rápida
  static const ThemeConfig defaultTheme = ThemeConfig(
    id: 'modern_light',
    name: 'Modern Light',
    primary: Color(0xFFFF6B6B), // Coral Vibrante
    secondary: Color(0xFFFFD93D),
    background: Color(0xFFF7F9FC), // Azul grisáceo muy pálido
    surface: Colors.white,
    onBackground: Color(0xFF1A1C1E),
    onSurface: Color(0xFF1A1C1E),
    brightness: Brightness.light,
  );

  /// Lista maestra de todos los temas disponibles.
  static const List<ThemeConfig> all = [
    defaultTheme,

    // 1. Chocolate Delight (Restored & Improved)
    ThemeConfig(
      id: 'coffee_chocolate',
      name: 'Chocolate Delight',
      primary: Color(0xFFFFB74D), // Naranja suave/crema
      secondary: Color(0xFFFFE082), // Vainilla
      background: Color(0xFF2D1B1E), // Chocolate Oscuro Profundo
      surface: Color(0xFF4E342E), // Chocolate con Leche (Más claro para contraste)
      onBackground: Color(0xFFEFEBE9), // Blanco hueso
      onSurface: Color(0xFFEFEBE9),
      brightness: Brightness.dark,
    ),

    // 2. Dark Elegant: Ideal para cenas nocturnas o bares premium
    ThemeConfig(
      id: 'elegant_dark',
      name: 'Midnight Luxe',
      primary: Color(0xFFD4AF37), // Oro Metálico
      secondary: Color(0xFFC0C0C0), // Plata
      background: Color(0xFF121212), // Casi Negro
      surface: Color(0xFF1E1E1E), // Gris Oscuro
      brightness: Brightness.dark,
    ),

    // 3. Nordic Blue: Limpio, profesional, corporativo
    ThemeConfig(
      id: 'nordic_blue',
      name: 'Nordic Slate',
      primary: Color(0xFF457B9D), // Azul Acero
      secondary: Color(0xFFA8DADC), // Cian Pálido
      background: Color(0xFFF1FAEE), // Blanco Hueso
      surface: Colors.white,
      onBackground: Color(0xFF1D3557),
      onSurface: Color(0xFF1D3557),
      brightness: Brightness.light,
    ),

    // 4. Organic Bistro: Cálido, para cafeterías o comida saludable
    ThemeConfig(
      id: 'organic_bistro',
      name: 'Toscana Earth',
      primary: Color(0xFFBC6C25), // Terracotta
      secondary: Color(0xFF606C38), // Verde Oliva
      background: Color(0xFFFEFAE0), // Beige Crema
      surface: Colors.white,
      onBackground: Color(0xFF283618),
      onSurface: Color(0xFF283618),
      brightness: Brightness.light,
    ),

    // 5. Cyber Future: Alto contraste, moderno, fast food nocturno
    ThemeConfig(
      id: 'cyber_future',
      name: 'Cyber Punk',
      primary: Color(0xFF00E5FF), // Cian Neón
      secondary: Color(0xFFD500F9), // Magenta Neón
      background: Color(0xFF0A0F1C), // Azul Profundo
      surface: Color(0xFF16213E), // Azul Marina
      brightness: Brightness.dark,
    ),
    
    // 6. Deep Ocean: Serio y confiable
    ThemeConfig(
      id: 'deep_ocean',
      name: 'Deep Ocean',
      primary: Color(0xFF0277BD),
      secondary: Color(0xFF4FC3F7),
      background: Color(0xFFE1F5FE),
      surface: Colors.white,
      onBackground: Color(0xFF01579B),
      onSurface: Color(0xFF01579B),
      brightness: Brightness.light,
    ),
  ];
}
