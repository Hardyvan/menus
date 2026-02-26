import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';

import '../../domain/models/item_menu.dart';
import '../../domain/repositories/repositorio_menu.dart';

class CreateEditDishScreen extends StatelessWidget {
  final MenuItem? item; // Si es null, estamos creando. Si no, editando.

  const CreateEditDishScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final isEditing = item != null;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Plato' : 'Nuevo Plato'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _DishForm(item: item),
      ),
    );
  }
}

class _DishForm extends StatefulWidget {
  final MenuItem? item;

  const _DishForm({this.item});

  @override
  State<_DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<_DishForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _imageCtrl;
  String _category = 'Platos de Fondo';
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _descCtrl = TextEditingController(text: i?.description ?? '');
    _priceCtrl = TextEditingController(text: i?.price.toString() ?? '');
    _imageCtrl = TextEditingController(text: i?.imageUrl ?? '');
    if (i != null) {
      _category = i.category;
      _isAvailable = i.isAvailable;
    }
    
    // Escuchar cambios en la URL para actualizar vista previa
    _imageCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🖼️ PREVISUALIZACIÓN DE IMAGEN
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
                image: _imageCtrl.text.isNotEmpty 
                  ? DecorationImage(
                      image: NetworkImage(_imageCtrl.text),
                      fit: BoxFit.cover,
                      onError: (e,s) {}, // Silencioso si falla
                    )
                  : null,
              ),
              child: _imageCtrl.text.isEmpty
                  ? const Icon(Icons.image, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 24),

          CampoTextoPersonalizado(
            label: 'Nombre del Plato',
            prefixIcon: Icons.restaurant,
            controller: _nameCtrl,
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          CampoTextoPersonalizado(
            label: 'Descripción',
            prefixIcon: Icons.description,
            controller: _descCtrl,
            maxLines: 3,
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CampoTextoPersonalizado(
                  label: 'Precio (S/)',
                  prefixIcon: Icons.attach_money,
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => double.tryParse(v!) == null ? 'Inválido' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    dropdownColor: theme.cardColor,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.dividerColor)),
                    ),
                  items: ['Entradas', 'Platos de Fondo', 'Bebidas', 'Postres']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => _category = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CampoTextoPersonalizado(
            label: 'URL de Imagen',
            prefixIcon: Icons.link,
            controller: _imageCtrl,
             validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          
          // Switch Disponibilidad
          SwitchListTile(
            title: Text('Disponible para venta', style: TextStyle(color: theme.colorScheme.onSurface)),
            subtitle: const Text('Desactívalo si se agotan los insumos'),
            value: _isAvailable,
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (val) => setState(() => _isAvailable = val),
          ),
          
          const SizedBox(height: 32),
          BotonGradiente(
            text: 'GUARDAR PLATO',
            icon: Icons.save,
            onPressed: _saveDish,
          ),
        ],
      ),
    );
  }

  Future<void> _saveDish() async {
    if (!_formKey.currentState!.validate()) return;

    final newItem = MenuItem(
      id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text,
      description: _descCtrl.text,
      price: double.parse(_priceCtrl.text),
      imageUrl: _imageCtrl.text,
      category: _category,
      isAvailable: _isAvailable,
    );

    final repo = context.read<MenuRepository>();
    
    if (widget.item == null) {
      await repo.addMenuItem(newItem);
    } else {
      await repo.updateMenuItem(newItem);
    }

    if (mounted) {
      context.pop(); // Volver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menú actualizado correctamente')),
      );
    }
  }
}
