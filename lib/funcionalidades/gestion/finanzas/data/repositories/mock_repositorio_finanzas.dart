import '../../domain/models/modelos_finanzas.dart';
import '../../domain/repositories/repositorio_finanzas.dart';

class MockFinanceRepository implements FinanceRepository {
  @override
  Future<FinancialStats> getDailyStats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const FinancialStats(
      incomeToday: 1250.00,
      expenseToday: 430.50,
      netProfit: 819.50,
      invoiceCount: 45,
    );
  }

  @override
  Future<List<AppTransaction>> getRecentTransactions() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      AppTransaction(id: '1', concept: 'Venta Mesa #4', type: 'Ingreso', amount: 45.00, date: DateTime.now().subtract(const Duration(minutes: 30))),
      AppTransaction(id: '2', concept: 'Pago Proveedor (Verduras)', type: 'Gasto', amount: 120.00, date: DateTime.now().subtract(const Duration(hours: 2))),
      AppTransaction(id: '3', concept: 'Venta Mesa #2', type: 'Ingreso', amount: 85.50, date: DateTime.now().subtract(const Duration(hours: 3))),
      AppTransaction(id: '4', concept: 'Venta Delivery #104', type: 'Ingreso', amount: 32.00, date: DateTime.now().subtract(const Duration(hours: 3, minutes: 15))),
    ];
  }
}
