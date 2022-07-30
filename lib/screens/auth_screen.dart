import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

/*
i am not using fireBase auth package instead using firebase rest api
for auth screen
* */
enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/authScreen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: deviceSize.height-50,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 75.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-15.0),//special operator[return the prev i,e Matrix4]
                      /*
                      same as
                      final x=Matrix4.rotationZ(m);
                      x.translate(l);
                      */
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 50,
                            fontFamily: 'Anton',
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    fit: FlexFit.tight,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _showErrorDialog(String message){
    return showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
          title: Text('⚠️ Error',style: TextStyle(color: Colors.red),),
          content: Text(message),
        scrollable: true,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        backgroundColor: Colors.white.withOpacity(0.6),
        actions: [
          OutlinedButton(onPressed: (){
            Navigator.of(context).pop();
          },
            child: Text('ok',style: TextStyle(color: Colors.white),),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          ),
          
        ],
      );
    });
  }
  void _submit() async{
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if (_authMode == AuthMode.Login) {
        //Log user in
        await Provider.of<Auth>(context,listen: false).signIn(email:_authData['email']!,password: _authData['password']!);
      } else {
        //Sign user up
        await Provider.of<Auth>(context,listen: false).signUp(email:_authData['email']!,password: _authData['password']!);

      }
    }on HttpException catch(error){
      var errorMessage='Authentication failed.';
      final errorString=error.toString();
      if(errorString.contains('EMAIL_EXISTS')){
        errorMessage='The email address is already in use.';
      }else if(errorString.contains('INVALID_EMAIL')){
        errorMessage='The email address is invalid.';
      }
      else if(errorString.contains('WEAK_PASSWORD')){
        errorMessage='The password is too weak.';
      }
      else if(errorString.contains('EMAIL_NOT_FOUND') || errorString.contains('INVALID_PASSWORD')){
        errorMessage='Email not found or password is invalid.';
      }
      _showErrorDialog(errorMessage);
    }catch(error){
      var errorMessage='Could not authenticate you at the moment.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      child: Container(
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 300),
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border:Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        width: mediaQuery.size.width * 0.75,
        padding: EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Password do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(4),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
                      minimumSize:mediaQuery.orientation==Orientation.landscape ?MaterialStateProperty.all(Size(mediaQuery.size.width*0.15,mediaQuery.size.width*0.05),) : MaterialStateProperty.all(Size(mediaQuery.size.width*0.35,mediaQuery.size.width*0.10),),
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange.withOpacity(0.9),),
                    ),
                    child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                  ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(4),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
                    minimumSize:mediaQuery.orientation==Orientation.landscape ?MaterialStateProperty.all(Size(mediaQuery.size.width*0.15,mediaQuery.size.width*0.05),) : MaterialStateProperty.all(Size(mediaQuery.size.width*0.35,mediaQuery.size.width*0.10),),
                    backgroundColor: MaterialStateProperty.all(Colors.deepOrange.withOpacity(0.7),),
                  ),
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
