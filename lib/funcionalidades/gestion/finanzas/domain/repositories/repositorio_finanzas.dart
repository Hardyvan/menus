import '../models/modelos_finanzas.dart';

abstract class FinanceRepository {
  Future<FinancialStats> getDailyStats();
  Future<List<AppTransaction>> getRecentTransactions();
}
