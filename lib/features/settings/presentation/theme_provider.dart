import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// Provider que gestiona el tema actual de la aplicación.
class ThemeProvider extends ChangeNotifier {
  ThemeConfig _currentConfig = AppPalettes.modernLight;

  ThemeConfig get currentConfig => _currentConfig;
  
  // Lista de Paletas Disponibles
  final List<ThemeConfig> availablePalettes = AppPalettes.all;

  ThemeData get themeData => AppTheme.create(_currentConfig);

  void setTheme(ThemeConfig config) {
    _currentConfig = config;
    notifyListeners();
  }
}
