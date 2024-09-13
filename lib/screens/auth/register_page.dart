import 'dart:convert'; // Importa a biblioteca para trabalhar com dados no formato JSON.

import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para construir a interface do usuário.
import 'package:frontendconsulta/services/api_service.dart'; // Importa o serviço personalizado que lida com requisições de API.

class RegisterPage extends StatefulWidget {
  // Define a página de registro como um widget Stateful, pois haverá mudanças de estado.
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
  // Cria e retorna o estado da página, que gerenciará a interface do usuário e a lógica.
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // Chave global para identificar o formulário e permitir a validação dos campos.

  // Controladores para capturar o texto inserido nos campos de entrada.
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  final ApiService _apiService =
      ApiService(); // Instância do serviço de API para enviar requisições.

  // Método para registrar o paciente, enviando os dados para o servidor.
  Future<void> _registerPaciente() async {
    // Faz a requisição para registrar o paciente no servidor.
    final response = await _apiService.post('paciente/register', {
      'nome': _nomeController.text, // Nome capturado do campo de texto.
      'telefone':
          _telefoneController.text, // Telefone capturado do campo de texto.
      'email': _emailController.text, // Email capturado do campo de texto.
      'senha': _senhaController.text, // Senha capturada do campo de texto.
    });

    // Verifica se o registro foi bem-sucedido.
    if (response.statusCode == 201) {
      final responseData =
          jsonDecode(response.body); // Decodifica a resposta JSON.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente registrado com sucesso!')),
      );

      Navigator.pushReplacementNamed(
        context,
        '/completeRegistration', // Navega para a página de completar o registro.
        arguments: responseData['id'], // Passa o ID do paciente como argumento.
      );
    } else {
      // Se o registro falhar, exibe uma mensagem de erro.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar paciente: ${response.body}')),
      );
    }
  }

  @override
  void dispose() {
    // Método chamado quando o widget é destruído para limpar os controladores.
    _nomeController.dispose(); // Libera o controlador do nome.
    _telefoneController.dispose(); // Libera o controlador do telefone.
    _emailController.dispose(); // Libera o controlador do email.
    _senhaController.dispose(); // Libera o controlador da senha.
    _confirmarSenhaController
        .dispose(); // Libera o controlador da confirmação da senha.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constrói a interface do usuário.
    return Scaffold(
      body: Container(
        width: double
            .infinity, // Define a largura do container para ocupar a largura total da tela.
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
            const SizedBox(
                height: 40), // Espaçamento na parte superior da tela.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cadastrar-se',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaçamento entre os elementos.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Preencha os dados abaixo',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
                height: 20), // Espaçamento antes de iniciar o formulário.
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  // Adiciona rolagem para o conteúdo da página, caso seja necessário.
                  child: Form(
                    key:
                        _formKey, // Associa o formulário à chave global para validação.
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Cada um desses métodos cria um campo de entrada de texto.
                        _buildTextField(
                          controller: _nomeController,
                          label: 'Nome',
                        ),
                        _buildTextField(
                          controller: _telefoneController,
                          label: 'Telefone',
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                        ),
                        _buildTextField(
                          controller: _senhaController,
                          label: 'Senha',
                          obscureText:
                              true, // Define se o texto deve ser obscurecido (usado para senhas).
                        ),
                        _buildTextField(
                          controller: _confirmarSenhaController,
                          label: 'Confirme a senha',
                          obscureText:
                              true, // Define se o texto deve ser obscurecido (usado para senhas).
                        ),
                        const SizedBox(
                            height:
                                10), // Espaçamento entre os campos e o botão.
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerPaciente(); // Chama a função para registrar o paciente.
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
                            'Registrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
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

  // Método para criar um campo de entrada de texto reutilizável.
  Widget _buildTextField({
    required TextEditingController
        controller, // Controlador para capturar o texto inserido.
    required String label, // Rótulo do campo.
    bool obscureText =
        false, // Define se o texto deve ser obscurecido (usado para senhas).
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller, // Associa o campo de texto ao controlador.
        obscureText:
            obscureText, // Define se o texto será oculto (para campos de senha).
        decoration: InputDecoration(
          labelText: label, // Define o rótulo do campo.
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        // Função de validação para garantir que o campo não esteja vazio.
        validator: (value) {
          if (label == "Confirme a senha") {
            if (value == null || value.isEmpty) {
              return 'Por favor, confirme sua senha'; // Mensagem de erro se o campo estiver vazio.
            }
            if (value != _senhaController.text) {
              return 'As senhas não coincidem'; // Mensagem de erro se as senhas não coincidirem.
            }
          } else {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira este campo corretamente'; // Mensagem de erro se o campo estiver vazio.
            }
          }
          return null; // Se estiver preenchido corretamente, não há erro.
        },
      ),
    );
  }
}
