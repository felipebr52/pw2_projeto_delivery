import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proj_pw2/models/game.dart';
import 'package:proj_pw2/models/promo_banner.dart';
import 'package:flutter/foundation.dart';

class GameRepository {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  Future<List<Game>> getAllGames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produtos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Game.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar produtos da API: $e');
    }
    return [];
  }

  Future<List<Game>> getGamesByCategory(String category) async {
    final allGames = await getAllGames();
    if (category == "Todos") return allGames;
    if (category == "Ofertas") return allGames.where((jogo) => jogo.preco < 200).toList();
    if (category == "Lançamentos") return allGames.where((jogo) => jogo.titulo.contains("2023") || jogo.titulo.contains("VI")).toList();
    return allGames.where((jogo) => jogo.categoria == category).toList();
  }

  Future<List<PromoBanner>> getBanners() async {
    final allGames = await getAllGames();
    if (allGames.isEmpty) return [];
    
    // Pegando até 3 jogos para destacar no banner usando imagens reais
    return allGames.take(3).map((game) {
      return PromoBanner(
        id: game.id.toString(),
        imagemPath: game.imagemPath,
        preco: game.preco,
      );
    }).toList();
  }

  Future<List<String>> getCategories() async {
    final allGames = await getAllGames();
    final categories = allGames.map((e) => e.categoria).toSet().toList();
    
    // Inserindo filtros extras fixos no topo
    return [
      "Todos",
      "Ofertas",
      "Lançamentos",
      ...categories,
    ];
  }
}
