import '../../../../features/menu/domain/models/menu_item.dart';

/// Representa un ítem dentro del carrito de compras.
class CartItem {
  final String id;
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.id,
    required this.menuItem,
    this.quantity = 1,
  });

  /// Calcula el subtotal para este ítem.
  double get subtotal => menuItem.price * quantity;
}
