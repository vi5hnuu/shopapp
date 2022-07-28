import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:provider/provider.dart';

class CartSItem extends StatefulWidget {//show loading indication in place of +1 -1
  final String pId;
  const CartSItem({required this.pId});

  @override
  State<CartSItem> createState() => _CartSItemState();
}

class _CartSItemState extends State<CartSItem> {
  bool _isIncPressed=false;
  bool _isDcrPressed=false;
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    final item=cart.getCartItemForPId(widget.pId);
    print('cart Item rebuild.');
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection dir){
          cart.removeItem(widget.pId);
      },
      confirmDismiss: (DismissDirection dir){
        return showDialog(//not attacched to ScaffoldMess... as it can be shown anywhere
          //showDialog return Future<T>
            context: context,
            builder: (BuildContext ctx){
              return AlertDialog(
                title: Text(
                'Are You Sure ?',
                 style: TextStyle(
                   fontSize: 24,
                   fontFamily: 'RobotoCondensed'
                 ),
                ),
                content: Text(
                    'This action will permanently delete the ${item.title} item',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(onPressed: (){
                    Navigator.pop(context,true);
                  }, icon: Icon(Icons.check_circle_outline)),
                  IconButton(onPressed: (){
                    Navigator.pop(context,false);
                  }, icon: Icon(Icons.cancel_outlined))
                ],
              );
            }
        );
      },
      key: ValueKey(item.id),
      background: Container(
        margin: EdgeInsets.all(15),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete,color: Colors.red,size: 30,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(15),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: ExpansionTile(
          maintainState: true,
          title: Text('${item.title}'),
          tilePadding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            //Todo : increase decrease the Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(30),
                  child:_isIncPressed ? Center(child: CircularProgressIndicator(),) : IconButton(
                    disabledColor: Colors.grey,
                    onPressed:() async{
                      setState(() {
                        _isIncPressed=true;
                      });
                      cart.incQuantity(widget.pId).then((_) {//Pid is not lost as state build is called for indicator...[widget.pId is safe]
                        setState(() {
                          _isIncPressed=false;
                        });
                      } );
                    },
                    icon: Icon(Icons.plus_one),
                    tooltip: '+1  Quantity',
                    splashColor:Theme.of(context).colorScheme.primary,
                    splashRadius: 30,
                  ),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  clipBehavior: Clip.hardEdge,
                  elevation: 4,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)),
                  child: Text(
                      'Product Total : ${item.quantity}x${item.price}'),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30),
                  child:_isDcrPressed ? Center(child: CircularProgressIndicator(),) : IconButton(
                    onPressed:() async{
                      setState(() {
                        _isDcrPressed=true;
                      });
                      cart.decrQuantity(widget.pId).then((_) {//Pid is not lost as state build is called for indicator...[widget.pId is safe]
                        setState(() {
                          _isDcrPressed=false;
                        });
                      } );
                    },
                    icon: Icon(Icons.exposure_minus_1),
                    tooltip: '-1  Quantity',
                    splashColor:Theme.of(context).colorScheme.primary,
                    splashRadius: 30,
                  ),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  clipBehavior: Clip.hardEdge,
                  elevation: 4,
                ),

              ],
            )
          ],
          leading: Icon(
            Icons.summarize_outlined,
            size: 34,
          ),
          trailing: Icon(Icons.expand_circle_down_outlined),
          subtitle: Text(
            '₹ ${(item.quantity * item.price).toStringAsFixed(2)}',
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          childrenPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
