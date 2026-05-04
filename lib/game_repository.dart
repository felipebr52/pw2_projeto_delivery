import 'package:proj_pw2/cardapio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameRepository {
  // URL base do servidor Node.js
  // Para Android Emulator: use 10.0.2.2
  // Para iOS Simulator: use localhost
  // Para dispositivo físico: use o IP da máquina
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Busca todos os jogos via API
  Future<List<Game>> getAllGames() async {
    // Para testes, retornando dados hardcoded
    // Quando o servidor Node.js estiver pronto, descomente o código abaixo
    /*
    try {
      final response = await http.get(Uri.parse('$baseUrl/games'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar jogos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
    */

    // Dados hardcoded para teste
    return [
      Game(
        titulo: "CyberPunk 2077",
        categoria: "RPG",
        preco: 199.90,
        imagemPath: "assets/images/cyberpunk77.JPG",
      ),
      Game(
        titulo: "FIFA 2023",
        categoria: "Esportes",
        preco: 299.90,
        imagemPath: "assets/images/fifa2023.jpg",
      ),
      Game(
        titulo: "Street Fighter VI",
        categoria: "Luta",
        preco: 249.90,
        imagemPath: "assets/images/sf6.jpg",
      ),
      Game(
        titulo: "Call of Duty",
        categoria: "FPS",
        preco: 349.90,
        imagemPath: "assets/images/cod.jpg",
      ),
      Game(
        titulo: "The Witcher 3",
        categoria: "RPG",
        preco: 149.90,
        imagemPath: "assets/images/witcher3.jpg",
      ),
      Game(
        titulo: "Mortal Kombat",
        categoria: "Luta",
        preco: 199.90,
        imagemPath: "assets/images/mk.jpg",
      ),
    ];
  }

  // Método opcional para buscar por categoria via API
  // Útil se o Node.js suportar queries por categoria
  Future<List<Game>> getGamesByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/games?categoria=$category'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Game.fromJson(json)).toList();
      } else {
        // Fallback: busca todos e filtra localmente
        final allGames = await getAllGames();
        if (category == "Todos") return allGames;
        if (category == "Ofertas") return allGames.where((jogo) => jogo.preco < 200).toList();
        if (category == "Lançamentos") return allGames.where((jogo) => jogo.titulo.contains("2023") || jogo.titulo.contains("VI")).toList();
        return allGames.where((jogo) => jogo.categoria == category).toList();
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}