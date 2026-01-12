import 'package:flutter/material.dart';
import '../../menu/domain/models/item_menu.dart';
import '../domain/models/item_carrito.dart';

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

  /// Agrega un producto al carrito o incrementa su cantidad.
  void addItem(MenuItem menuItem, int quantity, {String? notes}) {
    // 🧠 LOGIC: Usamos el ID del plato como clave única.
    // Esto evita duplicados si el usuario agrega el mismo plato dos veces.
    // OJO: Si las notas son diferentes, debería ser un item distinto idealmente,
    // pero por simplicidad de este MVP, si el ID es igual, sumamos cantidad y
    // concatenamos notas o ignoramos.
    // Para UX real, si cambia la nota, debería ser otro CartItem. 
    // Vamos a asumir que "Mismo ID + Mismas Notas" = Mismo Item.
    // Pero simplifiquemos: Si el usuario agrega, se suma.
    
    // 🧠 LOGIC: Usamos ID + Notas como clave única.
    // "Hamburguesa sin cebolla" es distinto a "Hamburguesa normal".
    final index = _items.indexWhere((item) => 
        item.menuItem.id == menuItem.id && item.notes == notes);

    if (index >= 0) {
      // ✅ Si ya existe una combinación idéntica, solo sumamos cantidad
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + quantity,
      );
    } else {
      // No existe, lo agregamos
      _items.add(
        CartItem(
          id: menuItem.id, // ID del producto como ID del item de carrito
          menuItem: menuItem,
          quantity: quantity,
          notes: notes,
        ),
      );
    }
    
    notifyListeners();
  }

  /// Decrementa la cantidad de un producto.
  /// Si llega a 0, se elimina del carrito.
  void decreaseItem(CartItem itemToDecrease) {
    final index = _items.indexOf(itemToDecrease);
    if (index >= 0) {
      final currentQuantity = _items[index].quantity;
      
      if (currentQuantity > 1) {
        // Reducimos cantidad
        _items[index] = _items[index].copyWith(
          quantity: currentQuantity - 1,
        );
      } else {
        // La cantidad es 1, así que eliminamos el ítem
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Elimina un producto del carrito completamente.
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  String? _tableNumber;
  String? get tableNumber => _tableNumber;

  void setTableNumber(String table) {
    _tableNumber = table;
    notifyListeners();
  }

  /// Limpia todo el carrito y la mesa seleccionada.
  void clearCart() {
    _items.clear();
    _tableNumber = null;
    notifyListeners();
  }
}
