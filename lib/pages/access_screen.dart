import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'successful_access_screen.dart';


class SuccessModel {
  SuccessModel({required this.id, required this.message});

  final String id;
  final String message;

  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    return SuccessModel(
      id: json['id'] as String,
      message: json['message'] as String,
    );
  }
}

class ErrorModel {
  ErrorModel({required this.message, required this.errors});

  final String message;
  final List<String> errors;

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['message'] as String,
      errors: (json['errors'] as List<dynamic>).cast<String>(),
    );
  }
}

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
  String _errorMessage = ''; //
  List<String> _passwordErrors = [];

  // Envia a senha para a API e trata as respostas no console
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

        print("Status da resposta: ${response.statusCode}");
        print("Corpo da resposta: ${response.body}");

        if (response.statusCode == 202) {
          final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
          final success = SuccessModel.fromJson(data);
          print("ID: ${success.id}");
          print("Mensagem: ${success.message}");

          // Navega para a próxima tela
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessfulAccessScreen(
                message: success.message,
                id: success.id,
              ),
            ),
          );
        } else if (response.statusCode == 400) {
          final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
          final error = ErrorModel.fromJson(data);
          print("Erro da API: ${error.message}");
          print("Detalhes: ${error.errors.join(', ')}");

          setState(() {
            _errorMessage = error.message;
            _passwordErrors = error.errors;
          });
        } else {
          print("Erro desconhecido: ${response.statusCode}");
          _showErrorSnackBar('Erro desconhecido. Tente novamente.');
        }
      } catch (e) {
        print("Erro na requisição: $e");
        _showErrorSnackBar('Erro ao conectar à API.');
      }
    }
  }

  void _checkPassword() {
    setState(() {
      _isButtonEnabled = _controller.text.isNotEmpty;
      _passwordErrors = _validatePassword(_controller.text);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    print("Mensagem de erro: $message");
  }

  // Função de validação de senha
  List<String> _validatePassword(String password) {
    final List<String> errors = [];
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add('Deve conter pelo menos uma letra maiúscula.');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errors.add('Deve conter pelo menos uma letra minúscula.');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errors.add('Deve conter pelo menos um número.');
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errors.add('Deve conter pelo menos um caractere especial.');
    }
    if (password.length < 8) {
      errors.add('Deve ter no mínimo 8 caracteres.');
    }
    return errors;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _controller,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    hintText: "Digite sua senha",
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 2, color: Colors.blueAccent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
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
                  onChanged: (value) {
                    _checkPassword();
                  },
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _passwordErrors.map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 16),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _submit : null,
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
