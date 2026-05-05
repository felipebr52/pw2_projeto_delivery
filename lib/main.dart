import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proj_pw2/providers/cart_model.dart';
import 'package:proj_pw2/screens/login_screen.dart';
import 'package:proj_pw2/theme/app_theme.dart';

void main() {
  runApp(const GamesJaApp());
}

class GamesJaApp extends StatelessWidget {
  const GamesJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Games Já!',
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
