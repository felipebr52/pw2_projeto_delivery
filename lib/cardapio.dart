import 'package:flutter/material.dart';
import 'package:proj_pw2/main.dart';
import 'package:proj_pw2/carrinho.dart';
import 'package:provider/provider.dart';
import 'package:proj_pw2/cart_model.dart';
import 'dart:async';

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
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                color: const Color(0xFF3A3A3A),
                width: double.infinity,
                child: Image.asset(
                  jogo.imagemPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.videogame_asset,
                      color: Colors.white24,
                      size: 40,
                    ),
                  ),
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E00),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      final cart = Provider.of<CartModel>(context, listen: false);
                      cart.addItem(CartItem(
                        titulo: jogo.titulo,
                        imagemPath: jogo.imagemPath,
                        preco: jogo.preco,
                      ));
                      final idx = cart.items.indexWhere((e) => e.titulo == jogo.titulo);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Adicionado ao carrinho'),
                          action: SnackBarAction(
                            label: 'Desfazer',
                            onPressed: () {
                              if (idx >= 0) cart.changeQuantity(idx, -1);
                            },
                          ),
                        ),
                      );
                    },
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
// 2. A Tela Principal (O Cardápio) - AGORA COMO STATEFUL
class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  // === VARIÁVEIS DE CONTROLE DO TIMER E DA BARRA ===
  bool _mostrarBarraTopo = true;
  Timer? _timerInatividade;

  
  final List<Game> jogos = [
    Game(
      titulo: "CyberPunk 2077",
      categoria: "RPG",
      preco: 199.90,
      imagemPath: "assets/images/cyberpunk77.JPG",
    ),
    
  ];

  final List<String> categorias = [
    "Todos",
    "Ofertas",
    "Lançamentos",
    "RPG",
    "Luta",
    "FPS",
  ];

  @override
  void initState() {
    super.initState();
    _iniciarTimer(); // Inicia a contagem assim que entra na tela
  }

  void _iniciarTimer() {
    _timerInatividade?.cancel(); // Zera o cronômetro se já tiver um rodando

    setState(() {
      _mostrarBarraTopo = true; // Mostra a barra de cima
    });

    // Se passar 3 segundos sem ngm tocar na tela, inverte a gangorra
    _timerInatividade = Timer(const Duration(seconds: 3), () {
      setState(() {
        _mostrarBarraTopo = false; // Esconde a barra, aparece o botão flutuante
      });
    });
  }

  @override
  void dispose() {
    _timerInatividade?.cancel(); // Limpa a memória ao sair da tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listener envolve o Scaffold inteiro para detectar qualquer toque na tela
    return Listener(
      onPointerDown: (_) => _iniciarTimer(), // Qualquer toque reinicia o timer
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        
        // ==========================================
        // BARRA DO TOPO (Some se o timer zerar)
        // ==========================================
        appBar: _mostrarBarraTopo
            ? AppBar(
                backgroundColor: const Color(0xFF6B227B),
                title: const Text(
                  'GAMES JÁ!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Lembre de importar o LoginScreen se for usar aqui
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                   
                  },
                ),
                actions: [
                  Consumer<CartModel>(builder: (context, cart, _) {
                    final count = cart.items.length;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
                                  gradient: const LinearGradient(colors: [Color(0xFFFF7A18), Color(0xFFFF5E00)]),
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
              )
            : null, // Recebe null para sumir da tela

        // ==========================================
        // BOTÃO FLUTUANTE (Aparece se a barra sumir)
        // ==========================================
        floatingActionButton: !_mostrarBarraTopo
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CarrinhoScreen()));
                 
                },
                elevation: 4,
                backgroundColor: Colors.deepOrangeAccent,
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              )
            : null, // Some quando a barra está ativa

        body: Column(
          children: [
            const SizedBox(height: 16),
            // CARROSSEL
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFF5E00),
                        width: 1,
                      ),
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

            const SizedBox(height: 24),
            
            // MENU (Filtros)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorias.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
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
                      borderRadius: BorderRadius.circular(20),
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

            // GRID DE JOGOS
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
      ),
    );
  }
}