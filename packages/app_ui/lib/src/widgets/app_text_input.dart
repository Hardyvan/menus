import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Un campo de texto estilizado para uso general en la app.
///
/// Incluye soporte para etiquetas, validación y texto oculto (password).
class AppTextInput extends StatelessWidget {
  const AppTextInput({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  /// La etiqueta que describe el campo (ej. "Correo Electrónico").
  final String label;

  /// Controlador para manejar el texto del input.
  final TextEditingController? controller;

  /// Si el texto debe estar oculto (para contraseñas).
  final bool obscureText;

  /// El tipo de teclado a mostrar (ej. numérico, email).
  final TextInputType? keyboardType;

  /// Función para validar el contenido del campo.
  final String? Function(String?)? validator;

  /// Callback que se ejecuta cuando el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Icono opcional al inicio del campo.
  final IconData? prefixIcon;

  /// Widget opcional al final del campo (ej. botón de ocultar contraseña).
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), // Dinámico
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Theme.of(context).cardColor, // Dinámico
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2), // Dinámico
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
