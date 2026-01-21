/// ViewModel para la gestión de selección de productos.
library;

import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// ViewModel que gestiona la carta del bar y la selección de productos.
///
/// Mantiene el catálogo de productos disponibles y permite al usuario
/// seleccionar múltiples productos con diferentes cantidades.
///
/// Implementa [ChangeNotifier] para notificar cambios a la UI.
class ProductSelectionViewModel extends ChangeNotifier {
  /// Catálogo de productos disponibles en el bar.
  ///
  /// Lista constante con todos los productos que el usuario puede seleccionar.
  /// Incluye bebidas y tapas con sus respectivos precios.
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

  /// Mapa que almacena las cantidades seleccionadas por producto.
  ///
  /// La clave es el ID del producto y el valor es la cantidad seleccionada.
  /// Solo se almacenan productos con cantidad > 0.
  final Map<String, int> _selectedQuantities = {};

  /// Obtiene la cantidad seleccionada de un producto específico.
  ///
  /// [productId] ID del producto a consultar.
  /// Retorna 0 si el producto no está seleccionado.
  int getQuantity(String productId) {
    return _selectedQuantities[productId] ?? 0;
  }

  /// Incrementa en 1 la cantidad de un producto.
  ///
  /// Si el producto no estaba seleccionado, lo añade con cantidad 1.
  void incrementQuantity(String productId) {
    _selectedQuantities[productId] = getQuantity(productId) + 1;
    notifyListeners();
  }

  /// Decrementa en 1 la cantidad de un producto.
  ///
  /// Si la cantidad llega a 0, elimina el producto del mapa.
  /// No permite cantidades negativas.
  void decrementQuantity(String productId) {
    final currentQuantity = getQuantity(productId);
    if (currentQuantity > 0) {
      if (currentQuantity == 1) {
        // Eliminar del mapa si llega a 0
        _selectedQuantities.remove(productId);
      } else {
        _selectedQuantities[productId] = currentQuantity - 1;
      }
      notifyListeners();
    }
  }

  /// Indica si hay al menos un producto seleccionado.
  ///
  /// Útil para habilitar/deshabilitar el botón de confirmar.
  bool get hasSelection => _selectedQuantities.isNotEmpty;

  /// Convierte las selecciones en una lista de [SelectedProduct].
  ///
  /// Recorre el mapa de cantidades y crea objetos SelectedProduct
  /// para cada producto con cantidad mayor a 0.
  List<SelectedProduct> getSelectedProducts() {
    final List<SelectedProduct> selected = [];

    for (var entry in _selectedQuantities.entries) {
      if (entry.value > 0) {
        // Buscar el producto en el catálogo
        final product = availableProducts.firstWhere((p) => p.id == entry.key);
        selected.add(SelectedProduct(product: product, quantity: entry.value));
      }
    }

    return selected;
  }

  /// Calcula el total de la selección actual.
  ///
  /// Suma el precio × cantidad de todos los productos seleccionados.
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

  /// Limpia todas las selecciones.
  ///
  /// Elimina todas las cantidades del mapa y notifica a la UI.
  void clearSelection() {
    _selectedQuantities.clear();
    notifyListeners();
  }
}
