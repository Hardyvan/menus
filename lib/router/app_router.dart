import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/menu/presentation/item_detail_screen.dart';
import '../features/menu/domain/models/menu_item.dart';
import '../features/management/inventory/presentation/inventory_screen.dart';
import '../features/management/finance/presentation/cash_flow_screen.dart';
import '../features/management/billing/presentation/billing_screen.dart';


/// Configuración principal de rutas.
final appRouter = GoRouter(
  initialLocation: '/login', // Iniciar en el Login
  routes: [
    // Ruta de Login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Ruta Principal (Home con BottomNav)
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Rutas anidadas o sub-rutas si fueran necesarias
      ],
    ),

    // Ruta de Carrito (Si se quiere acceder como pantalla completa aparte del tab)
    GoRoute(
      path: '/cart-full',
      builder: (context, state) => const CartScreen(),
    ),

    // Detalle del Item
    // Se pasa el objeto MenuItem completo vía 'extra'
    GoRoute(
      path: '/item',
      builder: (context, state) {
        final item = state.extra as MenuItem;
        return ItemDetailScreen(item: item);
      },
    ),

    // Rutas Administrativas (ERP)
    GoRoute(
      path: '/admin/inventory',
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: '/admin/finance',
      builder: (context, state) => const CashFlowScreen(),
    ),
    GoRoute(
      path: '/admin/billing',
      builder: (context, state) => const BillingScreen(),
    ),
  ],
);

