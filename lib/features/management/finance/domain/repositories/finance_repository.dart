import '../models/finance_models.dart';

abstract class FinanceRepository {
  Future<FinancialStats> getDailyStats();
  Future<List<AppTransaction>> getRecentTransactions();
}
