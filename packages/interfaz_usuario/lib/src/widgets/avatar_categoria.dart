import 'package:flutter/material.dart';


/// Widget circular que representa una categoría (ej. Hamburguesas, Pizza).
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 💡 Usamos el tema actual en lugar de colores fijos
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              // El color cambia dinámicamente según la paleta seleccionada (Purple, Green, etc.)
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.5),
                      width: 4,
                    )
                  : null,
            ),
            child: Icon(
              icon,
              // Contraste automático: blanco sobre primario, gris sobre superficie
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
