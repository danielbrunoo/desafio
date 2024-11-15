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
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  String _errorMessage = '';

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
          // Converte o JSON da resposta em Map<String, dynamic>
          final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

          // Transforma o JSON no objeto SuccessModel
          final success = SuccessModel.fromJson(data);

          print("ID: ${success.id}");
          print("Mensagem: ${success.message}");

          // Navega para a próxima tela com a mensagem de sucesso
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessfulAccessScreen(
                message: success.message,
              ),
            ),
          );
        } else if (response.statusCode == 400) {
          // Tratamento do código 400
          final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
          print("Erro da API: ${data['message']}");

          _showErrorSnackBar(data['message'] as String);
        } else {
          // Outros erros
          _showErrorSnackBar('Erro na autenticação. Tente novamente.');
        }
      } catch (e) {
        print("Erro na requisição: $e");
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    print("Mensagem de erro: $message");
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
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    ),
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
                  validator: (value) {
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
                    return null;
                  },
                  onChanged: (value) {
                    _checkPassword();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null,
                  child: const Text("Entrar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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

class SuccessModel {
  SuccessModel({
    required this.id,
    required this.message,
  });

  final String id;
  final String message;

  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    return SuccessModel(
      id: json['id'] as String,
      message: json['message'] as String,
    );
  }
}
