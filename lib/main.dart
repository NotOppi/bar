/// Aplicación de gestión de pedidos para un bar.
///
/// Esta aplicación permite gestionar los pedidos de un bar, incluyendo
/// la creación de nuevos pedidos, selección de productos y visualización
/// de resúmenes. Utiliza arquitectura MVVM para separar la lógica de
/// negocio de la interfaz de usuario.
///
/// ## Arquitectura
/// - **Models**: Clases de datos (Product, Order)
/// - **ViewModels**: Lógica de negocio y estado
/// - **Views**: Interfaces de usuario (Screens)
///
/// ## Navegación
/// - Navegación imperativa con `Navigator.push` y `Navigator.pop`
/// - Navegación con rutas nombradas para el resumen (`/resumen`)
library;

import 'package:flutter/material.dart';
import 'views/home_screen.dart';
import 'views/order_summary_screen.dart';

/// Punto de entrada de la aplicación.
///
/// Inicializa y ejecuta la aplicación Flutter.
void main() {
  runApp(const BarApp());
}

/// Widget raíz de la aplicación Bar.
///
/// Configura el tema de la aplicación, las rutas de navegación
/// y establece [HomeScreen] como pantalla inicial.
///
/// ### Rutas definidas:
/// - `/resumen`: Pantalla de resumen del pedido [OrderSummaryScreen]
class BarApp extends StatelessWidget {
  /// Crea una instancia de [BarApp].
  const BarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar - Gestión de Pedidos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      // Pantalla inicial: Home
      home: const HomeScreen(),
      // Definición de rutas con nombre para navegación declarativa
      routes: {
        // Ruta para el resumen del pedido (navegación con pushNamed)
        '/resumen': (context) => const OrderSummaryScreen(),
      },
    );
  }
}
