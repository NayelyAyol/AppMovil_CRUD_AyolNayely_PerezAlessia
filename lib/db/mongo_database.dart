import 'package:mongo_dart/mongo_dart.dart';

import '../models/item_coleccion.dart';

/// Capa de acceso a MongoDB Atlas para la colección local de libros.
///
/// IMPORTANTE: reemplaza la cadena de conexión por la de tu propio
/// cluster de MongoDB Atlas (Database Access -> usuario y contraseña,
/// Network Access -> permitir tu IP o 0.0.0.0/0 para pruebas).
class MongoDatabase {
  static Db? _db;
  static DbCollection? _coleccion;

  static const String _connectionString =
      'mongodb+srv://nayelyayol_db_user:g5tQhokyEhUfJkn1@crudcluster.nktoovj.mongodb.net/?appName=CrudCluster';

  static Future<void> connect() async {
    _db = await Db.create(_connectionString);
    await _db!.open();
    _coleccion = _db!.collection('libros');
  }

  static DbCollection get _col {
    final coleccion = _coleccion;
    if (coleccion == null) {
      throw Exception('La base de datos no ha sido inicializada. Llama a MongoDatabase.connect() primero.');
    }
    return coleccion;
  }

  /// READ: obtiene todos los libros guardados.
  static Future<List<ItemColeccion>> getItems() async {
    final List<Map<String, dynamic>> data = await _col.find().toList();
    return data.map((e) => ItemColeccion.fromMap(e)).toList();
  }

  /// CREATE: inserta un nuevo libro (manual o desde la API externa).
  static Future<void> insertItem(ItemColeccion item) async {
    await _col.insertOne(item.toMap());
  }

  /// UPDATE: actualiza un libro existente según su campo "id".
  static Future<void> updateItem(ItemColeccion item) async {
    await _col.update(
      where.eq('id', item.id),
      item.toMap(),
    );
  }

  /// DELETE: elimina un libro según su campo "id".
  static Future<void> deleteItem(String id) async {
    await _col.deleteOne(where.eq('id', id));
  }

  /// Verifica si ya existe un libro con ese título (evita duplicados
  /// al guardar desde la API externa).
  static Future<bool> existeLibro(String titulo) async {
    final Map<String, dynamic>? existente = await _col.findOne(where.eq('titulo', titulo));
    return existente != null;
  }
}