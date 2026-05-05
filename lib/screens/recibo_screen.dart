import 'package:flutter/material.dart';
import 'package:proj_pw2/models/order.dart';
import 'package:proj_pw2/theme/app_theme.dart';

class ReciboScreen extends StatelessWidget {
  final Order order;

  const ReciboScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('RECIBO DO PEDIDO'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.receipt_long, size: 60, color: Colors.black87),
                    const SizedBox(height: 16),
                    const Text(
                      'GAMES JÁ! DELIVERY',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CNPJ: 00.000.000/0001-00',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.black26, thickness: 1), // Usamos hr visual
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              Text('Data: ${order.date.day.toString().padLeft(2, '0')}/${order.date.month.toString().padLeft(2, '0')}/${order.date.year}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              Text('Hora: ${order.date.hour.toString().padLeft(2, '0')}:${order.date.minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.black87)),
              Text('Cupom Fiscal / Pedido #${order.id}', style: const TextStyle(color: Colors.black87)),
              
              const SizedBox(height: 16),
              const Divider(color: Colors.black26),
              const SizedBox(height: 8),
              
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 3, child: Text('QTD UN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(flex: 5, child: Text('DESCRIÇÃO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(flex: 3, child: Text('VL. UNIT.', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(flex: 3, child: Text('VL. ITEM', textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
                ],
              ),
              const SizedBox(height: 8),
              
              ...order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: Text('${item.quantidade} UN', style: const TextStyle(color: Colors.black87, fontSize: 12))),
                      Expanded(flex: 5, child: Text(item.titulo, style: const TextStyle(color: Colors.black87, fontSize: 12))),
                      Expanded(flex: 3, child: Text('R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}', textAlign: TextAlign.right, style: const TextStyle(color: Colors.black87, fontSize: 12))),
                      Expanded(flex: 3, child: Text('R\$ ${(item.preco * item.quantidade).toStringAsFixed(2).replaceAll('.', ',')}', textAlign: TextAlign.right, style: const TextStyle(color: Colors.black87, fontSize: 12))),
                    ],
                  ),
                );
              }),
              
              const SizedBox(height: 16),
              const Divider(color: Colors.black26),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('TOTAL R\$', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(
                    order.total.toStringAsFixed(2).replaceAll('.', ','),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Obrigado pela preferência!\nVolte sempre.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
