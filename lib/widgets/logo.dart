import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String mensaje;

  const Logo({super.key, required this.mensaje});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 170,
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/tag-logo.png'),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            mensaje,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    ));
  }
}
