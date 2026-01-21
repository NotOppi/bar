/// Modelo que representa un producto del bar
class Product {
  final String id;
  final String name;
  final double price;

  const Product({required this.id, required this.name, required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Modelo que representa un producto seleccionado con cantidad
class SelectedProduct {
  final Product product;
  int quantity;

  SelectedProduct({required this.product, this.quantity = 1});

  /// Calcula el precio total de este producto (precio × cantidad)
  double get totalPrice => product.price * quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedProduct &&
          runtimeType == other.runtimeType &&
          product == other.product;

  @override
  int get hashCode => product.hashCode;
}
