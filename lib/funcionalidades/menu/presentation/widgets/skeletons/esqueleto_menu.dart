import 'package:flutter/material.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';

/// Skeleton que imita la estructura de MenuItemCard.
class MenuSkeleton extends StatelessWidget {
  const MenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return TarjetaPremium(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
          children: [
            // Imagen Placeholder
            Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8))),
            const SizedBox(width: 12),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(width: 120, height: 16, decoration: BoxDecoration(color: Colors.grey[300])),
                   const SizedBox(height: 8),
                   Container(width: 200, height: 12, decoration: BoxDecoration(color: Colors.grey[300])),
                ],
              ),
            ),
            
            // Precio
            const SizedBox(width: 12),
            Container(width: 60, height: 30, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15))),
          ],
        ),
    );
  }
}
