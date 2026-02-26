import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menus/funcionalidades/pedidos/domain/repositories/repositorio_pedido.dart';
import 'package:menus/funcionalidades/pedidos/domain/models/pedido.dart';
import '../domain/models/modelos_finanzas.dart';
import '../domain/repositories/repositorio_finanzas.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos PedidoRepository para datos reales de la sesión
    final pedidoRepo = context.read<PedidoRepository>();
    // Mantenemos financeRepo para datos mock que no tenemos implementados en pedidos (gastos, historico)
    final financeRepo = context.read<FinanceRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Flujo de Caja'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const Drawer(),
      // 🚀 CARGA PARALELA (Future.wait)
      // Aquí hacemos DOS llamadas al mismo tiempo:
      // 1. Traer Pedidos (para calcular ingresos)
      // 2. Traer Gastos (del módulo de finanzas)
      // La pantalla espera a que AMBAS terminen antes de mostrarse. ¡Eficiencia pura!
      body: FutureBuilder<List<Object>>(
        future: Future.wait([
          //aqui es donde va el codigo backend//
          // Obtenemos pedidos pagados o entregados para calcular ingresos
          pedidoRepo.getPedidosByStatus([PedidoStatus.paid, PedidoStatus.cooking, PedidoStatus.ready, PedidoStatus.delivered]),
          financeRepo.getDailyStats(), // Para gastos dummy
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pedidos = snapshot.data?[0] as List<Pedido>;
          final dummyStats = snapshot.data?[1] as FinancialStats;

          // CÁLCULO EN CLIENTE (Fase C)
          final incomeToday = pedidos.fold(0.0, (sum, pedido) => sum + pedido.total);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen Diario', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                
                // Cards Superiores
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Ingresos Hoy',
                        value: 'S/ ${incomeToday.toStringAsFixed(2)}',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        subtitle: 'En Vivo',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Gastos Hoy',
                        value: 'S/ ${dummyStats.expenseToday.toStringAsFixed(2)}',
                        icon: Icons.trending_down,
                        color: Colors.red,
                        subtitle: '(Simulado)',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Beneficio Neto',
                        value: 'S/ ${(incomeToday - dummyStats.expenseToday).toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Pedidos',
                        value: '${pedidos.length}',
                        icon: Icons.receipt,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Text('Últimos Pedidos', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    // columns:const ['Mesa', 'Estado', 'Monto', 'Hora'],
                    // rows:pedidos.map((p) => _buildPedidoRow(context, p)).toList(),
                    child: _buildEmptyState(context),
                  ),
                ),
                
                const SizedBox(height: 32),
                Text('Desempeño del Personal (Top Mozos)', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 150, 
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildWaiterCard(context, 'Luis Diaz', '18 Pedidos', 'S/ 1,250.00', 1),
                      _buildWaiterCard(context, 'Ana López', '14 Pedidos', 'S/ 980.50', 2),
                      _buildWaiterCard(context, 'Pedro M.', '10 Pedidos', 'S/ 450.00', 3),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
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

  Widget _buildWaiterCard(BuildContext context, String name, String orders, String sales, int rank) {
    final theme = Theme.of(context);
    Color medalColor = Colors.grey.withValues(alpha: 0.2); // Default
    if (rank == 1) medalColor = const Color(0xFFFFD700); // Gold
    if (rank == 2) medalColor = const Color(0xFFC0C0C0); // Silver
    if (rank == 3) medalColor = const Color(0xFFCD7F32); // Bronze

    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: rank == 1 ? Border.all(color: medalColor, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(name[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              if (rank <= 3) Icon(Icons.emoji_events, color: medalColor, size: 24),
            ],
          ),
          const Spacer(),
          Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.receipt_long, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(orders, style: theme.textTheme.bodySmall),
            ],
          ),
          Row(
            children: [
               const Icon(Icons.attach_money, size: 14, color: Colors.green),
               const SizedBox(width: 4),
               Text(sales, style: theme.textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 40, color: Theme.of(context).disabledColor),
          const SizedBox(height: 12),
           Text(
            'Sin movimientos hoy',
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
