import 'package:flutter/material.dart';


/// 🧱 WIDGET REUTILIZABLE (Wrapper Pattern)
///
/// En lugar de usar `ElevatedButton` en todas las pantallas y repetir estilos,
/// creamos nuestro propio botón (`AppButton`).
///
/// Ventajas:
/// 1. Consistencia: Si cambiamos el radio del borde aquí, cambia en TODA la app.
/// 2. Simplicidad: Es más fácil escribir `AppButton(text: 'Hola')` que configurar un ElevatedButton gigante.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  /// El texto a mostrar en el botón.
  final String text;

  /// La acción a ejecutar al presionar el botón.
  final VoidCallback? onPressed;

  /// Si es true, muestra un indicador de carga en lugar del texto.
  final bool isLoading;

  /// Icono opcional para mostrar antes del texto.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // 🎨 Usamos el color primario del tema actual (dinámico)
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary, // Color del texto/icono
        disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              // Spinner de carga con el color "onPrimary" (generalmente blanco)
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
