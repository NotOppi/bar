/// Pantalla principal de la aplicación.
library;

import 'package:flutter/material.dart';
import '../models/order.dart';
import '../viewmodels/home_viewmodel.dart';
import 'create_order_screen.dart';

/// Pantalla Home que muestra la lista de pedidos activos del bar.
///
/// Es la pantalla principal de la aplicación. Muestra todos los pedidos
/// actuales con su información resumida (mesa, productos y total).
/// Permite crear nuevos pedidos mediante el botón flotante.
class HomeScreen extends StatefulWidget {
  /// Crea una instancia de [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// ViewModel que gestiona la lista de pedidos.
  final HomeViewModel _viewModel = HomeViewModel();

  /// Navega a la pantalla de creación de pedido y espera el resultado.
  ///
  /// Utiliza navegación imperativa con [Navigator.push].
  /// Si el usuario guarda un pedido, se añade a la lista.
  /// Si cancela, no se realiza ningún cambio.
  Future<void> _navigateToCreateOrder() async {
    // Navegación imperativa - espera el resultado del pedido
    final Order? newOrder = await Navigator.push<Order>(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
    );

    // IMPORTANTE: Verificar mounted antes de usar context o setState
    // Esto evita errores si el widget fue desmontado durante la navegación
    if (!mounted) return;

    // Solo añadir si se devolvió un pedido válido
    if (newOrder != null) {
      setState(() {
        _viewModel.addOrder(newOrder);
      });

      // Mostrar confirmación al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido "${newOrder.tableName}" creado correctamente'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar - Pedidos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _viewModel.orders.isEmpty
          ? const Center(
              child: Text(
                'No hay pedidos actualmente',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _viewModel.orders.length,
              itemBuilder: (context, index) {
                final order = _viewModel.orders[index];
                return _OrderCard(order: order);
              },
            ),
      // Botón flotante con tooltip informativo
      floatingActionButton: Tooltip(
        message: 'Crear un nuevo pedido',
        child: FloatingActionButton.extended(
          onPressed: _navigateToCreateOrder,
          icon: const Icon(Icons.add),
          label: const Text('Nuevo pedido'),
        ),
      ),
    );
  }
}

/// Widget que muestra la información resumida de un pedido en formato tarjeta.
///
/// Muestra: mesa/nombre, número de productos y precio total.
class _OrderCard extends StatelessWidget {
  /// El pedido a mostrar.
  final Order order;

  /// Crea una tarjeta de pedido.
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila con icono de mesa y nombre
            Row(
              children: [
                Tooltip(
                  message: 'Mesa o identificación del cliente',
                  child: const Icon(
                    Icons.table_restaurant,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.tableName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Número total de productos
            Row(
              children: [
                Tooltip(
                  message: 'Cantidad total de productos',
                  child: const Icon(
                    Icons.shopping_basket,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${order.totalProducts} producto${order.totalProducts != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Precio total del pedido
            Row(
              children: [
                Tooltip(
                  message: 'Importe total del pedido',
                  child: const Icon(Icons.euro, size: 20, color: Colors.green),
                ),
                const SizedBox(width: 8),
                Text(
                  'Total: ${order.totalPrice.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
