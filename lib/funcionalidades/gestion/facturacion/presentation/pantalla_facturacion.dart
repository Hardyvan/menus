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
  // Estado local para saber qué pedido se está cobrando actualmente (para mostrar spinner)
  String? _processingOrderId;

  @override
  Widget build(BuildContext context) {
    final pedidoRepo = context.read<PedidoRepository>();
    final billingRepo = context.watch<BillingRepository>(); // Watch para stats

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Caja y Facturación'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
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
                  child: AppDataTable(
                    columns: const ['Mesa', 'Total', 'Items', 'Estado', 'Acción'],
                    rows: pendingOrders.map((p) => _buildOrderRow(context, p, pedidoRepo, billingRepo)).toList(),
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
              child: AppCard(
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
              child: AppCard(
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

  List<Widget> _buildOrderRow(
      BuildContext context, Pedido p, PedidoRepository pedRepo, BillingRepository billRepo) {
    final theme = Theme.of(context);
    final isProcessing = _processingOrderId == p.id;

    return [
      Text(p.tableNumber, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      Text('S/ ${p.total.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
      Text('${p.items.length} platos', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
        ),
        child: const Text(
          'PENDIENTE',
          style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      AppButton(
        text: 'COBRAR',
        icon: Icons.payments_outlined,
        isLoading: isProcessing,
        onPressed: isProcessing ? null : () => _handleCheckout(p, pedRepo, billRepo),
      ),
    ];
  }

  Future<void> _handleCheckout(
      Pedido p, PedidoRepository pedRepo, BillingRepository billRepo) async {
    
    // 1. Selector de Método de Pago
    final paymentMethod = await _showPaymentMethodDialog(context);
    if (paymentMethod == null) return; // Cancelado por usuario

    setState(() => _processingOrderId = p.id); // Iniciar Loading

    try {
      // 2. Actualizar Estado del Pedido (Backend)
      await pedRepo.updatePedidoStatus(p.id, PedidoStatus.paid);

      // 3. Generar Factura (Backend/SUNAT)
      final newInvoice = Invoice(
        id: 'FAC-${DateTime.now().millisecondsSinceEpoch}', // ID Generado
        orderId: p.id,
        clientName: 'Cliente Mesa ${p.tableNumber}', // Podría ser input
        status: 'Pagado',
        total: p.total,
        paymentMethod: paymentMethod,
        date: DateTime.now(),
      );
      
      await billRepo.createInvoice(newInvoice);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Cobrado con $paymentMethod exitosamente'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cobrar: $e'), backgroundColor: Theme.of(context).colorScheme.error),
      );
    } finally {
      if (mounted) setState(() => _processingOrderId = null); // Detener Loading
    }
  }

  Future<String?> _showPaymentMethodDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Método de Pago'),
        children: [
          _PaymentOption(
            icon: Icons.money, 
            label: 'Efectivo', 
            color: Colors.green,
            onTap: () => Navigator.pop(ctx, 'Efectivo')
          ),
          _PaymentOption(
            icon: Icons.credit_card, 
            label: 'Tarjeta (Visa/Master)', 
            color: Colors.blue,
            onTap: () => Navigator.pop(ctx, 'Tarjeta')
          ),
          _PaymentOption(
            icon: Icons.qr_code, 
            label: 'Yape / Plin', 
            color: Colors.purple,
            onTap: () => Navigator.pop(ctx, 'Yape/Plin')
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

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon, required this.label, required this.color, required this.onTap
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
