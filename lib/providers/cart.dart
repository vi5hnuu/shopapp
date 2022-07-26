import 'dart:collection';

import 'package:flutter/material.dart';

class CartItem{
  final String id; //this id is diff than product it belongs to
  final String title;
  int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return UnmodifiableMapView(_items);
  }


  int get itemCount{
    return _items.length;
  }

  MapEntry<String,CartItem> getCartItemAt(int i){
    return _items.entries.elementAt(i);
  }

  double get totalAmount{
    return _items.values.fold(0, (previousValue, cartItem){
      return previousValue+=cartItem.quantity*cartItem.price;
    });
  }


  void decrQuantity(String pId){
    var item=getCartItemForPId(pId);
    if(item.quantity>=2){
      item.quantity--;
      notifyListeners();
    }
  }
  void incQuantity(String pId){
    var item=getCartItemForPId(pId);
    item.quantity++;
    notifyListeners();
  }
  CartItem getCartItemForPId(String pId){
    return _items.entries.firstWhere((entry) => entry.key==pId).value;
  }
  void addItem(
      {required String productId,
      required double price,
      required String title}) {
    if (_items.containsKey(productId)) {
      //we already have this product in cart
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String pId){
    _items.remove(pId);
    notifyListeners();
  }
  void clear(){
    print('cart Cleared');
    _items.clear();
    notifyListeners();
  }
}
