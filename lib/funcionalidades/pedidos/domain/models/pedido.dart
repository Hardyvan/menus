import 'package:menus/funcionalidades/menu/domain/models/item_menu.dart';

enum PedidoStatus {
  pendingPayment, // Creado por Mozo, espera pago
  paid,           // Pagado, listo para cocina
  cooking,        // En preparación
  ready,          // Listo para entrega
  delivered       // Entregado a mesa
}

/// 📦 ENTIDAD CENTRAL: PEDIDO
/// Define una orden completa de una mesa.
/// Inmutable para garantizar seguridad en entornos reactivos.
class Pedido {
  final String id;
  final String tableNumber; // Mesa asignada
  final List<PedidoItem> items;
  final double total;
  final DateTime timestamp; // Creación
  final DateTime updatedAt; // Última modificación (Auditoría)
  final PedidoStatus status;
  
  // 📝 Log de Auditoría (Historial de estados)
  // Ejemplo: { 'paid': 12:00, 'cooking': 12:05 }
  final Map<PedidoStatus, DateTime> statusHistory;

  const Pedido({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.total,
    required this.timestamp,
    required this.updatedAt,
    this.status = PedidoStatus.pendingPayment,
    this.statusHistory = const {},
  });

  /// 🛡️ INMUTABILIDAD: Método CopyWith
  /// Permite generar una nueva versión del pedido con cambios específicos.
  Pedido copyWith({
    String? id,
    String? tableNumber,
    List<PedidoItem>? items,
    double? total,
    DateTime? timestamp,
    DateTime? updatedAt,
    PedidoStatus? status,
    Map<PedidoStatus, DateTime>? statusHistory,
  }) {
    return Pedido(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      total: total ?? this.total,
      timestamp: timestamp ?? this.timestamp,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }
}

class PedidoItem {
  final MenuItem menuItem;
  final int quantity;
  final String? notes; // 📝 Comentarios de cocina (ej. "Sin sal")

  const PedidoItem({
    required this.menuItem,
    required this.quantity,
    this.notes,
  });
  
  double get subtotal => menuItem.price * quantity;
}
