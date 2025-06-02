import 'package:flutter/material.dart';
import 'package:proyecto_final/Model/models.dart';
import 'package:proyecto_final/Database/db.dart';

///clase intermediaria entre la app y la base de datos
class DatabaseProvider with ChangeNotifier {
  List<Usuario> _usuarios = [];
  List<Libro> _libros = [];
  List<LibroUsuario> _librosUsuario = [];
  List<Libro> librosLeidos = [];

  List<Usuario> get usuarios => _usuarios;
  List<Libro> get libros => _libros;
  List<LibroUsuario> get librosUsuario => _librosUsuario;

  Future<void> cargarUsuarios() async {
    _usuarios = await Db.getUsuarios();
    notifyListeners();
  }

  Future<void> cargarLibros() async {
    _libros = await Db.getLibros();
    notifyListeners();
  }

  Future<void> cargarLibrosUsurio(Usuario usuario) async {
    await cargarLibros();
    _librosUsuario = await Db.getLibrosUsuario(usuario);

    Set<int> idsLibros = _librosUsuario.map((libroUsuario) => libroUsuario.id_libro).toSet();
    librosLeidos = _libros.where((libro) => idsLibros.contains(libro.id)).toList();
    notifyListeners();
  }


  Future<void> actualizarUser(Usuario u) async {
    await Db.updateUsuario(u);
    await cargarUsuarios();
  }

  Future<void> addUsuario(Usuario usuario) async {
    await Db.insertUsuario(usuario);
    await cargarUsuarios();
  }

  Future<void> addLibro(Libro libro) async {
    await Db.insertLibro(libro);
    await cargarLibros();
  }

  Future<void> insertLibroUsuario(LibroUsuario libroUsuario) async {
  await Db.insertLibro_Usuario(libroUsuario);
  await cargarLibros();
  }

  Future<void> removeUsuario(Usuario usuario) async {
    await Db.deltetUsuario(usuario);
    await cargarUsuarios();
  }

  Future<void> removeLibro(Libro libro) async {
    await Db.deleteLibro(libro);
    await cargarLibros();
  }

  Future<void> removeLibroUsuario(LibroUsuario libroUsuario) async {
    await Db.deleteLibro_Usuario(libroUsuario);
    await cargarLibros();
  }
}