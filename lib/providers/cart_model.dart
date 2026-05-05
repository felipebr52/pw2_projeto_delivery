import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_pw2/models/cart_item.dart';
import 'package:proj_pw2/models/order.dart';

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];
  List<Order> _orders = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  CartModel() {
    _loadData();
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + item.preco * item.quantidade);

  void addItem(CartItem item) {
    final index = _items.indexWhere((e) => e.titulo == item.titulo);
    if (index >= 0) {
      _items[index].quantidade += item.quantidade;
    } else {
      _items.add(item);
    }
    _saveData();
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _saveData();
      notifyListeners();
    }
  }

  void changeQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) return;
    _items[index].quantidade += delta;
    if (_items[index].quantidade <= 0) {
      _items.removeAt(index);
    }
    _saveData();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveData();
    notifyListeners();
  }

  void checkout() {
    if (_items.isEmpty) return;
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unico baseado no timestamp
      date: DateTime.now(),
      items: List.from(_items),
      total: total,
    );
    _orders.add(order);
    _items.clear();
    _saveData();
    notifyListeners();
  }

  // Persistencia com Shared Preferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = jsonEncode(_items.map((e) => e.toJson()).toList());
    final ordersJson = jsonEncode(_orders.map((e) => e.toJson()).toList());
    await prefs.setString('cart_items', itemsJson);
    await prefs.setString('orders', ordersJson);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final itemsString = prefs.getString('cart_items');
    if (itemsString != null) {
      final List<dynamic> decodedItems = jsonDecode(itemsString);
      _items = decodedItems.map((e) => CartItem.fromJson(e)).toList();
    }

    final ordersString = prefs.getString('orders');
    if (ordersString != null) {
      final List<dynamic> decodedOrders = jsonDecode(ordersString);
      _orders = decodedOrders.map((e) => Order.fromJson(e)).toList();
    }
    
    notifyListeners();
  }
}
