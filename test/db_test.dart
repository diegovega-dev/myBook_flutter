import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:proyecto_final/Model/models.dart';
import 'package:proyecto_final/database/db.dart';

void main() {
  late Database db;

  ///crea base de datos en memoria para hacer las pruebas
  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        // Create the tables as in your DB class
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute('''
        CREATE TABLE libros (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre VARCHAR(255) NOT NULL,
          publicacion CHAR(10) NOT NULL,
          genero VARCHAR(255),
          descripcion TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre VARCHAR(255) NOT NULL,
          apellidos VARCHAR(255) NOT NULL,
          nombre_usuario VARCHAR(255) NOT NULL,
          password VARCHAR(255) NOT NULL,
          email VARCHAR(255) NOT NULL
        )
      ''');
        await db.execute('''
        CREATE TABLE libros_usuario (
          id_usuario INTEGER NOT NULL,
          id_libro INTEGER NOT NULL,
          nota INTEGER NOT NULL CHECK (nota BETWEEN 1 AND 10),
          opinion TEXT NOT NULL,
          PRIMARY KEY (id_usuario, id_libro),
          FOREIGN KEY (id_usuario) REFERENCES usuarios (id) ON DELETE CASCADE,
          FOREIGN KEY (id_libro) REFERENCES libros (id) ON DELETE CASCADE
        )
      ''');
      },
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('insertUsuario inserts a new user correctly', () async {
    final usuario = Usuario(
      id: null,
      nombre: 'Diego',
      apellidos: 'Vega',
      nombre_usuario: 'user1',
      password: '1234',
      email: 'user1@example.com',
    );

    final userId = await Db.insertUsuario(usuario);
    expect(userId, isNotNull);

    final result = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [userId],
    );

    expect(result.isNotEmpty, true);
    expect(result.first['nombre_usuario'], 'user1');
  });

  test('getUsuarios fetches the correct users from the database', () async {
    final usuario1 = Usuario(
      id: null,
      nombre: 'Juan',
      apellidos: 'Perez',
      nombre_usuario: 'juanp',
      password: 'password123',
      email: 'juan@example.com',
    );

    final usuario2 = Usuario(
      id: null,
      nombre: 'Ana',
      apellidos: 'Lopez',
      nombre_usuario: 'anal',
      password: 'password456',
      email: 'ana@example.com',
    );

    await Db.insertUsuario(usuario1);
    await Db.insertUsuario(usuario2);

    final usuariosList = await Db.getUsuarios();
    expect(usuariosList.length, 2);
    expect(usuariosList[0].nombre_usuario, 'juanp');
    expect(usuariosList[1].nombre_usuario, 'anal');
  });

  test('insertLibro inserts a new book correctly', () async {
    final libro = Libro(
      id: null,
      nombre: '1984',
      publicacion: '1949-06-08',
      genero: 'Distopía',
      descripcion: 'A dystopian novel.',
    );

    final libroId = await Db.insertLibro(libro);
    expect(libroId, isNotNull);
    final result = await db.query(
      'libros',
      where: 'id = ?',
      whereArgs: [libroId],
    );

    expect(result.isNotEmpty, true);
    expect(result.first['nombre'], '1984');
  });

  test('getLibros fetches the correct books from the database', () async {
    final libro1 = Libro(
      id: null,
      nombre: '1984',
      publicacion: '1949-06-08',
      genero: 'Distopía',
      descripcion: 'A dystopian novel.',
    );

    final libro2 = Libro(
      id: null,
      nombre: 'Cien años de soledad',
      publicacion: '1967-05-30',
      genero: 'Realismo Mágico',
      descripcion: 'A novel by Gabriel Garcia Marquez.',
    );

    await Db.insertLibro(libro1);
    await Db.insertLibro(libro2);

    final librosList = await Db.getLibros();

    expect(librosList.length, 2);
    expect(librosList[0].nombre, '1984');
    expect(librosList[1].nombre, 'Cien años de soledad');
  });

}