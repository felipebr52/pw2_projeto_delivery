import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proj_pw2/screens/cardapio_screen.dart';
import 'package:proj_pw2/services/api_service.dart';
import 'package:proj_pw2/theme/app_theme.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _fazerCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final result = await ApiService.cadastro(
        _nomeController.text, 
        _emailController.text, 
        _senhaController.text
      );
      
      setState(() => _isLoading = false);

      if (result != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CardapioScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao cadastrar. E-mail pode já estar em uso.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRAR'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, 15)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Crie sua conta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: _nomeController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(hintText: 'Nome Completo'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor, insira seu nome';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail';
                            if (!value.contains('@')) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(hintText: 'Senha'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                            if (value.length < 6) return 'No mínimo 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _fazerCadastro,
                            child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Cadastrar e Entrar',
                                    style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
