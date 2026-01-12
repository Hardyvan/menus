import '../models/producto.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getLowStockProducts();
  
  // 📝 Transacciones de Almacén
  Future<void> updateStock(String productId, double newStock);
  Future<void> addProduct(Product product);
}
