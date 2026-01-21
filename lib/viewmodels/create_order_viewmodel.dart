import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/order.dart';

/// ViewModel para la pantalla de creación de pedido
/// Gestiona el estado del pedido en creación
class CreateOrderViewModel extends ChangeNotifier {
  String _tableName = '';
  final List<SelectedProduct> _selectedProducts = [];

  /// Nombre de la mesa o identificativo del pedido
  String get tableName => _tableName;

  /// Lista de productos seleccionados
  List<SelectedProduct> get selectedProducts =>
      List.unmodifiable(_selectedProducts);

  /// Número total de productos
  int get totalProducts {
    return _selectedProducts.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Precio total del pedido
  double get totalPrice {
    return _selectedProducts.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Indica si el pedido es válido para guardar
  bool get isValidOrder {
    return _tableName.trim().isNotEmpty && _selectedProducts.isNotEmpty;
  }

  /// Indica si el nombre de mesa es válido
  bool get isTableNameValid => _tableName.trim().isNotEmpty;

  /// Indica si hay productos seleccionados
  bool get hasProducts => _selectedProducts.isNotEmpty;

  /// Actualiza el nombre de la mesa
  void setTableName(String name) {
    _tableName = name;
    notifyListeners();
  }

  /// Añade productos seleccionados (desde la pantalla de selección)
  void addProducts(List<SelectedProduct> products) {
    for (var newProduct in products) {
      // Buscar si el producto ya existe
      final existingIndex = _selectedProducts.indexWhere(
        (p) => p.product.id == newProduct.product.id,
      );

      if (existingIndex != -1) {
        // Si existe, sumar la cantidad
        _selectedProducts[existingIndex].quantity += newProduct.quantity;
      } else {
        // Si no existe, añadirlo
        _selectedProducts.add(
          SelectedProduct(
            product: newProduct.product,
            quantity: newProduct.quantity,
          ),
        );
      }
    }
    notifyListeners();
  }

  /// Elimina un producto de la lista
  void removeProduct(SelectedProduct product) {
    _selectedProducts.removeWhere((p) => p.product.id == product.product.id);
    notifyListeners();
  }

  /// Crea el pedido completo
  Order createOrder(String orderId) {
    return Order(
      id: orderId,
      tableName: _tableName.trim(),
      products: List.from(_selectedProducts),
    );
  }

  /// Limpia el estado del ViewModel
  void clear() {
    _tableName = '';
    _selectedProducts.clear();
    notifyListeners();
  }
}
