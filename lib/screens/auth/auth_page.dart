import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontendconsulta/context/user-provider.dart';
import 'package:frontendconsulta/services/api_service.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Obtém a instância do UserProvider
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _login() async {
    try {
      final response = await _apiService.post('paciente/login', {
        'email': _emailController.text,
        'senha': _senhaController.text,
      });

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final responseData = jsonDecode(response.body);

        // Acessa o token e o ID do paciente
        final String token = responseData['token'];
        final String pacienteId = responseData['paciente']['id'];

        // Exibe uma mensagem de sucesso com o nome do paciente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login realizado com sucesso! ID: $pacienteId')),
        );

        // Aqui, você pode armazenar o token em algum lugar seguro, como o SecureStorage, se necessário.
        // Navega para a página inicial passando o ID do paciente como argumento
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // Chama o método setUser no UserProvider
        userProvider.setUser(token, pacienteId);
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: pacienteId,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao realizar login: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.green.shade900,
              Colors.green.shade700,
              Colors.green.shade500,
              Colors.green.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Digite suas credenciais',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 50),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                        ),
                        _buildTextField(
                          controller: _senhaController,
                          label: 'Senha',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade300,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            'Não tem uma conta? Cadastre-se',
                            style: TextStyle(
                              color: Colors.green.shade900,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira este campo corretamente';
          }
          return null;
        },
      ),
    );
  }
}
