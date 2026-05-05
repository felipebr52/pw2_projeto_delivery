import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proj_pw2/models/game.dart';
import 'package:proj_pw2/models/promo_banner.dart';

class GameRepository {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Game>> getAllGames() async {
    // Retornando mock data
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

  Future<List<Game>> getGamesByCategory(String category) async {
    final allGames = await getAllGames();
    if (category == "Todos") return allGames;
    if (category == "Ofertas") return allGames.where((jogo) => jogo.preco < 200).toList();
    if (category == "Lançamentos") return allGames.where((jogo) => jogo.titulo.contains("2023") || jogo.titulo.contains("VI")).toList();
    return allGames.where((jogo) => jogo.categoria == category).toList();
  }

  // Novo método para buscar os banners promocionais da API
  Future<List<PromoBanner>> getBanners() async {
    // Quando a API estiver pronta, fará um http.get('$baseUrl/banners')
    return [
      PromoBanner(
        id: "1",
        imagemPath: "assets/images/banner_oferta1.jpg", 
      ),
      PromoBanner(
        id: "2",
        imagemPath: "assets/images/banner_lancamento.jpg",
      ),
      PromoBanner(
        id: "3",
        imagemPath: "assets/images/banner_fretegratis.jpg",
      ),
    ];
  }

  // Novo método para buscar as categorias da API
  Future<List<String>> getCategories() async {
    // Quando a API estiver pronta, fará um http.get('$baseUrl/categories')
    // A string "Todos" normalmente é fixa no FrontEnd, mas deixaremos aqui como fallback.
    return [
      "Todos",
      "Ofertas",
      "Lançamentos",
      "RPG",
      "Luta",
      "FPS",
      "Aventura", // Categoria nova simulada
    ];
  }
}
