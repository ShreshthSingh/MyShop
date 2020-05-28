import 'package:flutter/material.dart';

class HttpException implements Exception{
  String message;
  HttpException(this.message);
  @override
  String toString(){
    return message;
  }
} 