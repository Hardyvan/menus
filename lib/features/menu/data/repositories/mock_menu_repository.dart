import '../../domain/models/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';

/// Implementación estática (Mock) del repositorio.
/// Simula una llamada a red con un pequeño retardo artificial.
class MockMenuRepository implements MenuRepository {
  @override
  Future<List<MenuItem>> getMenuItems() async {
    // Simulamos latencia de red
    await Future.delayed(const Duration(milliseconds: 800));
    return MenuItem.mockItems;
  }

  @override
  Future<List<MenuItem>> getTrendingItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Por demo, devolvemos los primeros 5 items como "Trending"
    return MenuItem.mockItems.take(5).toList();
  }

  @override
  Future<List<MenuItem>> getSpecialOffers() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Por demo, devolvemos los items invertidos como "Ofertas"
    return MenuItem.mockItems.reversed.take(4).toList();
  }
}
