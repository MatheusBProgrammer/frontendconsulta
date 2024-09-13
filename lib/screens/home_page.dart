import 'package:flutter/material.dart';
import 'package:frontendconsulta/context/profissionais-provider.dart';
import 'package:frontendconsulta/context/user-provider.dart';
import 'package:frontendconsulta/screens/nav/consultas_marcadas.dart';
import 'package:frontendconsulta/screens/nav/prontuarios_page.dart';
import 'package:frontendconsulta/screens/nav/agendamentos_page.dart';
import 'package:frontendconsulta/screens/nav/config_page.dart';
import 'package:frontendconsulta/screens/nav/consultorio_page.dart';
import 'package:frontendconsulta/screens/nav/profissionais_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      ProntuariosPage(),
      ConsultasMarcadasPage(),
      AgendamentoPage(),
      ProfissionaisPage(),
      ConsultorioOnlinePage(),
      ConfiguracoesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 24),
            label: 'Prontuários',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank, size: 24),
            label: 'Marcações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 24),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search, size: 24),
            label: 'Profissionais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call, size: 24),
            label: 'Consultório Online',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 24),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
