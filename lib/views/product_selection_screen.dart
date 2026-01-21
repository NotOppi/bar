import 'package:flutter/material.dart';
import '../viewmodels/product_selection_viewmodel.dart';

/// Pantalla de selección de productos del bar
class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  // ViewModel para gestionar la selección de productos
  final ProductSelectionViewModel _viewModel = ProductSelectionViewModel();

  /// Confirma la selección y vuelve a la pantalla de creación
  void _confirmSelection() {
    // Obtener los productos seleccionados
    final selectedProducts = _viewModel.getSelectedProducts();

    // Volver con los productos seleccionados
    Navigator.pop(context, selectedProducts);
  }

  /// Cancela la selección y vuelve sin datos
  void _cancelSelection() {
    Navigator.pop(context); // Sin resultado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carta del Bar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Lista de productos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _viewModel.availableProducts.length,
              itemBuilder: (context, index) {
                final product = _viewModel.availableProducts[index];
                final quantity = _viewModel.getQuantity(product.id);

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        product.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: const TextStyle(color: Colors.green),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón decrementar
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: quantity > 0 ? Colors.red : Colors.grey,
                          onPressed: quantity > 0
                              ? () {
                                  setState(() {
                                    _viewModel.decrementQuantity(product.id);
                                  });
                                }
                              : null,
                        ),
                        // Cantidad
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: quantity > 0 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        // Botón incrementar
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              _viewModel.incrementQuantity(product.id);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Resumen de selección y botones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Total de la selección
                if (_viewModel.hasSelection)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total selección:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_viewModel.selectionTotal.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Botones de acción
                Row(
                  children: [
                    // Botón Cancelar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancelSelection,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón Confirmar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _viewModel.hasSelection
                            ? _confirmSelection
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
