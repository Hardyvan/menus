import 'package:flutter/material.dart';
import '../domain/models/producto.dart';
import '../domain/repositories/repositorio_inventario.dart';

/// 🧠 GESTOR DE ESTADO DEL INVENTARIO
///
/// Mantiene la lista de productos en memoria y maneja la lógica de negocio
/// para evitar recargas innecesarias y facilitar filtros.
class InventoryProvider extends ChangeNotifier {
  final InventoryRepository _repository;
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _currentFilter = 'Todos';
  String _searchQuery = '';

  InventoryProvider(this._repository) {
    _loadInitialData();
  }

  // Getters
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  int get lowStockCount => _allProducts.where((p) => p.isLowStock).length;
  double get totalValue => _allProducts.fold(0.0, (sum, p) => sum + (p.stock * p.costPrice));

  // 1. Carga Inicial
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _repository.getProducts();
      _applyFilters();
    } catch (e) {
      debugPrint('Error cargando inventario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Filtros y Búsqueda
  void filterByCategory(String category) {
    _currentFilter = category;
    _applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((p) {
      final matchesCategory = _currentFilter == 'Todos' || p.category == _currentFilter;
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  // 3. Acciones (Transacciones)
  Future<void> updateStock(String productId, double newStock) async {
    try {
      await _repository.updateStock(productId, newStock);
      // Actualizamos localmente para feedback instantáneo
      final index = _allProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final old = _allProducts[index];
        _allProducts[index] = Product(
          id: old.id,
          name: old.name,
          category: old.category,
          stock: newStock,
          costPrice: old.costPrice,
          unit: old.unit,
          minStock: old.minStock,
          lastUpdated: DateTime.now(),
        );
        _applyFilters(); // Re-aplicar filtros para actualizar la vista
      }
    } catch (e) {
      debugPrint('Error actualizando stock: $e');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _repository.addProduct(product);
      _allProducts.add(product);
      _applyFilters();
    } catch (e) {
      rethrow;
    }
  }
}
