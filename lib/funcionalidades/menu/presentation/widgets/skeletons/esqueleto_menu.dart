import 'package:flutter/material.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';

/// Skeleton que imita la estructura de MenuItemCard.
class MenuSkeleton extends StatelessWidget {
  const MenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: AppShimmer(
        child: Row(
          children: [
            // Imagen Placeholder
            AppShimmer.rect(width: 50, height: 50, borderRadius: 8),
            const SizedBox(width: 12),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   AppShimmer.rect(width: 120, height: 16),
                   const SizedBox(height: 8),
                   AppShimmer.rect(width: 200, height: 12),
                ],
              ),
            ),
            
            // Precio
            const SizedBox(width: 12),
            AppShimmer.rect(width: 60, height: 30, borderRadius: 15),
          ],
        ),
      ),
    );
  }
}
