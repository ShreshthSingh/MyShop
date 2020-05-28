import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Orders>(context, listen: false).getFetchOrders();
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),

      drawer:MainDrawer(), 
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return OrderItemm(ordersData.orders[i]);
              },
              itemCount: ordersData.orders.length,
            ),
    );
  }
}
