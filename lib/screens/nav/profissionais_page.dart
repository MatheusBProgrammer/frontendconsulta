import 'package:flutter/material.dart';
import 'package:frontendconsulta/context/profissionais-provider.dart';
import 'package:frontendconsulta/context/user-provider.dart';
import 'package:frontendconsulta/screens/nav/agendamentos_page.dart';
import 'package:provider/provider.dart';
import 'package:frontendconsulta/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfissionaisPage extends StatefulWidget {
  const ProfissionaisPage({super.key});

  @override
  _ProfissionaisPageState createState() => _ProfissionaisPageState();
}

class _ProfissionaisPageState extends State<ProfissionaisPage> {
  // Lista de profissionais filtrados com base no tipo, especialidade e nome selecionados
  List<dynamic> _filteredProfissionais = [];

  // Lista completa de profissionais recebidos da API
  List<dynamic> _allProfissionais = [];

  // Lista de tipos de profissionais disponíveis para o dropdown
  List<String> _tiposProfissionais = [];

  // Lista de especialidades dos profissionais disponíveis para o dropdown
  List<String> _especialidades = [];

  // Tipo de profissional selecionado no dropdown
  String? _selectedTipoProfissional;

  // Especialidade selecionada no dropdown secundário
  String? _selectedEspecialidade;

  // Nome pesquisado no campo de texto
  String _searchQuery = '';

  // Variável para controlar o estado de carregamento (se os dados estão sendo carregados)
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega os dados quando as dependências mudam, normalmente usado para inicializar dados na tela
    _loadData();
  }

  // Função que carrega os dados dos profissionais usando um provider
  Future<void> _loadData() async {
    final provider = Provider.of<ProfissionaisProvider>(context, listen: false);

    // Verifica se a lista de profissionais no provider está vazia
    if (provider.profissionais.isEmpty) {
      try {
        // Faz uma requisição para a API para obter todos os profissionais
        final profissionais = await ApiService().getAllProfissionais();

        // Armazena os profissionais no provider para reutilização
        provider.setProfissionais(profissionais);

        setState(() {
          // Atualiza as listas internas com os dados recebidos
          _allProfissionais = profissionais;
          _filteredProfissionais = profissionais;
          _tiposProfissionais = _getTiposProfissionais(profissionais);
          _isLoading = false; // Define que o carregamento foi concluído
        });
      } catch (error) {
        setState(() {
          _isLoading =
              false; // Define que o carregamento foi concluído, mesmo em caso de erro
        });
        print('Erro ao carregar profissionais: $error');
      }
    } else {
      setState(() {
        // Caso os profissionais já estejam carregados no provider, apenas os utiliza
        _allProfissionais = provider.profissionais;
        _filteredProfissionais = provider.profissionais;
        _tiposProfissionais = _getTiposProfissionais(provider.profissionais);
        _isLoading = false; // Define que o carregamento foi concluído
      });
    }
  }

  // Função que força a atualização dos dados através de uma nova requisição ao servidor
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Define que o carregamento foi iniciado
    });

    // Faz uma nova requisição para obter os profissionais atualizados
    final profissionais = await ApiService().getAllProfissionais();

    setState(() {
      // Atualiza as listas internas e redefine as seleções e busca
      _allProfissionais = profissionais;
      _filteredProfissionais = profissionais;
      _tiposProfissionais = _getTiposProfissionais(profissionais);
      _selectedTipoProfissional =
          null; // Reseta a seleção de tipo de profissional
      _selectedEspecialidade = null; // Reseta a seleção de especialidade
      _searchQuery = ''; // Reseta o campo de busca
      _isLoading = false; // Define que o carregamento foi concluído
    });
  }

  // Função que obtém os tipos de profissionais únicos da lista de profissionais
  List<String> _getTiposProfissionais(List<dynamic> profissionais) {
    final tipos = profissionais
        .map<String>((profissional) {
          // Mapeia os profissionais para o campo 'tipoProfissional'
          return profissional['tipoProfissional'] as String? ?? '';
        })
        .where(
            (tipo) => tipo.isNotEmpty) // Filtra os tipos que não estão vazios
        .toSet() // Remove duplicatas
        .toList();
    return tipos;
  }

  // Função que obtém as especialidades disponíveis com base no tipo de profissional selecionado
  List<String> _getEspecialidades(List<dynamic> profissionais, String tipo) {
    final especialidades = profissionais
        .where((profissional) => profissional['tipoProfissional'] == tipo)
        .map<String>((profissional) {
          // Mapeia os profissionais para o campo 'especialidade'
          return profissional['especialidade'] as String? ?? '';
        })
        .where((especialidade) => especialidade
            .isNotEmpty) // Filtra especialidades que não estão vazias
        .toSet() // Remove duplicatas
        .toList();
    return especialidades;
  }

  // Função que filtra a lista de profissionais com base nos critérios de tipo, especialidade e nome
  void _filterProfissionais() {
    setState(() {
      _filteredProfissionais = _allProfissionais.where((profissional) {
        final matchesTipo = _selectedTipoProfissional == null ||
            _selectedTipoProfissional!.isEmpty ||
            profissional['tipoProfissional'] == _selectedTipoProfissional;

        final matchesEspecialidade = _selectedEspecialidade == null ||
            _selectedEspecialidade!.isEmpty ||
            profissional['especialidade'] == _selectedEspecialidade;

        final matchesNome = _searchQuery.isEmpty ||
            (profissional['nome'] != null &&
                profissional['nome']!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()));

        return matchesTipo && matchesEspecialidade && matchesNome;
      }).toList();
    });
  }

  void _showProfessionalDetails(BuildContext context, dynamic profissional) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite controle total do tamanho
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85, // 80% da altura da tela
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profissional['perfilImagem'] != null
                          ? NetworkImage(profissional['perfilImagem'])
                          : null,
                      child: profissional['perfilImagem'] == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      profissional['nome'] ?? 'Sem nome',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      profissional['especialidade'] ?? 'Sem especialidade',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    'Instituição de Ensino:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profissional['instituicaoEnsino'] ?? 'Não informado',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Endereço:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${profissional['endereco']['rua']}, ${profissional['endereco']['numero']}, ${profissional['endereco']['complemento']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${profissional['endereco']['bairro']}, ${profissional['endereco']['cidade']}-${profissional['endereco']['estado']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final whatsappUrl = Uri.parse(
                            'https://wa.me/${profissional['telefone']}');
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Não foi possível abrir o WhatsApp'),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.message, color: Colors.white),
                      label: Text('Falar no WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final provider =
                            Provider.of<UserProvider>(context, listen: false);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgendamentoPage(
                              medicoId: profissional['_id'],
                              medicoNome: profissional["nome"],
                              pacienteId: provider
                                  .id, // Substitua pelo ID do paciente autenticado
                            ),
                          ),
                        );
                      },
                      child: Text('Agendar Consulta'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Ajusta a altura da toolbar com base na presença de especialidades ou consulta
        toolbarHeight:
            (_especialidades.isNotEmpty || _searchQuery.isNotEmpty) ? 160 : 80,
        title: _tiposProfissionais.isEmpty
            ? Container() // Se a lista de tipos estiver vazia, não exibe o dropdown
            : Column(
                children: [
                  // Dropdown para selecionar o tipo de profissional
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Selecione o tipo de profissional'),
                      value: _selectedTipoProfissional,
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded: true,
                      underline: Container(),
                      items: _tiposProfissionais
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTipoProfissional = newValue;
                          _selectedEspecialidade =
                              null; // Reseta a especialidade selecionada
                          _searchQuery = ''; // Reseta a barra de pesquisa
                          if (newValue != null) {
                            _especialidades =
                                _getEspecialidades(_allProfissionais, newValue);
                          } else {
                            _especialidades = [];
                          }
                          _filterProfissionais(); // Filtra a lista de profissionais
                        });
                      },
                    ),
                  ),
                  // Dropdown para selecionar a especialidade, visível apenas se houver especialidades
                  if (_especialidades.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          hint: const Text('Selecione a especialidade'),
                          value: _selectedEspecialidade,
                          icon: const Icon(Icons.arrow_downward),
                          isExpanded: true,
                          underline: Container(),
                          items: _especialidades
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEspecialidade = newValue;
                              _filterProfissionais(); // Filtra a lista de profissionais
                            });
                          },
                        ),
                      ),
                    ),
                  // Campo de pesquisa, visível apenas se houver especialidades ou consulta
                  if (_especialidades.isNotEmpty || _searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Digite o nome do profissional',
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _filterProfissionais(); // Filtra a lista de profissionais
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
      ),
      // Corpo da página, mostra um indicador de carregamento ou a lista de profissionais filtrados
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh:
                  _refreshData, // Atualiza os dados ao puxar a tela para baixo
              child: _filteredProfissionais.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredProfissionais.length,
                      itemBuilder: (context, index) {
                        final profissional = _filteredProfissionais[index];
                        return ListTile(
                          leading: profissional['perfilImagem'] != null &&
                                  profissional['perfilImagem'].isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      profissional['perfilImagem']),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                          title: Text(profissional['nome'] ?? 'Sem nome'),
                          subtitle: Text(profissional['especialidade'] ??
                              'Sem especialidade'),
                          onTap: () =>
                              _showProfessionalDetails(context, profissional),
                        );
                      },
                    )
                  : const Center(child: Text('Nenhum profissional encontrado')),
            ),
    );
  }
}
