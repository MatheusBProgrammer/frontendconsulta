import 'package:flutter/material.dart';
import 'package:frontendconsulta/screens/nav/profissionais_page.dart';

class AgendamentoPage extends StatefulWidget {
  final String? medicoId; // Parâmetro opcional
  final String? medicoNome; // Nome do médico selecionado
  final String? pacienteId; // Parâmetro opcional

  const AgendamentoPage(
      {this.medicoId, this.medicoNome, this.pacienteId, Key? key})
      : super(key: key);

  @override
  _AgendamentoPageState createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final _formKey = GlobalKey<FormState>();
  String _descricao = '';
  String _notas = '';
  DateTime? _dataConsulta;

  Future<void> agendarConsulta() async {
    // Função vazia para implementar depois
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consulta'),
        centerTitle: true, // Cor do AppBar usando o tema
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exibe o nome do médico predefinido ou opção para selecionar um médico
              GestureDetector(
                onTap: () {
                  // Navega para a página de profissionais
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfissionaisPage(),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(0.1), // Fundo mais suave
                    borderRadius:
                        BorderRadius.circular(12), // Cantos arredondados
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.medicoNome != null
                              ? 'Médico: ${widget.medicoNome}'
                              : 'Médico não selecionado (clique aqui para selecionar um médico)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Campo de descrição da consulta
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição da Consulta',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
                onSaved: (value) {
                  _descricao = value!;
                },
              ),
              const SizedBox(height: 20),
              // Campo de notas adicionais
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notas Adicionais',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onSaved: (value) {
                  _notas = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              // Seleção de data
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataConsulta == null
                          ? 'Selecione a data'
                          : 'Data selecionada: ${_dataConsulta!.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dataConsulta = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .primaryColor, // Cor do botão usando o tema
                      foregroundColor: Colors.white, // Cor do texto branca
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Escolher Data'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Botão de agendar consulta
              Center(
                child: ElevatedButton(
                  onPressed: agendarConsulta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Cor do botão usando o tema
                    foregroundColor: Colors.white, // Cor do texto branca
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Borda arredondada
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Agendar Consulta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
