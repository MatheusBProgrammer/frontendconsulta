import 'dart:convert'; // Importa a biblioteca para trabalhar com dados no formato JSON.
import 'dart:io'; // Importa a biblioteca para manipulação de arquivos e I/O.

import 'package:flutter/material.dart'; // Importa a biblioteca principal do Flutter para construir a interface do usuário.
import 'package:frontendconsulta/services/api_service.dart'; // Importa o serviço personalizado que lida com requisições de API.
import 'package:image_picker/image_picker.dart'; // Importa a biblioteca que permite selecionar imagens da galeria ou da câmera.

class CompleteRegistrationPage extends StatefulWidget {
  // Define a página de conclusão do registro como um widget Stateful, pois haverá mudanças de estado.
  const CompleteRegistrationPage({super.key});

  @override
  _CompleteRegistrationPageState createState() =>
      _CompleteRegistrationPageState();
  // Cria e retorna o estado da página, que gerenciará a interface do usuário e a lógica.
}

class _CompleteRegistrationPageState extends State<CompleteRegistrationPage> {
  late String pacienteId; // Variável para armazenar o ID do paciente.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Este método é chamado sempre que as dependências do widget mudam.
    // Aqui, ele é usado para capturar o ID do paciente que foi passado como argumento para a rota.

    final args = ModalRoute.of(context)?.settings.arguments as String;
    // Pega os argumentos da rota e os converte para uma String, que representa o ID do paciente.
    pacienteId = args; // Armazena o ID do paciente na variável `pacienteId`.
  }

  final _formKey = GlobalKey<FormState>();
  // Chave global para identificar o formulário e permitir a validação dos campos.

  // Controladores para capturar o texto inserido nos campos de entrada.
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  File? _imageFile; // Variável para armazenar o arquivo de imagem selecionado.

  final ApiService _apiService =
      ApiService(); // Instância do serviço de API para enviar requisições.
  final ImagePicker _picker =
      ImagePicker(); // Instância do `ImagePicker` para selecionar imagens.

  // Método para permitir que o usuário selecione uma imagem da galeria.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // Aguarda a seleção de uma imagem da galeria e armazena na variável `pickedFile`.

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        // Se um arquivo for selecionado, converte o caminho do arquivo para um objeto `File`.
      });
    }
  }

  // Método para completar o registro do paciente.
  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    // Valida o formulário. Se algum campo não estiver preenchido corretamente, a função é encerrada.

    final addressData = {
      // Cria um mapa com os dados de endereço a partir dos campos de texto.
      'rua': _ruaController.text,
      'numero': _numeroController.text,
      'complemento': _complementoController.text,
      'bairro': _bairroController.text,
      'cidade': _cidadeController.text,
      'estado': _estadoController.text,
      'cep': _cepController.text,
    };

    // Faz a requisição para atualizar o endereço do paciente no servidor.
    final addressResponse = await _apiService.updateAddress(
      pacienteId, // Passa o ID do paciente.
      addressData, // Passa os dados do endereço.
    );

    if (addressResponse.statusCode == 200) {
      // Se a atualização do endereço for bem-sucedida:
      if (_imageFile != null) {
        // Se uma imagem foi selecionada, faz o upload da imagem.
        final imageUploadResponse = await _apiService.uploadImage(
          'paciente/$pacienteId/add-foto', // Endpoint para adicionar a foto.
          _imageFile!, // A imagem selecionada.
        );

        if (imageUploadResponse.statusCode == 200) {
          // Se o upload da imagem for bem-sucedido:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro completo com sucesso!')),
          );
          Navigator.pushReplacementNamed(context, '/home',
              arguments: pacienteId); // Navega para a página inicial.
        } else {
          // Se houver um erro no upload da imagem:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao enviar imagem de perfil')),
          );
        }
      } else {
        // Se nenhuma imagem foi selecionada:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registro completo com sucesso, sem imagem!')),
        );
        Navigator.pushReplacementNamed(context, '/home',
            arguments: pacienteId); // Navega para a página inicial.
      }
    } else {
      // Se houver um erro na atualização do endereço:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar endereço')),
      );
    }
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
                  'Completar Registro',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10), // Espaçamento entre os elementos.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Preencha os dados restantes',
                style: TextStyle(color: Colors.white, fontSize: 12),
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
                          controller: _ruaController,
                          label: 'Rua',
                        ),
                        _buildTextField(
                          controller: _numeroController,
                          label: 'Número',
                        ),
                        _buildTextField(
                          controller: _complementoController,
                          label: 'Complemento',
                        ),
                        _buildTextField(
                          controller: _bairroController,
                          label: 'Bairro',
                        ),
                        _buildTextField(
                          controller: _cidadeController,
                          label: 'Cidade',
                        ),
                        _buildTextField(
                          controller: _estadoController,
                          label: 'Estado',
                        ),
                        _buildTextField(
                          controller: _cepController,
                          label: 'CEP',
                        ),
                        const SizedBox(
                            height:
                                10), // Espaçamento entre os campos e o botão.
                        // Se uma imagem foi selecionada, mostra a imagem. Caso contrário, mostra o botão para selecionar a imagem.
                        _imageFile != null
                            ? Image.file(_imageFile!)
                            : ElevatedButton(
                                onPressed:
                                    _pickImage, // Ação para selecionar a imagem.
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
                                  'Selecionar Imagem de Perfil',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                        const SizedBox(
                            height:
                                20), // Espaçamento antes do botão de completar registro.
                        ElevatedButton(
                          onPressed:
                              _completeRegistration, // Ação para completar o registro.
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
                            'Completar Registro',
                            style: TextStyle(fontSize: 18),
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
          if (value == null || value.isEmpty) {
            return 'Por favor, insira este campo'; // Mensagem de erro se o campo estiver vazio.
          }
          return null; // Se estiver preenchido corretamente, não há erro.
        },
      ),
    );
  }
}
