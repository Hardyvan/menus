import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../../autenticacion/application/proveedor_autenticacion.dart';

import '../domain/models/item_menu.dart';
import '../domain/repositories/repositorio_menu.dart';
import '../../carrito/application/proveedor_carrito.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = ['Todos', 'Entradas', 'Platos de Fondo', 'Bebidas', 'Postres'];

  // Mapeo de iconos
  final Map<String, IconData> _categoryIcons = {
    'Todos': Icons.restaurant_menu,
    'Entradas': Icons.tapas,
    'Platos de Fondo': Icons.dinner_dining,
    'Bebidas': Icons.local_bar,
    'Postres': Icons.icecream,
  };

  @override
  Widget build(BuildContext context) {
    final menuRepo = context.read<MenuRepository>();
    final isAdmin = context.watch<AuthProvider>().currentUser?.canEditMenu ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: isAdmin ? const AdminDrawer() : null, // 🍔 Menú Lateral (Solo Admin)
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: 16),
            // 1. Encabezado (Bienvenida)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenido,',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '¿Qué se te antoja hoy?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: CircleAvatar(
                          backgroundColor: AppColors.surface,
                          child: Icon(
                            isAdmin ? Icons.menu : Icons.person, // 🍔 vs 👤
                            color: AppColors.primary
                          ),
                        ),
                        onPressed: () {
                          if (isAdmin) {
                            Scaffold.of(context).openDrawer();
                          } else {
                            context.push('/profile'); // Perfil para no admins
                          }
                        },
                      );
                    }
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Buscador
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                    // Acción de búsqueda futura
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Text(
                        'Buscar platos, bebidas...',
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             const SizedBox(height: 24),

            // 3. Categorías
            SizedBox(
              height: 110, // Increased height to prevent overflow (Icon + Text)
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return CategoryAvatar(
                    label: category,
                    icon: _categoryIcons[category] ?? Icons.fastfood, // icon provided
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 4. Lista de Platos
            Expanded(
              child: FutureBuilder<List<MenuItem>>(
                future: menuRepo.getMenuItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  }

                  final allItems = snapshot.data ?? [];
                  final filteredItems = _selectedCategory == 'Todos' 
                      ? allItems 
                      : allItems.where((item) => item.category == _selectedCategory).toList();

                  if (filteredItems.isEmpty) {
                    return const Center(child: Text('No hay platos en esta categoría', style: TextStyle(color: Colors.grey)));
                  }

                  return AnimationLimiter(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _MenuItemCard(item: item),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>(); 

    return GestureDetector(
      onTap: () {
        context.push('/item', extra: item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: '${item.id}-${item.imageUrl}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(item.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (!item.isAvailable) 
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'AGOTADO', 
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '4.5',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'S/ ${item.price.toStringAsFixed(2)}',
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 20),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          onPressed: item.isAvailable ? () {
                            cart.addItem(item, 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} añadido al carrito'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AppColors.surface,
                              ),
                            );
                          } : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
