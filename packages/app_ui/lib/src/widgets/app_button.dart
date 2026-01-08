import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Un botón personalizado que sigue el diseño de la aplicación.
///
/// Este botón envuelve [ElevatedButton] para proveer estilos consistentes.
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
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // Usamos el color primario de nuestra paleta
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              // Spinner de carga de color blanco
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
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
