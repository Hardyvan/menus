import '../../domain/models/invoice.dart';
import '../../domain/repositories/billing_repository.dart';

class MockBillingRepository implements BillingRepository {
  @override
  Future<List<Invoice>> getInvoices() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      Invoice(id: 'FAC-00124', clientName: 'Consumidor Final', status: 'Pagado', total: 45.00, date: DateTime.now()),
      Invoice(id: 'FAC-00123', clientName: 'Juan Pérez', status: 'Pagado', total: 85.50, date: DateTime.now().subtract(const Duration(hours: 3))),
      Invoice(id: 'FAC-00122', clientName: 'Consumidor Final', status: 'Pagado', total: 12.00, date: DateTime.now().subtract(const Duration(days: 1))),
      Invoice(id: 'FAC-00121', clientName: 'María López', status: 'Anulado', total: 0.00, date: DateTime.now().subtract(const Duration(days: 1))),
    ];
  }
}
