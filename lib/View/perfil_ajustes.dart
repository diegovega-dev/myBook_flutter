import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/ViewModel/db_provider.dart';
import 'package:proyecto_final/ViewModel/sesionProvider.dart';
import 'package:proyecto_final/main.dart';
import '../ViewModel/language_provider.dart';
import '../ViewModel/theme_provider.dart';
import '../l10n/flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets.dart';

///clase de la pantalla de ajustes
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);

    final bool esPantallaGrande = MediaQuery.of(context).size.width > 600;
    final int columnas = esPantallaGrande ? 3 : 1;

    ///map que un el titulo que quiero pasarle al card con el widget
    final List<Map<String, dynamic>> settings = [
      {
        "titulo": local.lb_darkTheme,
        "widget": Switch(
          value: themeProvider.temaOscuro,
          onChanged: (value) => themeProvider.cambiarTema(),
        ),
      },
      {
        "titulo": local.lb_language,
        "widget": DropdownButton<String>(
          value: languageProvider.locale.languageCode == 'es' ? "Español" : "English",
          items: const [
            DropdownMenuItem(value: "Español", child: Text("Español")),
            DropdownMenuItem(value: "English", child: Text("English"))
          ],
          onChanged: (value) => languageProvider.cambiarIdioma(),
        ),
      },
      {
        "titulo": local.lb_textSize,
        "widget": Slider(
          min: 0.8,
          max: 2.0,
          divisions: 6,
          value: themeProvider.multi,
          onChanged: (value) => themeProvider.cambiarTexto(value),
        ),
      }
    ];

    ///depende del tamaño de pantalla devuelve un listview o un gridview
    return Scaffold(
      appBar: AppBar(title: Text(local.ajustes), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: esPantallaGrande
            ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnas,
                crossAxisSpacing: 20,
                mainAxisSpacing: 15,
                childAspectRatio: 1.8,
              ),
              itemCount: settings.length,
              itemBuilder: (context, index) => SettingsCard(
                titulo: settings[index]["titulo"],
                child: settings[index]["widget"],
              ),
            )
            : ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SettingsCard(
                  titulo: settings[index]["titulo"],
                  child: settings[index]["widget"],
                ),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _Profile();
}

///clase de la pantalla de perfil
class _Profile extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;
    final SesionProvider sesion = Provider.of<SesionProvider>(context);
    final DatabaseProvider dbProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.perfil),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(local.logout),
                  content: Text(local.confirmacionLogout),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(local.cancelar),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          sesion.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainApp()),
                                (Route<dynamic> route) => false,
                          );
                        });
                      },
                      child: Text(local.logout),
                    ),
                  ],
                );
              },
            );
          },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.cambiarPass),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: local.passActual,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return local.errorCampoVacio;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: local.nuevaPass,
                  border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return local.errorCampoVacio;
                }
                return null;
              },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: local.confirmarPass,
                  border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return local.errorCampoVacio;
                }
                if (value != _newPasswordController.text) {
                  return local.errorPassDistintas;
                }
                return null;
                },
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sesion.user.password = _newPasswordController.text;
                    dbProvider.actualizarUser(sesion.user);
                    Navigator.pop(context);
                  }
                },
                child: Text(local.cambiarPass),
              )
            ])),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(local.borrarCuenta),
                    content: Text(local.confirmacionBorrarCuenta),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(local.cancelar),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          dbProvider.removeUsuario(sesion.user);
                          sesion.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainApp()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(local.borrarCuenta),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red),
            child: Text(local.borrarCuenta))])))
    );
  }
}