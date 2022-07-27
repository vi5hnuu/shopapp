import 'package:flutter/material.dart';

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


  void toggleFavouritesStatus(){
    this.isFavourite=!this.isFavourite;
    notifyListeners();
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
