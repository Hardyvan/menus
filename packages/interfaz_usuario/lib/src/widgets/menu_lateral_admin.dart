import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menú lateral para acceso a módulos administrativos.
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dinámico
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // Dinámico
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // Dinámico
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gestión Restaurante',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color, // Dinámico
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Panel Administrativo',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color, // Dinámico
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).iconTheme.color), // Dinámico
            title: const Text('Inicio (Menú)'),
            onTap: () => context.go('/'),
          ),

          ListTile(
            leading: Icon(Icons.restaurant_menu, color: Theme.of(context).iconTheme.color),
            title: const Text('Gestión de Menú (Platos)'),
            onTap: () => context.push('/admin/menu'),
          ),

          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text('OPERACIONES', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold)), // Dinámico
          ),

          ListTile(
            leading: Icon(Icons.soup_kitchen, color: Theme.of(context).iconTheme.color),
            title: const Text('Cocina (KDS)'),
            onTap: () => context.push('/kitchen'),
          ),
          ListTile(
            leading: Icon(Icons.inventory_2, color: Theme.of(context).iconTheme.color),
            title: const Text('Inventario & Almacén'),
            onTap: () => context.push('/admin/inventory'),
          ),
          ListTile(
            leading: Icon(Icons.receipt_long, color: Theme.of(context).iconTheme.color),
            title: const Text('Facturación'),
            onTap: () => context.push('/admin/billing'),
          ),
          ListTile(
            leading: Icon(Icons.analytics, color: Theme.of(context).iconTheme.color),
            title: const Text('Finanzas & Caja'),
            onTap: () => context.push('/admin/finance'),
          ),
          ListTile(
            leading: Icon(Icons.people, color: Theme.of(context).iconTheme.color),
            title: const Text('Personal & Usuarios'),
            onTap: () => context.push('/admin/users'),
          ),
        ],
      ),
    );
  }
}
