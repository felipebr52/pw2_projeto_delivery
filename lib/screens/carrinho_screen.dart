import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proj_pw2/providers/cart_model.dart';
import 'package:proj_pw2/theme/app_theme.dart';
import 'dart:ui';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  bool _isCheckingOut = false;

  void _alterarQuantidade(BuildContext context, int index, int delta) {
    Provider.of<CartModel>(context, listen: false).changeQuantity(index, delta);
  }

  void _removerItem(BuildContext context, int index) {
    Provider.of<CartModel>(context, listen: false).removeAt(index);
  }

  Future<void> _finalizarCompra(CartModel cart) async {
    setState(() => _isCheckingOut = true);
    bool success = await cart.checkout();
    setState(() => _isCheckingOut = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido realizado com sucesso!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao processar o pedido. Tente novamente.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MEU CARRINHO')),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text("Seu carrinho está vazio 🎮", style: TextStyle(color: Colors.white54, fontSize: 18)),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];

              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.imagemPath.startsWith('http')
                            ? Image.network(item.imagemPath, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.videogame_asset))
                            : Image.asset(item.imagemPath, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.videogame_asset)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () => _removerItem(context, index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _alterarQuantidade(context, index, -1),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(4)), child: const Text('-', style: TextStyle(color: Colors.white, fontSize: 16))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('${item.quantidade}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                GestureDetector(
                                  onTap: () => _alterarQuantidade(context, index, 1),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(4)), child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 16))),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1c0422),
              border: Border(top: BorderSide(color: Colors.white12, width: 1)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Text(
                        'R\$ ${cart.total.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (cart.items.isEmpty || _isCheckingOut) ? null : () => _finalizarCompra(cart),
                      child: _isCheckingOut 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('FINALIZAR COMPRA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
