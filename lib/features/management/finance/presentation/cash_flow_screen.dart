import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';
import '../domain/models/finance_models.dart';
import '../domain/repositories/finance_repository.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final financeRepo = context.read<FinanceRepository>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flujo de Caja'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
      body: FutureBuilder<List<Object>>(
        future: Future.wait([
          financeRepo.getDailyStats(),
          financeRepo.getRecentTransactions(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data?[0] as FinancialStats;
          final transactions = snapshot.data?[1] as List<AppTransaction>;

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
                        value: 'S/ ${stats.incomeToday.toStringAsFixed(2)}',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        trend: '+12%',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Gastos Hoy',
                        value: 'S/ ${stats.expenseToday.toStringAsFixed(2)}',
                        icon: Icons.trending_down,
                        color: Colors.red,
                        trend: '-5%',
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
                        value: 'S/ ${stats.netProfit.toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Facturas',
                        value: '${stats.invoiceCount}',
                        icon: Icons.receipt,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Text('Últimos Movimientos', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: AppDataTable(
                    columns: const ['Concepto', 'Tipo', 'Monto', 'Hora'],
                    rows: transactions.map((t) => _buildTransaction(t)).toList(),
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

  List<Widget> _buildTransaction(AppTransaction t) {
    return [
      Text(t.concept, style: const TextStyle(color: Colors.white)),
      Text(t.type, style: TextStyle(color: t.isIncome ? Colors.green : Colors.red)),
      Text(
        (t.isIncome ? '+' : '-') + 'S/ ${t.amount.toStringAsFixed(2)}', 
        style: TextStyle(fontWeight: FontWeight.bold, color: t.isIncome ? Colors.green : Colors.red)
      ),
      Text(DateFormat('hh:mm a').format(t.date), style: const TextStyle(color: AppColors.textSecondary)),
    ];
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
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
