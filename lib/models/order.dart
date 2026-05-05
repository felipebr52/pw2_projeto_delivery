import 'package:proj_pw2/models/cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}
