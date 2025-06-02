import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:proyecto_final/Model/models.dart';

class Db {
  
  //crear y/o acceder a la base de datos sqlite
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'gestorLibros.db'),
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        // Crear la tabla libros
        await db.execute(
          '''
          CREATE TABLE libros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(255) NOT NULL,
            publicacion CHAR(10) NOT NULL,
            genero VARCHAR(255),
            descripcion TEXT
          )
          ''');

        // Crear la tabla usuarios
        await db.execute(
          '''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(255) NOT NULL,
            apellidos VARCHAR(255) NOT NULL,
            nombre_usuario VARCHAR(255) NOT NULL,
            password VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL
          )
          ''');

        // Crear la tabla lisbros_usuario
        await db.execute(
          '''
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

        await db.execute(
          '''
          INSERT INTO `usuarios` (`nombre`, `apellidos`,`nombre_usuario`, `password`, `email`) VALUES
          ('Diego', 'Vega','user1', '1234', 'user1@gmail.com'),
          ('Sergio', 'Perez','user2', '4321', 'user2@gmail.com'),
          ('Pablo', 'Alvarez','user3', 'pass', 'user3@gmail.com');
          '''
        );
        
        await db.execute(
          '''
          INSERT INTO `libros` (`nombre`, `publicacion`, `genero`, `descripcion`) VALUES
          ('1984', '1949-06-08', 'Distopía', 'Una novela que explora un mundo distópico controlado por el Gran Hermano.'),
          ('Cien años de soledad', '1967-05-30', 'Realismo Mágico', 'Una obra maestra de Gabriel García Márquez que narra la historia de la familia Buendía.'),
          ('El principito', '1943-04-06', 'Fábula', 'Un pequeño príncipe viaja por el universo descubriendo el valor de la amistad y el amor.'),
          ('To Kill a Mockingbird', '1960-07-11', 'Ficción', 'Una historia sobre justicia y prejuicio en el sur de Estados Unidos.');
          '''
        );

        await db.execute(
          '''
          INSERT INTO `libros_usuario` (`id_usuario`, `id_libro`, `nota`, `opinion`) VALUES
          (1, 1, 9, 'Una lectura fascinante y aterradora, muy recomendable.'),
          (1, 2, 8, 'Me gustó mucho la profundidad de los personajes.'),
          (2, 3, 10, 'Un libro hermoso y conmovedor, lleno de enseñanzas.'),
          (3, 4, 7, 'Interesante, pero un poco lento en algunos capítulos.');
          '''
        );
      },
      version: 1,
    );
  }

  //metodos insert (devuelven el id)
  static Future<int> insertUsuario(Usuario user) async {
    Database database = await _openDB();
    return database.insert("usuarios", user.toMap());
  }

  static Future<int> insertLibro_Usuario(LibroUsuario libroUsuario) async {
    Database database = await _openDB();
    return database.insert("libros_usuario", libroUsuario.toMap());
  }

  static Future<int> insertLibro(Libro libro) async {
    Database database = await _openDB();
    return database.insert("libros", libro.toMap());
  }

  //metodos delete (devuelven el id)
  static Future<int> deltetUsuario(Usuario user) async {
    Database database = await _openDB();
    return database.delete("usuarios", where: "id = ?", whereArgs: [user.id]);
  }

  static Future<int> deleteLibro_Usuario(LibroUsuario libroUsuario) async {
    Database database = await _openDB();
    return database.delete("libros_usuario", where: "id_usuario = ? and id_libro = ?", whereArgs: [libroUsuario.id_usuario, libroUsuario.id_libro]);
  }

  static Future<int> deleteLibro(Libro libro) async {
    Database database = await _openDB();
    return database.delete("libros", where: "id = ?", whereArgs: [libro.id]);
  }

  //metodos update (devuelven el id)
  static Future<int> updateUsuario(Usuario user) async {
    Database database = await _openDB();
    return database.update("usuarios",user.toMap() ,where: "id = ?", whereArgs: [user.id]);
  }

  static Future<int> updateLibro_Usuario(LibroUsuario libroUsuario) async {
    Database database = await _openDB();
    return database.update("libros_usuario",libroUsuario.toMap() ,where: "id_usuario = ? and id_libro = ?", whereArgs: [libroUsuario.id_usuario, libroUsuario.id_libro]);
  }

  static Future<int> updateLibro(Libro libro) async {
    Database database = await _openDB();
    return database.update("libros",libro.toMap() ,where: "id = ?", whereArgs: [libro.id]);
  }

  //getter
  static Future<List<Usuario>> getUsuarios () async {
    Database database = await _openDB();
    
    final List<Map<String, dynamic>> usuariosMap = await database.query("usuarios");
    return List.generate(usuariosMap.length, 
      (i) => Usuario(
        id: usuariosMap[i]['id'],
        nombre: usuariosMap[i]['nombre'],
        apellidos: usuariosMap[i]['apellidos'],
        nombre_usuario: usuariosMap[i]['nombre_usuario'],
        password: usuariosMap[i]['password'],
        email: usuariosMap[i]['email']
      ));
  }

  static Future<List<Libro>> getLibros () async {
    Database database = await _openDB();
    
    final List<Map<String, dynamic>> librosMap = await database.query("libros");
    return List.generate(librosMap.length, 
      (i) => Libro(
        id: librosMap[i]['id'],
        descripcion: librosMap[i]['descripcion'],
        genero: librosMap[i]['genero'],
        nombre: librosMap[i]['nombre'],
        publicacion: librosMap[i]['publicacion']
      ));
  }

  static Future<List<LibroUsuario>> getLibrosUsuario (Usuario user) async {
    Database database = await _openDB();
    
    final List<Map<String, dynamic>> librosMap = await database.query("libros_usuario", where: "id_usuario = ?", whereArgs: [user.id]);
    return List.generate(librosMap.length, 
      (i) => LibroUsuario(
        id_libro: librosMap[i]['id_libro'],
        id_usuario: librosMap[i]['id_usuario'],
        nota: librosMap[i]['nota'],
        opinion: librosMap[i]['opinion']
      ));
  }

}