import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/Model/models.dart';
import 'package:proyecto_final/widgets.dart';
import 'package:proyecto_final/ViewModel/db_provider.dart';
import 'package:proyecto_final/ViewModel/sesionProvider.dart';
import 'package:proyecto_final/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

///clase con toda la logica para iniciar sesion
class _Login extends State<Login> {
  List<Usuario> usuarios = [];
  final TextEditingController _conName = TextEditingController();
  final TextEditingController _conPass = TextEditingController();
  var _errorNombre;
  var _errorPass;
  bool mostrarPass = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _loadData());
  }

  ///metodo para cargar los datos necesarios
  Future<void> _loadData() async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await dbProvider.cargarUsuarios();
    setState(() {
      usuarios = dbProvider.usuarios;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;
    final sesion = Provider.of<SesionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(local.txt_btn_iniciarSesion)),
      body: Center(
        child: usuarios.isEmpty
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Contenedor(
                      label: local.lb_nombreUsuario,
                      hint: local.h_nombreUsuario,
                      margen: 10,
                      a: SizedBox(
                        width: 274,
                        child: TextField(
                          onTap: () => setState(() {
                            _errorNombre = null;
                          }),
                          controller: _conName,
                          decoration: InputDecoration(errorText: _errorNombre, label: Text(local.h_nombreUsuario)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Contenedor(
                            label: local.lb_pass,
                            hint: local.h_pass,
                            margen: 10,
                            a: SizedBox(
                              width: 200,
                              child: TextField(
                                onTap: () => setState(() {
                                  _errorPass = null;
                                }),
                                controller: _conPass,
                                obscureText: mostrarPass,
                                decoration: InputDecoration(errorText: _errorPass, label: Text(local.h_pass)),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: !mostrarPass,
                              onChanged: (value) => setState(() {
                                mostrarPass = !value!;
                              }),
                            ),
                            const Icon(Icons.remove_red_eye),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        bool usuarioEncontrado = false;

                        ///busca un usuario con el nombre especificado
                        for (var user in usuarios) {
                          if (user.nombre_usuario == _conName.text) {
                            usuarioEncontrado = true;
                            if (user.password == _conPass.text) {
                              sesion.login(user);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const Main()),
                                (Route<dynamic> route) => false,
                              );
                              return;
                            } else {
                              setState(() {
                                _errorPass = local.error_pass;
                                _errorNombre = null;
                              });
                              return;
                            }
                          }
                        }

                        if (!usuarioEncontrado) {
                          setState(() {
                            _errorNombre = local.error_username;
                            _errorPass = null;
                          });
                        }
                      },
                      icon: const Icon(Icons.send, size: 30),
                    ),
                  ],
                ),
              ),
        ),
      );
    }
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<StatefulWidget> createState() => _CreateAccount();
}

///clase con toda la logica para crear un nueva cuenta
class _CreateAccount extends State<CreateAccount> {
  List<Usuario> usuarios = [];
  final TextEditingController _conName = TextEditingController();
  final TextEditingController _conSurname = TextEditingController();
  final TextEditingController _conUsername = TextEditingController();
  final TextEditingController _conPassword = TextEditingController();
  final TextEditingController _conEmail = TextEditingController();
  var _errorName;
  var _errorSurname;
  var _errorUsername;
  var _errorPassword;
  var _errorEmail;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _loadData());
  }

  ///metodo para cargar los datos necesarios
  Future<void> _loadData() async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    await dbProvider.cargarUsuarios();
    setState(() {
      usuarios = dbProvider.usuarios;
    });
  }

  ///metodo que comprueba si el nombre de usuario ya esta cogido
  bool _isUsernameTaken(String username) {
    return usuarios.any((user) => user.nombre_usuario == username);
  }

  ///metodo que comprueba si el correo electronico ya esta registrado
  bool _isEmailTaken(String email) {
    return usuarios.any((user) => user.email == email);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(local.txt_btn_crearCuenta),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Contenedor(
              label: local.lb_nombre, 
              hint: local.h_nombre, 
              margen: 10, 
              a: SizedBox(
                width: 200, 
                child: TextField(
                  controller: _conName,
                  decoration: InputDecoration(
                    labelText: local.lb_nombre,
                    hintText: _errorName ?? local.h_nombre,
                    hintStyle: TextStyle(color: _errorName != null ? Colors.red : Colors.grey),
                    labelStyle: TextStyle(color: _errorName != null ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
            Contenedor(
              label: local.lb_apellidos, 
              hint: local.h_apellidos, 
              margen: 10, 
              a: SizedBox(
                width: 200, 
                child: TextField(
                  controller: _conSurname,
                  decoration: InputDecoration(
                    labelText: local.lb_apellidos,
                    hintText: _errorSurname ?? local.h_apellidos,
                    hintStyle: TextStyle(color: _errorSurname != null ? Colors.red : Colors.grey),
                    labelStyle: TextStyle(color: _errorSurname != null ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
            Contenedor(
              label: local.lb_nombreUsuario, 
              hint: local.h_nombreUsuario, 
              margen: 10, 
              a: SizedBox(
                width: 200, 
                child: TextField(
                  controller: _conUsername,
                  decoration: InputDecoration(
                    labelText: local.lb_nombreUsuario,
                    hintText: _errorUsername ?? local.h_nombreUsuario,
                    hintStyle: TextStyle(color: _errorUsername != null ? Colors.red : Colors.grey),
                    labelStyle: TextStyle(color: _errorUsername != null ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
            Contenedor(
              label: local.lb_pass, 
              hint: local.h_pass, 
              margen: 10, 
              a: SizedBox(
                width: 200, 
                child: TextField(
                  controller: _conPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: local.lb_pass,
                    hintText: _errorPassword ?? local.h_pass,
                    hintStyle: TextStyle(color: _errorPassword != null ? Colors.red : Colors.grey),
                    labelStyle: TextStyle(color: _errorPassword != null ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
            Contenedor(
              label: local.lb_email, 
              hint: local.h_email, 
              margen: 10, 
              a: SizedBox(
                width: 200, 
                child: TextField(
                  controller: _conEmail,
                  decoration: InputDecoration(
                    labelText: local.lb_email,
                    hintText: _errorEmail ?? local.h_email,
                    hintStyle: TextStyle(color: _errorEmail != null ? Colors.red : Colors.grey),
                    labelStyle: TextStyle(color: _errorEmail != null ? Colors.red : Colors.black),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await _crearCuenta();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearCuenta() async {
    final AppLocalizations local = AppLocalizations.of(context)!;
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final sesion = Provider.of<SesionProvider>(context, listen: false);

    setState(() {
      _errorName = _conName.text.isEmpty ? local.error_name : null;
      _errorSurname = _conSurname.text.isEmpty ? local.error_surname : null;
      _errorUsername = _conUsername.text.isEmpty ? local.error_username : null;
      _errorPassword = _conPassword.text.isEmpty ? local.error_pass : null;
      _errorEmail = _conEmail.text.isEmpty ? local.error_email : null;
    });

    if (_errorName != null || _errorSurname != null || _errorUsername != null || _errorPassword != null || _errorEmail != null) {
      return;
    }

    if (_isUsernameTaken(_conUsername.text)) {
      setState(() {
        _errorUsername = local.error_username_taken;
      });
      return;
    }

    if (_isEmailTaken(_conEmail.text)) {
      setState(() {
        _errorEmail = local.error_email_taken;
      });
      return;
    }

    Usuario nuevoUsuario = Usuario(
      nombre: _conName.text,
      apellidos: _conSurname.text,
      nombre_usuario: _conUsername.text,
      password: _conPassword.text,
      email: _conEmail.text,
      id: null,
    );

    await dbProvider.addUsuario(nuevoUsuario);

    await dbProvider.cargarUsuarios();

    for (Usuario a in dbProvider.usuarios) {
      if (a.nombre_usuario == _conUsername.text) {
        sesion.login(a);
        break;
      }
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Main()),
          (Route<dynamic> route) => false,
    );
  }
}
