import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import '../menu/presentation/menu_screen.dart';
import '../cart/presentation/cart_screen.dart';
import 'package:provider/provider.dart';
import '../settings/presentation/theme_provider.dart';

/// Pantalla Principal que contiene la barra de navegación.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MenuScreen(), // Home
    const Center(child: Text('Search (Próximamente)')),
    const CartScreen(), // Cart
    const Center(child: Text('Profile (Próximamente)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dinámico
      drawer: const AdminDrawer(), // Acceso al panel administrativo
// appBar: Removed to allow children screens to handle their own headers
      // and integrated with the main Scaffold's drawer.
body: _screens[_currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
