import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Un widget que aplica un efecto de "esqueleto cargando" (Shimmer) a su hijo.
///
/// Se adapta automáticamente al tema (Dark/Light).
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }

  /// Crea un bloque rectangular simple para usar como placeholder.
  static Widget rect({
    double? width,
    double? height,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // El color base del container es irrelevante por el Shimmer
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
