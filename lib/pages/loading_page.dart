import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/pages/login_page.dart';
import 'package:realtime_chat/pages/usuarios_page.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(child: Text('Espere...'));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      socketService.connect();
      //Navigator.pushReplacementNamed(context, 'usuarios');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuariosPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    } else {
      //Navigator.pushReplacementNamed(context, 'login');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
