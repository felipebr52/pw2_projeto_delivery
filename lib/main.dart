import 'package:flutter/material.dart';
import 'package:proj_pw2/cardapio.dart';

void main() {
  runApp(const GamesJaApp());
}

class GamesJaApp extends StatelessWidget {
  const GamesJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Games Já!',
      theme: ThemeData(
        fontFamily: 'Inter', // A fonte base que definimos
        brightness: Brightness.dark, // Força o tema escuro
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O fundo roxo escuro do app (Ajuste o Hexadecimal para o exato do seu Figma)
      backgroundColor: const Color(0xFF6B227B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Área da sua Logo do Krita
              const SizedBox(
                height: 140,
                child: Center(
                  // Quando configurar o SVG, troque este Text pelo SvgPicture.asset
                  child: Text(
                    'GJA LOGO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.black, // O traço escuro do seu pixo
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Campo de E-mail (Neutro, limpo, sem brigar com a logo)
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  // Um preto transparente para criar o campo sem precisar de borda
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Quinas duras
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de Senha
              TextFormField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botão Principal de Login (O destaque da tela)
              SizedBox(
                // Aqui fica a altura que discutimos. Se 68px ficar gigante no emulador, baixe para 56.
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFFF5E00,
                    ), // O Laranja/Amarelo de destaque
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4, // Aquela sombra sutil que você colocou
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CardapioScreen(),
                      ),
                    );
                    // Lógica para pular pra tela de Feed depois
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
