import 'package:flutter/material.dart';

class SuccessfulAccessScreen extends StatelessWidget {
  const SuccessfulAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Text(
          "Acesso Bem-sucedido!",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  offset: Offset(1.0, 1.0),
                  // color: Colors.black.withOpacity(0.5),
                )
              ]
          ),
        ),
      ),
    );
    // }
  }
}