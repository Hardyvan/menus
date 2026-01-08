import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/menu_item.dart';
import '../domain/repositories/menu_repository.dart';
import '../../cart/application/cart_provider.dart';
import '../../settings/presentation/theme_provider.dart';
import 'widgets/menu_item_card.dart';

/// Pantalla Principal del Menú (Refactorizada).
/// Ahora usa un diseño vertical por secciones estilo "App de Delivery".
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.select<CartProvider, int>((p) => p.itemCount);
    // Accedemos al repositorio inyectado
    final menuRepository = context.read<MenuRepository>();

    // Eliminamos Scaffold anidado para evitar conflictos de Layout con el Drawer principal
    return FutureBuilder<List<List<MenuItem>>>(
        // Hacemos carga paralela de "Trending" y "Ofertas"
        future: Future.wait([
          menuRepository.getTrendingItems(),
          menuRepository.getSpecialOffers(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error cargando menú: ${snapshot.error}'));
          }

          final trendingItems = snapshot.data?[0] ?? [];
          final specialOffers = snapshot.data?[1] ?? [];

          return CustomScrollView(
            slivers: [
              // ... Header y AppBar (Igual que antes) ...
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dinámico
                surfaceTintColor: Colors.transparent,
                floating: true,
                // title: Row de dirección
                title: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Entregar en', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)), // Dinámico
                        Text('Casa - Calle 123', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.palette_outlined),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final provider = context.read<ThemeProvider>();
                          return ThemeSelectorModal(
                            currentThemeId: provider.currentConfig.id,
                            availableThemes: provider.availablePalettes,
                            onThemeSelected: (config) {
                              provider.setTheme(config);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                  if (cartItemCount > 0)
                     Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, // Dinámico
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text('$cartItemCount', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                     ),
                ],
              ),

              // 1. Sección "Trending Now"
              const SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Trending Now',
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = trendingItems[index];
                      return SizedBox(
                        width: 200,
                        child: MenuItemCard(
                          item: item,
                          onTap: () => _navigateToDetail(context, item),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. Sección "Popular Categories" (Estática por ahora, podría venir de repo)
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Popular Categories',
                  icon: Icons.auto_awesome, 
                  iconColor: Colors.yellow,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryAvatar(label: 'Pizza', icon: Icons.local_pizza, isSelected: true),
                      const SizedBox(width: 20),
                      CategoryAvatar(label: 'Burger', icon: Icons.lunch_dining),
                      const SizedBox(width: 20),
                      CategoryAvatar(label: 'Asian', icon: Icons.rice_bowl),
                      const SizedBox(width: 20),
                      CategoryAvatar(label: 'Dessert', icon: Icons.icecream),
                      const SizedBox(width: 20),
                      CategoryAvatar(label: 'Drinks', icon: Icons.local_bar),
                    ],
                  ),
                ),
              ),

              // 3. Sección "Special Offers"
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Special Offers',
                  icon: Icons.percent,
                  iconColor: AppColors.error,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                       final item = specialOffers[index];
                       return _SpecialOfferCard(item: item, onTap: () => _navigateToDetail(context, item));
                    },
                    childCount: specialOffers.length,
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      );
  }

  void _navigateToDetail(BuildContext context, MenuItem item) {
    context.push('/item', extra: item);
  }
}

/// Tarjeta horizontal compacta para ofertas ("Special Offers")
class _SpecialOfferCard extends StatelessWidget {
  const _SpecialOfferCard({required this.item, this.onTap});
  final MenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Hero(
            tag: item.title,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                  child: const Text('-30%', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
                Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                const SizedBox(height: 4),
                Text('S/ ${(item.price * 0.7).toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
