
import 'package:flutter/material.dart';

class SuccessfulAccessScreen extends StatelessWidget {
  final String message;

  const SuccessfulAccessScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sucesso'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            message,
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
      ),
    );
  }
}
