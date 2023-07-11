import 'package:flutter/material.dart';

class Bluebutton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const Bluebutton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 2,
          shape: const StadiumBorder()),
      onPressed: () {
        onPressed();
      },
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
