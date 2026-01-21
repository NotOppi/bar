import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/product.dart';

/// ViewModel para la pantalla principal (Home)
/// Gestiona la lista de pedidos del bar
class HomeViewModel extends ChangeNotifier {
  final List<Order> _orders = [];

  /// Lista de pedidos actuales
  List<Order> get orders => List.unmodifiable(_orders);

  /// Constructor que inicializa con pedidos de ejemplo
  HomeViewModel() {
    _initializeWithSampleOrders();
  }

  /// Inicializa la lista con pedidos de ejemplo
  void _initializeWithSampleOrders() {
    // Productos de ejemplo
    const cerveza = Product(id: '1', name: 'Cerveza', price: 2.50);
    const vino = Product(id: '2', name: 'Copa de vino', price: 3.00);
    const refresco = Product(id: '3', name: 'Refresco', price: 2.00);
    const tapa = Product(id: '4', name: 'Tapa de jamón', price: 4.50);
    const cafe = Product(id: '5', name: 'Café', price: 1.50);

    // Pedido 1: Mesa 1
    _orders.add(
      Order(
        id: '1',
        tableName: 'Mesa 1',
        products: [
          SelectedProduct(product: cerveza, quantity: 2),
          SelectedProduct(product: tapa, quantity: 1),
        ],
      ),
    );

    // Pedido 2: Mesa 3
    _orders.add(
      Order(
        id: '2',
        tableName: 'Mesa 3',
        products: [
          SelectedProduct(product: vino, quantity: 2),
          SelectedProduct(product: cafe, quantity: 2),
        ],
      ),
    );

    // Pedido 3: Barra - Carlos
    _orders.add(
      Order(
        id: '3',
        tableName: 'Barra - Carlos',
        products: [
          SelectedProduct(product: cerveza, quantity: 1),
          SelectedProduct(product: refresco, quantity: 1),
        ],
      ),
    );
  }

  /// Añade un nuevo pedido a la lista
  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  /// Genera un nuevo ID único para un pedido
  String generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
