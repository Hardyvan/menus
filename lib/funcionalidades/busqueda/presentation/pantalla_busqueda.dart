import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Asegúrate de que este paquete exporte ResponsiveLayoutBuilder
import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:go_router/go_router.dart'; // Unused

import '../../menu/domain/models/item_menu.dart';
import '../../menu/domain/repositories/repositorio_menu.dart';
import '../../menu/presentation/widgets/tarjeta_item_menu.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Datos
  List<MenuItem> _allItems = [];
  List<MenuItem> _filteredItems = [];
  List<String> _categories = ['Todos'];
  
  // Estado
  bool _isLoading = true;
  String _selectedCategory = 'Todos';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadItems();
    // 🚀 OPTIMIZACIÓN: Debouncing
    // No filtramos en cada tecla, esperamos a que el usuario termine de escribir.
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final repo = context.read<MenuRepository>();
    final items = await repo.getMenuItems();
    
    // Extraer categorías únicas
    final categorySet = <String>{'Todos'};
    for (var item in items) {
      categorySet.add(item.category);
    }

    if (mounted) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _categories = categorySet.toList();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _filterItems);
  }

  // 🧠 Utilitario de Normalización (ignora acentos y mayúsculas)
  String _normalize(String text) {
    return text.toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  void _filterItems() {
    final query = _normalize(_searchController.text);
    
    setState(() {
      _filteredItems = _allItems.where((item) {
        // 1. Filtro por Categoría
        if (_selectedCategory != 'Todos' && item.category != _selectedCategory) {
          return false;
        }

        // 2. Filtro por Texto (Inteligente)
        if (query.isEmpty) return true;

        return _normalize(item.name).contains(query) ||
               _normalize(item.description).contains(query);
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterItems(); // Filtrar inmediatamente al cambiar categoría
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------------
            // 1. HEADER & SEARCH
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   AppTextInput(
                    controller: _searchController,
                    label: 'Buscar platos, bebidas, postres...',
                    prefixIcon: Icons.search,
                    backgroundColor: theme.cardColor,
                  ),
                  const SizedBox(height: 16),
                  
                  // 🏷️ CHIPS DE CATEGORÍA
                  if (!_isLoading)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = cat == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => _onCategorySelected(cat),
                              selectedColor: theme.colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: isSelected 
                                  ? theme.colorScheme.onPrimaryContainer 
                                  : theme.colorScheme.onSurface,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            
            // ----------------------------------------------------------
            // 2. RESULTADOS (Responsive)
            // ----------------------------------------------------------
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty 
                  ? _buildEmptyState(theme)
                  : AnimationLimiter(
                      child: ResponsiveLayoutBuilder(
                        // 📱 MÓVIL: Lista Vertical
                        mobile: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: MenuItemCard(item: _filteredItems[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        // 💻 TABLET/DESKTOP: Grid
                        tablet: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columnas en tablet
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8, // Ajuste para tarjetas
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              columnCount: 2,
                              duration: const Duration(milliseconds: 375),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: MenuItemCard(item: _filteredItems[index]),
                                ),
                              ),
                            );
                          },
                        ),
                        desktop: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 columnas en desktop
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              columnCount: 3,
                              duration: const Duration(milliseconds: 375),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: MenuItemCard(item: _filteredItems[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: theme.disabledColor.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No encontramos "${_searchController.text}"',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otra palabra o categoría.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            child: AppButton(
              text: 'VER TODO',
              onPressed: () {
                _searchController.clear();
                _onCategorySelected('Todos');
              },
            ),
          ),
        ],
      ),
    );
  }
}
