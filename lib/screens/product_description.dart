import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../models/product.dart';
import '../providers/products.dart';

class ProductDescription extends StatelessWidget {
  //String id;
  //ProductDescription(this.id);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // <Products> because we are looking for array which have id as the item we clicked.....
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 5),
                  borderRadius: BorderRadius.circular(19.0),
                ),
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
                height: 300,
                width: double.infinity,
              ),
              SizedBox(height: 10),
              Text(
                ' ₹' + loadedProduct.price.toString(),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                  child: Text(
                loadedProduct.description,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    softWrap: true,
              ))
            ],
          ),
        ));
  }
}
