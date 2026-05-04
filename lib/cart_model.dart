import 'package:flutter/foundation.dart';

class CartItem {
  final String titulo;
  final String imagemPath;
  final double preco;
  int quantidade;

  CartItem({
    required this.titulo,
    required this.imagemPath,
    required this.preco,
    this.quantidade = 1,
  });
}

class Order {
  final int id;
  final DateTime date;
  final List<CartItem> items;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];
  int _nextOrderId = 1;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  double get total =>
      _items.fold(0, (sum, item) => sum + item.preco * item.quantidade);

  void addItem(CartItem item) {
    final index = _items.indexWhere((e) => e.titulo == item.titulo);
    if (index >= 0) {
      _items[index].quantidade += item.quantidade;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void changeQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) return;
    _items[index].quantidade += delta;
    if (_items[index].quantidade <= 0) {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void checkout() {
    if (_items.isEmpty) return;
    final order = Order(
      id: _nextOrderId++,
      date: DateTime.now(),
      items: List.from(_items),
      total: total,
    );
    _orders.add(order);
    clear();
    notifyListeners();
  }
}
