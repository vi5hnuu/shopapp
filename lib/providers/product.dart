import 'dart:io';

import 'package:flutter/material.dart';

import '../main.dart' show db;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite=false});


  Future<void> toggleFavouritesStatus() async{
    bool oldFavStatus=this.isFavourite;
    this.isFavourite=!this.isFavourite;
    notifyListeners();
    db.collection('products').doc(id).update({'isFavourite':this.isFavourite}).catchError((err){
      this.isFavourite=oldFavStatus;
      notifyListeners();
    });
  }

  @override
  String toString(){
    return '${this.id} / ${this.title} / ${this.description} / ${this.price}/${this.imageUrl} / ${this.isFavourite}';
  }
  @override
  bool operator == (Object a){
    return this.id==(a as Product).id;
  }
}
