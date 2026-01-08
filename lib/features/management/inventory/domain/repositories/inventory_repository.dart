import '../models/product.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getLowStockProducts();
}
