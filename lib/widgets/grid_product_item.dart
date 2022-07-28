import 'package:flutter/material.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem();
  @override
  Widget build(BuildContext context) {
    final Product product=Provider.of<Product>(context,listen: false);
    final Cart cart=Provider.of<Cart>(context,listen: false);
    // print('rebuild entire grid item ??');
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
        child: Image.network(product.imageUrl,fit: BoxFit.cover,),
        onTap: (){
          Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments: product.id);
        },
        ),
        footer:GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (BuildContext ctx,Product product,_){
              // print('Rebuild only heart icon');
              return IconButton(
                icon:product.isFavourite ?Icon(Icons.favorite):Icon(Icons.favorite_border),
                onPressed: product.toggleFavouritesStatus,
                // tooltip: 'Mark as favourite',
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          trailing: Consumer<Cart>(
            builder: (BuildContext ctx,Cart,_){
              return IconButton(
                icon:
                Icon(Icons.shopping_cart_outlined),
                onPressed: () async{
                  cart.addItem(productId: product.id, price: product.price, title: product.title).then((_){
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(
                        reason: SnackBarClosedReason.dismiss
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${cart.getCartItemForPId(product.id).quantity}x ${product.title}'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: (){
                              cart.decrQuantity(product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed 1 piece of ${product.title}'),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            },
                          ),
                        )
                    );
                  });

                  },
                tooltip: 'Add to cart',
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          title: Text(product.title,textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
