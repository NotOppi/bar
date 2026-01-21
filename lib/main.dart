import 'package:flutter/material.dart';
import 'views/home_screen.dart';
import 'views/order_summary_screen.dart';

void main() {
  runApp(const BarApp());
}

/// Aplicación principal del Bar
/// Utiliza arquitectura MVVM para la gestión del estado
class BarApp extends StatelessWidget {
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
      // Definición de rutas con nombre
      routes: {
        // Ruta para el resumen del pedido (navegación con pushNamed)
        '/resumen': (context) => const OrderSummaryScreen(),
      },
    );
  }
}
