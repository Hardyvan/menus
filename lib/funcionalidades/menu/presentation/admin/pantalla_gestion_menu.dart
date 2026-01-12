import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';

import '../../domain/models/item_menu.dart';
import '../../domain/repositories/repositorio_menu.dart';

class ManageMenuScreen extends StatefulWidget {
  const ManageMenuScreen({super.key});

  @override
  State<ManageMenuScreen> createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  String _searchQuery = ''; // 🔍 Estado del buscador
  
  @override
  Widget build(BuildContext context) {
    final menuRepo = context.read<MenuRepository>();
    final theme = Theme.of(context);

    // ⚡ STREAM BUILDER (Opcional)
    // Para ver cambios en tiempo real (como el switch de disponibilidad),
    // lo ideal sería un StreamBuilder. Como usamos FutureBuilder y un Mock en memoria,
    // usaremos setState para refrescar tras acciones rápidas si es necesario, 
    // o simplemente confiaremos en que al volver a cargar el Future se vean los cambios.

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestión del Menú'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}), // Recargar forzosamente
          )
        ],
      ),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          // 1. Barra de Búsqueda y Acción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: AppTextInput(
                    label: 'Buscar plato...',
                    prefixIcon: Icons.search,
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () async {
                    await context.push('/admin/menu/create');
                    setState(() {}); // Recargar al volver
                  },
                  backgroundColor: theme.colorScheme.primary,
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),

          // 2. Lista de Items
          Expanded(
            child: FutureBuilder<List<MenuItem>>(
              future: menuRepo.getMenuItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allItems = snapshot.data ?? [];
                
                // 🔍 Filtrado local por búsqueda
                final filteredItems = _searchQuery.isEmpty 
                  ? allItems 
                  : allItems.where((i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                if (filteredItems.isEmpty) {
                   return Center(child: Text('No se encontraron platos', style: TextStyle(color: Colors.grey[600])));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _buildAdminItemCard(context, item, menuRepo);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminItemCard(BuildContext context, MenuItem item, MenuRepository repo) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) async {
        await repo.deleteMenuItem(item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} eliminado')));
        }
      },
      child: AppCard(
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (_,__) => Container(color: Colors.grey[900]),
              errorWidget: (_,__,___) => const Icon(Icons.broken_image),
            ),
          ),
          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('S/ ${item.price.toStringAsFixed(2)} - ${item.category}'),
              Text(
                item.isAvailable ? 'Disponible' : 'Agotado',
                style: TextStyle(
                  color: item.isAvailable ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⚡ SWITCH DE DISPONIBILIDAD
              Switch(
                value: item.isAvailable, 
                activeColor: theme.colorScheme.primary,
                onChanged: (val) async {
                  await repo.updateAvailability(item.id, val);
                  setState(() {}); // Refrescar UI inmediatamente
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  await context.push('/admin/menu/edit', extra: item);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar plato?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
