import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              shape: BoxShape.circle,
              border: isSelected 
                ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 4)
                : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
