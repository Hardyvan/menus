import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:menus/funcionalidades/pedidos/domain/models/pedido.dart';
import 'package:menus/funcionalidades/pedidos/domain/repositories/repositorio_pedido.dart';
import '../application/proveedor_carrito.dart';
import '../domain/models/item_carrito.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Pedido'),
        centerTitle: true,
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Limpiar carrito',
              onPressed: () => _confirmClearCart(context, cart),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _buildEmptyState(theme)
          : Column(
              children: [
                // 1. Selector de Mesa
                _buildTableSelector(context, cart, theme),

                // 2. Lista de Ítems
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _CartItemCard(
                                cartItem: cart.items[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 3. Resumen y Confirmación
                _CartSummary(
                  total: cart.totalAmount,
                  isSending: _isSending,
                  onConfirm: () => _processOrder(cart),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80,
              color: theme.iconTheme.color?.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Agrega platos deliciosos!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            child: AppButton(
              text: 'Ir al Menú',
              onPressed: () => context.go('/menu'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSelector(
      BuildContext context, CartProvider cart, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
            bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          const Icon(Icons.table_restaurant_outlined),
          const SizedBox(width: 12),
          Text(
            'Mesa:',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: cart.tableNumber,
                hint: const Text('Seleccionar mesa'),
                isExpanded: true,
                items: List.generate(20, (index) {
                  final tableNum = (index + 1).toString();
                  return DropdownMenuItem(
                    value: tableNum,
                    child: Text('Mesa $tableNum'),
                  );
                }),
                onChanged: (val) {
                  if (val != null) cart.setTableNumber(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder(CartProvider cart) async {
    // 1. Validación
    if (cart.tableNumber == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Falta indicar la Mesa!'),
            ],
          ),
          backgroundColor: Colors.orange[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // 2. Simulación de Backend / Integración
      final pedidoRepo = context.read<PedidoRepository>();
      
      final nuevoPedido = Pedido(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tableNumber: cart.tableNumber!,
        items: cart.items.map((cartItem) => PedidoItem(
              menuItem: cartItem.menuItem,
              quantity: cartItem.quantity,
              notes: cartItem.notes, // ✅ Mapeamos las notas
            )).toList(),
        total: cart.totalAmount,
        timestamp: DateTime.now(),
        updatedAt: DateTime.now(), // 🕒 Auditoría Inicial
        status: PedidoStatus.pendingPayment,
      );

      await pedidoRepo.createPedido(nuevoPedido);
      
      // 3. Limpieza y Éxito
      if (!mounted) return;
      cart.clearCart();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('¡Pedido enviado a cocina! 👨‍🍳'),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      context.pop(); // Regresar
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar pedido: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _confirmClearCart(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Vaciar carrito?'),
        content: const Text('Se eliminarán todos los platos seleccionados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<CartProvider>(); // Usamos read para acciones

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Ajuste fino
        child: Row(
          children: [
            // Imagen cuadrada
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.menuItem.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.menuItem.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'S/ ${cartItem.menuItem.price}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                  if (cartItem.notes != null)
                    Text(
                      'Nota: ${cartItem.notes}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),

            // Controles de Cantidad POS Style
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 20, color: theme.colorScheme.primary),
                    onPressed: () => provider.decreaseItem(cartItem),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    padding: EdgeInsets.zero,
                  ),
                  Text(
                    '${cartItem.quantity}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 20, color: theme.colorScheme.primary),
                    onPressed: () => provider.addItem(cartItem.menuItem, 1),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.total,
    required this.isSending,
    required this.onConfirm,
  });

  final double total;
  final bool isSending;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleLarge),
                Text(
                  'S/ ${total.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'CONFIRMAR PEDIDO',
                isLoading: isSending,
                onPressed: isSending ? null : onConfirm, // Deshabilitar si carga
              ),
            ),
          ],
        ),
      ),
    );
  }
}
