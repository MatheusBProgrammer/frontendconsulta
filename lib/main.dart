import 'package:flutter/material.dart';
import 'package:frontendconsulta/context/user-provider.dart';
import 'package:frontendconsulta/context/profissionais-provider.dart'; // Importa o ProfissionaisProvider
import 'package:frontendconsulta/screens/auth/auth_page.dart';
import 'package:frontendconsulta/screens/auth/complete_registration_page.dart';
import 'package:frontendconsulta/screens/auth/register_page.dart';
import 'package:frontendconsulta/screens/auth/splash_screen.dart';
import 'package:frontendconsulta/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(
          create: (_) =>
              ProfissionaisProvider()), // Adiciona o ProfissionaisProvider
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta App',
      theme: ThemeData(
        primaryColor: Colors.blue, // Define apenas a cor primária
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthPage(),
        '/register': (context) => const RegisterPage(),
        '/completeRegistration': (context) => const CompleteRegistrationPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
