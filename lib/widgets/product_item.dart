import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';
class ProductItem extends StatelessWidget {
  ///final String id;
  //final String title;
  //final String imageUrl;
  //ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final authToken = Provider.of<Auth>(context).token;
    final userId = Provider.of<Auth>(context).userId;
    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/productdesc', arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: ()  async {
                  try{await product.toggleFavorite(authToken,userId);}
                  catch(error){
                    scaffold.showSnackBar(SnackBar(content:Text('Toggle failed')));
                  }
                  
                },
                color: Theme.of(context).accentColor),
            title: Text(product.title),
            backgroundColor: Colors.black87,
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addToCart(
                    product.id,
                    product.price,
                    product.title,
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Item added to the cart'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                })),
      ),
    );
  }
}
