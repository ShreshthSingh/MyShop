import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String name;
  final String imgurl;
  final String id;
  UserProductItem(this.name, this.imgurl,this.id);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imgurl,
          height: 150.0,
          width: 100.0,
          fit: BoxFit.cover,
        ),
      ),
      trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/editproduct',arguments: id);
                  }),
              IconButton(
                  icon: Icon(Icons.delete, color: Colors.red), onPressed:  ()async {
                   try{await Provider.of<Products>(context,listen: false).deleteProduct(id);}
                   catch(error){
                     scaffold.showSnackBar(SnackBar(content: Text('Deleting Failed'),));
                   }
                    print ('hiii');
                  })
            ],
          )),
      title: Text(name),
    );
  }
}
