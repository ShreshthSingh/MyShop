import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    if (token!=null){
      return true;

    }
    else{
      return false;
    }
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

void logout() async {
  _token = null;
 _expiryDate = null ;
  _userId = null ;
  if (_authTimer!=null){
    _authTimer.cancel();
    _authTimer = null;
  }
  notifyListeners();
  print('Logout triggered');

  final prefs = await SharedPreferences.getInstance() ;

  prefs.clear();
}



  Future<void> signup(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBErKnfZd2PddSyyb_jsPvhEGKjDsIlQBc";

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);

        
      }
 _token = responseData['idToken'];
      _userId = responseData['localId'];
      print (responseData);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
          notifyListeners();
        autoLogout();

         final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({'userId':_userId,'expiryDate':_expiryDate.toIso8601String(),'token':_token});
        prefs.setString('userData',userData);
        


    
    } catch (error) {
      throw error;
    }
  }



  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
	
    autoLogout();
    
    return true;
  }
  Future<void> login(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBErKnfZd2PddSyyb_jsPvhEGKjDsIlQBc";

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
       _token = responseData['idToken'];
      _userId = responseData['localId'];
      print (responseData['refreshToken']);
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
          notifyListeners();
          autoLogout();

         final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
       {
         'token': _token,
        'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);



         
    
    } catch (error) {
     
      print(error);
      throw error;
    }
  }

 void autoLogout(){
   if (_authTimer!=null){
     _authTimer.cancel();
   }
   final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
  _authTimer = Timer(Duration(seconds:timeToExpiry),logout);
 }




}
