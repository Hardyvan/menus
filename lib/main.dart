import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import 'package:menus/features/auth/presentation/login_screen.dart'; // Mantener como referencia si es necesario
import 'package:menus/features/cart/application/cart_provider.dart';
import 'package:menus/router/app_router.dart';
import 'package:menus/features/settings/presentation/theme_provider.dart';
import 'package:menus/features/menu/domain/repositories/menu_repository.dart';
import 'package:menus/features/menu/data/repositories/mock_menu_repository.dart';
import 'package:menus/features/management/inventory/domain/repositories/inventory_repository.dart';
import 'package:menus/features/management/inventory/data/repositories/mock_inventory_repository.dart';
import 'package:menus/features/management/finance/domain/repositories/finance_repository.dart';
import 'package:menus/features/management/finance/data/repositories/mock_finance_repository.dart';
import 'package:menus/features/management/billing/domain/repositories/billing_repository.dart';
import 'package:menus/features/management/billing/data/repositories/mock_billing_repository.dart';

void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MenuRepository>(create: (_) => MockMenuRepository()),
        Provider<InventoryRepository>(create: (_) => MockInventoryRepository()),
        Provider<FinanceRepository>(create: (_) => MockFinanceRepository()),
        Provider<BillingRepository>(create: (_) => MockBillingRepository()), // Repository de Facturación
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData, // Usar tema dinámico
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
