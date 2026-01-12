import 'package:equatable/equatable.dart';

/// 🍽️ ENTIDAD DE DOMINIO: MenuItem
///
/// Representa un platillo, bebida o postre en el menú.
/// Es inmutable para garantizar la integridad de los datos.
class MenuItem extends Equatable {
  final String id;
  final String name; // 📝 Renamed from title to name for consistency
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable; // 📦 Stock Management

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });

  /// Crea una copia modificada del objeto (Patrón Prototype/Copy)
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, category, isAvailable];

  /// Datos de prueba para previsualización
  static const List<MenuItem> mockItems = [
    MenuItem(
      id: '1',
      name: 'Hamburguesa Clásica',
      description: 'Carne de res premium, lechuga, tomate y queso cheddar.',
      price: 12.50,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
      category: 'Platos de Fondo',
      isAvailable: true,
    ),
    MenuItem(
      id: '2',
      name: 'Pizza Margarita',
      description: 'Salsa de tomate casera, mozzarella fresca y albahaca.',
      price: 15.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=500&q=60',
      category: 'Platos de Fondo',
      isAvailable: true,
    ),
    MenuItem(
      id: '3',
      name: 'Ensalada César',
      description: 'Lechuga romana, crutones, queso parmesano y aderezo especial.',
      price: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=500&q=60',
      category: 'Entradas',
      isAvailable: true,
    ),
    MenuItem(
      id: '4',
      name: 'Tiramisú',
      description: 'Postre italiano clásico con café y mascarpone.',
      price: 8.50,
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=500&q=60',
      category: 'Postres',
      isAvailable: true,
    ),
    MenuItem(
      id: '5',
      name: 'Lomo Saltado',
      description: 'Trozos de carne flambeados con cebolla y tomate.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1596797038530-2c107229654b',
      category: 'Platos de Fondo',
      isAvailable: true,
    ),
    MenuItem(
      id: '6',
      name: 'Ceviche Clásico',
      description: 'Pesca del día marinada en limón sutil.',
      price: 38.00,
      imageUrl: 'https://images.unsplash.com/photo-1535399831218-d5bd36d1a6b3',
      category: 'Entradas',
      isAvailable: true,
    ),
    MenuItem(
      id: '7',
      name: 'Pisco Sour',
      description: 'Cóctel bandera con pisco quebranta.',
      price: 25.00,
      imageUrl: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b',
      category: 'Bebidas',
      isAvailable: true,
    ),
  ];
}
