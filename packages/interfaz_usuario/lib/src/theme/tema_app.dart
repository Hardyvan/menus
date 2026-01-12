import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colores_app.dart';
import 'config_tema.dart';
import 'paletas_app.dart';
import 'extensiones_tema.dart';

/// Configuración del Tema de la Aplicación.
///
/// Provee un [ThemeData] consistente que utiliza [AppColors].
/// Cualquier cambio aquí se reflejará en toda la aplicación.
class AppTheme {
  /// Obtiene el tema claro de la aplicación.
  /// Crea un ThemeData basado en una configuración dinámica.
  static ThemeData create(ThemeConfig config) {
    final isDark = config.brightness == Brightness.dark;
    
    final colorScheme = ColorScheme(
      brightness: config.brightness,
      primary: config.primary,
      secondary: config.secondary,
      surface: config.surface,
      error: AppColors.error,
      // Usar configuración o cálculo simple de contraste
      onPrimary: config.onPrimary ?? (isDark ? Colors.black : Colors.white),
      onSecondary: config.onSecondary ?? (isDark ? Colors.black : Colors.white),
      onSurface: config.onSurface,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: config.brightness,
      primaryColor: config.primary,
      scaffoldBackgroundColor: config.background,
      colorScheme: colorScheme,

      // --- Extensiones de Dominio ---
      extensions: <ThemeExtension<dynamic>>[
        const ColoresRestaurante(
          estadoPendiente: Colors.orange,
          estadoCocinando: Colors.blue,
          estadoListo: Colors.green,
          estadoEntregado: Colors.grey,
          indicadorPicante: Colors.red,
          indicadorVegano: Colors.lightGreen,
        ),
      ],

      textTheme: GoogleFonts.outfitTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme
      ).copyWith(
        bodyLarge: TextStyle(color: config.onBackground),
        bodyMedium: TextStyle(color: config.onBackground),
        titleMedium: TextStyle(color: config.onBackground),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: config.onBackground),
        titleTextStyle: GoogleFonts.outfit(
          color: config.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
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
  static ThemeData get lightTheme => create(AppPalettes.defaultTheme);

}
