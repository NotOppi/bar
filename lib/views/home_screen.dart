import 'package:flutter/material.dart';
import '../models/order.dart';
import '../viewmodels/home_viewmodel.dart';
import 'create_order_screen.dart';

/// Pantalla principal (Home) que muestra la lista de pedidos del bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ViewModel para gestionar la lista de pedidos
  final HomeViewModel _viewModel = HomeViewModel();

  /// Navega a la pantalla de creación de pedido
  Future<void> _navigateToCreateOrder() async {
    // Navegación imperativa con push
    final Order? newOrder = await Navigator.push<Order>(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
    );

    // Verificar mounted antes de actualizar el estado
    if (!mounted) return;

    // Si se devolvió un pedido, añadirlo a la lista
    if (newOrder != null) {
      setState(() {
        _viewModel.addOrder(newOrder);
      });
    }
    // Si el usuario canceló (newOrder == null), no se hace nada
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateOrder,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo pedido'),
      ),
    );
  }
}

/// Widget que muestra la información de un pedido
class _OrderCard extends StatelessWidget {
  final Order order;

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
            // Mesa o nombre del pedido
            Row(
              children: [
                const Icon(Icons.table_restaurant, color: Colors.brown),
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
            // Número de productos
            Row(
              children: [
                const Icon(Icons.shopping_basket, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${order.totalProducts} producto${order.totalProducts != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Precio total
            Row(
              children: [
                const Icon(Icons.euro, size: 20, color: Colors.green),
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
