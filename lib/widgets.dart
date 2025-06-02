import 'package:flutter/material.dart';

///widget que uso como container personalizado que contiene un semantics
class Contenedor extends StatelessWidget {
  final String label;
  final String hint;
  final double margen;
  final Widget a;

  const Contenedor({super.key, required this.label, required this.hint, required this.margen, required this.a});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      child: Container(
        margin: EdgeInsets.all(margen),
        child: a,
      ),
    );
  }
}

///card para la lista de libros leidos de la pantalla inicial
class LibroLeido extends StatelessWidget {
  final String titulo;
  final String comentario;
  final int nota;

  const LibroLeido({
    super.key,
    required this.titulo,
    required this.comentario,
    required this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comentario,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$nota/10",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(width: MediaQuery.sizeOf(context).width)
          ],
        ),
      ),
    );
  }
}

///card para la lista de libros
class LibroLista extends StatelessWidget {
  final String titulo;
  final String genero;
  final String fecha;
  final String descripcion;

  const LibroLista({
    super.key,
    required this.titulo,
    required this.genero,
    required this.fecha,
    required this.descripcion
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$titulo ($genero)",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topRight,
              child: Text(fecha),
            ),
            const SizedBox(height: 8),
            Container(width: MediaQuery.sizeOf(context).width)
          ],
        ),
      ),
    );
  }
}

///card para los ajustes
class SettingsCard extends StatelessWidget {
  final String titulo;
  final Widget child;

  const SettingsCard({super.key, required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Align(alignment: Alignment.centerRight, child: child),
          ],
        ),
      ),
    );
  }
}