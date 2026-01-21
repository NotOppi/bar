/// ViewModel para la gestión de la pantalla principal.
library;

import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/product.dart';

/// ViewModel que gestiona el estado de la pantalla Home.
///
/// Implementa [ChangeNotifier] para notificar a la UI cuando
/// hay cambios en la lista de pedidos. Mantiene una lista
/// de pedidos y proporciona métodos para añadir nuevos pedidos.
///
/// Se inicializa con pedidos de ejemplo para demostración.
class HomeViewModel extends ChangeNotifier {
  /// Lista interna de pedidos del bar.
  final List<Order> _orders = [];

  /// Obtiene una copia no modificable de la lista de pedidos.
  ///
  /// Se retorna una lista inmutable para evitar modificaciones
  /// externas que no pasen por los métodos del ViewModel.
  List<Order> get orders => List.unmodifiable(_orders);

  /// Constructor que inicializa el ViewModel con pedidos de ejemplo.
  HomeViewModel() {
    _initializeWithSampleOrders();
  }

  /// Inicializa la lista con pedidos de demostración.
  ///
  /// Crea varios pedidos de ejemplo para que la aplicación
  /// no inicie vacía. Incluye diferentes mesas y productos.
  void _initializeWithSampleOrders() {
    // Definición de productos de ejemplo
    const cerveza = Product(id: '1', name: 'Cerveza', price: 2.50);
    const vino = Product(id: '2', name: 'Copa de vino', price: 3.00);
    const refresco = Product(id: '3', name: 'Refresco', price: 2.00);
    const tapa = Product(id: '4', name: 'Tapa de jamón', price: 4.50);
    const cafe = Product(id: '5', name: 'Café', price: 1.50);

    // Pedido 1: Mesa 1 con cerveza y tapa
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

    // Pedido 2: Mesa 3 con vino y café
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

    // Pedido 3: Cliente en barra
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

  /// Añade un nuevo pedido a la lista.
  ///
  /// Notifica a los listeners (UI) para que se actualice
  /// la visualización de la lista de pedidos.
  ///
  /// [order] El pedido a añadir.
  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  /// Genera un identificador único para un nuevo pedido.
  ///
  /// Utiliza el timestamp en milisegundos para garantizar unicidad.
  String generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
