import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  //prodId is the one that is visible on that of cart item to be deleted
  final String prodId;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity, this.prodId});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        cart.removeItem(prodId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Want to remove this item from cart?'),
                  actions: <Widget>[
                    FlatButton(onPressed:(){
                      Navigator.of(ctx).pop(true);
                    }, child: Text('Yes')),
                    
                    FlatButton(onPressed:(){
                      Navigator.of(ctx).pop(false);
                    }, child: Text('No'))
                  ],
                  elevation: 15,
                ));
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(child: FittedBox(child: Text('₹ $price'))),
              title: Text(title),
              subtitle: Text('Total: ₹${(price * quantity)}'),
              trailing: Text('X $quantity'),
            ),
          )),
    );
  }
}
