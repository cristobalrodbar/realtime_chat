import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/helpers/mostrar_alerta.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/services/socket_service.dart';
import 'package:realtime_chat/widgets/blue_button.dart';
import 'package:realtime_chat/widgets/custom_input.dart';

import '../widgets/labels.dart';
import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(mensaje: 'Login'),
                  _Form(),
                  Labels(
                      titulo: '¿No tienes cuenta?',
                      subtitulo: 'Crea una ahora',
                      ruta: 'register'),
                  const Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              icon: Icons.mail_outline,
              placeHolder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(
              icon: Icons.lock_outline,
              placeHolder: 'Password',
              isPassword: true,
              textController: passCtrl),
          Bluebutton(
            text: 'Ingrese',
            onPressed:
                //TODO null
                authService.autenticando
                    ? () => null
                    : () async {
                        //print(emailCtrl.text + ' - ' + passCtrl.text);
                        FocusScope.of(context).unfocus();
                        final loginOk = await authService.login(
                            emailCtrl.text.trim(), passCtrl.text.trim());
                        if (loginOk) {
                          socketService.connect();
                          Navigator.pushReplacementNamed(context, 'usuarios');
                        } else {
                          //TODO mostrar alerta
                          // ignore: use_build_context_synchronously
                          mostrarAlerta(context, 'Login incorrecto',
                              'Revise credenciales');
                        }
                      },
          )
        ],
      ),
    );
  }
}
