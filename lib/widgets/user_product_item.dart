import 'package:flutter/material.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product.dart';
import 'package:provider/provider.dart';

import '../main.dart' show db;
import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  final String pId;
  final String title;
  final String imageUrl;
  const UserProductItem(
      {required this.pId, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ), //not a widget unlike Image.network
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName,
                  arguments: pId);
            },
            icon: Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
          ),
          IconButton(
            onPressed: () {
              showDialog(//not attacched to ScaffoldMess... as it can be shown anywhere
                //showDialog return Future<T>
                  context: context,
                  barrierDismissible: false,//else it will return Future<null> not subtype of Future<bool> -> error
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
                        'This action will permanently delete the ${title} item.',
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
              ).then((ans) async{
                if(ans){
                  Products products=Provider.of<Products>(context,listen: false);
                  Product ref=products.findById(id: pId);
                  products.deleteProduct(pId);

                  //just in case del failed //Todo : this code is not tested
                  await db.collection('products').doc(pId).delete().catchError((err){
                    products.addProductAgain(ref);//
                  });
                }
              });
            },
            icon: const Icon(
              Icons.delete,
            ),
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}
