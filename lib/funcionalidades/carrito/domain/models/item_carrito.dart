import 'package:menus/funcionalidades/menu/domain/models/item_menu.dart';

/// Representa un ítem dentro del carrito de compras (Modelo Inmutable).
class CartItem {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String? notes; // 📝 Scalability: Modificadores (ej. "Sin cebolla")

  const CartItem({
    required this.id,
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  /// Crea una copia de este ítem con campos actualizados.
  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  /// Calcula el subtotal para este ítem.
  double get subtotal => menuItem.price * quantity;
}
