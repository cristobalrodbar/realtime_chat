import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/mensajes_response.dart';
import 'package:realtime_chat/services/auth_service.dart';
import '../models/usuario.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId');
    final String? token = await AuthService.getToken();

    final resp = await http.get(uri, headers: {
      'Content-type': 'application/json',
      'x-token': token.toString()
    });

    final mensajesResponse = mensajesResponseFromJson(resp.body);

    return mensajesResponse.mensajes;
  }
}
