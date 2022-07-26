import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName='/OrdersScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Order screen rebuild');
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (BuildContext ctx,int index){
          return OrderSItem(orderItem: orderData.orders[index],);
        },
        itemCount: orderData.orders.length,
      ),
    );
  }
}
