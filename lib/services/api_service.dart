import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  // Autenticação
  static Future<Map<String, dynamic>?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id', data['id']); // API returns {id, nome, email}
        await prefs.setString('usuario_nome', data['nome']);
        return data;
      }
    } catch (e) {
      print('Erro de Login: $e');
    }
    return null;
  }

  // Cadastro
  static Future<Map<String, dynamic>?> cadastro(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id', data['id']);
        await prefs.setString('usuario_nome', data['nome']);
        return data;
      }
    } catch (e) {
      print('Erro de Cadastro: $e');
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    await prefs.remove('usuario_nome');
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuario_id');
    final nome = prefs.getString('usuario_nome');
    if (id != null && nome != null) {
      return {'id': id, 'nome': nome};
    }
    return null;
  }

  // Checkout
  static Future<bool> checkout(int usuarioId, List<Map<String, dynamic>> itens, double total) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pedidos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': usuarioId,
          'itens': itens,
          'total': total,
        }),
      );

      if (response.statusCode == 201) return true;
    } catch (e) {
      print('Erro no Checkout: $e');
    }
    return false;
  }

  // Histórico de Pedidos
  static Future<List<dynamic>> getPedidos() async {
    final user = await getCurrentUser();
    if (user == null) return [];
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos/usuario/${user['id']}'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
    }
    return [];
  }

  // Obter detalhes de um Recibo
  static Future<Map<String, dynamic>?> getRecibo(int pedidoId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pedidos/recibo/$pedidoId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar recibo: $e');
    }
    return null;
  }
}
