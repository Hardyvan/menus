import 'package:flutter/material.dart';

/// Define la paleta de colores de la aplicación.
///
/// Usamos constates estáticas para definir los colores primarios, secundarios,
/// y de superficie. Esto facilita cambiar el aspecto visual de toda la app
/// desde un solo lugar.
abstract class AppColors {
  /// Color primario: Naranja Fuego/Brillante (Trending/Acción)
  static const Color primary = Color(0xFFFF5722); 

  /// Color secundario: Amarillo/Dorado (Estrellas/Ofertas)
  static const Color secondary = Color(0xFFFFC107);

  /// Color de fondo principal: Casi negro
  static const Color background = Color(0xFF121212);

  /// Color de superficie: Gris oscuro (Tarjetas)
  static const Color surface = Color(0xFF1E1E1E);

  /// Color para errores.
  static const Color error = Color(0xFFCF6679);

  /// Color para texto principal (Blanco/Gris claro).
  static const Color onBackground = Color(0xFFEEEEEE);

  /// Color para texto en elementos primarios.
  static const Color onPrimary = Colors.white;
  
  /// Color para texto secundario (Gris medio).
  static const Color textSecondary = Color(0xFF9E9E9E);
}
