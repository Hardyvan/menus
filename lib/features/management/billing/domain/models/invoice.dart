class Invoice {
  final String id;
  final String clientName;
  final String status; // 'Pagado', 'Pendiente', 'Anulado'
  final double total;
  final DateTime date;

  const Invoice({
    required this.id,
    required this.clientName,
    required this.status,
    required this.total,
    required this.date,
  });

  bool get isPaid => status == 'Pagado';
}
