import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'successful_access_screen.dart'; // Importe a tela de destino

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave para o Form
  bool _isButtonEnabled = false; // Variável para controlar o estado do botão
  String? _passwordError; // Variável para armazenar o erro da senha

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Se a validação passar, processa a senha
      final password = _controller.text;
      print("Senha digitada: $password");

      // Aqui, você pode validar a senha (se necessário) antes de navegar para a tela seguinte
      if (password == "senha_correta") {  // Substitua "senha_correta" pela sua lógica de senha
        // Se a senha for válida, navega para a tela de sucesso
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessfulAccessScreen()),
        );
      } else {
        // Caso a senha esteja incorreta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Senha incorreta!')),
        );
      }
    }
  }

  // Função para verificar se a senha é válida (não está vazia)
  void _checkPassword() {
    setState(() {
      _passwordError = _controller.text.isEmpty ? '' : null;
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
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
          child: Form( // Usando Form para validação
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Alterando de TextField para TextFormField
                TextFormField(
                  controller: _controller,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    hintText: "Digite sua senha",
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Senha obrigatória';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _checkPassword(); // Verifica o estado do campo a cada alteração
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Garante que a validação seja realizada durante a digitação
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _passwordError!,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null, // Desabilita o botão se não tiver senha
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
