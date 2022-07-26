import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/cart_item.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    print('cart screen rebuild.');

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: Column(
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
              children: [
                OutlinedButton(
                  onPressed: () {
                    bool isAdded=Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(),cart.totalAmount);
                    if(isAdded){
                      Navigator.pushNamed(context, OrdersScreen.routeName);
                      cart.clear();
                    }
                  },
                  child: Text(
                    'Place Order',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
            ),
          ),
          Divider(
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
    );
  }
}
