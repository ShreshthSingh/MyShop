import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
 var _isInit = true; 
 var _isLoading = false;

  @override
  void initState() {
  // Future.delayed(Duration.zero).then((_){
  //   Provider.of<Products>(context).getFetchProducts();
    
  // });
    super.initState();
  }

//did change dependecy s bhi kr skte they yeh upar wala kaaam
 @override
  void didChangeDependencies() {

    
    if (_isInit){
          setState(() {
      _isLoading = true;
    });
       Provider.of<Products>(context).getFetchProducts(false).then((_){
         setState(() {
      _isLoading = false;
    });
       });
       
    }
   _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }





  final List<Product> loadedProduct = [];

  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (selectedValue) {
                if (selectedValue == FilterOptions.Favorites) {
                  setState(() {
                    _showFavorites = true;
                  });
                } else {
                  setState(() {
                    _showFavorites = false;
                  });
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Show Favorites'),
                        value: FilterOptions.Favorites),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.All)
                  ]),

          ///here we have wrapped only the badge cicle with builder functton beacuse shopping icon is contsant
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemsCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/cart',
                );
              },
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body:_isLoading?Center(child: CircularProgressIndicator(),): ProductsGrid(_showFavorites),
    );
  }
}
