import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';

import 'package:menus/funcionalidades/pedidos/domain/repositories/repositorio_pedido.dart';
import 'package:menus/funcionalidades/pedidos/domain/models/pedido.dart';
import '../domain/repositories/repositorio_facturacion.dart';
import '../domain/models/factura.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {

  @override
  Widget build(BuildContext context) {
    final pedidoRepo = context.read<PedidoRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Caja y Facturación'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(),
      body: StreamBuilder<List<Pedido>>(
        stream: pedidoRepo.pedidosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allPedidos = snapshot.data ?? [];
          final pendingOrders = allPedidos.where((p) => p.status == PedidoStatus.pendingPayment).toList();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Resumen Financiero del Día (Dashboard)
                _buildDailySummary(context),
                const SizedBox(height: 24),

                // 2. Header de Sección
                _buildSectionHeader(context, pendingOrders.length),
                const SizedBox(height: 16),

                // 3. Tabla de Cobros
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    // columns: const ['Mesa', 'Total', 'Items', 'Estado', 'Acción'],
                    // rows: pendingOrders.map((p) => _buildOrderRow(context, p, pedidoRepo, billingRepo)).toList(),
                    child: _buildEmptyState(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailySummary(BuildContext context) {
    // 🧠 LOGIC: Calcular totales en tiempo real (Mock)
    // En una app real, esto vendría directo del repositorio con una query optimizada
    return FutureBuilder<List<Invoice>>(
      future: context.read<BillingRepository>().getInvoices(),
      builder: (context, snapshot) {
        final invoices = snapshot.data ?? [];
        final todayInvoices = invoices.where((i) => 
          i.date.day == DateTime.now().day && i.isPaid
        ).toList();
        
        final totalToday = todayInvoices.fold(0.0, (sum, item) => sum + item.total);
        final cashCount = todayInvoices.where((i) => i.paymentMethod == 'Efectivo').length;
        final cardCount = todayInvoices.where((i) => i.paymentMethod == 'Tarjeta').length;

        // Determinar método favorito
        String topMethod = 'N/A';
        if (cashCount > cardCount) topMethod = 'Efectivo';
        if (cardCount > cashCount) topMethod = 'Tarjeta';

        return Row(
          children: [
            Expanded(
              child: TarjetaPremium(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Venta Hoy', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('S/ ${totalToday.toStringAsFixed(2)}', 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TarjetaPremium(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Método Top', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(topMethod, 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, int count) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.receipt_long, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          'Pedidos Pendientes ($count)',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
          Icon(Icons.check_circle_outline, size: 48, color: Colors.green.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            '¡Todo al día!',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'No hay pedidos pendientes de cobro.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
