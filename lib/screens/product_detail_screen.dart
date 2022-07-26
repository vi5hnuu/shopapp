import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName='/productDetailScreen';
  @override
  Widget build(BuildContext context) {
    String pid=ModalRoute.of(context)?.settings.arguments as String;
    Product product=Provider.of<Products>(context,listen: false).findById(id:pid);//do not listen if products change but just access data when only this widget builds
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey,width: 2)
              ),
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                  borderRadius:BorderRadius.circular(15) ,
                  child: Image.network(product.imageUrl,fit: BoxFit.cover,)),
            ),
            SizedBox(height: 10,),
            Text('₹ ${product.price}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            Container(
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10).copyWith(top: 20),
                child: Text(
                    product.description,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Raleway'
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
