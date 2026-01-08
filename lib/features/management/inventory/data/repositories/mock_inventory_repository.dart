import '../../domain/models/product.dart';
import '../../domain/repositories/inventory_repository.dart';

class MockInventoryRepository implements InventoryRepository {
  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simular red
    return Product.mockProducts;
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Product.mockProducts.where((p) => p.isLowStock).toList();
  }
}
