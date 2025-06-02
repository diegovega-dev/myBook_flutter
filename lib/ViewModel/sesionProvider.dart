import 'package:flutter/foundation.dart';
import 'package:proyecto_final/Model/models.dart';

///provider que gestiona el usuario que ha iniciado sesion y esta usando la app
class SesionProvider with ChangeNotifier {
  Usuario? _user;

  get user => _user;

  void login(Usuario u) {
    _user = u;
    notifyListeners();
  }

  void logout(){
    _user = null;
    notifyListeners();
  }
}