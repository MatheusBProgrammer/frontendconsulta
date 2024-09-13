import 'package:flutter/material.dart';
import 'package:frontendconsulta/context/user-provider.dart';
import 'package:frontendconsulta/services/api_service.dart';
import 'package:provider/provider.dart';

class ConsultasMarcadasPage extends StatefulWidget {
  @override
  _ConsultasMarcadasPageState createState() => _ConsultasMarcadasPageState();
}

class _ConsultasMarcadasPageState extends State<ConsultasMarcadasPage> {
  late Future<List<dynamic>> _consultasFuture;

  @override
  void initState() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final pacienteId = provider.id;
    super.initState();
    // Inicializa o futuro para buscar as consultas quando a página for carregada
    _consultasFuture = ApiService().getConsultasByPaciente(pacienteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas Marcadas'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _consultasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar consultas: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma consulta marcada.'));
          } else {
            // Lista de consultas marcadas
            final consultas = snapshot.data!;
            return ListView.builder(
              itemCount: consultas.length,
              itemBuilder: (context, index) {
                final consulta = consultas[index];
                final dataConsulta = DateTime.parse(consulta['data']).toLocal();

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text('Consulta: ${consulta['descricao']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data: ${dataConsulta.toString().split(' ')[0]}'),
                        Text('Notas: ${consulta['notas'] ?? 'Sem notas'}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Adicione a navegação para mais detalhes da consulta, se necessário
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
