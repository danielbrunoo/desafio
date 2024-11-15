import 'dart:ffi';

import 'package:flutter/material.dart';

class SuccessfulAccessScreen extends StatelessWidget {
  const SuccessfulAccessScreen({super.key, required this.message});
  final String message;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Password is valid',
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    blurRadius: 10,
                    offset: Offset(1.0, 1.0),
                    // color: Colors.black.withOpacity(0.5),
                  )
                ]),
          ),
        ),
      ),
    );
  }

}

class SuccessModel {
  SuccessModel({
    required this.id,
    required this.message,
  });

  String id;
  String message;


}
