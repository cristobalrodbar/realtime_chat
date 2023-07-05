import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat/helpers/mostrar_alerta.dart';
import 'package:realtime_chat/services/auth_service.dart';
import 'package:realtime_chat/widgets/blue_button.dart';
import 'package:realtime_chat/widgets/custom_input.dart';

import '../widgets/labels.dart';
import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
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
                  Logo(mensaje: 'Registro'),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    subtitulo: 'Ingresa ahora',
                    titulo: '¿Ya tienes cuenta?',
                  ),
                  const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
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
  final nameCtrl = TextEditingController();

  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              icon: Icons.perm_identity,
              placeHolder: 'Nombre',
              keyboardType: TextInputType.text,
              textController: nameCtrl),
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
              text: 'Crear cuenta',
              onPressed: authService.autenticando
                  ? () => null
                  : () async {
                      print(nameCtrl.text);
                      print(emailCtrl.text);
                      print(passCtrl.text);
                      print('onpressed');
                      final registroOk = await authService.register(
                          nameCtrl.text.trim(),
                          emailCtrl.text.trim(),
                          passCtrl.text.trim());

                      if (registroOk == true) {
                        //TODO conectar a socket server
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(
                            context, 'Registro incorrecto', registroOk);
                      }
                    })
        ],
      ),
    );
  }
}
