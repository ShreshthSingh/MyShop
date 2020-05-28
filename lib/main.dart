import 'package:flutter/material.dart';
import 'package:myshop/screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_description.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './screens/user_products.dart';
import './screens/edit_product_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (ctx) => Products(),
              update: (_, auth, data) => data..update(auth.token, auth.userId)),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(),
              update: (_, auth, data) => data..update(auth.token, auth.userId)),
        ],
        //ChangeNotifierProvider.value(
        //create: (ctx) => Products(),
        //value:Products(),
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.lightBlue,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductsOverviewScreen()
               : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
            routes: {
              '/productdesc': (ctx) => ProductDescription(),
              '/cart': (ctx) => CartScreen(),
              '/orders': (ctx) => OrdersScreen(),
              '/userproducts': (ctx) => UserProductsScreen(),
              '/editproduct': (ctx) => EditProductsScreen(),
            },
          ),
        ));
  }
}
