import 'package:mongo_dart/mongo_dart.dart';

/// Modelo de un libro guardado en la colección local (MongoDB Atlas).
/// Cumple con el mínimo de 7 campos solicitados en el taller.
class ItemColeccion {
  final ObjectId? mongoId;
  final String id;
  final String titulo;
  final String autor;
  final String editorial;
  final double precio;
  final int stock;
  final String imagen;
  final String descripcion;
  final String fuente; // 'Manual' o 'Open Library API'

  ItemColeccion({
    this.mongoId,
    required this.id,
    required this.titulo,
    required this.autor,
    required this.editorial,
    required this.precio,
    required this.stock,
    required this.imagen,
    required this.descripcion,
    required this.fuente,
  });

  factory ItemColeccion.fromMap(Map<String, dynamic> map) {
    return ItemColeccion(
      mongoId: map['_id'] as ObjectId?,
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      autor: map['autor'] ?? '',
      editorial: map['editorial'] ?? '',
      precio: (map['precio'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      imagen: map['imagen'] ?? '',
      descripcion: map['descripcion'] ?? '',
      fuente: map['fuente'] ?? 'Manual',
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'editorial': editorial,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'descripcion': descripcion,
      'fuente': fuente,
    };

    if (mongoId != null) {
      map['_id'] = mongoId;
    }

    return map;
  }
}