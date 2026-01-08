import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ui/app_ui.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/menu_item.dart';
import '../../cart/application/cart_provider.dart';

/// Pantalla de Detalle de un Platillo.
///
/// Muestra la imagen en grande, descripción completa y botón de compra.
/// Implementa navegación responsiva:
/// - Se adapta layout para verse bien en móvil y escritorio.
class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key, required this.item});

  final MenuItem item;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _addToCart() {
    // Agregamos al carrito global
    context.read<CartProvider>().addItem(widget.item, _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Agregado ${_quantity}x ${widget.item.title} al carrito',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop(); // GoRouter pop
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dinámico
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: Colors.transparent,
      ),
      // Usamos ResponsiveLayoutBuilder para ajustar el contenedor principal
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800), // Límite para escritorio
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Imagen Principal con borde redondeado
              Hero(
                tag: widget.item.imageUrl, // Mismo tag que en la lista
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.restaurant, size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Título y Precio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color, // Dinámico
                          ),
                    ),
                  ),
                  Text(
                    'S/ ${widget.item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor, // Dinámico
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. Descripción
              Text(
                widget.item.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8), // Dinámico
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),

              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 16),

              // 4. Selector de Cantidad y Botón
              ResponsiveLayoutBuilder(
                mobile: Column(
                  children: [
                    _QuantitySelector(
                      quantity: _quantity,
                      onIncrement: _increment,
                      onDecrement: _decrement,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: 'Agregar al Carrito - S/ ${(widget.item.price * _quantity).toStringAsFixed(2)}',
                        onPressed: _addToCart,
                        icon: Icons.add_shopping_cart,
                      ),
                    ),
                  ],
                ),
                // En tablet/desktop mostramos en una fila
                tablet: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _QuantitySelector(
                      quantity: _quantity,
                      onIncrement: _increment,
                      onDecrement: _decrement,
                    ),
                    const SizedBox(width: 24),
                    AppButton(
                      text: 'Agregar al Pedido',
                      onPressed: _addToCart,
                      icon: Icons.add_shopping_cart,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selector de cantidad interno
class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Dinámico
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
            color: Theme.of(context).primaryColor, // Dinámico
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
            color: Theme.of(context).primaryColor, // Dinámico
          ),
        ],
      ),
    );
  }
}
