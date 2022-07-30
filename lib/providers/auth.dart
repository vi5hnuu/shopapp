
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


/*
the token is used to tell that this user is logged in and now load products
but for firestore i dont know how to pass token
so i have set rule that load products when anyone logged in
*/
class Auth with ChangeNotifier{
   String? _token;//expire after some time
   DateTime? _expireDate;
   String? _userId;

  bool get isAuth{
    print(token!=null);
      return token!=null;
  }

  String? get token{
    if(_expireDate!=null && _expireDate!.isAfter(DateTime.now()) && _token!=null){
      return _token;
    }
    return null;
  }

  Future<void> _authenticate({required String email,required String password,required String urlSegment}) async{
    final url='https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=[API_KEY]';
    final body=jsonEncode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    });
    final http.Response response;
    try{
      response=await http.post(Uri.parse(url),body: body);
      final responseData=jsonDecode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
      _token=responseData['idToken'];
      _userId=responseData['localId'];
      _expireDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      // print(_token);
      // print(_userId);
      // print(_expireDate);
      notifyListeners();
    }catch(e){
        print(e);
        rethrow;
    }
  }

  Future<void> signUp({required String email,required String password}) async{
    //await necessary because we dont want signUp to complete immediately[loading curson is shoul only ultill signUp completes and if we dont use await it simple completes putting authenticate out of flow which himself is async]
    await _authenticate(email: email, password: password, urlSegment: 'signUp');
  //or put return inplace of await
  }

  //login
  Future<void> signIn({required String email,required String password}) async{
    //await necessary because we dont want signIn to complete immediately[loading curson is shoul only ultill signIn completes and if we dont use await it simple completes putting authenticate out of flow which himself is async]
    await _authenticate(email: email, password: password, urlSegment: 'signInWithPassword');
    //or put return inplace of await
  }
}

