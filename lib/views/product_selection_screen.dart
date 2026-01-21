/// Pantalla de selección de productos de la carta.
library;

import 'package:flutter/material.dart';
import '../viewmodels/product_selection_viewmodel.dart';

/// Pantalla que muestra la carta del bar para seleccionar productos.
///
/// Permite al usuario:
/// - Ver todos los productos disponibles con sus precios
/// - Seleccionar múltiples productos con diferentes cantidades
/// - Ver el total de la selección actual
/// - Confirmar o cancelar la selección
class ProductSelectionScreen extends StatefulWidget {
  /// Crea una instancia de [ProductSelectionScreen].
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  /// ViewModel que gestiona la selección de productos.
  final ProductSelectionViewModel _viewModel = ProductSelectionViewModel();

  /// Confirma la selección y devuelve los productos.
  ///
  /// Utiliza [Navigator.pop] devolviendo la lista de productos seleccionados.
  void _confirmSelection() {
    final selectedProducts = _viewModel.getSelectedProducts();

    // Verificar que hay productos seleccionados
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Selecciona al menos un producto'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Devolver los productos seleccionados a la pantalla anterior
    Navigator.pop(context, selectedProducts);
  }

  /// Cancela la selección y vuelve sin datos.
  ///
  /// Utiliza [Navigator.pop] sin argumentos.
  void _cancelSelection() {
    Navigator.pop(context);
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
          // Lista de productos disponibles
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
                    // Avatar con inicial del producto
                    leading: Tooltip(
                      message: product.name,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          product.name[0],
                          style: const TextStyle(color: Colors.white),
                        ),
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
                        // Botón decrementar cantidad
                        Tooltip(
                          message: 'Quitar una unidad',
                          child: IconButton(
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
                        ),
                        // Cantidad seleccionada
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
                        // Botón incrementar cantidad
                        Tooltip(
                          message: 'Añadir una unidad',
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.green,
                            onPressed: () {
                              setState(() {
                                _viewModel.incrementQuantity(product.id);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Barra inferior con total y botones de acción
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
                // Total de la selección actual
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
                // Botones Cancelar y Confirmar
                Row(
                  children: [
                    // Botón Cancelar
                    Expanded(
                      child: Tooltip(
                        message: 'Volver sin seleccionar productos',
                        child: OutlinedButton(
                          onPressed: _cancelSelection,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón Confirmar
                    Expanded(
                      child: Tooltip(
                        message: _viewModel.hasSelection
                            ? 'Añadir productos al pedido'
                            : 'Selecciona al menos un producto',
                        child: ElevatedButton(
                          onPressed:
                              _viewModel.hasSelection ? _confirmSelection : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirmar'),
                        ),
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
