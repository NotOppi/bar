import 'product.dart';

/// Modelo que representa un pedido del bar
class Order {
  final String id;
  final String tableName; // Mesa o nombre identificativo
  final List<SelectedProduct> products;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.tableName,
    required this.products,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calcula el número total de productos en el pedido
  int get totalProducts {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calcula el precio total del pedido
  double get totalPrice {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
