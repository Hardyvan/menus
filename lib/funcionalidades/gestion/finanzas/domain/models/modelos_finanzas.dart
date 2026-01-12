class AppTransaction {
  final String id;
  final String concept;
  final String type; // 'Ingreso' or 'Gasto'
  final double amount;
  final DateTime date;

  const AppTransaction({
    required this.id,
    required this.concept,
    required this.type,
    required this.amount,
    required this.date,
  });

  bool get isIncome => type == 'Ingreso';
}

class FinancialStats {
  final double incomeToday;
  final double expenseToday;
  final double netProfit;
  final int invoiceCount;

  const FinancialStats({
    required this.incomeToday,
    required this.expenseToday,
    required this.netProfit,
    required this.invoiceCount,
  });
}
