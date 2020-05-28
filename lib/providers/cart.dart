import 'package:flutter/material.dart';

//prodid uss product ki id h jo tum add kr rhe ho...orr id nayi wali h jo tumharey cart m hogi
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalCount {
    var total = 0.0;
    //totalling logic..
    _items.forEach((key, cartItem) {
      total = total + ((cartItem.price) * cartItem.quantity);
    });
    return total;
  }

  void addToCart(String prodId, double price, String title) {
    notifyListeners();
    //if item already in cart
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  int get itemsCount {
    notifyListeners();
    return _items.length;
  }

  void removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      return;
    }
    if (_items[prodId].quantity > 1) {
      _items.update(
          prodId,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity - 1,
              price: existing.price));
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
