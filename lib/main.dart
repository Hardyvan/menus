import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menus/funcionalidades/carrito/application/proveedor_carrito.dart';
import 'package:menus/rutas/enrutador_app.dart';
import 'package:menus/funcionalidades/configuracion/presentation/proveedor_tema.dart';
import 'package:menus/funcionalidades/menu/domain/repositories/repositorio_menu.dart';
import 'package:menus/funcionalidades/menu/data/repositories/mock_repositorio_menu.dart';
import 'package:menus/core/red/cliente_dio.dart';
import 'package:menus/funcionalidades/gestion/inventario/domain/repositories/repositorio_inventario.dart';
import 'package:menus/funcionalidades/gestion/inventario/data/repositories/mock_repositorio_inventario.dart';
import 'package:menus/funcionalidades/gestion/finanzas/domain/repositories/repositorio_finanzas.dart';
import 'package:menus/funcionalidades/gestion/finanzas/data/repositories/mock_repositorio_finanzas.dart';
import 'package:menus/funcionalidades/gestion/facturacion/domain/repositories/repositorio_facturacion.dart';
import 'package:menus/funcionalidades/gestion/facturacion/data/repositories/mock_repositorio_facturacion.dart';
import 'package:menus/funcionalidades/pedidos/domain/repositories/repositorio_pedido.dart';
import 'package:menus/funcionalidades/pedidos/data/repositories/mock_repositorio_pedido.dart';
import 'package:menus/funcionalidades/gestion/inventario/application/proveedor_inventario.dart';
import 'package:menus/funcionalidades/autenticacion/application/proveedor_autenticacion.dart';
import 'package:menus/funcionalidades/usuarios/domain/repositories/repositorio_usuario.dart';
import 'package:menus/funcionalidades/usuarios/data/repositories/mock_repositorio_usuario.dart';

// 💡 PUNTO DE ENTRADA: Aquí comienza la magia.
// 💡 PUNTO DE ENTRADA: Aquí comienza la magia.
void main() async {
  // 1. Aseguramos que el motor de Flutter esté listo antes de usar plugins async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Pre-Carga del Tema (Evita el "flashbang" blanco)
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // 3. Inflamos la aplicación con el tema ya cargado
  runApp(RestaurantApp(themeProvider: themeProvider));
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    // 💉 INYECCIÓN DE DEPENDENCIAS (MultiProvider)
    // Aquí "inyectamos" los cerebros de la app (Repositorios y Providers)
    // para que estén disponibles en TODAS las pantallas de abajo.
    return MultiProvider(
      providers: [
        // 📦 Repositorios: Se encargan de buscar datos (Data Layer)
        // Usamos "Mock" (Falsos) por ahora, luego cambiaremos a implementaciones reales.
        Provider<MenuRepository>(create: (_) => MockMenuRepository()),
        Provider<InventoryRepository>(create: (_) => MockInventoryRepository()),
        Provider<FinanceRepository>(create: (_) => MockFinanceRepository()),
        Provider<BillingRepository>(create: (_) => MockBillingRepository()),
        Provider<PedidoRepository>(create: (_) => MockPedidoRepository()), // Repository de Pedidos
        Provider<UserRepository>(create: (_) => MockUserRepository()), // 👥 Repository de Usuarios (Nuevo)
        
        // 🌐 Globales
        Provider<DioClient>(create: (_) => DioClient()), // Cliente para peticiones HTTP

        // 🧠 Providers (Lógica de Estado): Manejan la lógica viva de la UI
        ChangeNotifierProvider(create: (_) => AuthProvider()), // 🔐 Autenticación
        ChangeNotifierProvider(create: (_) => CartProvider()), // Estado del Carrito
        ChangeNotifierProvider(create: (ctx) => InventoryProvider(ctx.read<InventoryRepository>())), // 📦 Inventario
        
        // Usamos .value porque ya instanciamos el ThemeProvider en main()
        ChangeNotifierProvider.value(value: themeProvider), 
      ],
      // 🎨 CONSUMER: Escuchamos cambios en el Tema para repintar la app completa
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData, // ¡Aquí el tema cambia dinámicamente!
            routerConfig: appRouter, // Nuestro mapa de navegación
          );
        },
      ),
    );
  }
}
