import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  bool _autenticando = false;
  late Usuario usuario;
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //getter del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};
    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print('authservice: ' + resp.body);

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      //guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};
    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print('authservice: ' + resp.body);

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      //guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    print(token);

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': '$token'});

    print('isLoggedIn: ' + resp.body);
    //autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      //guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logOut();
      return false;
    }

    //final resp = await  http.get(url)
    //return true;
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}
