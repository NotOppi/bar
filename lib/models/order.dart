/// Modelo de datos para representar un pedido del bar.
library;

import 'product.dart';

/// Representa un pedido completo del bar.
///
/// Un pedido contiene información sobre la mesa o cliente,
/// los productos seleccionados y la fecha de creación.
/// Proporciona cálculos automáticos del total de productos
/// y el precio total del pedido.
///
/// Ejemplo de uso:
/// ```dart
/// final pedido = Order(
///   id: '1',
///   tableName: 'Mesa 5',
///   products: [SelectedProduct(product: cerveza, quantity: 2)],
/// );
/// print(pedido.totalPrice); // 5.00
/// ```
class Order {
  /// Identificador único del pedido.
  final String id;

  /// Mesa o nombre identificativo del cliente.
  ///
  /// Puede ser el número de mesa (ej: "Mesa 5") o un nombre
  /// (ej: "Barra - Carlos").
  final String tableName;

  /// Lista de productos incluidos en el pedido.
  final List<SelectedProduct> products;

  /// Fecha y hora de creación del pedido.
  final DateTime createdAt;

  /// Crea un nuevo pedido.
  ///
  /// [id] y [tableName] son obligatorios.
  /// [products] contiene los productos del pedido.
  /// [createdAt] se establece automáticamente a la fecha actual si no se especifica.
  Order({
    required this.id,
    required this.tableName,
    required this.products,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calcula el número total de productos en el pedido.
  ///
  /// Suma las cantidades de todos los productos seleccionados.
  /// Por ejemplo, 2 cervezas + 1 tapa = 3 productos.
  int get totalProducts {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calcula el precio total del pedido en euros.
  ///
  /// Suma el precio total de cada producto seleccionado
  /// (precio unitario × cantidad).
  double get totalPrice {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
