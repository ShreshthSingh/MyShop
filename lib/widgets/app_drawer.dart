import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
             Container(
              height: 120,
              color: Theme.of(context).accentColor,
              child: Text('MyShop',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30,color: Colors.white)),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft
              ),
            
            SizedBox(height: 20),
            FlatButton(
              onPressed: () { return Navigator.of(context).pushNamed('/orders');
                  
                  },
              child: Text('YOUR ORDERS', style: TextStyle(color: Colors.blue)),
              
            ),
          SizedBox(height: 20),
            FlatButton(
              onPressed: () { return Navigator.of(context).pushNamed('/userproducts');
                  
                  },
              child: Text('YOUR PRODUCTS', style: TextStyle(color: Colors.blue)),
              
            ),
            SizedBox(height: 20),
            FlatButton(
              onPressed: () { return Navigator.of(context).pushNamed('/');

                       
                  },
              child: Text('HOME', style: TextStyle(color: Colors.blue)),
              
            ),
             SizedBox(height: 20),
            FlatButton(
              onPressed: () {  Provider.of<Auth>(context,listen: false ).logout();
                    Navigator.of(context).pop();
                       
                  },
              child: Text('LOGOUT', style: TextStyle(color: Colors.blue)),
              
            )






          ],
        ),
      );
  }
}