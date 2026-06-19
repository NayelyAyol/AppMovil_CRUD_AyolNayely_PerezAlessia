import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pantalla 6: Acerca de.
/// Integrantes, API usada y explicación técnica del proyecto.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _seccion(String titulo, String contenido, IconData icono) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: AppColors.vino),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(contenido),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const Icon(Icons.menu_book, size: 70, color: AppColors.vino),
                const SizedBox(height: 8),
                Text('Rincón Literario', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                const Text(
                  'Tu estantería digital, con encanto retro',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _seccion(
            'Integrantes',
            'Nayely Ayol - Código\nAlessia Perez - Código',
            Icons.people,
          ),
          _seccion(
            'API utilizada',
            'Open Library Search API (openlibrary.org/search.json). '
                'Permite explorar libros por título, autor o tema, con paginación '
                'para el scroll infinito y portadas a través del servicio '
                'covers.openlibrary.org.',
            Icons.travel_explore,
          ),
          _seccion(
            'Tecnologías',
            'Flutter + Dart, MongoDB Atlas (paquete mongo_dart) para la colección '
                'local, paquete http para el consumo de la API externa y uuid para '
                'generar identificadores únicos.',
            Icons.code,
          ),
          _seccion(
            'Funcionalidades',
            'CRUD completo de libros guardados (crear, listar, editar, eliminar y '
                'ver detalle), exploración de Open Library con scroll infinito, '
                'guardado directo desde la API hacia la colección local, búsqueda '
                'por título y estadísticas generales de la colección.',
            Icons.star,
          ),
        ],
      ),
    );
  }
}