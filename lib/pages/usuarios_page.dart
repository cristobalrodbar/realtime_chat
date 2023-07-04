import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuarios = [
    Usuario(email: 'tomy@gmail.com', nombre: 'Toms', online: false, uid: '1'),
    Usuario(
        email: 'ferherrera@gmail.com', nombre: 'Fer', online: true, uid: '2'),
    Usuario(email: 'chalino@gmail.com', nombre: 'Cha', online: true, uid: '3')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                /* child: Icon(
                Icons.check_circle,
                color: Colors.blue[400],
              ), */
                child: const Icon(Icons.offline_bolt, color: Colors.red),
              )
            ],
            title: Text('Mi Nombre', style: TextStyle(color: Colors.black87)),
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {},
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
    );
  }

  _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
