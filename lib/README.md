# Proyecto Flutter con Dart - Examen Área 2

## Descripción
Aplicación móvil desarrollada en Flutter con gestión de estado usando Riverpod. Consume la API REST pública de JSONPlaceholder (`/posts`) implementando validación cruzada, scroll infinito y separación de arquitectura.

## Estructura del Proyecto (Plana en raíz)
Todos los archivos del proyecto se encuentran en la raíz del paquete:
- `app_colors.dart`, `app_dimensions.dart`, `app_theme.dart`: Configuración visual y tema.
- `custom_auth_text_field.dart`: Widget reutilizable para los campos de texto de autenticación.
- `auth_state.dart`, `auth_provider.dart`: Gestión de estado de autenticación.
- `login_screen.dart`, `register_screen.dart`: Pantallas de Login y Registro.
- `post.dart`, `posts_service.dart`, `posts_provider.dart`, `posts_screen.dart`: Modelo, consumo REST y pantalla del listado.
- `main.dart`: Punto de entrada y configuración de rutas de la aplicación.

## Instrucciones para Ejecutar
1. Copia los archivos `.dart` a la carpeta `lib/` de tu proyecto Flutter.
2. Ejecuta `flutter pub get` asegurándote de incluir en `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_riverpod: ^2.5.1
     http: ^1.2.1
   ```
3. Inicia la aplicación con `flutter run`.

## Declaración del Uso de IA
- **Generado por IA:** Diseños iniciales de las pantallas mediante Google Stitch y esqueletos de código para los Riverpod Notifiers.
- **Modificado/Adaptado:** Implementación de la validación cruzada en tiempo real, manejo de estados HTTP (Carga, Datos, Error y Vacío) con mensajes claros al usuario, y control del ScrollController para la paginación infinita sin peticiones duplicadas.
