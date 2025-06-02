import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/View/login.dart';
import 'package:proyecto_final/View/perfil_ajustes.dart';
import 'package:proyecto_final/widgets.dart';
import 'package:proyecto_final/ViewModel/db_provider.dart';
import 'package:proyecto_final/ViewModel/language_provider.dart';
import 'package:proyecto_final/ViewModel/sesionProvider.dart';
import 'package:proyecto_final/ViewModel/theme_provider.dart';
import 'package:proyecto_final/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

import 'View/pantallas.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  ///se crean una variable con las preferencias guardadas
  final prefs = await SharedPreferences.getInstance();

  final themeProvider = ThemeProvider();
  themeProvider.temaOscuro = prefs.getBool('oscuro') ?? false;
  themeProvider.tamanoLetra = prefs.getDouble('tamanoLetra') ?? 16;
  themeProvider.multi = themeProvider.tamanoLetra / 16.0;

  final languageProvider = LanguageProvider();
  languageProvider.locale = Locale(prefs.getString('idioma') ?? 'es');

  ///si la plataforma no es movil le pone un tamaño y posición específicos
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowFrame(const Rect.fromLTWH(700, 100, 430, 826));
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  ///Se usa un multiprovider para acceder a todos los que necesitamos
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => languageProvider),
      ChangeNotifierProvider(create: (context) => themeProvider),
      ChangeNotifierProvider(create: (context) => SesionProvider()),
      ChangeNotifierProvider(create: (context) => DatabaseProvider())
    ],
    child: const MainApp()));
}

///esta clase es donde se especifica la configuracion del idioma y del tema que se va a usar
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: true);

      return MaterialApp(
            supportedLocales: const [
            Locale('en'),
            Locale('es'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: themeProvider.theme, 
            locale: languageProvider.locale,
            home: const BotonesInicio()
      );
    }
}

///clase que contiene la pantalla con los botones de iniciar sesion o crear cuenta
class BotonesInicio extends StatelessWidget{
  const BotonesInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center( child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Contenedor(hint: local.h_btn_iniciarSesion, label: local.lb_btn_iniciarSesion, margen: 10,
            a: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login())), 
              child: Text(local.txt_btn_iniciarSesion))
          ),
          Contenedor(hint: local.h_btn_crearCuenta, label: local.lb_btn_crearCuenta, margen: 10,
            a: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccount())), 
              child: Text(local.txt_btn_crearCuenta))
          ),
        ],
      ))
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() => _Main();
}

///clase padre de toda la aplicación real, de donde cuelga todo
class _Main extends State<Main> {
  int n = 1;
  List<Widget> pantallas = [
    const CrearLibro(),
    const Inicio(),
    const Buscar()
  ];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations local = AppLocalizations.of(context)!;

    List<String> titulos = [
      local.crearLibro,
      local.inicio,
      local.buscar
    ];

    return Scaffold(
      drawer: Drawer(
          child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Row(
                      children: [
                        Icon(Icons.menu, color: Colors.white, size: 40),
                        SizedBox(width: 10),
                        Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24))]),
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(local.perfil),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(local.ajustes),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
                  },
                ),

                const Spacer(),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("version 1.0.0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                )])
      ),
      appBar: AppBar(centerTitle: true, title: Text(titulos[n])),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: n,
        onTap: (index) {
          setState(() {
            n = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.playlist_add_rounded),
            label: local.crearLibro,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: local.inicio,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: local.buscar,
          ),
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children:[pantallas[n]]),
    );
  }
}
