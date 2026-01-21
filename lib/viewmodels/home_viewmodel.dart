/// ViewModel para la gestión de la pantalla principal.
library;

import 'package:flutter/foundation.dart';
import '../models/order.dart';

/// ViewModel que gestiona el estado de la pantalla Home.
///
/// Implementa [ChangeNotifier] para notificar a la UI cuando
/// hay cambios en la lista de pedidos. Mantiene una lista
/// de pedidos y proporciona métodos para añadir nuevos pedidos.
class HomeViewModel extends ChangeNotifier {
  /// Lista interna de pedidos del bar.
  final List<Order> _orders = [];

  /// Obtiene una copia no modificable de la lista de pedidos.
  ///
  /// Se retorna una lista inmutable para evitar modificaciones
  /// externas que no pasen por los métodos del ViewModel.
  List<Order> get orders => List.unmodifiable(_orders);

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
