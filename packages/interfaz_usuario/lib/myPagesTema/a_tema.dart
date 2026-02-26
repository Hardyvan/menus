import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================
// 1. THEME EXTENSION (PALETA DE ESTADOS CORPORATIVOS)
// =============================================================================
@immutable
class InsoftColors extends ThemeExtension<InsoftColors> {
  final Color? estadoPendiente;
  final Color? estadoPagado;
  final Color? estadoDeudor;
  final Color? kanbanHaciendo;
  final Color? kanbanHecho;

  const InsoftColors({
    required this.estadoPendiente,
    required this.estadoPagado,
    required this.estadoDeudor,
    required this.kanbanHaciendo,
    required this.kanbanHecho,
  });

  @override
  InsoftColors copyWith({Color? estadoPendiente, Color? estadoPagado, Color? estadoDeudor, Color? kanbanHaciendo, Color? kanbanHecho}) {
    return InsoftColors(
      estadoPendiente: estadoPendiente ?? this.estadoPendiente,
      estadoPagado: estadoPagado ?? this.estadoPagado,
      estadoDeudor: estadoDeudor ?? this.estadoDeudor,
      kanbanHaciendo: kanbanHaciendo ?? this.kanbanHaciendo,
      kanbanHecho: kanbanHecho ?? this.kanbanHecho,
    );
  }

  @override
  InsoftColors lerp(ThemeExtension<InsoftColors>? other, double t) {
    if (other is! InsoftColors) return this;
    return InsoftColors(
      estadoPendiente: Color.lerp(estadoPendiente, other.estadoPendiente, t),
      estadoPagado: Color.lerp(estadoPagado, other.estadoPagado, t),
      estadoDeudor: Color.lerp(estadoDeudor, other.estadoDeudor, t),
      kanbanHaciendo: Color.lerp(kanbanHaciendo, other.kanbanHaciendo, t),
      kanbanHecho: Color.lerp(kanbanHecho, other.kanbanHecho, t),
    );
  }

  // MODO CLARO
  static const light = InsoftColors(
    estadoPendiente: Color(0xFFFF9900), 
    estadoPagado:    Color(0xFF2E7D32), 
    estadoDeudor:    Color(0xFFC62828), 
    kanbanHaciendo:  Color(0xFF1565C0), 
    kanbanHecho:     Color(0xFF6A1B9A), 
  );

  // MODO OSCURO 
  static const dark = InsoftColors(
    estadoPendiente: Color(0xFFFFB74D), 
    estadoPagado:    Color(0xFF66BB6A), 
    estadoDeudor:    Color(0xFFEF5350), 
    kanbanHaciendo:  Color(0xFF42A5F5), 
    kanbanHecho:     Color(0xFFAB47BC), 
  );
}

// =============================================================================
// 2. PALETA BASE Y CONSTANTES (EXTRAÍDA DEL LOGO Y DISEÑO PREMIUM)
// =============================================================================
class AppTokens {
  static const double radioMedio = 12.0;
  static const double radioGrande = 20.0;
  static const double paddingEstandar = 20.0;

  static const Color darkBg = Color(0xFF121E2A);      
  static const Color lightBg = Color(0xFFF5F7FA);     

  // Sombra suave universal para fondos claros
  static final List<BoxShadow> sombraSuave = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: -5,
    ),
  ];
}

// Wrapper de compatibilidad y variables de UI estáticas
class ColoresApp {
  static const Color fondoClaro = AppTokens.lightBg;
  static const Color fondoOscuro = AppTokens.darkBg;
  
  static List<BoxShadow> get sombraSuave => AppTokens.sombraSuave;
  static const Color fondo = AppTokens.lightBg;

  static const Color exito = Color(0xFF2E7D32); 
  static const Color error = Color(0xFFC62828); 

  static const Color superficieClara = Color(0xFFFFFFFF);
  static const Color superficieOscura = Color(0xFF1C2A38); 

  static const Color textoSecundarioClaro = Color(0xFF546E7A); 
  static const Color textoOscuro = Color(0xFFECEFF1); 
}

class DimensionesApp {
  static const double radioMedio = AppTokens.radioMedio;
  static const double radioGrande = AppTokens.radioGrande;
  static const double paddingEstandar = AppTokens.paddingEstandar;
}

// =============================================================================
// 3. CONFIGURACIÓN DINÁMICA DE TEMA (MODIFICANDO LA PALETA PROFESIONAL)
// =============================================================================
class ThemeConfig {
  final Brightness brightness;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color onBackground;
  
  // Opcionales para overrides manuales
  final Color? onPrimary;
  final Color? onSecondary;
  final Color? onSurface;

  const ThemeConfig({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.onBackground,
    this.onPrimary,
    this.onSecondary,
    this.onSurface,
  });

  bool get isDark => brightness == Brightness.dark;
}

// Catálogo de configuraciones predefinidas
class AppPalettes {
  static const Color defaultPrimary = Color(0xFF003366); // brandBlue
  static const Color defaultSecondary = Color(0xFFFF9900); // brandOrange

  static ThemeConfig light({Color primary = defaultPrimary, Color secondary = defaultSecondary}) {
    return ThemeConfig(
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      background: AppTokens.lightBg,
      surface: ColoresApp.superficieClara,
      onBackground: const Color(0xFF1F2937),
    );
  }

  static ThemeConfig dark({Color primary = const Color(0xFF64B5F6), Color secondary = defaultSecondary}) {
    return ThemeConfig(
      brightness: Brightness.dark,
      primary: primary,
      secondary: secondary,
      background: AppTokens.darkBg,
      surface: ColoresApp.superficieOscura,
      onBackground: ColoresApp.textoOscuro,
    );
  }
}

// =============================================================================
// 4. TEMA APP (CONSTRUCTOR DINÁMICO)
// =============================================================================
class TemaApp {
  
  /// Genera un ThemeData completo y profesional basado en nuestro ThemeConfig dinámico.
  static ThemeData obtenerTema(ThemeConfig config) {
    final isDark = config.isDark;
    
    // Extensión corporativa
    final extensionColores = isDark ? InsoftColors.dark : InsoftColors.light;
    
    // Contenedores suavizados basados en el primario elegido
    final primaryContainer = isDark ? config.primary.withValues(alpha: 0.2) : config.primary.withValues(alpha: 0.1);
    final onPrimaryContainer = isDark ? config.onBackground : config.primary;

    // Base M3
    final baseTheme = isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      scaffoldBackgroundColor: config.background,
      extensions: [extensionColores],
      visualDensity: VisualDensity.standard,

      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(
        color: isDark ? Colors.white70 : config.primary,
        size: 24,
      ),

      cardColor: config.surface,

      colorScheme: ColorScheme.fromSeed(
        seedColor: config.primary,
        brightness: config.brightness,
        primary: config.primary,
        secondary: config.secondary,
        surface: config.surface,
        onSurface: config.onBackground, 
        error: ColoresApp.error,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
      ),

      // -----------------------------------------------------------------------
      // TIPOGRAFÍA
      // -----------------------------------------------------------------------
      textTheme: baseTheme.textTheme.apply(
        fontFamily: 'Inter',
        bodyColor: config.onBackground,
        displayColor: config.onBackground,
      ).copyWith(
        displayLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, letterSpacing: -0.5, color: config.onBackground),
        headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, letterSpacing: -0.5, color: config.onBackground),
        titleLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, color: config.onBackground),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: config.onBackground),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: config.onBackground),
        labelLarge: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600),
      ),

      // -----------------------------------------------------------------------
      // INPUTS
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF273444) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(
          color: config.onBackground.withValues(alpha: 0.5),
          fontFamily: 'Inter',
        ),
        suffixIconColor: isDark ? Colors.white70 : Colors.black54,
        floatingLabelStyle: TextStyle(
            color: config.secondary,
            fontWeight: FontWeight.w600
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : config.primary.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          borderSide: BorderSide(color: config.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1),
        ),
      ),

      // -----------------------------------------------------------------------
      // BOTONES
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: config.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          ),
          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : config.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: isDark ? Colors.white24 : config.primary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          ),
          textStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // -----------------------------------------------------------------------
      // TARJETAS Y DIÁLOGOS
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        color: config.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          side: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 12),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: config.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radioGrande)),
        titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? Colors.white : config.primary
        ),
      ),

      // -----------------------------------------------------------------------
      // DETALLES FINOS
      // -----------------------------------------------------------------------
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: config.secondary,
        selectionColor: config.secondary.withValues(alpha: 0.3),
        selectionHandleColor: config.secondary,
      ),

      // Status Bar gestionada por el Tema
      appBarTheme: AppBarTheme(
        backgroundColor: config.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : config.primary),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: isDark ? Colors.white : config.primary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }
}

// =============================================================================
// 5. PROVIDER DINÁMICO UNIFICADO
// =============================================================================
class ProveedorTema extends ChangeNotifier {
  ThemeMode _modoTema = ThemeMode.system;
  ThemeMode get modoTema => _modoTema;
  
  // Soporte para cambiar el color primario dinámicamente
  Color _colorSeleccionado = AppPalettes.defaultPrimary;
  Color get colorSeleccionado => _colorSeleccionado;

  void cambiarTema(bool esOscuro) {
    _modoTema = esOscuro ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  
  void cambiarColorPrimario(Color nuevoColor) {
    _colorSeleccionado = nuevoColor;
    notifyListeners();
  }
  
  // Obtiene el ThemeConfig resolviendo el color dinámico y el brillo
  ThemeConfig get configActual {
    bool esOscuro = _modoTema == ThemeMode.dark; 
    
    return esOscuro 
        ? AppPalettes.dark(primary: _colorSeleccionado)
        : AppPalettes.light(primary: _colorSeleccionado);
  }
}
