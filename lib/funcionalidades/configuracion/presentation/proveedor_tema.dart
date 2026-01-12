import 'package:flutter/material.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🧠 MOTOR DE TEMAS (State Management)
///
/// Este Provider es el "jefe" del diseño. Controla qué colores usa toda la app.
/// Cuando llamamos a [setTheme] y ejecutamos [notifyListeners],
/// Flutter repinta TODA la aplicación con los nuevos colores instantáneamente.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme_id'; // 🔑 Llave de persistencia
  ThemeConfig _currentConfig = AppPalettes.defaultTheme;

  ThemeConfig get currentConfig => _currentConfig;
  
  // Lista de Paletas Disponibles
  final List<ThemeConfig> availablePalettes = AppPalettes.all;

  // Convierte la configuración pura en un ThemeData real de Flutter
  ThemeData get themeData => AppTheme.create(_currentConfig);

  // Helpers para UI limpia
  bool get isDark => _currentConfig.brightness == Brightness.dark;

  // 1. Cargar tema guardado (Se llama antes de runApp)
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_themeKey);
      
      if (savedId != null) {
        // Buscamos el ID en nuestra lista de paletas
        final foundTheme = availablePalettes.firstWhere(
          (t) => t.id == savedId, 
          orElse: () => AppPalettes.defaultTheme
        );
        _currentConfig = foundTheme;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cargando tema: $e');
    }
  }

  // 2. Cambiar tema y guardar persistencia
  Future<void> setTheme(ThemeConfig config) async {
    // Optimización: Si es el mismo tema, no repintar
    if (_currentConfig.id == config.id) return;

    _currentConfig = config;
    notifyListeners(); // 🔔 ¡Ding! Repinten todo.
    
    // Persistir selección
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, config.id);
  }
}
