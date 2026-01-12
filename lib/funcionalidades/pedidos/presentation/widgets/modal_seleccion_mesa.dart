import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../../domain/repositories/repositorio_pedido.dart';
import '../../domain/models/pedido.dart';

class TableSelectionModal extends StatefulWidget {
  final Function(String) onTableSelected;

  const TableSelectionModal({super.key, required this.onTableSelected});

  @override
  State<TableSelectionModal> createState() => _TableSelectionModalState();
}

class _TableSelectionModalState extends State<TableSelectionModal> {
  // Lista simulada de mesas
  final List<String> _tables = List.generate(12, (index) => 'Mesa ${index + 1}');
  String? _selectedTable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = context.read<PedidoRepository>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seleccionar Mesa',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              // Leyenda
              Row(
                children: [
                  _buildLegendItem(theme, Colors.redAccent.withValues(alpha: 0.2), 'Ocupada'),
                  const SizedBox(width: 8),
                  _buildLegendItem(theme, theme.cardColor, 'Libre'),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '¿Qué mesa estás atendiendo?',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          
          // 5. UX: Feedback Visual de Mesas Ocupadas
          StreamBuilder<List<Pedido>>(
            stream: repo.pedidosStream,
            builder: (context, snapshot) {
              final occupiedTables = <String>{};
              if (snapshot.hasData) {
                for (var pedido in snapshot.data!) {
                  // Asumimos que cualquier pedido activo ocupa la mesa
                  // Podríamos filtrar solo los no "delivered" si tuviéramos un estado "closed"
                  occupiedTables.add(pedido.tableNumber);
                }
              }

              return AspectRatio(
                aspectRatio: 1.5,
                child: GridView.builder(
                  itemCount: _tables.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final table = _tables[index];
                    final isOccupied = occupiedTables.contains(table);
                    final isSelected = _selectedTable == table;
                    
                    return InkWell(
                      onTap: isOccupied ? null : () {
                        setState(() {
                          _selectedTable = table;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // Rojo si ocupado, Primary si seleccionado, Card si libre
                          color: isOccupied 
                              ? Colors.redAccent.withValues(alpha: 0.1) 
                              : isSelected 
                                  ? theme.colorScheme.primary 
                                  : theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isOccupied 
                                ? Colors.redAccent.withValues(alpha: 0.5)
                                : isSelected 
                                    ? theme.colorScheme.primary 
                                    : theme.colorScheme.outlineVariant,
                          ),
                          boxShadow: isSelected 
                            ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))]
                            : [],
                        ),
                        child: Text(
                          table,
                          style: TextStyle(
                            color: isOccupied 
                                ? Colors.redAccent
                                : isSelected 
                                    ? theme.colorScheme.onPrimary 
                                    : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            decoration: isOccupied ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: 'Confirmar',
              onPressed: _selectedTable != null 
                ? () => widget.onTableSelected(_selectedTable!) 
                : null, // Disabled if null
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: theme.dividerColor, width: 0.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
