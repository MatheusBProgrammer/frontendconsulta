import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String _pacienteId = "";

  String get id => _pacienteId;

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> setUser(String PacienteToken, String PacienteId) async {
    _pacienteId = PacienteId;
    await _storage.write(key: 'token', value: PacienteToken);
    notifyListeners();
  }

  Future<void> clearUser() async {
    _pacienteId = '';
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
