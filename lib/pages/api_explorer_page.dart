import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';
import '../services/open_library_service.dart';
import '../theme/app_theme.dart';

/// Pantalla 5: Explorador de API.
/// Consume Open Library (https://openlibrary.org/search.json) con
/// scroll infinito y permite guardar cualquier resultado en la
/// colección local de MongoDB Atlas.
class ApiExplorerPage extends StatefulWidget {
  const ApiExplorerPage({super.key});

  @override
  State<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends State<ApiExplorerPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _buscadorCtrl = TextEditingController(text: 'romance');

  final List<dynamic> _libros = [];
  int _page = 1;
  final int _limit = 10;
  bool _cargando = false;
  bool _hayMas = true;
  String _query = 'romance';

  @override
  void initState() {
    super.initState();
    _cargarMas();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _cargarMas();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _buscadorCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarMas() async {
    if (_cargando || !_hayMas) return;

    setState(() => _cargando = true);

    try {
      final List<dynamic> nuevos = await OpenLibraryService.buscarLibros(
        query: _query,
        page: _page,
        limit: _limit,
      );

      setState(() {
        _page++;
        _libros.addAll(nuevos);
        _cargando = false;

        if (nuevos.length < _limit) {
          _hayMas = false;
        }
      });
    } catch (e) {
      setState(() => _cargando = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al consultar Open Library: $e')),
      );
    }
  }

  void _buscar() {
    final String texto = _buscadorCtrl.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      _query = texto;
      _libros.clear();
      _page = 1;
      _hayMas = true;
    });

    _cargarMas();
  }

  Future<void> _guardarEnColeccion(dynamic libro) async {
    final String titulo = libro['title'] ?? 'Sin título';

    final bool yaExiste = await MongoDatabase.existeLibro(titulo);

    if (yaExiste) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este libro ya está en tu colección')),
      );
      return;
    }

    final ItemColeccion item = ItemColeccion(
      id: const Uuid().v4(),
      titulo: titulo,
      autor: OpenLibraryService.obtenerAutor(libro),
      editorial: OpenLibraryService.obtenerEditorial(libro),
      precio: 0,
      stock: 1,
      imagen: OpenLibraryService.obtenerPortada(libro),
      descripcion: 'Primera publicación: ${libro['first_publish_year'] ?? 'N/D'}',
      fuente: 'Open Library API',
    );

    await MongoDatabase.insertItem(item);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guardado en mi colección')),
    );
  }

  Widget _portada(String url) {
    if (url.isEmpty) {
      return Container(
        width: 60,
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.dorado.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.menu_book, color: AppColors.vino),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url,
        width: 60,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 60,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.dorado.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.broken_image, color: AppColors.vino),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar Libros')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscadorCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por título, autor o tema...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _buscar,
                  child: const Icon(Icons.travel_explore),
                ),
              ],
            ),
          ),
          Expanded(
            child: _libros.isEmpty && _cargando
                ? const Center(child: CircularProgressIndicator(color: AppColors.vino))
                : _libros.isEmpty
                    ? const Center(child: Text('Sin resultados, intenta otra búsqueda'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _libros.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _libros.length) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: _hayMas
                                    ? const CircularProgressIndicator(color: AppColors.vino)
                                    : const Text('No hay más resultados'),
                              ),
                            );
                          }

                          final dynamic libro = _libros[index];
                          final String portada = OpenLibraryService.obtenerPortada(libro);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _portada(portada),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          libro['title'] ?? 'Sin título',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          OpenLibraryService.obtenerAutor(libro),
                                          style: const TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                        Text('Año: ${libro['first_publish_year'] ?? 'N/D'}'),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FilledButton.icon(
                                            onPressed: () => _guardarEnColeccion(libro),
                                            icon: const Icon(Icons.bookmark_add, size: 18),
                                            label: const Text('Guardar'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}