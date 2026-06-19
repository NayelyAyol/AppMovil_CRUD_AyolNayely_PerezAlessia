# <h1 align="center"> Rincón Literario - Flutter + MongoDB Atlas + Open Library 📖 </h1>

## Descripción

Aplicación móvil desarrollada con Flutter que permite administrar una colección personal de libros utilizando MongoDB Atlas como base de datos en la nube y la API pública de Open Library para explorar y guardar nuevos libros.

La aplicación permite:

* Registrar libros manualmente
* Editar libros existentes
* Eliminar libros de la colección
* Buscar libros en Open Library
* Guardar libros desde la API a MongoDB Atlas
* Visualizar estadísticas generales de la colección
* Consultar detalles completos de cada libro

---

## Autoras

* Nayely Ayol
* Alessia Pérez

---

## Tecnologías utilizadas

* Flutter
* Dart
* MongoDB Atlas
* mongo_dart
* HTTP Package
* UUID
* Open Library API

---

## API utilizada

Se consumió la siguiente API pública:

https://openlibrary.org/search.json

Servicio de portadas:

https://covers.openlibrary.org/

---

## Base de Datos

Se utilizó MongoDB Atlas para almacenar la colección de libros.

Colección utilizada:

```text
libros
```

Campos almacenados:

* id
* titulo
* autor
* editorial
* precio
* stock
* imagen
* descripcion
* fuente

---

## Funcionalidades

* CRUD completo de libros
* Conexión a MongoDB Atlas
* Exploración de libros mediante Open Library
* Scroll infinito en resultados de búsqueda
* Guardado directo desde la API hacia MongoDB
* Búsqueda local por título
* Visualización de detalles completos
* Estadísticas generales de la colección
* Prevención de libros duplicados
* Interfaz temática estilo biblioteca retro

---

## Proceso de desarrollo

### 1. Instalación de dependencias

```bash
flutter pub get
```

Dependencias principales:

```yaml
dependencies:
  flutter:
    sdk: flutter

  http:
  mongo_dart:
  uuid:
```

---

### 2. Configuración de MongoDB Atlas

Crear el archivo:

```dart
lib/config/mongo_config.dart
```

Agregar la cadena de conexión:

```dart
class MongoConfig {
  static const String connectionString =
      "mongodb+srv://usuario:password@cluster.mongodb.net/rincon_literario";
}
```

---

### 3. Conexión a MongoDB

Archivo:

```dart
lib/db/mongo_database.dart
```

```dart
static Future<void> connect() async {
  _db = await Db.create(_connectionString);
  await _db!.open();
  _coleccion = _db!.collection('libros');
}
```

Inicialización desde main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MongoDatabase.connect();

  runApp(const MyApp());
}
```

---

### 4. Consumo de Open Library

Archivo:

```dart
services/open_library_service.dart
```

```dart
final Uri url = Uri.parse(
  'https://openlibrary.org/search.json?q=$query&page=$page&limit=$limit',
);

final response = await http.get(url);
```

---

### 5. Exploración de libros

La pantalla:

```text
ApiExplorerPage
```

permite:

* Buscar por título
* Buscar por autor
* Buscar por tema
* Scroll infinito
* Guardar resultados en MongoDB

---

### 6. Gestión de colección

La pantalla:

```text
CollectionPage
```

permite:

* Listar libros
* Buscar libros
* Editar registros
* Eliminar registros
* Abrir detalle de cada libro

---

### 7. Formulario de libros

La pantalla:

```text
FormPage
```

permite:

* Crear nuevos libros
* Actualizar libros existentes
* Validar datos ingresados
* Controlar precios y stock

---

## Estructura del proyecto

```text
lib/
│
├── config/
│   └── mongo_config.dart
│
├── db/
│   └── mongo_database.dart
│
├── models/
│   └── item_coleccion.dart
│
├── pages/
│   ├── home_page.dart
│   ├── collection_page.dart
│   ├── detail_page.dart
│   ├── form_page.dart
│   ├── api_explorer_page.dart
│   └── about_page.dart
│
├── services/
│   └── open_library_service.dart
│
├── theme/
│   └── app_theme.dart
│
└── main.dart
```

---

## Pantallas implementadas

### 🏠 Inicio

* Menú principal
* Estadísticas generales
* Acceso a módulos

### 📚 Mi Colección

* Lista de libros almacenados
* Búsqueda local
* CRUD completo

### 📖 Detalle del Libro

* Información completa
* Portada
* Editorial
* Descripción
* Precio
* Stock

### ➕ Nuevo Libro

* Registro manual
* Validaciones

### 🔍 Explorar Libros

* Consumo de Open Library
* Scroll infinito
* Guardado directo

### ℹ️ Acerca de

* Integrantes
* Tecnologías
* API utilizada
* Explicación técnica

---

## Ejecución del proyecto

Para ejecutar la aplicación:

```bash
flutter run
```

Para visualizar dispositivos disponibles:

```bash
flutter devices
```

Para generar APK:

```bash
flutter build apk --release
```

APK generada en:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Capturas de la funcionalidad

| Inicio       | Mi Colección |
| ------------ | ------------ |
| <img width="1080" height="2400" alt="1781852737673" src="https://github.com/user-attachments/assets/371341bd-d4e9-4649-94ac-c4aab14eb6f8" />| <img width="1080" height="2400" alt="1781852737639" src="https://github.com/user-attachments/assets/7b0deea0-95c3-470e-91e8-450078188dc4" />|

| Explorar Libros | Detalle      |
| --------------- | ------------ |
| <img width="1080" height="2400" alt="1781852737464" src="https://github.com/user-attachments/assets/975fbd63-59d3-4079-a728-51e124b17982" />| <img width="1080" height="2400" alt="1781852737604" src="https://github.com/user-attachments/assets/07bd0b5b-c3a2-4486-bcb7-d2c4c82a9714" />|

| Formulario   | Acerca de    |
| ------------ | ------------ |
| <img width="1080" height="2400" alt="1781852737570" src="https://github.com/user-attachments/assets/ed12c7f4-7fe0-4339-ba6a-728484fbea14" />| <img width="1080" height="2400" alt="1781852737353" src="https://github.com/user-attachments/assets/bb816df3-833b-42cd-bb12-eaf9ff6a0544" />|

| Editar | Eliminar      |
| --------------- | ------------ |
|<img width="1080" height="2400" alt="1781852737500" src="https://github.com/user-attachments/assets/8d7c94c6-0da8-44f7-a68d-89d31e5689d4" />|<img width="1080" height="2400" alt="1781852737535" src="https://github.com/user-attachments/assets/6255e819-c511-4c3b-8bc8-9b99662490ec" />|

---
## Link del video

- https://drive.google.com/drive/folders/1WVcDgWSXjyDeW_h-c3xysR3uhY_gViti?usp=drive_link
---
## APK

- https://drive.google.com/drive/folders/1Q3ozdVD3Evp-gtxyfZDOws0_j_Ss54h9?usp=sharing
---
## Resultados

* Conexión exitosa con MongoDB Atlas.
* Implementación completa de operaciones CRUD.
* Consumo correcto de la API Open Library.
* Integración de almacenamiento local y nube.
* Implementación de scroll infinito.
* Prevención de registros duplicados.
* Interfaz amigable inspirada en una biblioteca clásica.
* Aplicación funcional desarrollada en Flutter.

