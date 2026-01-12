import 'package:flutter/material.dart';
import '../layout/puntos_de_quiebre.dart';
import 'tarjeta_app.dart';

/// Tabla de datos inteligente que se adapta a Móvil (Lista) y Escritorio (Tabla).
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
      return emptyState ?? _buildDefaultEmptyState(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.mobile) {
          return _buildMobileList(context);
        }
        return _buildDesktopTable(context);
      },
    );
  }

  /// 📱 Vista Móvil: Lista de Tarjetas
  Widget _buildMobileList(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // Scroll controlado por el padre
      shrinkWrap: true,
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final row = rows[index];
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(row.length, (colIndex) {
              // Evitamos error si hay más celdas que columnas
              if (colIndex >= columns.length) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nombre de la columna (Key)
                    Text(
                      columns[colIndex],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Valor de la celda (Value)
                    Flexible(child: row[colIndex]),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  /// 🖥️ Vista Escritorio: Tabla Tradicional
  Widget _buildDesktopTable(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface, // Dinámico
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)),
          dataRowColor: WidgetStateProperty.all(Colors.transparent),
          columns: columns
              .map((col) => DataColumn(
                    label: Text(
                      col.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ))
              .toList(),
          rows: rows
              .map((row) => DataRow(
                    cells: row.map((cellWidget) => DataCell(cellWidget)).toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 48, color: colorScheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No hay datos para mostrar',
              style: TextStyle(color: colorScheme.outline, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
