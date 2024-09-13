import 'package:flutter/material.dart';

class ProfissionaisProvider extends ChangeNotifier {
  List<dynamic> _profissionais = [];

  List<dynamic> get profissionais => _profissionais;

  void setProfissionais(List<dynamic> profissionais) {
    _profissionais = profissionais;
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }
}
