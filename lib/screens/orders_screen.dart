// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopapp/widgets/app_drawer.dart';
// import '../providers/orders.dart';
// import '../widgets/order_item.dart';
//
// //statefull widget only for showing and loading data
// class OrdersScreen extends StatefulWidget {
//   static const routeName='/OrdersScreen';
//   const OrdersScreen({Key? key}) : super(key: key);
//
//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }
//
// class _OrdersScreenState extends State<OrdersScreen> {
//   bool _loading=true;
//   @override
//   void initState() {
//     final orderData=Provider.of<Orders>(context,listen: false);
//     orderData.loadOrders().then((value){
//       setState(() {
//         _loading=false;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Order screen rebuild');
//     final orderData=Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Orders'),
//       ),
//       drawer: AppDrawer(),
//       body:_loading ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
//         onRefresh: orderData.loadOrders,
//         child: ListView.builder(
//           itemBuilder: (BuildContext ctx,int index){
//             return OrderSItem(orderItem: orderData.orders[index],);
//           },
//           itemCount: orderData.orders.length,
//         ),
//       ),
//     );
//   }
// }


////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

//statefull widget only for showing and loading data
class OrdersScreen extends StatefulWidget {
  static const routeName='/OrdersScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    print('Order screen rebuild');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body:FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).loadOrders(),
        builder: (BuildContext ctx,snapshots){
          if(snapshots.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshots.connectionState==ConnectionState.done){
            return Consumer<Orders>(
              builder: (BuildContext ct,orderData,_){
                return RefreshIndicator(
                  onRefresh: orderData.loadOrders,
                  child: ListView.builder(
                    itemBuilder: (BuildContext ctx,int index){
                      return OrderSItem(orderItem: orderData.orders[index],);
                    },
                    itemCount: orderData.orders.length,
                  ),
                );
              },
            );
          }
          else{
            //todo:handle error
            return Center(child: Text('error loading data.'),);
          }
        },
      )
    );
  }
}
