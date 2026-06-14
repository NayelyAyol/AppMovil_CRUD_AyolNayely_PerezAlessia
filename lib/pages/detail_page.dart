import 'package:flutter/material.dart';

import '../models/item_coleccion.dart';
import '../theme/app_theme.dart';

/// Pantalla 4: Detalle.
/// Muestra el detalle completo de un libro de la colección local.
class DetailPage extends StatelessWidget {
  final ItemColeccion item;

  const DetailPage({super.key, required this.item});

  Widget _portada() {
    if (item.imagen.isEmpty) {
      return Container(
        height: 260,
        width: double.infinity,
        color: AppColors.dorado.withOpacity(0.25),
        child: const Center(
          child: Icon(Icons.menu_book, size: 90, color: AppColors.vino),
        ),
      );
    }

    return Image.network(
      item.imagen,
      height: 260,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 260,
        width: double.infinity,
        color: AppColors.dorado.withOpacity(0.25),
        child: const Center(
          child: Icon(Icons.broken_image, size: 90, color: AppColors.vino),
        ),
      ),
    );
  }

  Widget _fila(IconData icono, String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: AppColors.vino),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.vino,
                  ),
                ),
                Text(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.titulo)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _portada(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titulo,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(item.fuente)),
                      const SizedBox(height: 18),
                      _fila(Icons.person, 'Autor', item.autor),
                      _fila(Icons.business, 'Editorial', item.editorial),
                      _fila(Icons.attach_money, 'Precio', '\$${item.precio.toStringAsFixed(2)}'),
                      _fila(Icons.inventory_2, 'Ejemplares en stock', item.stock.toString()),
                      _fila(
                        Icons.notes,
                        'Descripción',
                        item.descripcion.isEmpty ? 'Sin descripción' : item.descripcion,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}