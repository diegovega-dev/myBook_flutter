import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/Model/models.dart';
import 'package:proyecto_final/widgets.dart';
import 'package:proyecto_final/ViewModel/db_provider.dart';
import 'package:proyecto_final/ViewModel/sesionProvider.dart';
import 'package:proyecto_final/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';


class Inicio extends StatefulWidget {
  const Inicio({super.key});
  
  @override
  State<StatefulWidget> createState() => _Inicio();
}

///clase de la pantalla de inicio
class _Inicio extends State<Inicio> {

  @override
  void initState() {
    super.initState();
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final sesion = Provider.of<SesionProvider>(context, listen: false);

    dbProvider.cargarLibrosUsurio(sesion.user);
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);
    final sesion = Provider.of<SesionProvider>(context, listen: false);
    final AppLocalizations local = AppLocalizations.of(context)!;

    if (dbProvider.librosLeidos.isEmpty || dbProvider.librosUsuario.isEmpty) {
      return Center(child: Text(local.error_buscarLibros));
    }

    List<Libro> librosLeidos = dbProvider.librosLeidos;
    List<LibroUsuario> comentarioNota = dbProvider.librosUsuario;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: librosLeidos.length,
        itemBuilder: (context, index) {
          Libro libro = librosLeidos[index];

          LibroUsuario? libroUsuario = comentarioNota.firstWhere(
                (item) => item.id_libro == libro.id,
            orElse: () => LibroUsuario(
              id_usuario: sesion.user.id!,
              id_libro: libro.id!,
              nota: 0,
              opinion: '',
            ),
          );

          return Row(children: [
              Expanded(child: LibroLeido(
                titulo: libro.nombre,
                comentario: libroUsuario.opinion,
                nota: libroUsuario.nota,
              )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      dbProvider.removeLibroUsuario(libroUsuario);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Main()),
                            (Route<dynamic> route) => false,
                      );
                    });
                  },
                  icon: const Icon(Icons.delete))
            ],
          );
        },
      ),
    );
  }
}

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<StatefulWidget> createState() => _Buscar();
}

///clase de la pantalla de buscar un nuveo libro para añadir
class _Buscar extends State<Buscar> {
  final TextEditingController _searchController = TextEditingController();
  List<Libro> _resultados = [];

  @override
  void initState() {
    super.initState();
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final sesion = Provider.of<SesionProvider>(context, listen: false);

    dbProvider.cargarLibrosUsurio(sesion.user);
  }

  void _buscarLibros(String query, List<Libro> libros) {
    setState(() {
      _resultados = libros
          .where((libro) => libro.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);
    final AppLocalizations local = AppLocalizations.of(context)!;

    List<Libro> libros = dbProvider.libros.where((libro) => !dbProvider.librosLeidos.contains(libro)).toList();

    return SingleChildScrollView( child:
      SizedBox(
        height: MediaQuery.of(context).size.height -30,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: local.buscar,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _resultados.clear();
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) => _buscarLibros(value, libros),
            ),
          ),
          Expanded(
            child: _resultados.isEmpty
                ? Center(child: Text(local.error_buscarLibros))
                : ListView.builder(
                itemCount: _resultados.length,
                itemBuilder: (context, index) {
                Libro libro = _resultados[index];

                return Row(children: [
                  Expanded(child: LibroLista(
                    titulo: libro.nombre,
                    genero: libro.genero,
                    descripcion: libro.descripcion,
                    fecha: libro.publicacion,
                  )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return AgregarLibro(a: libro);
                            },
                          );
                        });
                      },
                      icon: const Icon(Icons.add))
                ],
                );
              },
            ),
          ),
        ]
    )));
  }
}

class AgregarLibro extends StatefulWidget {
  const AgregarLibro({super.key, required this.a});

  final Libro a;

  @override
  State<StatefulWidget> createState() => _AgregarLibro();
}

///clase que gestiona la pantallita que se abre para añadir el libro a tu coleccion
class _AgregarLibro extends State<AgregarLibro> {
  final TextEditingController comentarioController = TextEditingController();
  double nota = 5.0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;
    Libro libro = widget.a;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${local.anadir} ${libro.nombre}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(local.nota, style: const TextStyle(fontSize: 16)),
          Slider(
            value: nota,
            min: 0,
            max: 10,
            divisions: 10,
            label: nota.toString(),
            onChanged: (value) {
              setState(() {
                nota = value;
              });
            },
          ),
          TextField(
            controller: comentarioController,
            decoration: InputDecoration(
              labelText: local.comentario,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
              final sesion = Provider.of<SesionProvider>(context, listen: false);

              LibroUsuario libroUsuario = LibroUsuario(
                id_usuario: sesion.user.id!,
                id_libro: libro.id!,
                nota: nota.toInt(),
                opinion: comentarioController.text,
              );

              await dbProvider.insertLibroUsuario(libroUsuario);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Main()),
                    (Route<dynamic> route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(local.mensajeAgregado)),
              );
            },
            child: Text(local.anadir),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

}

class CrearLibro extends StatefulWidget {
  const CrearLibro({super.key});

  @override
  State<StatefulWidget> createState() => _CrearLibro();

}

///clase de la pantalla agregar un libro a la BD
class _CrearLibro extends State<CrearLibro> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _publicacionController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;

    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: local.h_nombre),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.errorCampoVacio;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _publicacionController,
                  decoration: InputDecoration(labelText: local.fechaPublicacion),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.errorCampoVacio;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _generoController,
                  decoration: InputDecoration(labelText: local.genero),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.errorCampoVacio;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: local.descripcion),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return local.errorCampoVacio;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final libro = Libro(
                        id: null,
                        nombre: _nombreController.text,
                        publicacion: _publicacionController.text,
                        genero: _generoController.text,
                        descripcion: _descripcionController.text,
                      );

                      final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
                      await dbProvider.addLibro(libro);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Main()),
                            (Route<dynamic> route) => false,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(local.mensajeAgregado)),
                      );
                    }
                  },
                  child: Text(local.anadir),
                ),
              ],
            ),
          ),
        ),
    );
  }
}