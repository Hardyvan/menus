import '../../domain/models/producto.dart';
import '../../domain/repositories/repositorio_inventario.dart';

class MockInventoryRepository implements InventoryRepository {
  // 🧠 Estado en Memoria (Simula base de datos)
  final List<Product> _db = List.of(Product.mockProducts);

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 600)); 
    return List.from(_db); // Copia segura
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _db.where((p) => p.isLowStock).toList();
  }

  @override
  Future<void> updateStock(String productId, double newStock) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _db.indexWhere((p) => p.id == productId);
    if (index != -1) {
      // ♻️ Inmutabilidad: Reemplazamos el objeto con una copia actualizada
      final old = _db[index];
      _db[index] = Product(
        id: old.id,
        name: old.name,
        category: old.category,
        stock: newStock,
        costPrice: old.costPrice,
        unit: old.unit,
        minStock: old.minStock,
        lastUpdated: DateTime.now(),
      );
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _db.add(product);
  }
}
