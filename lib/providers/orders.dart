import 'dart:collection';

import 'package:flutter/material.dart';

import 'cart.dart';

class OrderItem{
  final id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({required this.id,required this.amount,required this.products,required this.dateTime});
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders=[];

  List<OrderItem> get orders{
    return  UnmodifiableListView(_orders);
  }

  bool addOrder(List<CartItem> cartProducts,double total){
    if(total>0){
      _orders.insert(0, OrderItem(id: DateTime.now(), amount: total, products: cartProducts, dateTime: DateTime.now()));
      notifyListeners();
      return true;
    }
    return false;
  }
}