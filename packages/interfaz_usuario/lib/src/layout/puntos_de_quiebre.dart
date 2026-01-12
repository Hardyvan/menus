/// Define los puntos de quiebre (breakpoints) para el diseño responsivo.
///
/// Estos valores determinan cuándo la interfaz cambia entre diseño móvil,
/// tablet y escritorio.
abstract class AppBreakpoints {
  /// 📱 Móvil: Hasta 600px.
  /// Cualquier ancho menor a esto se considera celular.
  static const double mobile = 600;

  ///  tablet: Desde 600px hasta 1024px.
  /// Cubre tablets en modo vertical y teléfonos plegables abiertos.
  static const double tablet = 600;

  /// 💻 Escritorio / Laptop: Desde 1024px.
  /// El estándar para laptops y tablets en modo horizontal (Landscape).
  static const double desktop = 1024;

  /// 🖥️ Pantallas Ultra Anchas: Desde 1920px.
  /// Para monitores 4K o configuraciones especiales de restaurante.
  static const double ultraWide = 1920;
}
