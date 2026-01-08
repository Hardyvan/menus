import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';

import '../domain/models/invoice.dart';
import '../domain/repositories/billing_repository.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final billingRepo = context.read<BillingRepository>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Facturación y Ventas'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
      body: FutureBuilder<List<Invoice>>(
        future: billingRepo.getInvoices(),
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final invoices = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Filtros (Visual - solo UI por ahora)
                Row(
                  children: [
                    Expanded(
                      child: AppTextInput(
                        label: 'Buscar Factura',
                        prefixIcon: Icons.search,
                        controller: TextEditingController(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AppButton(
                      text: 'Filtrar',
                      onPressed: () {},
                      icon: Icons.filter_list,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tabla
                SizedBox(
                  width: double.infinity,
                  child: AppDataTable(
                    columns: const ['No. Factura', 'Cliente', 'Estado', 'Total', 'Fecha'],
                    rows: invoices.map((i) => _buildInvoice(i)).toList(),
                    emptyState: _buildEmptyState(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildInvoice(Invoice i) {
    final isPaid = i.isPaid;
    return [
      Text(i.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      Text(i.clientName, style: const TextStyle(color: AppColors.textSecondary)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: (isPaid ? Colors.green : Colors.grey).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          i.status,
          style: TextStyle(
            color: isPaid ? Colors.green : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Text('S/ ${i.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      Text(DateFormat('dd/MM HH:mm').format(i.date), style: const TextStyle(color: AppColors.textSecondary)),
    ];
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No hay facturas registradas',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
