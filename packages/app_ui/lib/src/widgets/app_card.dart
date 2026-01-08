import 'package:flutter/material.dart';

/// Una tarjeta base para contener información.
///
/// Provee elevación (sombra), bordes redondeados y padding estándar.
/// Ideal para mostrar ítems de menú o información agrupada.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  /// El contenido de la tarjeta.
  final Widget child;

  /// Padding interno opcional. Si es null, se usa el default (16).
  final EdgeInsetsGeometry? padding;

  /// Acción opcional al tocar la tarjeta (la hace interactiva).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: child,
    );

    return Card(
      margin: EdgeInsets.zero, // El margen lo controla el padre si es necesario
      clipBehavior: Clip.antiAlias, // Para asegurar que los hijos respeten los bordes
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: cardContent,
            )
          : cardContent,
    );
  }
}
