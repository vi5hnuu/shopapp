import 'dart:collection';

import 'package:flutter/material.dart';

import '../main.dart' show db;

class CartItem {
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

  int get itemCount {
    return _items.length;
  }

  MapEntry<String, CartItem> getCartItemAt(int i) {
    return _items.entries.elementAt(i);
  }

  double get totalAmount {
    return _items.values.fold(0, (previousValue, cartItem) {
      return previousValue += cartItem.quantity * cartItem.price;
    });
  }

  Future<void> decrQuantity(String pId) async {
    var item = getCartItemForPId(pId);
    if (item.quantity >= 2)
      return this
          .addItem(
              productId: pId, price: item.price, title: item.title, inc: false)
          .then((_) {
        notifyListeners();
      });
  }

  Future<void> incQuantity(String pId) async {
    var item = getCartItemForPId(pId);
    return this
        .addItem(
            productId: pId, price: item.price, title: item.title, inc: true)
        .then((_) {
      notifyListeners();
    });
  }

  CartItem getCartItemForPId(String pId) {
    // print(_items.length);
    return _items.entries.firstWhere((entry) {
      print('.............');
      print(entry.key);
      print(pId);
      print('.............');

      // print(entry.value.title);
      return entry.key == pId;
    }).value;
  }

  Future<void> addItem(
      {required String productId,
      required double price,
      required String title,
      bool inc = true}) async {
    if (_items.containsKey(productId)) {
      print(_items.containsKey(productId));
      //we already have this product in cart
      await db
          .collection('cartItems')
          .get()
          .then((snapshots) => snapshots.docs.where((docref) {
              print(docref.id);
              print('docref id');
                bool ans= getCartItemForPId(productId).id == docref.id;
                print('selected ${ans}');
                return ans;
              }))
          .then((ourDoc) {
            print('ourDoc');
            print(ourDoc);
            print('x');
        final data = ourDoc.first.data()['cartItem'];
        print(data);
        db.collection('cartItems').doc(ourDoc.first.id).update({
          'cartItem': {
            'quantity': data['quantity'] + (inc ? 1 : -1),
            'price': data['price'],
            'title': data['title']
          }
        });
      }).then((_) {
        _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + (inc ? 1 : -1),
              price: existingCartItem.price),
        );
        notifyListeners();
      }).catchError((err){print(err);});
    } else {
      await db.collection('cartItems').add({
        'pId': productId,
        'cartItem': {"title": title, "quantity": 1, "price": price}
      }).then((docRef) {
        _items.putIfAbsent(
            productId,
            () => CartItem(
                id: docRef.id, title: title, quantity: 1, price: price));
        notifyListeners();
      }).catchError((err) {
        //do something with this 💩
      });
    }
  }

  Future<void> loadCartItems() async {
    _items.clear();
    db.collection('cartItems').get().then((coll){
      for(var singleDoc in coll.docs){
        // print(singleDoc.data());
        final Map<String,dynamic> dt=singleDoc.data();
        CartItem item=CartItem(id: singleDoc.id, title: dt['cartItem']['title'], quantity: dt['cartItem']['quantity'], price: dt['cartItem']['price']);
        _items.putIfAbsent(dt['pId'], () => item);
      }
      notifyListeners();
    });
  }

  CartItem findItemAt(String pId){
    return _items.entries.firstWhere((entry) => entry.key==pId).value;
  }

  void removeItem(String pId) {
    final savedataref=findItemAt(pId);
    db.collection('cartItems').get().then((coll) => coll.docs.where((docref) =>docref['pId']==pId)).then((docref){
      db.collection('cartItems').doc(docref.first.id).delete();
    }).catchError((err){
      _items.putIfAbsent(pId, () => savedataref);
      notifyListeners();
    });
    //////////
    _items.remove(pId);
    notifyListeners();
  }

  void clear() {
    print('cart Cleared');
    // _items.clear();
    notifyListeners();
  }
}
