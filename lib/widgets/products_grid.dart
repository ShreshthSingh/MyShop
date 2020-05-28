import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';



class ProductsGrid extends StatelessWidget  {
  bool showFavorites;
  ProductsGrid(this.showFavorites);
  

  @override
  Widget build(BuildContext context)  {
   final productsData = Provider.of<Products>(context);
   
   final products =  showFavorites?productsData.favitems:productsData.items;
   
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2 ,childAspectRatio: 3/2,mainAxisSpacing: 10,crossAxisSpacing: 10 ),
        itemBuilder: (ctx,i)=>ChangeNotifierProvider.value(
      //    create: (c)=>products[i],
          value: products[i],
          //hum product item ko access de rhe hn products k hr item k liye jo ki array m h providers wale
          child: ProductItem(
            //products[i].id,
            //products[i].title,
             //products[i].imageUrl
             )
             )
        );
  }
}