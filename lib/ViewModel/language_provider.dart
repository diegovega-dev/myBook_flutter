import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///provider que gestiona el cambio de idioma de la app
class LanguageProvider extends ChangeNotifier {
  Locale locale = const Locale('es'); // Idioma inicial

  Future<void> cambiarIdioma() async {
    locale = (locale.languageCode == 'es') ? const Locale('en') : const Locale('es');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma', locale.languageCode);
    notifyListeners();
  }
}