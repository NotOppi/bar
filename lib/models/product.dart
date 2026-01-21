/// Modelos relacionados con los productos del bar.
///
/// Este archivo contiene las clases [Product] y [SelectedProduct]
/// que representan los productos disponibles en la carta y los
/// productos seleccionados en un pedido respectivamente.
library;

/// Representa un producto disponible en la carta del bar.
///
/// Cada producto tiene un identificador único, nombre y precio.
/// Esta clase es inmutable para garantizar la integridad de los datos.
///
/// Ejemplo de uso:
/// ```dart
/// const cerveza = Product(id: '1', name: 'Cerveza', price: 2.50);
/// ```
class Product {
  /// Identificador único del producto.
  final String id;

  /// Nombre del producto que se muestra al usuario.
  final String name;

  /// Precio del producto en euros.
  final double price;

  /// Crea un nuevo producto con los datos especificados.
  ///
  /// Todos los parámetros son obligatorios.
  const Product({required this.id, required this.name, required this.price});

  /// Compara dos productos por su [id].
  ///
  /// Dos productos son iguales si tienen el mismo identificador.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Representa un producto seleccionado con una cantidad específica.
///
/// Se utiliza para gestionar los productos añadidos a un pedido,
/// permitiendo múltiples unidades del mismo producto.
///
/// Ejemplo de uso:
/// ```dart
/// final item = SelectedProduct(product: cerveza, quantity: 3);
/// print(item.totalPrice); // 7.50
/// ```
class SelectedProduct {
  /// El producto base seleccionado.
  final Product product;

  /// Cantidad de unidades de este producto.
  ///
  /// Por defecto es 1 si no se especifica.
  int quantity;

  /// Crea un producto seleccionado con la cantidad indicada.
  ///
  /// [product] es obligatorio, [quantity] por defecto es 1.
  SelectedProduct({required this.product, this.quantity = 1});

  /// Calcula el precio total de este producto (precio × cantidad).
  ///
  /// Retorna el resultado de multiplicar el precio unitario por la cantidad.
  double get totalPrice => product.price * quantity;

  /// Compara dos productos seleccionados por su producto base.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedProduct &&
          runtimeType == other.runtimeType &&
          product == other.product;

  @override
  int get hashCode => product.hashCode;
}
