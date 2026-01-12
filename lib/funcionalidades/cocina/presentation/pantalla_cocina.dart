import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Para el Timer

import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../pedidos/domain/models/pedido.dart';
import '../../pedidos/domain/repositories/repositorio_pedido.dart';

class CocinaScreen extends StatelessWidget {
  const CocinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧠 LOGIC: Directamente consumimos el stream.
    // Nada de hacks de "refresh". Si el repositorio actualiza el stream,
    // esta pantalla se redibuja sola.
    final pedidoRepo = context.read<PedidoRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocina - KDS'),
        centerTitle: true,
        actions: [
          // Indicador de "En Vivo"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.redAccent, width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.redAccent, size: 10),
                SizedBox(width: 8),
                Text('EN VIVO',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Pedido>>(
        stream: pedidoRepo.pedidosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allPedidos = snapshot.data ?? [];
          final cocinaOrders = allPedidos.where((p) =>
              p.status == PedidoStatus.paid ||
              p.status == PedidoStatus.cooking).toList();
          
          // Ordenar por tiempo (los más viejos primero)
          cocinaOrders.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          if (cocinaOrders.isEmpty) {
            return _buildEmptyState();
          }

          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              // Layout Responsivo Industrial
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450, // Tarjetas más anchas para ver items
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85, // Ajuste para contenido vertical
              ),
              itemCount: cocinaOrders.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: _LiveOrderCard(pedido: cocinaOrders[index]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, 
               size: 80, color: Colors.green.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text(
            '¡Todo limpio, Chef! 👨‍🍳',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text('Esperando nuevas comandas...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

/// Tarjeta Inteliigente con Cronómetro interno
class _LiveOrderCard extends StatefulWidget {
  const _LiveOrderCard({required this.pedido});
  final Pedido pedido;

  @override
  State<_LiveOrderCard> createState() => _LiveOrderCardState();
}

class _LiveOrderCardState extends State<_LiveOrderCard> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Actualizamos cada minuto para ahorrar recursos, pero mantenemos la UI viva
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.pedido.timestamp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNew = widget.pedido.status == PedidoStatus.paid;
    
    // 🚨 Semáforo de Prioridad
    final minutes = _elapsed.inMinutes;
    Color statusColor;
    if (isNew) {
      statusColor = Colors.green; // Nuevo
    } else if (minutes > 15) {
      statusColor = Colors.red; // ¡Peligro! Retrasado
    } else {
      statusColor = Colors.orange; // Cocinando
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // 1. Header Industrial
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MESA ${widget.pedido.tableNumber}", 
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white)
                    ),
                    Text(
                      "Hace $minutes min", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
                if (minutes > 15)
                   const Icon(Icons.warning, color: Colors.white, size: 32)
                else if (!isNew)
                   const Icon(Icons.soup_kitchen, color: Colors.white, size: 32),
              ],
            ),
          ),

          // 2. Lista de Items Escalable
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: widget.pedido.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = widget.pedido.items[index];
                final hasNotes = item.notes != null && item.notes!.isNotEmpty;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cantidad Gigante
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: theme.colorScheme.onSurface),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Nombre y Notas
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.menuItem.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            if (hasNotes)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.amber, width: 0.5)
                                ),
                                child: Text(
                                  '📢 ${item.notes}',
                                  style: TextStyle(
                                    fontSize: 14, 
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.amber[900]
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 3. Botón de Acción Seguro (Touch Grande)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 56, // Botón alto para dedos rápidos
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                icon: Icon(isNew ? Icons.local_fire_department : Icons.check_circle, size: 28),
                label: Text(
                  isNew ? 'MARCHAR' : 'TERMINAR',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                onPressed: () => _updateStatus(context, isNew),
                // 🛡️ Seguridad: Long Press para terminar y evitar errores
                onLongPress: !isNew ? () => _updateStatus(context, isNew) : null, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, bool isNew) {
    final repo = context.read<PedidoRepository>();
    if (isNew) {
      repo.updatePedidoStatus(widget.pedido.id, PedidoStatus.cooking);
    } else {
      repo.updatePedidoStatus(widget.pedido.id, PedidoStatus.ready);
    }
  }
}
