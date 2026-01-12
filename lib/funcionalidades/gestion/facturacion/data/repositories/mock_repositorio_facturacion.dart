import '../../domain/models/factura.dart';
import '../../domain/repositories/repositorio_facturacion.dart';

class MockBillingRepository implements BillingRepository {
  // 🧠 Memoria Volátil para el Mock (Simula Base de Datos)
  final List<Invoice> _db = [
    Invoice(
      id: 'FAC-00124', 
      orderId: 'ORD-999',
      clientName: 'Consumidor Final', 
      status: 'Pagado', 
      total: 45.00, 
      paymentMethod: 'Efectivo',
      date: DateTime.now()
    ),
    Invoice(
      id: 'FAC-00123', 
      orderId: 'ORD-998',
      clientName: 'Juan Pérez', 
      clientRuc: '10456789012',
      status: 'Pagado', 
      total: 85.50, 
      paymentMethod: 'Tarjeta',
      date: DateTime.now().subtract(const Duration(hours: 3))
    ),
  ];

  @override
  Future<List<Invoice>> getInvoices() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_db); // Retornamos copia segura
  }

  @override
  Future<void> createInvoice(Invoice invoice) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latencia de SUNAT/Backend
    _db.insert(0, invoice); // Agrega al inicio
  }
}
