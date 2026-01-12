import 'package:go_router/go_router.dart';
import '../funcionalidades/autenticacion/presentation/pantalla_login.dart';
import '../funcionalidades/inicio/pantalla_inicio.dart';
import '../funcionalidades/carrito/presentation/pantalla_carrito.dart';
import '../funcionalidades/menu/presentation/pantalla_detalle_item.dart';
import '../funcionalidades/menu/domain/models/item_menu.dart';
import '../funcionalidades/gestion/inventario/presentation/pantalla_inventario.dart';
import '../funcionalidades/gestion/finanzas/presentation/pantalla_flujo_caja.dart';
import '../funcionalidades/gestion/facturacion/presentation/pantalla_facturacion.dart';
import '../funcionalidades/cocina/presentation/pantalla_cocina.dart';
import '../funcionalidades/menu/presentation/admin/pantalla_gestion_menu.dart';
import '../funcionalidades/menu/presentation/admin/pantalla_crear_editar_plato.dart';
import '../funcionalidades/usuarios/presentation/pantalla_gestion_usuarios.dart';

/// 🗺️ MAPA DE NAVEGACIÓN (Router)
/// Aquí definimos todas las URLs posibles de la aplicación.
/// GoRouter se encarga de cambiar la pantalla sin perder el historial.
final appRouter = GoRouter(
  initialLocation: '/login', // 🚦 Semáforo en rojo: Empezamos preguntando contraseña
  routes: [
    // 🔐 LOGIN
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // 🏠 HOME (Shell/Contenedor Principal)
    // Es la ruta raíz '/' que contiene la barra de navegación inferior.
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Aquí podríamos poner rutas hijas que mantengan el BottomNav visible
      ],
    ),

    // 🛒 PANTALLAS INDEPENDIENTES (Sin BottomNav)
    // El carrito a pantalla completa
    GoRoute(
      path: '/cart-full',
      builder: (context, state) => const CartScreen(),
    ),

    // 🍽️ DETALLE DE PRODUCTO
    // 'state.extra' es como una mochila donde pasamos el objeto 'MenuItem'
    GoRoute(
      path: '/item',
      builder: (context, state) {
        final item = state.extra as MenuItem; // 🎒 Sacamos el item de la mochila
        return ItemDetailScreen(item: item);
      },
    ),

    // 👷 ZONA ADMINISTRATIVA (ERP)
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
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const ManageUsersScreen(),
    ),
    
    // 👨‍🍳 COCINA (KDS)
    GoRoute(
      path: '/kitchen',
      builder: (context, state) => const CocinaScreen(),
    ),

    // 📝 GESTIÓN DE MENÚ (CRUD)
    GoRoute(
      path: '/admin/menu',
      builder: (context, state) => const ManageMenuScreen(),
      routes: [
        // Sub-rutas para Crear/Editar
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateEditDishScreen(),
        ),
        GoRoute(
          path: 'edit',
          builder: (context, state) {
            final item = state.extra as MenuItem;
            return CreateEditDishScreen(item: item);
          },
        ),
      ],
    ),
  ],
);

