import 'package:flutter/foundation.dart';
import '../../usuarios/domain/models/modelo_usuario.dart';

/// 🔐 PROVEEDOR DE AUTENTICACIÓN
/// Gestiona el estado de la sesión del usuario actual.
/// Permite login, logout y acceso a los datos del usuario logueado en toda la app.
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  /// Simula un inicio de sesión
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de delay de red
      await Future.delayed(const Duration(seconds: 2));

      // Validación Mock (Backend Simulated)
      if (email == 'error@demo.com') {
        throw Exception('Credenciales inválidas');
      }

      // 👤 MOCK USER DATA
      // En una app real, esto vendría del JWT o respuesta del backend.
      // Asignamos roles según el email para pruebas rápidas.
      UserRole role = UserRole.admin;
      String name = 'Admin User';
      
      if (email.contains('mozo')) {
        role = UserRole.mozo;
        name = 'Juan Pérez (Mozo)';
      } else if (email.contains('cocina')) {
        role = UserRole.cocinero;
        name = 'Chef Mario';
      }

      _currentUser = User(
        id: 'u-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: role,
        // isActive defaults to true
      );
      
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cierra la sesión del usuario
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Método para actualizar datos del perfil (Simulación)
  void updateProfile({String? name}) {
    if (_currentUser != null && name != null) {
      // Como User es const, creamos uno nuevo (inmutabilidad básica)
      _currentUser = User(
        id: _currentUser!.id,
        name: name,
        email: _currentUser!.email,
        role: _currentUser!.role,
      );
      notifyListeners();
    }
  }
}
