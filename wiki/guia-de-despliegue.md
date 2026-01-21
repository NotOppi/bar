# 🚀 Guía de Despliegue - Bar App

Esta guía detalla cómo desplegar la aplicación Bar en las diferentes plataformas soportadas por Flutter.

---

## 📑 Índice

1. [Requisitos Previos](#1-requisitos-previos)
2. [Despliegue en Android](#2-despliegue-en-android)
3. [Despliegue en iOS](#3-despliegue-en-ios)
4. [Despliegue en Web](#4-despliegue-en-web)
5. [Despliegue en Windows](#5-despliegue-en-windows)
6. [Despliegue en macOS](#6-despliegue-en-macos)
7. [Despliegue en Linux](#7-despliegue-en-linux)
8. [Solución de Problemas](#8-solución-de-problemas)

---

## 1. Requisitos Previos

### Instalación de Flutter

```bash
# Verificar instalación de Flutter
flutter doctor

# Si no está instalado, seguir la guía oficial:
# https://docs.flutter.dev/get-started/install
```

### Requisitos del sistema

| Plataforma | Requisitos |
|------------|------------|
| **Flutter SDK** | >= 3.0.0 |
| **Dart SDK** | >= 3.0.0 |
| **Android Studio** | Para desarrollo Android |
| **Xcode** | Para desarrollo iOS/macOS (solo Mac) |
| **Visual Studio** | Para desarrollo Windows |

### Clonar el proyecto

```bash
git clone https://github.com/NotOppi/bar.git
cd bar
flutter pub get
```

---

## 2. Despliegue en Android

### 2.1 Configuración inicial

1. **Instalar Android Studio** y configurar el SDK de Android
2. Crear un dispositivo virtual o conectar un dispositivo físico
3. Habilitar "Developer options" y "USB debugging" en el dispositivo

### 2.2 Compilar APK de debug

```bash
flutter build apk --debug
```

El APK se genera en: `build/app/outputs/flutter-apk/app-debug.apk`

### 2.3 Compilar APK de release

```bash
flutter build apk --release
```

### 2.4 Compilar App Bundle (para Play Store)

```bash
flutter build appbundle --release
```

El bundle se genera en: `build/app/outputs/bundle/release/app-release.aab`

### 2.5 Instalar en dispositivo

```bash
# Instalar APK directamente
flutter install

# O usar adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 2.6 Publicar en Google Play Store

1. Crear cuenta de desarrollador en [Google Play Console](https://play.google.com/console)
2. Crear nueva aplicación
3. Subir el App Bundle (.aab)
4. Completar la ficha de la tienda
5. Configurar precios y distribución
6. Enviar para revisión

---

## 3. Despliegue en iOS

> ⚠️ **Nota:** Requiere un Mac con Xcode instalado

### 3.1 Configuración inicial

1. **Instalar Xcode** desde la App Store
2. Aceptar licencia de Xcode:
   ```bash
   sudo xcodebuild -license accept
   ```
3. Instalar CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

### 3.2 Configurar firma de código

1. Abrir proyecto en Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Seleccionar "Runner" en el navegador
3. En "Signing & Capabilities", configurar el Team
4. Asegurarse de que el Bundle Identifier es único

### 3.3 Compilar para simulador

```bash
flutter build ios --debug --simulator
```

### 3.4 Compilar para dispositivo

```bash
flutter build ios --release
```

### 3.5 Ejecutar en dispositivo

```bash
flutter run -d <device_id>
```

### 3.6 Publicar en App Store

1. Crear cuenta en [Apple Developer Program](https://developer.apple.com/programs/)
2. Crear App ID en Apple Developer Portal
3. Configurar perfiles de aprovisionamiento
4. Compilar archivo IPA:
   ```bash
   flutter build ipa
   ```
5. Subir a App Store Connect usando Transporter o Xcode
6. Completar información de la app
7. Enviar para revisión

---

## 4. Despliegue en Web

### 4.1 Compilar para web

```bash
flutter build web --release
```

Los archivos se generan en: `build/web/`

### 4.2 Opciones de compilación

```bash
# Con CanvasKit (mejor rendimiento gráfico)
flutter build web --web-renderer canvaskit

# Con HTML (menor tamaño)
flutter build web --web-renderer html

# Auto (Flutter decide)
flutter build web --web-renderer auto
```

### 4.3 Servir localmente

```bash
cd build/web
python3 -m http.server 8000
# Abrir http://localhost:8000
```

### 4.4 Desplegar en Firebase Hosting

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Iniciar sesión
firebase login

# Inicializar proyecto
firebase init hosting

# Desplegar
firebase deploy --only hosting
```

### 4.5 Desplegar en GitHub Pages

1. Compilar con base href:
   ```bash
   flutter build web --base-href "/bar/"
   ```
2. Copiar contenido de `build/web` a rama `gh-pages`
3. Configurar GitHub Pages en Settings del repositorio

### 4.6 Desplegar en Vercel

1. Conectar repositorio en [Vercel](https://vercel.com)
2. Configurar:
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
3. Deploy automático con cada push

---

## 5. Despliegue en Windows

### 5.1 Requisitos

- Windows 10 o superior
- Visual Studio 2022 con carga de trabajo "Desarrollo de escritorio con C++"

### 5.2 Compilar ejecutable

```bash
flutter build windows --release
```

Los archivos se generan en: `build/windows/runner/Release/`

### 5.3 Estructura de archivos

```
Release/
├── bar.exe              # Ejecutable principal
├── flutter_windows.dll  # Runtime de Flutter
├── data/               # Recursos de la app
└── *.dll               # Dependencias
```

### 5.4 Crear instalador con Inno Setup

1. Descargar [Inno Setup](https://jrsoftware.org/isinfo.php)
2. Crear script de instalación:

```iss
[Setup]
AppName=Bar App
AppVersion=1.0.0
DefaultDirName={pf}\Bar App
DefaultGroupName=Bar App
OutputDir=installer
OutputBaseFilename=BarApp_Setup

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Bar App"; Filename: "{app}\bar.exe"
Name: "{commondesktop}\Bar App"; Filename: "{app}\bar.exe"
```

3. Compilar el instalador

### 5.5 Crear MSIX para Microsoft Store

```bash
flutter pub add msix

# Agregar configuración en pubspec.yaml:
# msix_config:
#   display_name: Bar App
#   publisher_display_name: Filippo Ferrantelli
#   identity_name: com.example.bar
#   msix_version: 1.0.0.0

flutter pub run msix:create
```

---

## 6. Despliegue en macOS

> ⚠️ **Nota:** Requiere un Mac con Xcode instalado

### 6.1 Compilar aplicación

```bash
flutter build macos --release
```

La app se genera en: `build/macos/Build/Products/Release/bar.app`

### 6.2 Ejecutar la aplicación

```bash
open build/macos/Build/Products/Release/bar.app
```

### 6.3 Crear DMG para distribución

```bash
# Instalar create-dmg
brew install create-dmg

# Crear DMG
create-dmg \
  --volname "Bar App" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --app-drop-link 425 178 \
  "BarApp.dmg" \
  "build/macos/Build/Products/Release/bar.app"
```

### 6.4 Firmar la aplicación (para distribución)

```bash
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Tu Nombre (TEAM_ID)" \
  build/macos/Build/Products/Release/bar.app
```

### 6.5 Publicar en Mac App Store

1. Configurar firma de código en Xcode
2. Crear perfil de aprovisionamiento
3. Compilar archivo para App Store:
   ```bash
   flutter build macos
   ```
4. Subir usando Transporter o Xcode
5. Completar información en App Store Connect

---

## 7. Despliegue en Linux

### 7.1 Requisitos

```bash
# Instalar dependencias en Ubuntu/Debian
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
```

### 7.2 Compilar aplicación

```bash
flutter build linux --release
```

Los archivos se generan en: `build/linux/x64/release/bundle/`

### 7.3 Estructura de archivos

```
bundle/
├── bar                # Ejecutable principal
├── data/             # Recursos
└── lib/              # Bibliotecas compartidas
```

### 7.4 Ejecutar la aplicación

```bash
./build/linux/x64/release/bundle/bar
```

### 7.5 Crear paquete .deb

```bash
# Instalar flutter_distributor
dart pub global activate flutter_distributor

# Crear paquete
flutter_distributor package --platform linux --targets deb
```

### 7.6 Crear AppImage

```bash
# Instalar appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Crear estructura AppDir y generar AppImage
```

### 7.7 Publicar en Snap Store

```yaml
# snapcraft.yaml
name: bar-app
version: '1.0.0'
summary: Gestión de pedidos para bar
description: Aplicación Flutter para gestionar pedidos

parts:
  bar:
    plugin: flutter
    source: .
```

```bash
snapcraft
sudo snap install bar-app_1.0.0_amd64.snap --dangerous
```

---

## 8. Solución de Problemas

### Error: "Flutter SDK not found"

```bash
# Verificar PATH
echo $PATH

# Añadir Flutter al PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Error: "No connected devices"

```bash
# Listar dispositivos disponibles
flutter devices

# Habilitar plataforma específica
flutter config --enable-web
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

### Error: "Gradle build failed" (Android)

```bash
# Limpiar caché
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error: "CocoaPods not installed" (iOS/macOS)

```bash
sudo gem install cocoapods
cd ios
pod install
```

### Error de firma de código (iOS/macOS)

1. Verificar Apple Developer Account
2. Regenerar perfiles de aprovisionamiento
3. Limpiar Keychain y volver a importar certificados

---

## 📚 Referencias

- [Documentación oficial de Flutter](https://docs.flutter.dev)
- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Flutter Deployment](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Apple Developer Documentation](https://developer.apple.com/documentation)

---

<div align="center">

**© 2026 Bar App - Guía de Despliegue v1.0**

</div>
