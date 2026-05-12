import 'package:flutter/material.dart';
import 'package:proj_pw2/services/api_service.dart';
import 'package:proj_pw2/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ReciboScreen extends StatefulWidget {
  final int pedidoId;
  const ReciboScreen({super.key, required this.pedidoId});

  @override
  State<ReciboScreen> createState() => _ReciboScreenState();
}

class _ReciboScreenState extends State<ReciboScreen> {
  late Future<Map<String, dynamic>?> _reciboFuture;

  @override
  void initState() {
    super.initState();
    _reciboFuture = ApiService.getRecibo(widget.pedidoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('RECIBO')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _reciboFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Recibo não encontrado ou erro.', style: TextStyle(color: Colors.red)));
          }

          final dados = snapshot.data!;
          final pedido = dados['pedido'];
          final itens = dados['itens'] as List<dynamic>;

          final dateObj = DateTime.parse(pedido['data']);
          final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateObj);
          final total = double.parse(pedido['total'].toString());

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Recibo
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12, width: 2, style: BorderStyle.solid))), // Dashed is hard in pure container
                      child: Column(
                        children: [
                          const Text('GAMES JÁ!', style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black)),
                          const SizedBox(height: 8),
                          Text('Recibo do Pedido #${pedido['id']}', style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
                          Text(formattedDate, style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Cliente
                    const Text('Dados do Cliente:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text('Nome: ${pedido['nome']}', style: const TextStyle(color: Colors.black87)),
                    Text('Email: ${pedido['email']}', style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 20),
                    // Itens
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black12, width: 2), bottom: BorderSide(color: Colors.black12, width: 2)),
                      ),
                      child: Column(
                        children: itens.map((item) {
                          final preco = double.parse(item['preco_unitario'].toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text('${item['quantidade']}x ${item['produto_nome']}', style: const TextStyle(color: Colors.black))),
                                Text('R\$ ${(preco * item['quantidade']).toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Footer Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
                        Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.accentColor)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Obrigado por comprar na Games Já!', textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Voltar aos Pedidos', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
