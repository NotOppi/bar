# Bar - Gestión de Pedidos

## Descripción

Aplicación móvil desarrollada en **Flutter** para la gestión de pedidos en un bar. Permite crear, visualizar y gestionar pedidos de forma intuitiva, con una interfaz moderna y fácil de usar.

La aplicación sigue el patrón de arquitectura **MVVM (Model-View-ViewModel)** para una mejor organización del código, separación de responsabilidades y facilidad de mantenimiento.

## Tecnologías Utilizadas

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| **Flutter** | 3.x | Framework de desarrollo multiplataforma |
| **Dart** | 3.x | Lenguaje de programación |
| **Material Design 3** | - | Sistema de diseño de UI |

## Características Principales

### Funcionalidades

- **Pantalla Principal (Home)**
  - Visualización de todos los pedidos activos
  - Información de cada pedido: mesa, número de productos y total
  - Creación de nuevos pedidos

- **Creación de Pedidos**
  - Asignación de mesa o nombre identificativo
  - Selección múltiple de productos con cantidades
  - Resumen provisional del pedido en tiempo real
  - Validaciones de datos obligatorios

- **Carta del Bar**
  - Catálogo de 8 productos disponibles
  - Selección intuitiva con control de cantidad
  - Visualización de precios y total acumulado

- **Resumen del Pedido**
  - Vista detallada de solo lectura
  - Desglose completo de productos y precios
  - Total final del pedido

### Arquitectura MVVM

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── order.dart           # Modelo de pedido
│   └── product.dart         # Modelos de producto
├── viewmodels/              # Lógica de negocio
│   ├── home_viewmodel.dart
│   ├── create_order_viewmodel.dart
│   └── product_selection_viewmodel.dart
└── views/                   # Interfaces de usuario
    ├── home_screen.dart
    ├── create_order_screen.dart
    ├── product_selection_screen.dart
    └── order_summary_screen.dart
```

### Navegación

- **Navegación imperativa** (`Navigator.push`/`Navigator.pop`) entre pantallas principales
- **Navegación con rutas nombradas** (`Navigator.pushNamed`) para el resumen del pedido
- Paso de datos entre pantallas con `arguments`
- Manejo correcto de estados con verificación de `mounted`

## Instalación y Ejecución

```bash
# Clonar el repositorio
git clone https://github.com/NotOppi/bar.git

# Navegar al directorio
cd bar

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

## Documentación

- [Manual de Usuario](https://github.com/NotOppi/bar/wiki/manual-usuario)
- [Guía de Despliegue](https://github.com/NotOppi/bar/wiki/guia-de-despliegue)
- [Documentación API](docs/api/index.html)

## Autor

**Filippo Giuseppe Ferrantelli**

## Licencia

Este proyecto está bajo la Licencia MIT.
