import '../models/modelo_usuario.dart';

/// 🔐 REPOSITORIO DE USUARIOS
/// Abstracción para el manejo de usuarios, permitiendo cambiar entre
/// implementaciones locales (Mock) y remotas (API/Firebase) fácilmente.
abstract class UserRepository {
  /// Obtiene todos los usuarios del sistema.
  Future<List<User>> getUsers();

  /// Busca usuarios por nombre o email.
  Future<List<User>> searchUsers(String query);

  /// Crea un nuevo usuario.
  Future<void> createUser(User user);

  /// Actualiza un usuario existente.
  Future<void> updateUser(User user);

  /// Elimina (o desactiva) un usuario por ID.
  Future<void> deleteUser(String userId);

  /// Obtiene un usuario por ID.
  Future<User?> getUserById(String id);
}
