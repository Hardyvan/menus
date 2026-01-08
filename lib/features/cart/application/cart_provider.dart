import 'package:flutter/material.dart';
import '../../menu/domain/models/menu_item.dart';
import '../domain/models/cart_item.dart';

/// Gestiona el estado del carrito de compras.
///
/// Permite agregar productos, modificar cantidades y calcular totales.
/// Extiende [ChangeNotifier] para actualizar la UI automáticamente.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Retorna el precio total de la orden.
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Retorna la cantidad total de ítems (para badges).
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Agrega un producto al carrito.
  /// Si ya existe, actualiza la cantidad.
  void addItem(MenuItem menuItem, int quantity) {
    // Buscamos si ya está en el carrito
    final index = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

    if (index >= 0) {
      // Ya existe, sumamos cantidad
      _items[index].quantity += quantity;
    } else {
      // No existe, lo agregamos
      _items.add(
        CartItem(
          id: DateTime.now().toString(), // ID temporal único
          menuItem: menuItem,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  /// Elimina un producto del carrito.
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  /// Limpia todo el carrito.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
