import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your Cart')),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      //color: Theme.of(context).primaryTextTheme.title.color
                      Chip(
                        label: Text('₹ ${cart.totalCount.toString()}',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      _isLoading?CircularProgressIndicator():
                      FlatButton(
                        onPressed:cart.totalCount>0? () async {
                          setState(() {
                            _isLoading = true;
                          });
                         await Provider.of<Orders>(context, listen: false).addOrder(
                              cart.items.values.toList(), cart.totalCount);
                          setState(() {
                            _isLoading = false;
                          });    
                          cart.clearCart();    
                        }:null,
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemsCount,
                itemBuilder: (ctx, i) => ci.CartItem(
                    id: cart.items.values.toList()[i].id,
                    //i th key wala element delete krna hai
                    prodId: cart.items.keys.toList()[i],
                    //
                    title: cart.items.values.toList()[i].title,
                    price: cart.items.values.toList()[i].price,
                    quantity: cart.items.values.toList()[i].quantity),
              ),
            )
          ],
        ));
  }
}
