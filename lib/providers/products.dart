import 'dart:collection';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopapp/main.dart' show db;
//firestore

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return UnmodifiableListView(_items);
  }

  List<Product> get favouritesItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Future<void> loadData() async{
    _items.clear();
    await db.collection('products').get().then((coll){
      for(var doc in coll.docs){
        final data=doc.data();//doc has map<String,dynamic>
        Product p=Product(id: doc.id, title: data['title'], description: data['description'], price:data['price'], imageUrl: data['imageUrl'],isFavourite: data['isFavourite']);
          _items.add(p);
      }
    });//todo : handle error
  }

  Future<void> reloadData() async{
    this.loadData().then((value) =>notifyListeners()); //await then notify the screens using the products [we refreshed this in your products screen which is listening for products change]
    //we call notify listenners only after all products are loaded not after single product is loaded
  }

  void addProductAgain(Product newProduct){
    _items.add(newProduct);
    notifyListeners();
  }
  Future<void> addProduct(Product newProduct) async{
    final pdt = {
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price,
      'isFavourite': newProduct.isFavourite,
    };

    return db.collection('products').add(pdt).then((DocumentReference ref) async{
      final product = Product(
          id: newProduct.id != '' ? newProduct.id : ref.id,
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
          isFavourite: newProduct.isFavourite);
      if (newProduct.id == '') {
        _items.insert(0, product);
      } else {
        _items.remove(this.findById(id: newProduct.id));
        _items.insert(0, product);
        await db.collection('products').doc(newProduct.id).delete();
      }
      notifyListeners();
    }).catchError((err) {
      //todo: do something of this error
      print(err);
    });
  }

  Product findById({required String id}) {
    return _items.firstWhere((item) => item.id == id);
  }

  void deleteProduct(String pId) {
    _items.removeWhere((product) => product.id == pId);
    notifyListeners();
  }

}
