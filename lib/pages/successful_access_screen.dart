// import 'package:flutter/material.dart';
//
// class SuccessfulAccessScreen extends StatelessWidget {
//   const SuccessfulAccessScreen({super.key, required this.message});
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.greenAccent,
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Password is valid',
//             style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 shadows: <Shadow>[
//                   Shadow(
//                     blurRadius: 10,
//                     offset: Offset(1.0, 1.0),
//                     // color: Colors.black.withOpacity(0.5),
//                   )
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
// class SuccessModel {
//   SuccessModel({
//     required this.id,
//     required this.message,
//   });
//
//   final String id;
//   final String message;
//
//   factory SuccessModel.fromJson(Map<String, dynamic> json) {
//     return SuccessModel(
//       id: json['id'] as String,
//       message: json['message'] as String,
//     );
//   }
// }

import 'package:flutter/material.dart';

class SuccessfulAccessScreen extends StatelessWidget {
  final String message;

  const SuccessfulAccessScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Acesso Concedido',),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
