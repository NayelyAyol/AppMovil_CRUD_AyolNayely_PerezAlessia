import 'package:flutter/material.dart';

import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';
import 'form_page.dart';

/// Pantalla 2: Colección.
/// Lista de libros guardados en MongoDB Atlas, con búsqueda por título,
/// pull to refresh y acciones de editar / eliminar.
class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Future<List<ItemColeccion>> _futuro;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futuro = MongoDatabase.getItems();
  }

  Future<void> _refrescar() async {
    setState(_cargar);
  }

  Future<void> _eliminar(String id) async {
    await MongoDatabase.deleteItem(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Libro eliminado de la colección')),
    );

    await _refrescar();
  }

  void _confirmarEliminar(ItemColeccion item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Eliminar "${item.titulo}" de tu colección?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _eliminar(item.id);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _abrirFormulario({ItemColeccion? item}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPage(item: item)),
    );
    await _refrescar();
  }

  void _abrirDetalle(ItemColeccion item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(item: item)),
    );
  }

  Widget _portada(String url) {
    if (url.isEmpty) {
      return Container(
        width: 55,
        height: 80,
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
        width: 55,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 55,
          height: 80,
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
      appBar: AppBar(
        title: const Text('Mi Colección'),
        actions: [
          IconButton(onPressed: _refrescar, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _busqueda = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ItemColeccion>>(
              future: _futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.vino),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error al cargar datos:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                List<ItemColeccion> data = snapshot.data ?? [];

                if (_busqueda.isNotEmpty) {
                  data = data
                      .where((e) => e.titulo.toLowerCase().contains(_busqueda))
                      .toList();
                }

                if (data.isEmpty) {
                  return ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'Tu estantería está vacía 📚\nAgrega un libro o explora la API',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refrescar,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final ItemColeccion item = data[index];

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: _portada(item.imagen),
                          title: Text(
                            item.titulo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${item.autor}\n${item.editorial} · \$${item.precio.toStringAsFixed(2)} · Stock: ${item.stock}',
                          ),
                          isThreeLine: true,
                          onTap: () => _abrirDetalle(item),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit, color: AppColors.vino),
                                onPressed: () => _abrirFormulario(item: item),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(Icons.delete, color: AppColors.oxido),
                                onPressed: () => _confirmarEliminar(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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