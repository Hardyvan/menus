import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../application/proveedor_inventario.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧠 CONSUMER: Escuchamos al proveedor de inventario
    // Cada vez que cambien los filtros o datos, este widget se reconstruye.
    final inventoryProvider = context.watch<InventoryProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Inventario y Almacén'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(),
      body: inventoryProvider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Dashboard de Almacén
                _buildDashboard(context, inventoryProvider),
                const SizedBox(height: 24),
                
                // 2. Buscador y Filtros
                _buildFilters(context, inventoryProvider),
                const SizedBox(height: 16),

                // 3. Tabla de Productos
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    // columns:const ['Producto', 'Categoría', 'Stock', 'Costo', 'Estado', 'Acciones'],
                    // rows:inventoryProvider.products.map((p) => _buildRow(context, p, inventoryProvider)).toList(),
                    child: _buildEmptyState(context),
                  ),
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar diálogo de "Nuevo Producto"
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, InventoryProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Valor Total',
            value: 'S/ ${provider.totalValue.toStringAsFixed(2)}',
            icon: Icons.monetization_on,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Bajo Stock',
            value: '${provider.lowStockCount}',
            icon: Icons.warning_amber,
            color: Colors.orange,
            subtitle: provider.lowStockCount > 0 ? 'Revisar' : 'Óptimo',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, InventoryProvider provider) {
    return Column(
      children: [
        // Buscador
        CampoTextoPersonalizado(
          label: 'Buscar producto...',
          prefixIcon: Icons.search,
          onChanged: provider.search,
        ),
        const SizedBox(height: 12),
        // Chips de Categoría
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(label: 'Todos', isSelected: true, onTap: () => provider.filterByCategory('Todos')), // Simplificado para demo
              const SizedBox(width: 8),
              _FilterChip(label: 'Insumos', isSelected: false, onTap: () => provider.filterByCategory('Insumos')),
              const SizedBox(width: 8),
              _FilterChip(label: 'Vegetales', isSelected: false, onTap: () => provider.filterByCategory('Vegetales')),
              const SizedBox(width: 8),
              _FilterChip(label: 'Bebidas', isSelected: false, onTap: () => provider.filterByCategory('Bebidas')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No hay productos', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
