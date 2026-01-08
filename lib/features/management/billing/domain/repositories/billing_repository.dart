import '../models/invoice.dart';

abstract class BillingRepository {
  Future<List<Invoice>> getInvoices();
}
