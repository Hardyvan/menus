import 'package:menus/funcionalidades/usuarios/domain/models/modelo_usuario.dart';
import '../../domain/repositories/repositorio_usuario.dart';

class MockUserRepository implements UserRepository {
  // Simulación de Base de Datos en Memoria
  final List<User> _users = [
    const User(id: '1', name: 'Juan Pérez', email: 'juan@admin.com', role: UserRole.admin, isActive: true),
    const User(id: '2', name: 'Carlos Ruiz', email: 'carlos@cocina.com', role: UserRole.cocinero, isActive: true),
    const User(id: '3', name: 'Ana Lopez', email: 'ana@caja.com', role: UserRole.cajero, isActive: true),
    const User(id: '4', name: 'Luis Diaz', email: 'luis@mozo.com', role: UserRole.mozo, isActive: true),
    const User(id: '5', name: 'Pedro Almacen', email: 'pedro@bodega.com', role: UserRole.almacenero, isActive: false), // Usuario inactivo ejemplo
  ];

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Latencia realista
    return List.from(_users);
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _users.where((user) {
      return user.name.toLowerCase().contains(lowerQuery) ||
             user.email.toLowerCase().contains(lowerQuery) ||
             user.roleName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<void> createUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Validación de duplicados (Email único)
    if (_users.any((u) => u.email == user.email)) {
      throw Exception('El correo ${user.email} ya está registrado.');
    }
    _users.add(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    } else {
      throw Exception('Usuario no encontrado');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _users.removeWhere((u) => u.id == userId);
    // Nota: En un sistema real, aquí haríamos:
    // final index = ...
    // _users[index] = _users[index].copyWith(isActive: false);
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}
