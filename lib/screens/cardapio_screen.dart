import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proj_pw2/models/game.dart';
import 'package:proj_pw2/models/promo_banner.dart';
import 'package:proj_pw2/providers/cart_model.dart';
import 'package:proj_pw2/services/game_repository.dart';
import 'package:proj_pw2/screens/login_screen.dart';
import 'package:proj_pw2/screens/pedidos_screen.dart';
import 'package:proj_pw2/screens/carrinho_screen.dart';
import 'package:proj_pw2/widgets/game_card.dart';
import 'package:proj_pw2/theme/app_theme.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  String _selectedCategory = "Todos";

  List<Game> _allGames = [];
  List<PromoBanner> _banners = [];
  List<String> _categorias = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Game> get filteredJogos {
    if (_selectedCategory == "Todos") return _allGames;
    if (_selectedCategory == "Ofertas") return _allGames.where((jogo) => jogo.preco < 200).toList();
    if (_selectedCategory == "Lançamentos") return _allGames.where((jogo) => jogo.titulo.contains("2023") || jogo.titulo.contains("VI")).toList();
    return _allGames.where((jogo) => jogo.categoria == _selectedCategory).toList();
  }

  Future<void> loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final repository = GameRepository();
      
      // Carrega tudo ao mesmo tempo (em paralelo) da "API"
      final results = await Future.wait([
        repository.getAllGames(),
        repository.getBanners(),
        repository.getCategories(),
      ]);

      setState(() {
        _allGames = results[0] as List<Game>;
        _banners = results[1] as List<PromoBanner>;
        _categorias = results[2] as List<String>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar dados: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('GAMES JÁ!'),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_back),
          onSelected: (value) {
            if (value == 'login') {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else if (value == 'pedidos') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PedidoScreen()));
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'login',
              child: Text('Voltar ao Login'),
            ),
            const PopupMenuItem<String>(
              value: 'pedidos',
              child: Text('Ir para Pedidos'),
            ),
          ],
        ),
        actions: [
          Consumer<CartModel>(builder: (context, cart, _) {
            final count = cart.items.length;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CarrinhoScreen()));
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 8,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Container(
                        key: ValueKey<int>(count),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFF7A18), AppTheme.accentColor]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2)),
                          ],
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loadInitialData,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                
                // --- BANNERS ---
                if (_banners.isNotEmpty) ...[
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _banners.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final banner = _banners[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColorLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.accentColor,
                              width: 1,
                            ),
                            // Se as imagens do banner existirem no projeto, elas aparecerão aqui:
                            image: DecorationImage(
                              image: AssetImage(banner.imagemPath),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {}, // Ignora erro se imagem nao existir (fallback abaixo)
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PROMOÇÃO #${banner.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // --- CATEGORIAS ---
                if (_categorias.isNotEmpty) ...[
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categorias.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final categoria = _categorias[index];
                        bool isSelected = categoria == _selectedCategory;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = categoria;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accentColor
                                  : AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                categoria,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontFamily: 'Inter',
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // --- GRID DE JOGOS ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int columns = 2;
                        if (constraints.maxWidth > 600) {
                          columns = 3;
                        }
                        if (constraints.maxWidth > 900) {
                          columns = 4;
                        }
                        
                        return GridView.builder(
                          itemCount: filteredJogos.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            return GameCard(jogo: filteredJogos[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
