import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proj_pw2/screens/recibo_screen.dart';
import 'package:proj_pw2/services/api_service.dart';
import 'package:proj_pw2/theme/app_theme.dart';
import 'package:intl/intl.dart';

class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  late Future<List<dynamic>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = ApiService.getPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MEUS PEDIDOS')),
      body: FutureBuilder<List<dynamic>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar pedidos.', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum pedido realizado ainda", style: TextStyle(color: Colors.white54, fontSize: 18)));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final dateStr = order['data'];
              final dateObj = DateTime.parse(dateStr);
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateObj);
              final total = double.parse(order['total'].toString());

              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReciboScreen(pedidoId: order['id'])));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long, color: AppTheme.accentColor, size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pedido #${order['id']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                const SizedBox(height: 4),
                                Text(formattedDate, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(order['status'], style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w800, fontSize: 16)),
                              const SizedBox(height: 8),
                              const Text('Ver Recibo >', style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
