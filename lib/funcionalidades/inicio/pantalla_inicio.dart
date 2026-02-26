import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importamos el CartProvider para escuchar cambios en el carrito
import '../carrito/application/proveedor_carrito.dart';
import '../menu/presentation/pantalla_menu.dart';
import '../carrito/presentation/pantalla_carrito.dart';
import '../busqueda/presentation/pantalla_busqueda.dart';
import '../perfil/presentation/pantalla_perfil.dart';

/// Pantalla Principal que contiene la barra de navegación.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🧭 ÍNDICE DE NAVEGACIÓN
  // 0: Menú, 1: Buscar, 2: Carrito, 3: Perfil
  int _currentIndex = 0;

  // 🧱 PANTALLAS (Persistentes)
  // Las declaramos final para que el IndexedStack no las reconstruya innecesariamente.
  final List<Widget> _screens = const [
    MenuScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 🛒 Escuchamos el estado del carrito
    // Usamos .watch porque necesitamos reconstruir el FAB y el Badge cuando cambien los items.
    final cart = context.watch<CartProvider>();
    final hasItems = cart.items.isNotEmpty;
    final theme = Theme.of(context);

    // 🛡️ PROTECTOR DE SALIDA (PopScope)
    // Intercepta el botón "Atrás" de Android.
    // Evita que el usuario cierre la app por error, comportamiento típico de modo "Kiosco".
    return PopScope(
      canPop: false, // Bloqueamos la salida directa
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Si no estamos en el Home (tab 0), volver al Home
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return;
        }

        // Mensaje de estabilidad
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔒 La app está protegida. Usa "Cerrar Sesión" en Perfil para salir.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const Drawer(), // 🔐 Idealmente restringir por rol
        
        // ⚡ OPTIMIZACIÓN DE MEMORIA (IndexedStack)
        // Mantiene vivas todas las pantallas. Si scrolleas en el Menú y vas al Perfil,
        // al volver al Menú seguirás donde te quedaste.
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        
        // 🔮 FAB DINÁMICO
        // Solo aparece si estás en el Menú (Index 0) Y tienes cosas en el carrito.
        floatingActionButton: (_currentIndex == 0 && hasItems)
            ? FloatingActionButton.extended(
                onPressed: () {
                  // Navegar al Carrito (Index 2) para confirmar
                  setState(() => _currentIndex = 2);
                },
                backgroundColor: theme.primaryColor,
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'CONFIRMAR PEDIDO',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : null,
            
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menú'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
            NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Carrito'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
