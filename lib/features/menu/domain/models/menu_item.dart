/// Modelo que representa un platillo en el menú.
class MenuItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  /// Datos de prueba para previsualización
  static const List<MenuItem> mockItems = [
    MenuItem(
      id: '1',
      title: 'Hamburguesa Clásica',
      description: 'Carne de res premium, lechuga, tomate y queso cheddar.',
      price: 12.50,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
    ),
    MenuItem(
      id: '2',
      title: 'Pizza Margarita',
      description: 'Salsa de tomate casera, mozzarella fresca y albahaca.',
      price: 15.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=500&q=60',
    ),
    MenuItem(
      id: '3',
      title: 'Ensalada César',
      description: 'Lechuga romana, crutones, parmesano y aderezo césar.',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=500&q=60',
    ),
    MenuItem(
      id: '4',
      title: 'Pasta Alfredo',
      description: 'Fettuccine con salsa cremosa de parmesano.',
      price: 13.50,
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?auto=format&fit=crop&w=500&q=60',
    ),
  ];
}
