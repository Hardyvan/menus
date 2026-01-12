import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flujo de Caja'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
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
                      child: StatCard(
                        title: 'Ingresos Hoy',
                        value: 'S/ ${incomeToday.toStringAsFixed(2)}', // Calculado
                        icon: Icons.trending_up,
                        color: Colors.green,
                        trend: 'En Vivo',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Gastos Hoy',
                        value: 'S/ ${dummyStats.expenseToday.toStringAsFixed(2)}',
                        icon: Icons.trending_down,
                        color: Colors.red,
                        trend: '(Simulado)',
                        trendUp: true, 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Beneficio Neto',
                        value: 'S/ ${(incomeToday - dummyStats.expenseToday).toStringAsFixed(2)}', // Calculado
                        icon: Icons.account_balance_wallet,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
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
                  child: AppDataTable(
                    columns: const ['Mesa', 'Estado', 'Monto', 'Hora'],
                    rows: pedidos.map((p) => _buildPedidoRow(p)).toList(),
                    emptyState: _buildEmptyState(context),
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

  List<Widget> _buildPedidoRow(Pedido p) {
    return [
      Text(p.tableNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      Text(p.status.name.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary)),
      Text(
        'S/ ${p.total.toStringAsFixed(2)}', 
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
      ),
      Text(DateFormat('hh:mm a').format(p.timestamp), style: const TextStyle(color: AppColors.textSecondary)),
    ];
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          const Text(
            'Sin movimientos hoy',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
