import '../../domain/models/item_menu.dart';
import '../../domain/repositories/repositorio_menu.dart';

/// Implementación estática (Mock) del repositorio.
/// Simula una llamada a red con un pequeño retardo artificial.
/// 🎭 REPOSITORIO DE PRUEBA (MOCK)
///
/// Implementa el contrato `MenuRepository` usando datos falsos en memoria.
/// Se usa para desarrollar la UI sin depender de que el Backend esté listo.
class MockMenuRepository implements MenuRepository {
  // 🧠 Base de datos en memoria (Mutable)
  final List<MenuItem> _items = [
    const MenuItem(
      id: '1',
      name: 'Lomo Saltado',
      description: 'Trozos de carne flambeados con cebolla y tomate.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1596797038530-2c107229654b',
      category: 'Platos de Fondo',
      isAvailable: true,
    ),
    const MenuItem(
      id: '2',
      name: 'Ceviche Clásico',
      description: 'Pesca del día marinada en limón sutil.',
      price: 38.00,
      imageUrl: 'https://images.unsplash.com/photo-1535399831218-d5bd36d1a6b3',
      category: 'Entradas',
      isAvailable: true,
    ),
    const MenuItem(
      id: '3',
      name: 'Pisco Sour',
      description: 'Cóctel bandera con pisco quebranta.',
      price: 25.00,
      imageUrl: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b',
      category: 'Bebidas',
      isAvailable: true,
    ),
  ];

  @override
  Future<List<MenuItem>> getMenuItems() async {
    // Simulamos latencia de red (Network Delay)
    // Esto es útil para probar tus "spinners" de carga.
    await Future.delayed(const Duration(milliseconds: 800)); // Simular red
    return List.from(_items); // Copia segura
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (category == 'Todos') return List.from(_items);
    return _items.where((i) => i.category == category).toList();
  }

  @override
  Future<List<MenuItem>> getTrendingItems() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _items.take(3).toList(); // Simulamos devolver los primeros 3
  }

  @override
  Future<List<MenuItem>> getSpecialOffers() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _items.skip(2).take(2).toList(); // Simulamos
  }

  @override
  Future<void> addMenuItem(MenuItem item) async {
    await Future.delayed(const Duration(seconds: 1));
    _items.add(item);
  }

  @override
  Future<void> updateMenuItem(MenuItem item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteMenuItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _items.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> updateAvailability(String id, bool isAvailable) async {
     await Future.delayed(const Duration(milliseconds: 300));
     final index = _items.indexWhere((i) => i.id == id);
     if (index != -1) {
       _items[index] = _items[index].copyWith(isAvailable: isAvailable);
     }
  }
}
