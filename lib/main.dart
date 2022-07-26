import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/user_productScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext ctx)=>Products()),
        ChangeNotifierProvider(create: (BuildContext ctx)=>Cart()),
        ChangeNotifierProvider(create: (BuildContext ctx)=>Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange
          ),
          fontFamily: 'Lato',
        ),
        initialRoute: '/',
        routes: {
          '/':(BuildContext ctx){return ProductOverviewScreen();},
          ProductDetailScreen.routeName:(BuildContext ctx){return ProductDetailScreen();},
          CartScreen.routeName:(BuildContext ctx){return CartScreen();},
          OrdersScreen.routeName:(BuildContext ctx){return OrdersScreen();},
          UserProductScreen.routeName:(BuildContext ctx){return UserProductScreen();},
          EditProductScreen.routeName:(BuildContext ctx){return EditProductScreen();},
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductOverviewScreen();
  }
}
