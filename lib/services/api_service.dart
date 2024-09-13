import 'dart:convert'; // Importa a biblioteca para trabalhar com dados no formato JSON.
import 'dart:io'; // Importa a biblioteca para manipulação de arquivos e I/O.
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // Importa a biblioteca para manipulação de caminhos de arquivos.
import 'package:http_parser/http_parser.dart'; // Importa a biblioteca para definir o tipo de conteúdo (MIME) em requisições HTTP.

class ApiService {
  final String baseUrl =
      'http://localhost:5555/api'; // Define a URL base para as requisições à API.

  // Método para buscar todos os profissionais
  Future<List<dynamic>> getAllProfissionais() async {
    final url = Uri.parse('$baseUrl/profissional');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna a lista de profissionais
    } else {
      throw Exception('Falha ao carregar profissionais');
    }
  }

  // Método para fazer uma requisição POST comum
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(
        '$baseUrl/$endpoint'); // Concatena a URL base com o endpoint fornecido.
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json'
      }, // Define o cabeçalho da requisição como JSON.
      body: jsonEncode(body), // Converte o corpo da requisição para JSON.
    );
  }

  // Método para fazer upload de imagem com tratamento de erros
  Future<http.Response> uploadImage(String endpoint, File imageFile) async {
    try {
      final url = Uri.parse(
          '$baseUrl/$endpoint'); // Concatena a URL base com o endpoint fornecido.

      // Cria uma requisição multipart para enviar a imagem
      final request = http.MultipartRequest('POST', url);

      // Adiciona o arquivo de imagem ao corpo da requisição
      request.files.add(
        http.MultipartFile(
          'imagem', // Nome do campo que o backend espera para receber a imagem.
          imageFile
              .readAsBytes()
              .asStream(), // Lê o arquivo como um stream de bytes.
          imageFile.lengthSync(), // Obtém o tamanho do arquivo.
          filename: basename(imageFile.path), // Usa o nome original do arquivo.
          contentType: MediaType(
            'image', // Define o tipo MIME como 'image'.
            basename(imageFile.path)
                .split('.')
                .last, // Define o subtipo MIME (jpg, png, etc.) baseado na extensão do arquivo.
          ),
        ),
      );

      // Envia a requisição e recebe a resposta como stream
      final streamedResponse = await request.send();

      // Converte a resposta stream para uma resposta http normal
      final response = await http.Response.fromStream(streamedResponse);

      // Se a resposta não for de sucesso (status code 200), lança uma exceção
      if (response.statusCode != 200) {
        print(
            'Erro ao enviar imagem: ${response.statusCode} - ${response.reasonPhrase}');
        print('Resposta do servidor: ${response.body}');
        throw Exception('Erro ao enviar imagem: ${response.statusCode}');
      }

      return response; // Retorna a resposta HTTP em caso de sucesso.
    } catch (e) {
      print(
          'Erro durante o upload da imagem: $e'); // Imprime o erro no console para depuração.
      rethrow; // Lança novamente o erro para que ele possa ser tratado em outro lugar.
    }
  }

  // Método para atualizar o endereço do paciente
  Future<http.Response> updateAddress(
      String pacienteId, Map<String, dynamic> addressData) async {
    final url = Uri.parse('$baseUrl/paciente/$pacienteId/add-endereco');
    // Concatena a URL base com o endpoint específico para atualizar o endereço do paciente.

    return await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json'
      }, // Define o cabeçalho da requisição como JSON.
      body: jsonEncode(
          addressData), // Converte os dados do endereço para JSON antes de enviar.
    );
  }

  Future<List<dynamic>> getConsultasByPaciente(String pacienteId) async {
    final url = Uri.parse('$baseUrl/consulta/paciente/$pacienteId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); // Decodifica o JSON e retorna a lista de consultas
    } else {
      throw Exception('Falha ao carregar consultas');
    }
  }
}
