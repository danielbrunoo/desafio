import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'successful_access_screen.dart'; // Importe a tela de destino

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final password = _controller.text;
      print("Senha digitada: $password");

      try {
        final response = await http.post(
          Uri.parse('https://desafioflutter-api.modelviewlabs.com/validate'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'password': password}),
        );

        // Verifica a resposta da API
        if (response.statusCode == 202) {
          final data = jsonDecode(response.body);
          String; "String";
          print(String);
          print('Data: $data');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessfulAccessScreen(
                message: 'Sucesso',
              ),
            ),
          );
        } else {
          _showErrorSnackBar('Senha incorreta!');
        }
      } catch (e) {
        _showErrorSnackBar('Erro na requisição. Tente novamente.');
      }
    }
  }

  void _checkPassword() {
    setState(() {
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória';
    }
    if (value.length < 8) {
      return 'A senha precisa ter no mínimo 8 caracteres';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'A senha precisa ter pelo menos uma letra maiúscula';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'A senha precisa ter pelo menos uma letra minúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'A senha precisa ter pelo menos um número';
    }
    if (!RegExp(r'[!@#\$&*~.,%]').hasMatch(value)) {
      return 'A senha precisa ter pelo menos um caractere especial';
    }
    return null; // Senha válida
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'MVL Desafio',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(27),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controller,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    hintText: "Digite sua senha",
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.blueAccent),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                  onChanged: (value) {
                    _checkPassword();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null,
                  child: Text("Entrar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
