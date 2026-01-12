import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../domain/models/modelo_usuario.dart';
import '../domain/repositories/repositorio_usuario.dart';
import '../../autenticacion/application/proveedor_autenticacion.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  // Estado local para búsqueda y filtros
  String _searchQuery = '';
  UserRole? _selectedRoleFilter;
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final repo = context.read<UserRepository>();
    try {
      final users = await repo.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Manejo de error básico
    }
  }

  // Filtrado en cliente (para la lista visual)
  List<User> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _selectedRoleFilter == null || user.role == _selectedRoleFilter;
      // Opcional: mostrar solo activos? Por ahora mostramos todos, quizás atenuando los inactivos.
      return matchesSearch && matchesRole;
    }).toList();
  }

  void _showUserDialog({User? user}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    UserRole selectedRole = user?.role ?? UserRole.mozo;
    bool isActive = user?.isActive ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(user == null ? 'Nuevo Personal' : 'Editar Personal'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextInput(
                    label: 'Nombre Completo',
                    controller: nameController,
                    prefixIcon: Icons.person,
                    validator: (v) => v!.isEmpty ? 'Ingresa un nombre' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    label: 'Correo Electrónico',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa un email';
                      if (!v.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Selector de Rol
                  DropdownButtonFormField<UserRole>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      labelText: 'Asignar Rol',
                      prefixIcon: const Icon(Icons.badge),
                    ),
                    items: UserRole.values.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(User(id: '', name: '', email: '', role: r).roleName),
                    )).toList(),
                    onChanged: (val) => setDialogState(() => selectedRole = val!),
                  ),
                  
                  // Switch Activo/Inactivo (Solo edición)
                  if (user != null) ...[
                    const SizedBox(height: 16),
                    SwitchListTile(
                      //inactiveTrackColor: Colors.red.withOpacity(0.2), // Deprecated
                      inactiveTrackColor: Colors.red.withValues(alpha: 0.2), 
                      activeColor: Colors.green,
                      title: const Text('Estado Activo'),
                      subtitle: Text(isActive ? 'El usuario puede acceder' : 'Acceso denegado'),
                      value: isActive,
                      onChanged: (val) => setDialogState(() => isActive = val),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Cancelar')
            ),
            AppButton(
              text: 'Confirmar Acceso',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final repo = context.read<UserRepository>();
                  final newUser = User(
                    id: user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    email: emailController.text,
                    role: selectedRole,
                    isActive: isActive,
                  );

                  try {
                    if (user == null) {
                      await repo.createUser(newUser);
                    } else {
                      await repo.updateUser(newUser);
                    }
                    if (!context.mounted) return;
                    
                    Navigator.pop(ctx);
                    _loadUsers(); // Recargar lista
                  } catch (e) {
                    // Mostrar error si existe (ej. duplicado)
                    if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e'), backgroundColor: Theme.of(context).colorScheme.error),
                        );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteUser(User user) async {
    // 🛡️ SECURITY CHECK: Auto-borrado
    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser?.id == user.id) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⛔ No puedes eliminarte a ti mismo.')),
        );
        return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar Usuario?'),
        content: Text('Estás a punto de eliminar a ${user.name}. Se recomienda desactivarlo en su lugar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      await context.read<UserRepository>().deleteUser(user.id);
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, email...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 8),
                // Botón de filtro rápido (opcional, podría abrir bottom sheet)
                 PopupMenuButton<UserRole?>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (role) => setState(() => _selectedRoleFilter = role),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: null, child: Text('Todos')),
                    ...UserRole.values.map((r) => PopupMenuItem(
                      value: r, 
                      child: Text(User(id: '', name: '', email: '', role: r).roleName),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = _filteredUsers[index];
              return Opacity(
                opacity: user.isActive ? 1.0 : 0.5,
                child: AppCard(
                  padding: const EdgeInsets.all(4),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?', 
                            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                        ),
                        if (!user.isActive)
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: theme.colorScheme.error, shape: BoxShape.circle),
                              child: const Icon(Icons.block, color: Colors.white, size: 10),
                            ),
                          ),
                      ],
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text('${user.roleName} • ${user.email}'),
                        if (!user.isActive)
                           Text('Inactivo', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showUserDialog(user: user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.colorScheme.error),
                          onPressed: () => _deleteUser(user),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
