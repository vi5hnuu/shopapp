import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/cart_badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isLoading=true;

  @override
  void initState(){//todo : adding again and again
    Provider.of<Products>(context,listen: false).loadData().then((_){
      setState(() {
        _isLoading=false;
      });

    }).catchError((error){
     setState(() {
       _isLoading=false;
     });
      print(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('shop rebuild');
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (BuildContext ctx,cart,Widget? child){
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
                child: Badge(
                  child: child!,//dont rebuild this icon
                  value: cart.itemCount.toString(),
                ),
              );
            },
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.more_vert),
              tooltip: 'Filter results',
              onSelected: (value) {
                setState(() {
                  if (value == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: (BuildContext ctx) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Only Favourites')
                      ],
                    ),
                    value: FilterOptions.Favourites,
                    // onTap: (){},
                    padding: EdgeInsets.all(15),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.select_all, color: Colors.grey),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Show All')
                      ],
                    ),
                    value: FilterOptions.All,
                    // onTap: (){},
                    padding: EdgeInsets.all(15),
                  )
                ];
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body:_isLoading ?Center(child: CircularProgressIndicator(),)  :ProductsGrid(showFavs: _showOnlyFavourites),
    );
  }
}
