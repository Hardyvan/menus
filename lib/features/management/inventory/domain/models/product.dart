class Product {
  final String id;
  final String name;
  final String category;
  final double stock;
  final String unit;
  final int minStock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.unit,
    required this.minStock,
  });

  bool get isLowStock => stock <= minStock;

  // Fábrica para crear datos mock
  static List<Product> get mockProducts => [
    const Product(id: '1', name: 'Harina de Trigo', category: 'Insumos', stock: 50, unit: 'Kg', minStock: 10),
    const Product(id: '2', name: 'Tomates', category: 'Vegetales', stock: 5, unit: 'Kg', minStock: 8), // Low Stock
    const Product(id: '3', name: 'Queso Mozzarella', category: 'Lácteos', stock: 12, unit: 'Kg', minStock: 5),
    const Product(id: '4', name: 'Coca Cola Latas', category: 'Bebidas', stock: 120, unit: 'Und', minStock: 24),
    const Product(id: '5', name: 'Carne Res', category: 'Cárnicos', stock: 3, unit: 'Kg', minStock: 10), // Low Stock
  ];
}
