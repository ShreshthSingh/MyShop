import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';


class Products with ChangeNotifier {
   String authToken;
   String _userId;
   //Products(this.authToken);

  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Brown Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://rukminim1.flixcart.com/image/800/960/jjd6aa80/shirt/j/x/s/38-bfcoffisht02ab-being-fab-original-imaf6yg9ufxbpfsz.jpeg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Xbox',
      description: 'Game till u become a game',
      price: 23999,
      imageUrl:
          'https://rukminim1.flixcart.com/image/416/416/jxc5a4w0/gamingconsole/c/z/r/1024-xbox-one-s-microsoft-na-original-imafhtgs7zqruvqe.jpeg?q=70',
    ), */
  ];


  void update(String token,String userId){
    
    authToken = token;
    _userId = userId;
  }


  List<Product> get items {
    return [..._items];
  }

  List<Product> get favitems {
    return [..._items].where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

 Future<void> getFetchProducts([bool userFetch=false]) async{
      
     var url = 'https://flutter-myshop-5f569.firebaseio.com/products.json?auth=$authToken';
     if (userFetch == true){
       url = 'https://flutter-myshop-5f569.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$_userId"';
     }

try{
    final List<Product> loadedProducts = [];
     final response = await http.get(url);
     final productsdata = (json.decode(response.body));
     if (productsdata==null){
      return;
    }

    url = 'https://flutter-myshop-5f569.firebaseio.com/userFavorites/$_userId.json?auth=$authToken';
    final favResponse = await http.get(url);
    final favResponseData = (json.decode(favResponse.body));
    print (_userId);
    print('this is fav');
    print(favResponseData);
    productsdata.forEach((prodId,prodData){
      loadedProducts.add(Product(id:prodId,
      title: prodData['title'],
      description: prodData['description'],
      imageUrl: prodData['imageUrl'],
      price: prodData['price'],
      isFavorite:favResponseData==null?false: favResponseData[prodId]??false
      )
      );



   

    });
     _items = loadedProducts;
   
  notifyListeners();
   


   }catch (error){
     throw error;

   }
      
 }







 //changing the method to future returning
   Future<void> addProduct(Product product) async {
    
    final url = 'https://flutter-myshop-5f569.firebaseio.com/products.json?auth=$authToken';
    //json m convert krn k liye

    try{
      final response = await http.post(url,body:json.encode({
         'title':product.title,
         'description':product.description,
         'imageUrl':product.imageUrl,
         'price':product.price,
         'creatorId':_userId
         //'isFavorite':product.isFavorite
    }),);

   final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price
    );

    _items.add(newProduct);
    notifyListeners();

    }catch  (error){
        print (error);
      throw error;
    

    }
    

    //we want to throw this error in UI
    
  }

Future<void>  updateProduct(String id,Product newProduct) async {
  

 final productIndex = _items.indexWhere((prod)=>prod.id==id);
 if (productIndex>=0){
   final url= 'https://flutter-myshop-5f569.firebaseio.com/products/$id.json?auth=$authToken';
   await http.patch(url,body:json.encode({
     'description':newProduct.description,
     'imageUrl':newProduct.imageUrl,
     'isFavorite':newProduct.isFavorite,
     'price':newProduct.price,
     'title':newProduct.title
   }));
    _items[productIndex]= newProduct;
 notifyListeners();
 }
 else{
   print ('....');
 }


}

Future<void> deleteProduct(String id) async {
  final url= 'https://flutter-myshop-5f569.firebaseio.com/products/$id.json?auth=$authToken';
  final existingProductIndex = _items.indexWhere((product)=>product.id==id);
  var existingProduct = _items[existingProductIndex];
  _items.removeAt(existingProductIndex);
  notifyListeners();
 
 final response = await http.delete(url);
 if (response.statusCode>400){
   _items.insert(existingProductIndex,existingProduct);
    notifyListeners();
     throw HttpException('Some Exception has Occured');
      
    }
 existingProduct = null;
  
    
    
       
  
  
  



//  _items.removeWhere((product)=>product.id==id);

//  notifyListeners();
}

}
