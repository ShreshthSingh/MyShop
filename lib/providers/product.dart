import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';



class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  
  
  
  Product({
  @required this.id,
  @required this.title,
  @required this.description,
  @required this.price,
  @required this.imageUrl,
  this.isFavorite = false});

  Future<void> toggleFavorite(String token,String userId) async {

    final url = 'https://flutter-myshop-5f569.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    bool present = isFavorite; 
    isFavorite = !isFavorite;
   notifyListeners();

    try{
      
    final response =   await http.put(url,body:json.encode(
     
     isFavorite,
    
   ));

   if (response.statusCode>400){
     
   
     
     
     isFavorite = present;
      notifyListeners();
     throw HttpException('Some error is being ocurred');
     
   
    

   }
   
}catch(error){
   isFavorite = present;
   print(error);
    
    notifyListeners(
    
    );
    throw (error);


}

  }

}