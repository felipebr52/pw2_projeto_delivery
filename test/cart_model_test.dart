import 'package:flutter_test/flutter_test.dart';
import 'package:proj_pw2/cart_model.dart';

void main() {
  group('CartModel', () {
    test('adds item and computes total', () {
      final cart = CartModel();
      cart.addItem(CartItem(titulo: 'Game A', imagemPath: '', preco: 10.0));

      expect(cart.items.length, 1);
      expect(cart.total, 10.0);
    });

    test('adding same item increments quantity', () {
      final cart = CartModel();
      cart.addItem(CartItem(titulo: 'Game A', imagemPath: '', preco: 5.0));
      cart.addItem(CartItem(titulo: 'Game A', imagemPath: '', preco: 5.0));

      expect(cart.items.length, 1);
      expect(cart.items.first.quantidade, 2);
      expect(cart.total, 10.0);
    });

    test('changeQuantity modifies quantity and removes when zero', () {
      final cart = CartModel();
      cart.addItem(CartItem(titulo: 'Game B', imagemPath: '', preco: 7.5));
      // increase
      cart.changeQuantity(0, 1);
      expect(cart.items.first.quantidade, 2);
      // decrease twice -> removed
      cart.changeQuantity(0, -1);
      cart.changeQuantity(0, -1);
      expect(cart.items.length, 0);
    });

    test('removeAt removes the correct item', () {
      final cart = CartModel();
      cart.addItem(CartItem(titulo: 'A', imagemPath: '', preco: 1.0));
      cart.addItem(CartItem(titulo: 'B', imagemPath: '', preco: 2.0));
      expect(cart.items.length, 2);
      cart.removeAt(0);
      expect(cart.items.length, 1);
      expect(cart.items.first.titulo, 'B');
    });
  });
}
