/// ViewModel para la gestión de creación de pedidos.
library;

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/order.dart';

/// ViewModel que gestiona el estado de la pantalla de creación de pedido.
///
/// Mantiene el nombre de la mesa/cliente y la lista de productos
/// seleccionados. Proporciona validaciones y cálculos en tiempo real.
///
/// Implementa [ChangeNotifier] para notificar cambios a la UI.
class CreateOrderViewModel extends ChangeNotifier {
  /// Nombre de la mesa o identificativo del cliente.
  String _tableName = '';

  /// Lista interna de productos seleccionados para el pedido.
  final List<SelectedProduct> _selectedProducts = [];

  /// Obtiene el nombre de la mesa o identificativo del pedido.
  String get tableName => _tableName;

  /// Obtiene una copia no modificable de los productos seleccionados.
  List<SelectedProduct> get selectedProducts =>
      List.unmodifiable(_selectedProducts);

  /// Calcula el número total de productos en el pedido.
  ///
  /// Suma las cantidades de todos los productos seleccionados.
  int get totalProducts {
    return _selectedProducts.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calcula el precio total del pedido actual.
  ///
  /// Suma el subtotal de cada producto (precio × cantidad).
  double get totalPrice {
    return _selectedProducts.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Indica si el pedido cumple todos los requisitos para ser guardado.
  ///
  /// Un pedido es válido si tiene nombre de mesa y al menos un producto.
  bool get isValidOrder {
    return _tableName.trim().isNotEmpty && _selectedProducts.isNotEmpty;
  }

  /// Verifica si el nombre de la mesa es válido.
  ///
  /// El nombre no debe estar vacío ni contener solo espacios.
  bool get isTableNameValid => _tableName.trim().isNotEmpty;

  /// Indica si hay al menos un producto seleccionado.
  bool get hasProducts => _selectedProducts.isNotEmpty;

  /// Actualiza el nombre de la mesa.
  ///
  /// Notifica a la UI para actualizar las validaciones visuales.
  void setTableName(String name) {
    _tableName = name;
    notifyListeners();
  }

  /// Añade una lista de productos seleccionados al pedido.
  ///
  /// Si un producto ya existe en el pedido, suma las cantidades.
  /// Si es nuevo, lo añade a la lista.
  ///
  /// [products] Lista de productos a añadir.
  void addProducts(List<SelectedProduct> products) {
    for (var newProduct in products) {
      // Buscar si el producto ya existe en la lista actual
      final existingIndex = _selectedProducts.indexWhere(
        (p) => p.product.id == newProduct.product.id,
      );

      if (existingIndex != -1) {
        // Si existe, acumular la cantidad
        _selectedProducts[existingIndex].quantity += newProduct.quantity;
      } else {
        // Si no existe, añadir como nuevo
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

  /// Elimina un producto de la lista de seleccionados.
  ///
  /// Busca el producto por su ID y lo elimina completamente.
  void removeProduct(SelectedProduct product) {
    _selectedProducts.removeWhere((p) => p.product.id == product.product.id);
    notifyListeners();
  }

  /// Crea una instancia de [Order] con los datos actuales.
  ///
  /// [orderId] Identificador único para el nuevo pedido.
  /// Retorna un objeto Order listo para ser guardado.
  Order createOrder(String orderId) {
    return Order(
      id: orderId,
      tableName: _tableName.trim(),
      products: List.from(_selectedProducts),
    );
  }

  /// Limpia todos los datos del ViewModel.
  ///
  /// Útil para resetear el estado al cancelar o después de guardar.
  void clear() {
    _tableName = '';
    _selectedProducts.clear();
    notifyListeners();
  }
}
