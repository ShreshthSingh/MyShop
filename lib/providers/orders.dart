import 'package:flutter/material.dart';
import 'dart:convert';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  String authToken;
  String _userId;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void update(String token,String userId){
    authToken = token;
    _userId = userId;
  }


  Future<void> getFetchOrders() async {
    final url = 'https://flutter-myshop-5f569.firebaseio.com/orders/$_userId.json?auth=$authToken';
    final List<OrderItem> loadedOrders = [];

   try{
       final response = await http.get(url);
    final ordersdata = (json.decode(response.body));
    if (ordersdata==null){
      return;
    }
    ordersdata.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
          products: (orderData['products'] as List<dynamic>).map((item) =>
              CartItem(id: item['id'], title:item['title'], quantity: item['quantity'], price: item['price'])).toList()
              )
              );

         _orders = loadedOrders;
         notifyListeners();     
    });

}catch(error){
  throw(error);

}

  
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-myshop-5f569.firebaseio.com/orders/$_userId.json?auth=$authToken';
    //json m convert krn k liye

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList(),
        }),
      );

      final newOrder = OrderItem(
        id: json.decode(response.body)['dateTime'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      );

      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    //we want to throw this error in UI
  }
}
