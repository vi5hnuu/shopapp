import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:intl/intl.dart';

//local state management[expand widget]
class OrderSItem extends StatefulWidget {
  final OrderItem orderItem;
  const OrderSItem({required this.orderItem});

  @override
  State<OrderSItem> createState() => _OrderSItemState();
}

class _OrderSItemState extends State<OrderSItem> {
  var _expanded=false;
  @override
  Widget build(BuildContext context) {
    print('build order again');
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            // tileColor: Colors.orange,
            contentPadding: EdgeInsets.all(15),
            title: Text('₹ ${widget.orderItem.amount.toStringAsFixed(2)}'),
              style: ListTileStyle.drawer,
            subtitle: Text(DateFormat('dd/MM/yyyy').add_jm().format(widget.orderItem.dateTime),),
            trailing: IconButton(
              icon:_expanded ?Icon(Icons.expand_less): Icon(Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded=!_expanded;
                });
              },
            )
          ),
          if(_expanded)Container(
            child: Text('Order Sumary',style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          if(_expanded) Container(
            // color: Colors.red,
            height: min(widget.orderItem.products.length*40+50,180),
            margin: EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: widget.orderItem.products.length,
              itemBuilder: (BuildContext ctx,int index){
                final product=widget.orderItem.products[index];
                return Container(
                  height: 40,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5).copyWith(left: 20,right: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.title}',style: TextStyle(fontSize: 18),),
                      Text('${product.quantity}x${product.price.toStringAsFixed(2)}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                    ],
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
