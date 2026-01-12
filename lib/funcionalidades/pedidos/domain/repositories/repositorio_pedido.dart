import 'package:menus/funcionalidades/pedidos/domain/models/pedido.dart';

/// 📦 REPOSITORIO DE PEDIDOS
/// Centraliza toda la lógica de órdenes.
/// Es el corazón de la interacción entre Meseros (Crear), Cocina (Actualizar) y Caja (Cobrar).
abstract class PedidoRepository {
  /// Obtiene los pedidos filtrados por estado.
  Future<List<Pedido>> getPedidosByStatus(List<PedidoStatus> statuses);

  /// Crea un nuevo pedido.
  Future<void> createPedido(Pedido pedido);

  /// Actualiza el estado de un pedido.
  Future<void> updatePedidoStatus(String pedidoId, PedidoStatus newStatus);
  
  /// 🔴 STREAM EN VIVO
  /// Permite que la UI "escuche" cambios en tiempo real.
  Stream<List<Pedido>> get pedidosStream;

  /// 🧹 LIMPIEZA
  /// Cierra el stream controller para evitar fugas de memoria.
  void dispose();
}
