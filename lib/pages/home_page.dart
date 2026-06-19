import 'package:flutter/material.dart';

import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';
import '../theme/app_theme.dart';
import 'about_page.dart';
import 'api_explorer_page.dart';
import 'collection_page.dart';

/// Pantalla 1: Inicio.
/// Menú principal con acceso a la colección local, el explorador
/// de la API externa, estadísticas y la pantalla "Acerca de".
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _opcion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Widget destino,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.vino,
          radius: 24,
          child: Icon(icono, color: AppColors.crema),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right, color: AppColors.vino),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destino),
          ).then((_) {
            // Este bloque se ejecuta automáticamente al regresar a esta pantalla.
            // Fuerza a reconstruir el HomePage para que el FutureBuilder vuelva a leer MongoDB.
            if (context.mounted) {
              (context as Element).markNeedsBuild();
            }
          });
        },
      ),
    );
  }

  Widget _estadisticas() {
    return FutureBuilder<List<ItemColeccion>>(
      future: MongoDatabase.getItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.vino),
              ),
            ),
          );
        }

        final List<ItemColeccion> items = snapshot.data!;
        final int total = items.length;
        final int stockTotal = items.fold<int>(0, (s, e) => s + e.stock);

        // Suma acumulada de todos los precios de los libros en la colección
        final double valorTotalColeccion = items.fold<double>(
          0,
          (s, e) => s + e.precio,
        );

        Widget dato(String valor, String etiqueta, IconData icono) {
          return Column(
            children: [
              Icon(icono, color: AppColors.oxido, size: 22),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.vino,
                ),
              ),
              Text(etiqueta, style: const TextStyle(fontSize: 12)),
            ],
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dato('$total', 'Libros', Icons.menu_book),
                // Se reemplaza "Precio prom." por el "Valor total" acumulado de la colección
                dato(
                  '\$${valorTotalColeccion.toStringAsFixed(2)}',
                  'Valor total',
                  Icons.monetization_on,
                ),
                dato('$stockTotal', 'Stock total', Icons.inventory_2),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.vino,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.dorado, width: 3),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        size: 48,
                        color: AppColors.crema,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Rincón Literario',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.vino,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'tu pequeña librería de bolsillo',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.marronTexto,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _estadisticas(),
              const SizedBox(height: 22),
              const Text(
                'Explora',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.vino,
                ),
              ),
              const SizedBox(height: 8),
              _opcion(
                context,
                icono: Icons.collections_bookmark,
                titulo: 'Mi Colección',
                subtitulo: 'Ver, editar y eliminar los libros guardados',
                destino: const CollectionPage(),
              ),
              _opcion(
                context,
                icono: Icons.travel_explore,
                titulo: 'Explorar Libros',
                subtitulo: 'Buscar en Open Library y guardar en tu colección',
                destino: const ApiExplorerPage(),
              ),
              _opcion(
                context,
                icono: Icons.info_outline,
                titulo: 'Acerca de',
                subtitulo: 'Integrantes, API usada y detalles del proyecto',
                destino: const AboutPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
