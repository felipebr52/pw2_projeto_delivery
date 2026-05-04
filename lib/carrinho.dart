import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proj_pw2/cart_model.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  // All cart state is stored in CartModel provided at app root.
  void _alterarQuantidade(int index, int delta) {
    final cart = Provider.of<CartModel>(context, listen: false);
    cart.changeQuantity(index, delta);
  }

  void _removerItem(int index) {
    final cart = Provider.of<CartModel>(context, listen: false);
    cart.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B227B),
        title: const Text(
          'MEU CARRINHO',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(builder: (context) {
        final cart = Provider.of<CartModel>(context);
        return cart.items.isEmpty
            ? const Center(
                child: Text(
                  "Seu carrinho está vazio 🎮",
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.imagemPath,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 70,
                              height: 70,
                              color: const Color(0xFF3A3A3A),
                              child: const Icon(Icons.videogame_asset, color: Colors.white24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.titulo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                style: const TextStyle(
                                  color: Color(0xFFFF5E00),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () => _removerItem(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _alterarQuantidade(index, -1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(4)),
                                    child: const Text('-', style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '${item.quantidade}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _alterarQuantidade(index, 1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFFF5E00), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
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
                    'R\$ ${Provider.of<CartModel>(context).total.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: Provider.of<CartModel>(context).items.isEmpty ? null : () {
                    final cart = Provider.of<CartModel>(context, listen: false);
                    cart.checkout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pedido realizado com sucesso!')),
                    );
                  },
                  child: const Text(
                    'FINALIZAR COMPRA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
