import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio para consumir la API pública de Open Library
/// (https://openlibrary.org/search.json).
///
/// Soporta paginación mediante los parámetros "page" y "limit",
/// necesaria para el infinite scrolling de la pantalla ApiExplorerPage.
class OpenLibraryService {
  static Future<List<dynamic>> buscarLibros({
    required String query,
    required int page,
    int limit = 10,
  }) async {
    final Uri url = Uri.parse(
      'https://openlibrary.org/search.json?q=${Uri.encodeQueryComponent(query)}&page=$page&limit=$limit',
    );

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return (data['docs'] as List<dynamic>?) ?? [];
    } else {
      throw Exception('Error al consumir Open Library (${response.statusCode})');
    }
  }

  /// Construye la URL de portada a partir del "cover_i" devuelto por la API.
  static String obtenerPortada(dynamic libro) {
    final coverId = libro['cover_i'];
    if (coverId == null) return '';
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }

  /// Devuelve el/los autores como un solo texto.
  static String obtenerAutor(dynamic libro) {
    final autores = libro['author_name'];
    if (autores == null || (autores as List).isEmpty) return 'Autor desconocido';
    return autores.join(', ');
  }

  /// Devuelve la primera editorial disponible, si existe.
  static String obtenerEditorial(dynamic libro) {
    final editoriales = libro['publisher'];
    if (editoriales == null || (editoriales as List).isEmpty) return 'Desconocida';
    return editoriales.first.toString();
  }
}