import 'package:flutter/material.dart';
import 'breakpoints.dart';

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

  /// Widget opcional para tablets (600px - 1200px).
  /// Si no se provee, se usará [mobile].
  final Widget? tablet;

  /// Widget opcional para escritorio (> 1200px).
  /// Si no se provee, se usará [tablet] si existe, o [mobile].
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= AppBreakpoints.desktop) {
          // Si tenemos diseño específico para desktop, lo usamos.
          if (desktop != null) return desktop!;
          // Si no, intentamos usar el de tablet.
          if (tablet != null) return tablet!;
        }

        if (width >= AppBreakpoints.mobile) {
          // Estamos en rango de tablet.
          if (tablet != null) return tablet!;
        }

        // Por defecto (y en móviles) devolvemos el diseño móvil.
        return mobile;
      },
    );
  }
}
