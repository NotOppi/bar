import 'package:flutter/material.dart';
import '../models/product.dart';
import '../viewmodels/create_order_viewmodel.dart';
import 'product_selection_screen.dart';

/// Pantalla de creación de un nuevo pedido
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // ViewModel para gestionar el estado del pedido
  final CreateOrderViewModel _viewModel = CreateOrderViewModel();

  // Controlador para el campo de texto de la mesa
  final TextEditingController _tableController = TextEditingController();

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  /// Navega a la pantalla de selección de productos
  Future<void> _navigateToProductSelection() async {
    // Navegación imperativa con push
    final List<SelectedProduct>? selectedProducts =
        await Navigator.push<List<SelectedProduct>>(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductSelectionScreen(),
          ),
        );

    // Verificar mounted antes de actualizar el estado
    if (!mounted) return;

    // Si se devolvieron productos, añadirlos al pedido
    if (selectedProducts != null && selectedProducts.isNotEmpty) {
      setState(() {
        _viewModel.addProducts(selectedProducts);
      });
    }
  }

  /// Navega a la pantalla de resumen usando rutas con nombre
  void _navigateToSummary() {
    // Navegación con rutas con nombre (pushNamed)
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

  /// Guarda el pedido y vuelve a Home
  void _saveOrder() {
    // Validaciones
    if (!_viewModel.isTableNameValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, introduce el nombre de la mesa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_viewModel.hasProducts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, añade al menos un producto'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Crear el pedido completo
    final order = _viewModel.createOrder(
      DateTime.now().millisecondsSinceEpoch.toString(),
    );

    // Volver a Home devolviendo el pedido
    Navigator.pop(context, order);
  }

  /// Cancela la creación y vuelve a Home sin devolver nada
  void _cancelOrder() {
    Navigator.pop(context); // Sin resultado
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de texto para la mesa
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
                    TextField(
                      controller: _tableController,
                      decoration: const InputDecoration(
                        labelText: 'Mesa o nombre',
                        hintText: 'Ej: Mesa 5, Barra - Juan',
                        prefixIcon: Icon(Icons.table_restaurant),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _viewModel.setTableName(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botón para añadir productos
            ElevatedButton.icon(
              onPressed: _navigateToProductSelection,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Añadir productos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Resumen provisional del pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen del pedido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_viewModel.selectedProducts.isEmpty)
                      const Text(
                        'No hay productos seleccionados',
                        style: TextStyle(color: Colors.grey),
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _viewModel.removeProduct(item);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
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

            // Botón Ver Resumen (solo si hay datos)
            if (_viewModel.isValidOrder)
              ElevatedButton.icon(
                onPressed: _navigateToSummary,
                icon: const Icon(Icons.receipt_long),
                label: const Text('Ver resumen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            const SizedBox(height: 24),

            // Botones de acción
            Row(
              children: [
                // Botón Cancelar
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelOrder,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                // Botón Guardar
                Expanded(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
