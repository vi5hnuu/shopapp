import 'package:flutter/material.dart';
import 'package:shopapp/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String pId;
  final String title;
  final String imageUrl;
  const UserProductItem({required this.pId,required this.title,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl,),//not a widget unlike Image.network
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, EditProductScreen.routeName,arguments: pId);
          },
          icon: Icon(Icons.edit),color: Theme.of(context).colorScheme.primary,),
          IconButton(onPressed: (){}, icon: Icon(Icons.delete,),color: Theme.of(context).colorScheme.error,),
        ],
      ),
    );
  }
}
