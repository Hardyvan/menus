import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'theme_config.dart';
import 'app_palettes.dart';

/// Configuración del Tema de la Aplicación.
///
/// Provee un [ThemeData] consistente que utiliza [AppColors].
/// Cualquier cambio aquí se reflejará en toda la aplicación.
class AppTheme {
  /// Obtiene el tema claro de la aplicación.
  /// Crea un ThemeData basado en una configuración dinámica.
  static ThemeData create(ThemeConfig config) {
    final isDark = config.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: config.brightness,
      primaryColor: config.primary,
      scaffoldBackgroundColor: config.background,
      
      colorScheme: ColorScheme(
        brightness: config.brightness,
        primary: config.primary,
        secondary: config.secondary,
        surface: config.surface,
        error: AppColors.error,
        onPrimary: isDark ? AppColors.onPrimary : Colors.white,
        onSecondary: isDark ? Colors.black : Colors.white,
        onSurface: config.onSurface,
        onError: Colors.white,
        background: config.background,
        onBackground: config.onBackground,
      ),

      textTheme: GoogleFonts.outfitTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme
      ).apply(
        bodyColor: config.onBackground,
        displayColor: config.onBackground,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      cardTheme: CardTheme(
        color: config.surface,
        elevation: 0, // Flat en dark mode se ve mejor
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Deprecado: Usar ThemeProvider
  static ThemeData get lightTheme => create(AppPalettes.defaultDark);

}
