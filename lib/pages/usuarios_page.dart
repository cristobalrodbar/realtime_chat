import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/chat_service.dart';
import 'package:realtime_chat/services/usuarios_service.dart';

import '../services/chat_service.dart';
import '../services/socket_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsuarioService();
  List<Usuario> usuarios = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.usuario;
    return Scaffold(
        appBar: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: (socketService.serverStatus == ServerStatus.Online)
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.blue[400],
                      )
                    : Icon(Icons.offline_bolt, color: Colors.red),
                /* child: Icon(
                  Icons.check_circle,
                  color: Colors.blue[400],
                ), */
                //child: const Icon(Icons.offline_bolt, color: Colors.red),
              )
            ],
            title:
                Text(usuario.nombre, style: TextStyle(color: Colors.black87)),
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  socketService.disconnect();
                  Navigator.pushReplacementNamed(context, 'login');
                  AuthService.deleteToken();
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.black87))),
        body: SmartRefresher(
          onRefresh: _cargarUsuarios,
          enablePullDown: true,
          controller: _refreshController,
          header: WaterDropHeader(
              complete: Icon(
                Icons.check,
                color: Colors.blue[400],
              ),
              waterDropColor: Colors.blue),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(usuario.nombre.substring(0, 2))),
      trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: usuario.online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100))),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');

        //print(usuario.nombre + usuario.email);
      },
    );
  }

  _cargarUsuarios() async {
    // monitor network fetch
    usuarios = await usuarioService.getUsuarios();
    setState(() {});

    //await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
