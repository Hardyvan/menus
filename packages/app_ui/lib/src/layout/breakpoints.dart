/// Define los puntos de quiebre (breakpoints) para el diseño responsivo.
///
/// Estos valores determinan cuándo la interfaz cambia entre diseño móvil,
/// tablet y escritorio.
abstract class AppBreakpoints {
  /// Ancho máximo para considerar un dispositivo como Móvil.
  /// Cualquier ancho menor a 600px es móvil.
  static const double mobile = 600;

  /// Ancho máximo para considerar un dispositivo como Tablet.
  /// Cualquier ancho entre 600px y 1200px es tablet.
  static const double tablet = 1200;

  /// Si es mayor a 1200px, se considera Escritorio (Desktop).
  static const double desktop = 1200;
}
