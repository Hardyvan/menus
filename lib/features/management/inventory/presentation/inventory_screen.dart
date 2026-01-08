import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import '../domain/models/product.dart';
import '../domain/repositories/inventory_repository.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryRepo = context.read<InventoryRepository>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inventario y Almacén'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
      body: FutureBuilder<List<Product>>(
        future: inventoryRepo.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];
          final lowStockCount = products.where((p) => p.isLowStock).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen Rápido
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Productos',
                        value: '${products.length}',
                        icon: Icons.inventory,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Bajo Stock',
                        value: '$lowStockCount',
                        icon: Icons.warning_amber,
                        color: Colors.orange,
                        trend: lowStockCount > 0 ? 'Atención' : 'Todo OK',
                        trendUp: lowStockCount == 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Título Tabla
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Listado de Existencias',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    AppButton(
                      text: 'Nuevo Producto',
                      icon: Icons.add,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tabla de Datos
                SizedBox(
                  width: double.infinity,
                  child: AppDataTable(
                    columns: const ['Producto', 'Categoría', 'Stock', 'Estado', 'Acciones'],
                    rows: products.map((p) => _buildRow(p)).toList(),
                    emptyState: _buildEmptyState(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildRow(Product product) {
    return [
      Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      Text(product.category, style: const TextStyle(color: AppColors.textSecondary)),
      Text('${product.stock} ${product.unit}', style: const TextStyle(color: Colors.white)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (!product.isLowStock ? Colors.green : Colors.red).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          !product.isLowStock ? 'Normal' : 'Bajo',
          style: TextStyle(
            color: !product.isLowStock ? Colors.green : Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
    ];
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: AppColors.primary.withOpacity(0.1),
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Tu inventario está vacío',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comienza agregando tus primeros productos y controla tu stock al instante.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Agregar Producto',
            icon: Icons.add,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
