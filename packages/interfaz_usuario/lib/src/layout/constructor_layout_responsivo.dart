import 'package:flutter/material.dart';
import 'puntos_de_quiebre.dart';

/// Widget constructor para diseños responsivos.
///
/// Permite definir diferentes widgets para móvil, tablet y escritorio.
/// El widget selecciona automáticamente qué mostrar basado en el ancho de la pantalla.
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Widget a mostrar en pantallas móviles (< 600px).
  final Widget mobile;

  /// Widget opcional para tablets (600px - 1024px).
  /// Si no se provee, se usará [mobile].
  final Widget? tablet;

  /// Widget opcional para escritorio (> 1024px).
  /// Si no se provee, se usará [tablet] y luego [mobile].
  final Widget? desktop;

  // --------------------------------------------------------------------------
  // 🛠️ HELPERS ESTÁTICOS DE CONSULTA
  // Permiten consultar el tipo de dispositivo desde cualquier lugar del árbol
  // sin necesidad de instanciar todo el widget ResponsiveLayoutBuilder.
  // --------------------------------------------------------------------------

  /// Retorna true si el ancho de pantalla es menor a [AppBreakpoints.tablet] (600px).
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppBreakpoints.tablet;

  /// Retorna true si es una tablet (entre 600px y 1024px).
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  }

  /// Retorna true si es escritorio (mayor o igual a 1024px).
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppBreakpoints.desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 🧠 LÓGICA DE CAÍDA EN CASCADA (Fallback Logic)
        // Intentamos usar el diseño más grande posible. Si no existe, "caemos"
        // al diseño inmediatamente inferior.

        if (width >= AppBreakpoints.desktop) {
          // Si es Desktop, usamos desktop. Si es null, probamos tablet. Si es null, mobile.
          return desktop ?? tablet ?? mobile;
        }

        if (width >= AppBreakpoints.tablet) {
          // Si es Tablet, usamos tablet. Si es null, mobile.
          return tablet ?? mobile;
        }

        // Si es menor a 600px, siempre es mobile.
        return mobile;
      },
    );
  }
}
