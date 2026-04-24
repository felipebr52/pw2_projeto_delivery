import 'package:flutter/material.dart';
import 'package:proj_pw2/main.dart';

//Classe que define o que é um 'jogo'
class Game {
  final String titulo;
  final String categoria;
  final double preco;
  final String imagemPath; // <-- O novo campo aqui

  Game({
    required this.titulo,
    required this.categoria,
    required this.preco,
    required this.imagemPath, // <-- Adicione no construtor
  });
}

//define o Card que exibe o jogo
class GameCard extends StatelessWidget {
  final Game jogo;
  const GameCard({super.key, required this.jogo});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A3A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              width: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.videogame_asset,
                  color: Colors.white24,
                  size: 40,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jogo.categoria.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Color(0xFFFF5E00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  jogo.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${jogo.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. A Tela Principal (O Cardápio)
class CardapioScreen extends StatelessWidget {
  const CardapioScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Lista mockada que já tínhamos
    final List<Game> jogos = [
      Game(
        titulo: "CyberPunk 2077",
        categoria: "RPG",
        preco: 199.90,
        imagemPath: "assets/images/cyberpunk77.JPG", // Caminho do arquivo
      ),
      // ...
    ];

    final List<String> categorias = [
      "Todos",
      "Ofertas",
      "Lançamentos",
      "RPG",
      "Luta",
      "FPS",
    ];
    //===============valores de Teste============

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B227B),
        title: const Text(
          'GAMES JÁ!',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            //titulo
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        actions: [
          // 1. O CARRINHO: Fica fixo no topo direito
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Futuramente navega para a tela do Carrinho
            },
          ),
          const SizedBox(width: 8), // Respiro lateral
          //botão carrinho
        ],
      ),
      //O botão flutuante, que vai virar o carrinho
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: Text("Janela popup"),
                content: Text("Eu posso ser um formulário"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardapioScreen(),
                        ),
                      );
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        },
        elevation: 4,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Column(
        children: [
          // 2. O CARROSSEL (Banners de destaque)
          const SizedBox(height: 16), // Espaço do topo
          SizedBox(
            height: 140, // Altura do banner
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // Quantidade de banners
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return Container(
                  width: 280, // Largura de cada banner
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A), // Placeholder do banner
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFF5E00),
                      width: 1,
                    ), // Borda laranja
                  ),
                  child: const Center(
                    child: Text(
                      'BANNER PROMOCIONAL',
                      style: TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. O MENU (Filtros em formato de "Chips" horizontais)
          const SizedBox(height: 24),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                // Deixando o primeiro item ("Todos") "selecionado" com a cor amarela/laranja
                bool isSelected = index == 0;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF5E00)
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20), // Formato pílula
                  ),
                  child: Center(
                    child: Text(
                      categorias[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontFamily: 'Inter',
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // 4. O GRID DE JOGOS (Envolvido em um Expanded para ocupar o resto da tela)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: jogos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return GameCard(jogo: jogos[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
