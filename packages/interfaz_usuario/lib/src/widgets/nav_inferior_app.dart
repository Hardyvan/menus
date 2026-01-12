import 'package:flutter/material.dart';


/// Barra de navegación inferior con estilo moderno/oscuro.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurface.withValues(alpha: 0.6));
        }),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        height: 65,
        elevation: 0,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: colorScheme.primary),
            label: 'Inicio',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: cartCount > 0 
              ? Badge(
                  label: Text('$cartCount'),
                  backgroundColor: colorScheme.error,
                  textColor: colorScheme.onError,
                  child: const Icon(Icons.shopping_cart_outlined),
                )
              : const Icon(Icons.shopping_cart_outlined),
            selectedIcon: cartCount > 0
              ? Badge(
                  label: Text('$cartCount'),
                  backgroundColor: colorScheme.error,
                  textColor: colorScheme.onError,
                  child: Icon(Icons.shopping_cart, color: colorScheme.primary),
                )
              : Icon(Icons.shopping_cart, color: colorScheme.primary),
            label: 'Carrito',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
