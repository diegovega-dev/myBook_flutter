class Libro {
  final int? id;
  final String nombre;
  final String publicacion;
  final String genero;
  final String descripcion;

  Libro({
    required this.id,
    required this.nombre,
    required this.publicacion,
    required this.genero,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'publicacion': publicacion,
      'genero': genero,
      'descripcion': descripcion,
    };
  }
}

class Usuario {
  final int? id;
  final String nombre;
  final String apellidos;
  final String nombre_usuario;
  String password;
  final String email;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nombre_usuario,
    required this.password,
    required this.email
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'nombre_usuario': nombre_usuario,
      'password': password,
      'email': email
    };
  }
}

class LibroUsuario {
  final int id_usuario;
  final int id_libro;
  final int nota;
  final String opinion;

  LibroUsuario({
    required this.id_usuario,
    required this.id_libro,
    required this.nota,
    required this.opinion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': id_usuario,
      'id_libro': id_libro,
      'nota': nota,
      'opinion': opinion,
    };
  }
}