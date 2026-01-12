enum UserRole {
  admin,
  mozo, // Waiter
  cocinero, // Cook
  cajero, // Cashier
  almacenero // Warehouse
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  // 1. Seguridad: Eliminada contraseña del modelo de dominio.
  // 2. Auditoría: Estado activo/inactivo para no perder historial.
  final bool isActive; 
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
    this.createdAt,
  });

  // 🛡️ RBAC: Control de Acceso Basado en Roles
  // Getters para chequear permisos en cualquier parte de la app.
  bool get canManageInventory => role == UserRole.admin || role == UserRole.almacenero;
  bool get canProcessPayments => role == UserRole.admin || role == UserRole.cajero;
  bool get canManageUsers => role == UserRole.admin;
  bool get canEditMenu => role == UserRole.admin || role == UserRole.cocinero;

  String get roleName {
    switch (role) {
      case UserRole.admin: return 'Administrador';
      case UserRole.mozo: return 'Mozo';
      case UserRole.cocinero: return 'Cocinero';
      case UserRole.cajero: return 'Cajero';
      case UserRole.almacenero: return 'Almacenero';
    }
  }

  // Helper para inmutabilidad (útil para editar)
  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
