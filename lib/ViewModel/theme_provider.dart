import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///provider que gestiona el cambio de tema y tamaño de letra
class ThemeProvider extends ChangeNotifier {
  double tamanoLetra = 16.0;
  bool temaOscuro = false;
  double multi = 1.0;

  ///si la variable temaOscuro es true devuelve el tema oscuro, si no el claro
  ThemeData get theme => temaOscuro ? _temaOscuro : _temaClaro;

  ThemeData get _temaClaro => ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: tamanoLetra, color: Colors.black),
          bodyMedium: TextStyle(fontSize: tamanoLetra, color: Colors.black),
          bodySmall: TextStyle(fontSize: tamanoLetra, color: Colors.black),
        ),
      );

  ThemeData get _temaOscuro => ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: tamanoLetra, color: Colors.white),
          bodyMedium: TextStyle(fontSize: tamanoLetra, color: Colors.white),
          bodySmall: TextStyle(fontSize: tamanoLetra, color: Colors.white),
        ),
      );

  Future<void> cambiarTema() async {
    temaOscuro = !temaOscuro;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('oscuro', temaOscuro);
    notifyListeners();
  }

  Future<void> cambiarTexto(double m) async {
    multi = m;
    tamanoLetra = 16 * m;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tamanoLetra', tamanoLetra);
    notifyListeners();
  }
}



