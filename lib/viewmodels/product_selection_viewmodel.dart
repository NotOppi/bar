import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// ViewModel para la pantalla de selección de productos
/// Gestiona la carta del bar y la selección de productos
class ProductSelectionViewModel extends ChangeNotifier {
  /// Lista de productos disponibles en el bar (carta)
  final List<Product> availableProducts = const [
    Product(id: '1', name: 'Cerveza', price: 2.50),
    Product(id: '2', name: 'Copa de vino', price: 3.00),
    Product(id: '3', name: 'Refresco', price: 2.00),
    Product(id: '4', name: 'Tapa de jamón', price: 4.50),
    Product(id: '5', name: 'Café', price: 1.50),
    Product(id: '6', name: 'Tostada con tomate', price: 2.50),
    Product(id: '7', name: 'Tortilla española', price: 5.00),
    Product(id: '8', name: 'Agua mineral', price: 1.50),
  ];

  /// Mapa de cantidades seleccionadas por producto (productId -> cantidad)
  final Map<String, int> _selectedQuantities = {};

  /// Obtiene la cantidad seleccionada de un producto
  int getQuantity(String productId) {
    return _selectedQuantities[productId] ?? 0;
  }

  /// Incrementa la cantidad de un producto
  void incrementQuantity(String productId) {
    _selectedQuantities[productId] = getQuantity(productId) + 1;
    notifyListeners();
  }

  /// Decrementa la cantidad de un producto
  void decrementQuantity(String productId) {
    final currentQuantity = getQuantity(productId);
    if (currentQuantity > 0) {
      if (currentQuantity == 1) {
        _selectedQuantities.remove(productId);
      } else {
        _selectedQuantities[productId] = currentQuantity - 1;
      }
      notifyListeners();
    }
  }

  /// Indica si hay productos seleccionados
  bool get hasSelection => _selectedQuantities.isNotEmpty;

  /// Obtiene la lista de productos seleccionados con sus cantidades
  List<SelectedProduct> getSelectedProducts() {
    final List<SelectedProduct> selected = [];

    for (var entry in _selectedQuantities.entries) {
      if (entry.value > 0) {
        final product = availableProducts.firstWhere((p) => p.id == entry.key);
        selected.add(SelectedProduct(product: product, quantity: entry.value));
      }
    }

    return selected;
  }

  /// Calcula el total de la selección actual
  double get selectionTotal {
    double total = 0.0;
    for (var entry in _selectedQuantities.entries) {
      if (entry.value > 0) {
        final product = availableProducts.firstWhere((p) => p.id == entry.key);
        total += product.price * entry.value;
      }
    }
    return total;
  }

  /// Limpia la selección
  void clearSelection() {
    _selectedQuantities.clear();
    notifyListeners();
  }
}
