import '../models/item_menu.dart';

/// 📜 CONTRATO DEL REPOSITORIO (Interface)
///
/// Define QUÉ puede hacer nuestra app con los menús, pero NO CÓMO.
/// Esto nos permite cambiar la "tubería" de datos (Backend real vs Mock)
/// sin romper las pantallas. Es como un enchufe universal.
abstract class MenuRepository {
  /// Obtiene la lista completa de platillos.
  Future<List<MenuItem>> getMenuItems();

  /// Obtiene platillos por categoría
  Future<List<MenuItem>> getMenuItemsByCategory(String category);

  /// Obtiene los platillos en tendencia.
  Future<List<MenuItem>> getTrendingItems();

  /// Obtiene las ofertas especiales.
  Future<List<MenuItem>> getSpecialOffers();

  // --- CRUD (Create, Read, Update, Delete) ---
  
  /// Agrega un nuevo platillo.
  Future<void> addMenuItem(MenuItem item);

  /// Actualiza un platillo existente.
  Future<void> updateMenuItem(MenuItem item);

  /// Elimina un platillo por su ID.
  Future<void> deleteMenuItem(String id);
  
  /// ⚡ Actualización rápida de stock (Switch)
  Future<void> updateAvailability(String id, bool isAvailable);
}
