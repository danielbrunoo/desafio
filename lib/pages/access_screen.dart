import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'successful_access_screen.dart'; // Importe a tela de sucesso

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  String _errorMessage = '';

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String password = _controller.text;
      print('Senha digitada: $password');

      try {
        final http.Response response = await http.post(
          Uri.parse('https://desafioflutter-api.modelviewlabs.com/validate'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{'password': password}),
        );

        print('Status da resposta: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');

        if (response.statusCode == 202) {
          final data = jsonDecode(response.body);
          print('Dados da resposta: $data');

          if (data['message'] != null) {
            print('Senha válida! Acesso bem sucedido.');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SuccessfulAccessScreen(
                  message: '',
                ),
              ),
            );
          } else {
            print("Resposta da API não contém 'message'.");
            _showErrorSnackBar('Erro na autenticação. Tente novamente.');
          }
        } else {
          print('Resposta da API com erro: ${response.statusCode}');
          _showErrorSnackBar('Erro na autenticação. Tente novamente.');
        }
      } catch (e) {
        print('Erro na requisição: $e');
        _showErrorSnackBar('Erro na autenticação. Tente novamente.');
      }
    }
  }

  void _checkPassword() {
    setState(() {
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  void _showErrorSnackBar(String message) {
    setState(() {
      _errorMessage = message;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    print('Mensagem de erro: $message');
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
              children: <Widget>[
                TextFormField(
                  controller: _controller,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.blueAccent),
                    ),
                    enabledBorder: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.lock),
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Senha obrigatória';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    _checkPassword();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Entrar"),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
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
