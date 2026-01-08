import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Tabla de datos genérica estilizada para la app.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyState,
  });

  final List<String> columns;
  final List<List<Widget>> rows;
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return emptyState ?? Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text(
                'No hay datos para mostrar',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.white.withOpacity(0.05)),
          dataRowColor: MaterialStateProperty.all(Colors.transparent),
          columns: columns.map((col) => DataColumn(
            label: Text(
              col.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          )).toList(),
          rows: rows.map((row) => DataRow(
            cells: row.map((ceilWidget) => DataCell(ceilWidget)).toList(),
          )).toList(),
        ),
      ),
    );
  }
}
