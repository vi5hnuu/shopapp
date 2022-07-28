import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/widgets/cart_item.dart';

import '../main.dart' show db;
import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {//statefull just to show indicator and load data
  static const routeName = '/cartScreen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading=true;
  @override
  void initState() {
    Provider.of<Cart>(context,listen: false).loadCartItems().then((_){
      setState(() {
        _isLoading=false;
      });
    }).catchError((err){
      setState(() {
        _isLoading=false;

      });
      //handle error;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    bool amountGtZero=cart.totalAmount>0;
    print('cart screen rebuild.');

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body:_isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : RefreshIndicator(
        onRefresh: cart.loadCartItems,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              child: ExpansionTile(
                title: Text('Order Total'),
                tilePadding: EdgeInsets.symmetric(horizontal: 10),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.summarize_outlined,
                      size: 34,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                trailing: Icon(Icons.expand_circle_down_outlined),
                subtitle: Text(
                  '₹ ${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                childrenPadding: EdgeInsets.all(10),
                children: [
                  ElevatedButton(
                    onPressed:amountGtZero ?  () async{
                      final orders=Provider.of<Orders>(context,listen: false);
                      bool isAdded=await orders.addOrder(cart.items.values.toList(),cart.totalAmount);
                      if(isAdded){
                        Navigator.pushNamed(context, OrdersScreen.routeName);
                        final docs=await db.collection('cartItems').get();
                        for(var ref in docs.docs)
                          db.collection('cartItems').doc(ref.id).delete();//clear cart
                      }else{
                        //todo: show dialog that order addition to local list is failed
                      }
                    } : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              indent: 15,
              endIndent: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, int index) {
                  final currentItemEntry = cart.getCartItemAt(index);//map
                  return CartSItem(pId:currentItemEntry.key);
                },
                itemCount: cart.itemCount,
              ),
            )
          ],
        ),
      ),
    );
  }
}
