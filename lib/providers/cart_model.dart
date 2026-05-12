import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_pw2/models/cart_item.dart';
import 'package:proj_pw2/services/api_service.dart';

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

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

  // Faz a chamada à API Node para checkout online
  Future<bool> checkout() async {
    if (_items.isEmpty) return false;

    final user = await ApiService.getCurrentUser();
    if (user == null) return false;

    List<Map<String, dynamic>> apiItens = _items.map((item) => {
      'produto_id': item.id,
      'quantidade': item.quantidade,
      'preco_unitario': item.preco
    }).toList();

    bool success = await ApiService.checkout(user['id'], apiItens, total);
    
    if (success) {
      _items.clear();
      _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString('cart_items', itemsJson);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final itemsString = prefs.getString('cart_items');
    if (itemsString != null) {
      final List<dynamic> decodedItems = jsonDecode(itemsString);
      _items = decodedItems.map((e) => CartItem.fromJson(e)).toList();
    }
    
    notifyListeners();
  }
}
