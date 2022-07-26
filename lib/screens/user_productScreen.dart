import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import 'edit_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName='/userProductScreen';
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Your Products'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, EditProductScreen.routeName);
          }, icon:const Icon(Icons.add),),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          // itemExtent: 80,
          itemBuilder: (BuildContext ctx,int index){
              final currentProduct=productData.items[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserProductItem(pId: currentProduct.id,title: currentProduct.title,imageUrl: currentProduct.imageUrl,),
                    Divider()
                  ],
                );
          },
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
