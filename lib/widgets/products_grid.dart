import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'grid_product_item.dart';
class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({this.showFavs=false});

  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context,listen: false);//Todo : i made this false
    final List<Product> products=showFavs ?productData.favouritesItems :productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing : 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext ctx, int index) {
        final currentProduct=products[index];
        return ChangeNotifierProvider.value(
          value:currentProduct,
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
