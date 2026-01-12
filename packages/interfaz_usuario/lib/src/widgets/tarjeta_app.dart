import 'package:flutter/material.dart';

/// Una tarjeta base para contener información.
///
/// Provee elevación (sombra), bordes redondeados y padding estándar.
/// Ideal para mostrar ítems de menú o información agrupada.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.padding,
    this.onTap,
  });

  /// El contenido principal de la tarjeta.
  final Widget child;

  /// 🧱 SLOT: Contenido opcional para la parte superior (ej. Imagen).
  /// Se renderiza SIN padding para ocupar todo el ancho.
  final Widget? header;

  /// 🧱 SLOT: Contenido opcional para la parte inferior (ej. Botones de acción).
  final Widget? footer;

  /// Padding interno para el [child]. Si es null, se usa el default (16).
  final EdgeInsetsGeometry? padding;

  /// Acción opcional al tocar la tarjeta (la hace interactiva).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Construimos el contenido compuesto
    // 💡 Patrón de Composición: Header + Body + Footer
    final cardBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupar todo el ancho
      mainAxisSize: MainAxisSize.min, // Ajustarse al contenido
      children: [
        if (header != null) header!,
        Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
        if (footer != null) footer!,
      ],
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias, // Recorta el header/footer si se salen
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Valor por defecto consistente
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: cardBody,
            )
          : cardBody,
    );
  }
}
