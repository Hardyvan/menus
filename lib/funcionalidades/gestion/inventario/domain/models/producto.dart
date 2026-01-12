class Product {
  final String id;
  final String name;
  final String category;
  final double stock;
  final double costPrice; // 💰 Costo Unitario (Indispensable para finanzas)
  final String unit;
  final int minStock;
  final DateTime? lastUpdated; // 🕒 Auditoría

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.costPrice,
    required this.unit,
    required this.minStock,
    this.lastUpdated,
  });

  bool get isLowStock => stock <= minStock;

  // Fábrica para crear datos mock
  static List<Product> get mockProducts => [
    Product(id: '1', name: 'Harina de Trigo', category: 'Insumos', stock: 50, costPrice: 4.50, unit: 'Kg', minStock: 10, lastUpdated: DateTime.now()),
    Product(id: '2', name: 'Tomates', category: 'Vegetales', stock: 5, costPrice: 2.20, unit: 'Kg', minStock: 8, lastUpdated: DateTime.now().subtract(const Duration(days: 1))), // Low Stock
    Product(id: '3', name: 'Queso Mozzarella', category: 'Lácteos', stock: 12, costPrice: 28.00, unit: 'Kg', minStock: 5, lastUpdated: DateTime.now()),
    Product(id: '4', name: 'Coca Cola Latas', category: 'Bebidas', stock: 120, costPrice: 2.50, unit: 'Und', minStock: 24, lastUpdated: DateTime.now()),
    Product(id: '5', name: 'Carne Res', category: 'Cárnicos', stock: 3, costPrice: 35.00, unit: 'Kg', minStock: 10, lastUpdated: DateTime.now().subtract(const Duration(hours: 4))), // Low Stock
  ];
}
