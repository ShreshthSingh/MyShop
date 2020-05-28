import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemm extends StatefulWidget {
  final OrderItem order;
  OrderItemm(this.order);

  @override
  _OrderItemmState createState() => _OrderItemmState();
}

class _OrderItemmState extends State<OrderItemm> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('₹' + '${widget.order.amount.toString()}'),
              subtitle: Text(
                  DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
            ),
            if (_expanded)
              
                Container(
                  padding: EdgeInsets.all(10),
                  height: min(widget.order.products.length * 40.0 + 10, 100),
                  child: ListView(
                    children: widget.order.products.map((prod) {
                      return Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text('('+'₹'+prod.price.toStringAsFixed(2)+')'+'X'+ prod.quantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
              
          ],
        ));
  }
}
