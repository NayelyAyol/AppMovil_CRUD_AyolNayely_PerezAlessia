import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../db/mongo_database.dart';
import '../models/item_coleccion.dart';

class FormPage extends StatefulWidget {
  final ItemColeccion? item;

  const FormPage({super.key, this.item});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController autorCtrl = TextEditingController();
  final TextEditingController editorialCtrl = TextEditingController();
  final TextEditingController precioCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();
  final TextEditingController imagenCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    final ItemColeccion? item = widget.item;

    if (item != null) {
      tituloCtrl.text = item.titulo;
      autorCtrl.text = item.autor;
      editorialCtrl.text = item.editorial;
      precioCtrl.text = item.precio.toString();
      stockCtrl.text = item.stock.toString();
      imagenCtrl.text = item.imagen;
      descripcionCtrl.text = item.descripcion;
    }
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    autorCtrl.dispose();
    editorialCtrl.dispose();
    precioCtrl.dispose();
    stockCtrl.dispose();
    imagenCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final ItemColeccion item = ItemColeccion(
      mongoId: widget.item?.mongoId,
      id: widget.item?.id ?? const Uuid().v4(),
      titulo: tituloCtrl.text.trim(),
      autor: autorCtrl.text.trim(),
      editorial: editorialCtrl.text.trim(),
      precio: double.tryParse(precioCtrl.text.trim()) ?? 0,
      stock: int.tryParse(stockCtrl.text.trim()) ?? 0,
      imagen: imagenCtrl.text.trim(),
      descripcion: descripcionCtrl.text.trim(),
      fuente: widget.item?.fuente ?? 'Manual',
    );

    try {
      if (widget.item == null) {
        await MongoDatabase.insertItem(item);
      } else {
        await MongoDatabase.updateItem(item);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Libro agregado a tu colección'
                : 'Libro actualizado',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Widget _campo(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? icono,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icono != null ? Icon(icono) : null,
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo obligatorio';
          }
          if (validator != null) {
            return validator(value);
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool editando = widget.item != null;

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar libro' : 'Nuevo libro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo(tituloCtrl, 'Título', icono: Icons.menu_book),
              _campo(autorCtrl, 'Autor', icono: Icons.person),
              _campo(editorialCtrl, 'Editorial', icono: Icons.business),
              _campo(
                precioCtrl,
                'Precio',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                icono: Icons.attach_money,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  final n = double.tryParse(value ?? '');
                  if (n == null) {
                    return 'Ingrese un número válido';
                  }
                  if (n < 0) {
                    return 'El precio no puede ser negativo';
                  }
                  return null;
                },
              ),
              _campo(
                stockCtrl,
                'Stock (ejemplares)',
                keyboardType: TextInputType.number,
                icono: Icons.inventory_2,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null) return 'Ingrese un entero válido';
                  if (n < 0) return 'El stock no puede ser menor a 0';
                  return null;
                },
              ),
              _campo(imagenCtrl, 'URL de portada', icono: Icons.image),
              _campo(
                descripcionCtrl,
                'Descripción / sinopsis',
                maxLines: 4,
                icono: Icons.notes,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: const Icon(Icons.save),
                  label: Text(_guardando ? 'Guardando...' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
