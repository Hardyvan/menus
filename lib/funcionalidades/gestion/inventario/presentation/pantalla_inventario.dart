import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../domain/models/producto.dart';
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
      drawer: const AdminDrawer(),
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
                  child: AppDataTable(
                    columns: const ['Producto', 'Categoría', 'Stock', 'Costo', 'Estado', 'Acciones'],
                    rows: inventoryProvider.products.map((p) => _buildRow(context, p, inventoryProvider)).toList(),
                    emptyState: _buildEmptyState(context),
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
          child: StatCard(
            title: 'Valor Total',
            value: 'S/ ${provider.totalValue.toStringAsFixed(2)}',
            icon: Icons.monetization_on,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Bajo Stock',
            value: '${provider.lowStockCount}',
            icon: Icons.warning_amber,
            color: Colors.orange,
            trend: provider.lowStockCount > 0 ? 'Revisar' : 'Óptimo',
            trendUp: provider.lowStockCount == 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, InventoryProvider provider) {
    return Column(
      children: [
        // Buscador
        AppTextInput(
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

  List<Widget> _buildRow(BuildContext context, Product product, InventoryProvider provider) {
    final theme = Theme.of(context);
    final isLow = product.isLowStock;

    return [
      Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      Text(product.category, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
      Text('${product.stock} ${product.unit}', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
      Text('S/ ${product.costPrice.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.onSurface)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (isLow ? theme.colorScheme.error : Colors.green).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isLow ? 'BAJO' : 'NORMAL',
          style: TextStyle(
            color: isLow ? theme.colorScheme.error : Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add_box, color: Colors.green),
            tooltip: 'Ajuste Rápido',
            onPressed: () => _showStockDialog(context, product, provider),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    ];
  }

  Future<void> _showStockDialog(BuildContext context, Product product, InventoryProvider provider) async {
    final TextEditingController controller = TextEditingController(text: product.stock.toString());
    
    await showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: Text('Ajustar Stock: ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingrese la nueva cantidad real en almacén:'),
            const SizedBox(height: 16),
            AppTextInput(
              label: 'Cantidad (${product.unit})', 
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final newStock = double.tryParse(controller.text);
              if (newStock != null) {
                provider.updateStock(product.id, newStock);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stock de ${product.name} actualizado')),
                );
              }
            }, 
            child: const Text('Guardar'),
          ),
        ],
      ),
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
