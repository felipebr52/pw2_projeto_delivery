import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proj_pw2/models/game.dart';
import 'package:proj_pw2/models/cart_item.dart';
import 'package:proj_pw2/providers/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:proj_pw2/theme/app_theme.dart';

class GameCard extends StatelessWidget {
  final Game jogo;
  const GameCard({super.key, required this.jogo});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    child: jogo.imagemPath.startsWith('http')
                        ? Image.network(
                            jogo.imagemPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.videogame_asset, color: Colors.white24, size: 40)),
                          )
                        : Image.asset(
                            jogo.imagemPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.videogame_asset, color: Colors.white24, size: 40)),
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
                        color: AppTheme.accentColor,
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
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(jogo.disponivel ? Icons.add_shopping_cart : Icons.block, size: 16),
                        label: Text(jogo.disponivel ? 'Adicionar' : 'Indisponível'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: jogo.disponivel ? AppTheme.accentColor : Colors.grey[800],
                          foregroundColor: jogo.disponivel ? Colors.white : Colors.white54,
                          elevation: jogo.disponivel ? 8 : 0,
                        ),
                        onPressed: jogo.disponivel
                            ? () {
                                final cart = Provider.of<CartModel>(context, listen: false);
                                cart.addItem(CartItem(
                                  id: jogo.id,
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
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
