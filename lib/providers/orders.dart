import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/products.dart';

import '../main.dart' show db;
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



  Future<bool> addOrder(List<CartItem> cartProducts,double total) async{
    if(total<=0)
        return false;
    else{
      DateTime dateTime=DateTime.now();
      return db.collection('orders').add({
        'totalAmount':total,
        'orderDateTime':dateTime.millisecondsSinceEpoch,
        'cartItems':
        cartProducts.map((pdt)=> {
          'id':pdt.id,
          'price':pdt.price,
          'title':pdt.title,
          'quantity':pdt.quantity,
        }).toList()
      }).then((docRef){
        _orders.insert(0, OrderItem(id: docRef.id, amount: total, products: cartProducts, dateTime: dateTime));
        return true;//Future<true>
      }).catchError((err){
        print(err);
        return false;//Future<false>
      });
    }
  }

  Future<void> loadOrders() async{
    _orders.clear();
    await db.collection('orders').get().then((coll){
      final data=coll.docs;
      for(var doc in data){
        // print(doc.data());//check it
        Map<String,dynamic> ourData=doc.data();
        final totalAmount=ourData['totalAmount'];
         // print(ourData['cartItems'].runtimeType);
        final List<dynamic> cartItems=ourData['cartItems'];
        List<CartItem> products=cartItems.map((item) =>CartItem(id: item['id'], title: item['title'], quantity: item['quantity'], price: item['price'])).toList();
        OrderItem orderItem=OrderItem(id: doc.id, amount: totalAmount, products: products, dateTime:DateTime.fromMillisecondsSinceEpoch(ourData['orderDateTime']) );
        _orders.add(orderItem);
      }
      notifyListeners();
    });
  }
}