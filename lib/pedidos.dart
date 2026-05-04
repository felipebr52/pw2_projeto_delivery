import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proj_pw2/cart_model.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B227B),
        title: const Text(
          'MEUS PEDIDOS',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.orders.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum pedido realizado ainda",
                style: TextStyle(color: Colors.white54, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cart.orders.length,
            itemBuilder: (context, index) {
              final order = cart.orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido #${order.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Data: ${order.date.day}/${order.date.month}/${order.date.year} ${order.date.hour}:${order.date.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: R\$ ${order.total.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        color: Color(0xFFFF5E00),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Produtos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantidade}x ${item.titulo}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            'R\$ ${(item.preco * item.quantidade).toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}