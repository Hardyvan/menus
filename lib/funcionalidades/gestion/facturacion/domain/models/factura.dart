class Invoice {
  final String id;
  final String orderId; // 🔗 Relación con el pedido original
  final String clientName;
  final String? clientRuc; // 🏢 Para facturas corporativas
  final String status; // 'Pagado', 'Pendiente', 'Anulado'
  final double total;
  final String paymentMethod; // 💳 Efectivo, Tarjeta, Yape
  final DateTime date;

  const Invoice({
    required this.id,
    required this.orderId,
    required this.clientName,
    this.clientRuc,
    required this.status,
    required this.total,
    required this.paymentMethod,
    required this.date,
  });

  bool get isPaid => status == 'Pagado';
}
