import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:menus/funcionalidades/pedidos/domain/models/pedido.dart';
import 'package:menus/funcionalidades/pedidos/domain/repositories/repositorio_pedido.dart';

class MockPedidoRepository implements PedidoRepository {
  // Simulación de Base de Datos en Memoria
  final List<Pedido> _pedidos = [];
  
  // 4. Robustez en el Stream (RxDart)
  // Usamos BehaviorSubject para que quien se suscriba reciba el último estado inmediatamente.
  final _controller = BehaviorSubject<List<Pedido>>.seeded([]);

  MockPedidoRepository() {
    _notify();
  }

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_pedidos));
    }
  }

  @override
  Stream<List<Pedido>> get pedidosStream => _controller.stream;

  @override
  Future<List<Pedido>> getPedidosByStatus(List<PedidoStatus> statuses) async {
    //aqui es donde va el codigo backend//
    await Future.delayed(const Duration(milliseconds: 500)); // Simular latencia
    return _pedidos.where((p) => statuses.contains(p.status)).toList();
  }

  @override
  Future<void> createPedido(Pedido pedido) async {
    // 7. Manejo de Errores de Red
    try {
      //aqui es donde va el codigo backend//
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Simular error aleatorio (opcional para pruebas, comentado para prod)
      // if (DateTime.now().second % 10 == 0) throw Exception("Error de conexión simulado");

      _pedidos.add(pedido);
      _notify();
    } catch (e) {
      // En un app real, aquí loguearías el error a Crashlytics
      rethrow; 
    }
  }

  @override
  Future<void> updatePedidoStatus(String pedidoId, PedidoStatus newStatus) async {
    //aqui es donde va el codigo backend//
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      final oldPedido = _pedidos[index];
      
      // 3. Modelo de Datos: "Log de Auditoría" logic
      final newHistory = Map<PedidoStatus, DateTime>.from(oldPedido.statusHistory);
      newHistory[newStatus] = DateTime.now();

      // 2. Inmutabilidad en los Pedidos
      // Usamos copyWith en lugar de modificar el objeto directamente.
      _pedidos[index] = oldPedido.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        statusHistory: newHistory,
      );
      
      _notify();
    }
  }

  // 1. Gestión del Ciclo de Vida del Stream
  @override
  void dispose() {
    _controller.close();
  }
}
