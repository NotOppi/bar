/// Pantalla de resumen final del pedido.
library;

import 'package:flutter/material.dart';
import '../models/product.dart';

/// Pantalla de resumen final del pedido (solo lectura).
///
/// Muestra toda la información del pedido antes de guardarlo:
/// - Mesa o nombre del cliente
/// - Lista de productos con cantidades y precios
/// - Total del pedido
///
/// Se accede mediante navegación con rutas nombradas (`/resumen`).
/// Esta pantalla no permite modificaciones, solo visualización.
class OrderSummaryScreen extends StatelessWidget {
  /// Crea una instancia de [OrderSummaryScreen].
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos pasados desde la navegación con pushNamed
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Extraer datos del mapa de argumentos
    final String tableName = args['tableName'] as String;
    final List<SelectedProduct> products =
        args['products'] as List<SelectedProduct>;
    final double totalPrice = args['totalPrice'] as double;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Pedido'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Botón de retroceso personalizado
        leading: Tooltip(
          message: 'Volver a la pantalla de creación',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta: Información de la mesa
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Tooltip(
                      message: 'Identificación del pedido',
                      child: const Icon(Icons.table_restaurant, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mesa / Identificación',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            tableName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta: Listado de productos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado de la sección
                    Row(
                      children: [
                        Tooltip(
                          message: 'Productos incluidos en el pedido',
                          child: const Icon(Icons.receipt_long),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        // Badge con cantidad total
                        Tooltip(
                          message: 'Total de artículos',
                          child: Chip(
                            label: Text(
                              '${products.fold(0, (sum, item) => sum + item.quantity)} uds.',
                            ),
                            backgroundColor: Colors.blue[100],
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Lista de productos
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = products[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              // Nombre del producto
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item.product.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              // Cantidad
                              Expanded(
                                child: Text(
                                  'x${item.quantity}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // Precio unitario
                              Expanded(
                                child: Tooltip(
                                  message: 'Precio unitario',
                                  child: Text(
                                    '${item.product.price.toStringAsFixed(2)} €',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              // Subtotal del producto
                              Expanded(
                                child: Tooltip(
                                  message: 'Subtotal: ${item.product.price.toStringAsFixed(2)} € x ${item.quantity}',
                                  child: Text(
                                    '${item.totalPrice.toStringAsFixed(2)} €',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta: Total final
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Tooltip(
                          message: 'Importe total a pagar',
                          child: const Icon(
                            Icons.euro,
                            size: 28,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nota informativa: Solo lectura
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Este es un resumen de solo lectura',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botón para volver
            Tooltip(
              message: 'Volver a la pantalla anterior',
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
