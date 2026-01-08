import '../models/menu_item.dart';

/// Contrato para el repositorio de menús.
/// Desacopla la UI del origen de datos (Mock, API, DB).
abstract class MenuRepository {
  /// Obtiene la lista completa de platillos.
  Future<List<MenuItem>> getMenuItems();

  /// Obtiene los platillos en tendencia.
  Future<List<MenuItem>> getTrendingItems();

  /// Obtiene las ofertas especiales.
  Future<List<MenuItem>> getSpecialOffers();
}
