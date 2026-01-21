/// Pantalla de creación de pedidos.
library;

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../viewmodels/create_order_viewmodel.dart';
import 'product_selection_screen.dart';

/// Pantalla para crear un nuevo pedido.
///
/// Permite al usuario:
/// - Introducir el nombre de la mesa o cliente
/// - Añadir productos desde la carta del bar
/// - Ver un resumen provisional del pedido
/// - Guardar o cancelar el pedido
class CreateOrderScreen extends StatefulWidget {
  /// Crea una instancia de [CreateOrderScreen].
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  /// ViewModel que gestiona el estado del pedido en creación.
  final CreateOrderViewModel _viewModel = CreateOrderViewModel();

  /// Controlador del campo de texto para la mesa.
  final TextEditingController _tableController = TextEditingController();

  /// Key para el formulario de validación.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  /// Navega a la pantalla de selección de productos.
  ///
  /// Utiliza [Navigator.push] y espera los productos seleccionados.
  /// Los productos devueltos se añaden al pedido actual.
  Future<void> _navigateToProductSelection() async {
    final List<SelectedProduct>? selectedProducts =
        await Navigator.push<List<SelectedProduct>>(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductSelectionScreen(),
          ),
        );

    // Verificar mounted antes de actualizar estado
    if (!mounted) return;

    if (selectedProducts != null && selectedProducts.isNotEmpty) {
      setState(() {
        _viewModel.addProducts(selectedProducts);
      });

      // Notificar al usuario que se añadieron productos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Se añadieron ${selectedProducts.length} producto(s) al pedido',
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Navega a la pantalla de resumen usando rutas con nombre.
  ///
  /// Utiliza [Navigator.pushNamed] con la ruta '/resumen'.
  void _navigateToSummary() {
    Navigator.pushNamed(
      context,
      '/resumen',
      arguments: {
        'tableName': _viewModel.tableName,
        'products': _viewModel.selectedProducts,
        'totalPrice': _viewModel.totalPrice,
      },
    );
  }

  /// Valida y guarda el pedido.
  ///
  /// Realiza validaciones de:
  /// - Nombre de mesa no vacío
  /// - Al menos un producto seleccionado
  ///
  /// Si las validaciones pasan, cierra la pantalla devolviendo el pedido.
  void _saveOrder() {
    // Validar nombre de mesa
    if (!_viewModel.isTableNameValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Por favor, introduce el nombre de la mesa'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Validar que hay productos
    if (!_viewModel.hasProducts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Por favor, añade al menos un producto'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Crear el pedido y devolverlo a Home
    final order = _viewModel.createOrder(
      DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Navigator.pop devolviendo el pedido completo
    Navigator.pop(context, order);
  }

  /// Cancela la creación del pedido.
  ///
  /// Cierra la pantalla sin devolver datos a Home.
  void _cancelOrder() {
    // Mostrar diálogo de confirmación si hay datos
    if (_viewModel.hasProducts || _viewModel.tableName.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Cancelar pedido?'),
          content: const Text(
            'Se perderán todos los datos introducidos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No, continuar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Cerrar pantalla sin resultado
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sí, cancelar'),
            ),
          ],
        ),
      );
    } else {
      // Si no hay datos, salir directamente
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Pedido'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección: Identificación del pedido
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Identificación del pedido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Campo de texto con validación visual
                      TextFormField(
                        controller: _tableController,
                        decoration: InputDecoration(
                          labelText: 'Mesa o nombre *',
                          hintText: 'Ej: Mesa 5, Barra - Juan',
                          prefixIcon: const Icon(Icons.table_restaurant),
                          border: const OutlineInputBorder(),
                          // Indicador visual de error si está vacío y se ha tocado
                          errorText: _tableController.text.isEmpty &&
                                  _viewModel.tableName.isEmpty
                              ? null
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _viewModel.setTableName(value);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre de la mesa es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '* Campo obligatorio',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botón: Añadir productos
              Tooltip(
                message: 'Abrir la carta del bar para seleccionar productos',
                child: ElevatedButton.icon(
                  onPressed: _navigateToProductSelection,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Añadir productos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sección: Resumen provisional del pedido
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Resumen del pedido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_viewModel.hasProducts)
                            Tooltip(
                              message: 'Número total de productos',
                              child: Chip(
                                label: Text('${_viewModel.totalProducts}'),
                                backgroundColor: Colors.blue[100],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_viewModel.selectedProducts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'No hay productos seleccionados',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        // Lista de productos seleccionados
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _viewModel.selectedProducts.length,
                          itemBuilder: (context, index) {
                            final item = _viewModel.selectedProducts[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item.product.name),
                              subtitle: Text(
                                '${item.product.price.toStringAsFixed(2)} € x ${item.quantity}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${item.totalPrice.toStringAsFixed(2)} €',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Botón eliminar con tooltip
                                  Tooltip(
                                    message: 'Eliminar ${item.product.name}',
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _viewModel.removeProduct(item);
                                        });
                                        // Notificar eliminación
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${item.product.name} eliminado',
                                            ),
                                            duration:
                                                const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(thickness: 2),
                        // Total acumulado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_viewModel.totalPrice.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botón: Ver resumen (solo si el pedido es válido)
              if (_viewModel.isValidOrder)
                Tooltip(
                  message: 'Ver el resumen completo del pedido',
                  child: ElevatedButton.icon(
                    onPressed: _navigateToSummary,
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Ver resumen'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Botones de acción: Cancelar y Guardar
              Row(
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: Tooltip(
                      message: 'Cancelar y volver sin guardar',
                      child: OutlinedButton(
                        onPressed: _cancelOrder,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botón Guardar
                  Expanded(
                    child: Tooltip(
                      message: _viewModel.isValidOrder
                          ? 'Guardar el pedido'
                          : 'Completa los campos requeridos',
                      child: ElevatedButton(
                        onPressed: _saveOrder,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Guardar pedido'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
