import '../models/factura.dart';

abstract class BillingRepository {
  Future<List<Invoice>> getInvoices();
  
  /// 📝 Crea una nueva factura en el sistema (Backend / SUNAT)
  Future<void> createInvoice(Invoice invoice);
}
