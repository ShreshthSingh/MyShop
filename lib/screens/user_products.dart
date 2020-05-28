import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import '../providers/product.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/user_products_item.dart';

class UserProductsScreen extends StatelessWidget {
  /* @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  //var _isInit = true; */
  // var _isLoading = false;
/////yahan bc pull to refresh dhoka de gya thaa
  // void initState() {
  // Future.delayed(Duration.zero).then((_){
  //   Provider.of<Products>(context).getFetchProducts();

  // });
  //  super.initState();
  // }

  //did change dependecy s bhi kr skte they yeh upar wala kaaam
  /* @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getFetchProducts(true).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }
 */
  @override
  Widget build(BuildContext context) {
    Future<void> _refreshProducts() async {
      await Provider.of<Products>(context, listen: false).getFetchProducts(true);
    }

    //final products = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed('/editproduct');
                })
          ],
        ),
        drawer:MainDrawer() ,
        body: FutureBuilder(
            future: _refreshProducts(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : Consumer<Products>(
                                          builder:(ctx,prodData,_)=> Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: prodData.items.length,
                              itemBuilder: (_, i) => Column(
                                    children: <Widget>[
                                      UserProductItem(
                                          prodData.items[i].title,
                                          prodData.items[i].imageUrl,
                                          prodData.items[i].id),
                                      Divider()
                                    ],
                                  )),
                        ),
                    )));
  }
}
